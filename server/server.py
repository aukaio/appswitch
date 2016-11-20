from flask import Flask
from flask import request
import logging
import flask
import mcash

logger = logging.getLogger()
app = Flask(__name__)


@app.route('/payment')
def create_payment():
    logging.info('Creating payment request...')
    res = mcash.create_payment(amount='1.00')
    return flask.jsonify(**res.json())


@app.route('/payment/callback', methods=['POST'])
def callback():
    logging.info(str(request))
    return ""


@app.route('/payment/<tid>')
def payment_status(tid):
    logging.info('Fetching payment <%s>' % tid)
    res = mcash.get_payment(tid=tid)
    return flask.jsonify(**res.json())


if __name__ == '__main__':
    app.debug = True
    app.run()
