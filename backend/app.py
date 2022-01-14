from flask import Flask, jsonify
from flask.logging import create_logger
import logging
import os
import psycopg2

connection = psycopg2.connect("dbname=" + os.environ["DATABASE_NAME"] +
                              " user=" + os.environ["DATABASE_USERNAME"] +
                              " password=" + os.environ["DATABASE_PASSWORD"] +
                              " host=" + os.environ["DATABASE_HOST"] +
                              " port=" + os.environ["DATABASE_PORT"])
# Open a cursor to perform database operations
cursor = connection.cursor()
# Execute a query
cursor.execute("SELECT * FROM my_data")
# Retrieve query results
records = cursor.fetchall()


app = Flask(__name__)
LOG = create_logger(app)
LOG.setLevel(logging.INFO)

@app.route("/")
def home():
    html = f"<h1>GetWise</h1>\n\n"

    # TODO: Get a random wisdom from the db
    #LOG.info(f"Wisdom: \n{wisdom}")
    #LOG.info(f"Source: \n{source}")
    #return jsonify({'Wisdom': wisdom, 'Source': source})
    return html.format(format) + "<p>Hello, World!</p>\n"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
