from re import L
from db import db, Item, User, Category, Location
from flask import Flask, request
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

# User routes

@app.route("/api/users/", METHODS=["GET"])
def get_users():
    users = [User.serialize() for User in User.query.all()]
    return success_response({'Users': users})


@app.route("/api/users/", METHODS=["POST"])
def create_user():
    body = json.loads(request.data)
    username = body.get("username")
    email = body.get("email")
    password = body.get("password")
    verify_password = body.get("verify_password")
    if not username or not email or not password or not verify_password:
        return failure_response("Missing required fields", 400)
    if password != verify_password:
        return failure_response("Passwords do not match", 400)
    if User.query.filter_by(email = email).first():
        return failure_response("Email already in use", 400)
    user = User(username = username, email = email, password = password)
    db.session.add(user)
    db.session.commit()
    return success_response(user.serialize(), 201)
    

@app.route("/api/users/<int:user_id>/", METHODS=["GET"])
def get_user(user_id):
    user = User.query.filter_by(id = user_id).first()
    if not user:
        return failure_response("User not found", 404)
    return success_response(user.serialize())


@app.route("/api/users/<int:user_id>/", METHODS=["DELETE"])
def delete_user(user_id):
    user = User.query.filter_by(id = user_id).first()
    if not user:
        return failure_response("User not found", 404)
    db.session.delete(user)
    db.session.commit()
    return success_response(user.serialize())

# auth route here

# Item routes

@app.route("/api/items/", METHODS=["GET"])
def get_items():
    items = [Item.serialize() for Item in Item.query.all()]
    return success_response({'Items': items})

@app.route("/api/items/", METHODS=["POST"])
def create_item():
    pass

@app.route("/api/items/<int:item_id>/", METHODS=["GET"])
def get_item(item_id):
    pass

@app.route("/api/items/<int:item_id>/", METHODS=["DELETE"])
def delete_item(item_id):
    pass



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
