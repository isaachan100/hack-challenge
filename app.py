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

@app.route("/api/users/", methods=["GET"])
def get_users():
    """
    returns all users in the database
    """
    users = [User.serialize() for User in User.query.all()]
    return success_response({'Users': users})

@app.route("/api/users/", methods=["POST"])
def create_user():
    """
    creates a new user in the database
    """
    body = json.loads(request.data)
    name = body.get("name")
    email = body.get("email")
    # password = body.get("password")
    # verify_password = body.get("verify_password")
    # or not password or not verify_password:
    if not name or not email:
        return failure_response("Missing required fields", 400)
    # if password != verify_password:
    #     return failure_response("Passwords do not match", 400)
    if User.query.filter_by(email = email).first():
        return failure_response("Email already in use", 400)
    user = User(name = name, email = email)
    db.session.add(user)
    db.session.commit()
    return success_response(user.serialize(), 201)
    

@app.route("/api/users/<int:user_id>/", methods=["GET"])
def get_user(user_id):
    """
    returns a specific user based on their user id
    """
    user = User.query.filter_by(id = user_id).first()
    if not user:
        return failure_response("User not found", 404)
    return success_response(user.serialize())


@app.route("/api/users/<int:user_id>/", methods=["DELETE"])
def delete_user(user_id):
    """
    deletes a user 
    """
    user = User.query.filter_by(id = user_id).first()
    if not user:
        return failure_response("User not found", 404)
    db.session.delete(user)
    db.session.commit()
    return success_response(user.serialize())

# auth route here
@app.route("/api/users/login/", methods = ["POST"])
def login():
    """
    attempts to verify user and returns session token if successful
    """
    pass

# Item routes

@app.route("/api/items/", methods=["GET"])
def get_items():
    """
    returns all items
    """
    items = [Item.serialize() for Item in Item.query.all()]
    return success_response({'Items': items})

@app.route("/api/items/", methods=["POST"])
def create_item():
    """
    creates an item
    """
    pass

@app.route("/api/items/<int:item_id>/", methods=["GET"])
def get_item(item_id):
    """
    returns a specific item based on item id
    """
    pass

@app.route("/api/items/<int:item_id>/", methods=["DELETE"])
def delete_item(item_id):
    """
    deletes an item based on item id
    """
    pass

@app.route("/api/items/<int:item_id>/", methods = ["POST"])
def update_item(item_id):
    """
    updates an item given item id
    """
    pass

@app.route("/api/items/claim/<int:item_id/", methods = ["POST"])
def submit_claim(item_id):
    """
    allows a user to submit a claim for an item
    """
    pass

#create locations
"""
creates location objects and adds them to the database
"""


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
