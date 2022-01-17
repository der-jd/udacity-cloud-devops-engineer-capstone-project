from flask import Flask, jsonify
from flask.logging import create_logger
import logging
import os
import psycopg2

connection = psycopg2.connect(dbname = os.environ["DATABASE_NAME"],
                              user = os.environ["DATABASE_USERNAME"],
                              password = os.environ["DATABASE_PASSWORD"],
                              host = os.environ["DATABASE_HOST"],
                              port = os.environ["DATABASE_PORT"])

app = Flask(__name__)
LOG = create_logger(app)
LOG.setLevel(logging.INFO)

@app.route("/")
def home():
    html = f"<h1>GetWise</h1>\n\n"

    # Open a cursor to perform database operations
    cursor = connection.cursor()
    # Execute a query
    cursor.execute("SELECT * FROM Wisdoms ORDER BY random() LIMIT 1")
    # Retrieve query results
    records = cursor.fetchall()
    wisdom = records[0][1]
    source = records[0][2]
    # TODO: add query for categories and images
    cursor.close()

    LOG.info(f"Wisdom: \n{wisdom}")
    LOG.info(f"Source: \n{source}")
    # TODO: log categories and image urls

    html += wisdom + "\n\n"
    if source:
        html += "source: " + source + "\n\n"
    # TODO: output categories and image

    return html.format(format)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
