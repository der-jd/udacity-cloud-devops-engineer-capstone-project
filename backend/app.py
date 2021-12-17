from flask import Flask, jsonify
from flask.logging import create_logger
import logging

app = Flask(__name__)
LOG = create_logger(app)
LOG.setLevel(logging.INFO)

@app.route("/")
def home():
    html = f"<h1>GetWise</h1>"
    return html.format(format)

    # TODO: Get a random wisdom from the db
    LOG.info(f"Wisdom: \n{wisdom}")
    LOG.info(f"Source: \n{source}")
    return jsonify({'Wisdom': wisdom, 'Source': source})

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
