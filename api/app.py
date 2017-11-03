#!flask/bin/python
from flask import Flask, request, jsonify
import random
import string
import hashlib
import time

app = Flask(__name__)

@app.route('/sessions', methods=['POST'])
def sessions():
    body = request.json

    if body is None:
        response = jsonify(absent_data_error())
        response.status_code = 400
        return response

    (email, pwd) = (body.get('email'), body.get('password'))

    if email is None or pwd is None:
        response = jsonify(absent_credentials_error())
        response.status_code = 400
        return response

    user = users().get(email)

    if user is None or pwd != default_pwd():
        response = jsonify(invalid_credentials_error())
        response.status_code = 401
        return response

    return jsonify(user)

def absent_data_error():
    return {'message': 'There is no JSON data in this request'}

def absent_credentials_error():
    return {'message': 'Some credentials were not present in the request'}

def invalid_credentials_error():
    return {'message': 'These credentials are invalid'}

def default_pwd():
    return 'admin'

def users():
    return {
        'fellipe.caetano@sympla.com.br': {
            'first_name': 'Fellipe',
            'last_name': 'Caetano',
            'created_at': timestamp(),
            'token': token()
        }
    }

def timestamp():
    return int(time.time())

def token():
    return md5(random_string(64))

def md5(key):
    digest = hashlib.md5()
    digest.update(key.encode('utf-8'))
    return digest.hexdigest()

def random_string(length):
    randomizer = random.SystemRandom()
    random_chars = randomizer.choice(string.ascii_uppercase + string.digits)
    return ''.join(random_chars)

if __name__ == '__main__':
    app.run(debug=True)
