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

    # Query for random wisdom
    cursor.execute("SELECT * FROM Wisdoms ORDER BY random() LIMIT 1")
    # Retrieve query results
    records = cursor.fetchall()
    id_ = records[0][0]
    wisdom = records[0][1]
    source = records[0][2]
    LOG.info(f"Wisdom: \n{wisdom}")
    LOG.info(f"Source: \n{source}")
    html += f"<pre>" + wisdom + "</pre>\n\n"
    if source:
        html += f"<p>Source: " + source + "</p>\n\n"

    # Query for wisdom categories
    cursor.execute("SELECT category FROM Categories WHERE wisdomId = '" + str(id_) + "'")
    categories = cursor.fetchall()
    LOG.info(f"Categories:")
    if categories:
        html += f"<p>Categories:</p>\n"
    for c in categories:
        LOG.info(f"{c[0]}")
        html += f"<p>" + c[0] + "</p>\n"

    # Query for image urls
    cursor.execute("SELECT imageUrl FROM Images WHERE wisdomId = '" + str(id_) + "'")
    imageUrls = cursor.fetchall()
    LOG.info(f"Image URLs:")
    for u in imageUrls:
        LOG.info(f"{u[0]}")
        html += f"<img src=\"" + u[0] + "\">\n"
    cursor.close()

    return html.format(format)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
