# ============================================================
#  Retail POS — Flask Backend
#  File  : app.py
#  Port  : 5000
#  Access: Read-only MySQL user (SELECT only)
# ============================================================

import os
import re
import time
import mysql.connector
from mysql.connector import Error
from flask import Flask, request, jsonify, render_template

app = Flask(__name__)

# ── Database config pulled from environment variables ────────
# These are set in docker-compose.yml. The defaults here are
# fallbacks for running locally outside Docker.
DB_CONFIG = {
    "host":     os.environ.get("DB_HOST",     "db"),
    "user":     os.environ.get("DB_USER",     "app_readonly"),
    "password": os.environ.get("DB_PASSWORD", "readonly_pass"),
    "database": os.environ.get("DB_NAME",     "retail_pos"),
    "port":     int(os.environ.get("DB_PORT", 3306)),
}


def get_connection(retries: int = 10, delay: int = 3):
    """
    Try to connect to MySQL, retrying up to `retries` times.
    MySQL takes a few seconds to fully start inside Docker, so
    we wait and retry rather than failing immediately.
    """
    for attempt in range(1, retries + 1):
        try:
            conn = mysql.connector.connect(**DB_CONFIG)
            return conn
        except Error as e:
            print(f"[DB] Attempt {attempt}/{retries} failed: {e}")
            if attempt < retries:
                time.sleep(delay)
    raise RuntimeError("Could not connect to the database after multiple attempts.")


def is_select_only(query: str) -> bool:
    """
    Safety check — only allow SELECT statements.
    Strips leading whitespace and comments, then checks that
    the first keyword is SELECT.

    This check happens server-side so even a crafted request
    that bypasses the UI cannot run a destructive query.
    """
    # Remove SQL comments (-- style and /* */ style)
    clean = re.sub(r"--[^\n]*", "", query)
    clean = re.sub(r"/\*.*?\*/", "", clean, flags=re.DOTALL)
    clean = clean.strip()

    # Must start with SELECT (case-insensitive)
    return bool(re.match(r"^SELECT\b", clean, re.IGNORECASE))


# ── Routes ───────────────────────────────────────────────────

@app.route("/")
def index():
    """Serve the main UI page."""
    return render_template("index.html")


@app.route("/query", methods=["POST"])
def run_query():
    """
    Accepts a JSON body: { "query": "SELECT ..." }
    Returns JSON with columns, rows, and row count.
    Returns an error message if the query is invalid or fails.
    """
    data  = request.get_json(silent=True) or {}
    query = data.get("query", "").strip()

    # ── Validate input ───────────────────────────────────────
    if not query:
        return jsonify({"error": "No query provided. Please type a SELECT statement."}), 400

    if not is_select_only(query):
        return jsonify({
            "error": (
                "Only SELECT queries are allowed. "
                "INSERT, UPDATE, DELETE, and DROP statements are blocked."
            )
        }), 403

    # ── Run query ────────────────────────────────────────────
    try:
        conn   = get_connection(retries=3, delay=1)
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query)
        rows    = cursor.fetchall()
        columns = list(rows[0].keys()) if rows else (
            [desc[0] for desc in cursor.description] if cursor.description else []
        )
        cursor.close()
        conn.close()

        # Convert any non-serialisable types (dates, decimals) to strings
        serialisable_rows = []
        for row in rows:
            serialisable_rows.append(
                {k: (str(v) if v is not None else None) for k, v in row.items()}
            )

        return jsonify({
            "columns": columns,
            "rows":    serialisable_rows,
            "count":   len(serialisable_rows),
        })

    except Error as e:
        return jsonify({"error": f"MySQL error: {e}"}), 500
    except RuntimeError as e:
        return jsonify({"error": str(e)}), 503


# ── Start ─────────────────────────────────────────────────────
if __name__ == "__main__":
    # debug=False is important for any shared/production environment
    app.run(host="0.0.0.0", port=5000, debug=False)
