from re import L
from db import db
from db import Item
from db import User
from db import Category
from db import Location
from flask import Flask
from flask import request
import json
import os

app = Flask(__name__)
db_filename = "lostandfound.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()


#routes here

def success_response(data, code = 200):
    return json.dumps(data), code

def failure_response(message, code = 400):
    return json.dumps({"error": message}), code




if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)