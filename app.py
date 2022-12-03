from re import L
from db import db, Item, User, Location, Asset, Claim
from flask import Flask, request
import json
import os
import datetime

app = Flask(__name__)
db_filename = "lostandfound.db"


app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

# helper methods
def success_response(data, code = 200):
    return json.dumps(data), code

def failure_response(message, code = 400):
    return json.dumps({"error": message}), code

def extract_token(request):
    """
    Helper function that extracts the token from the header of a request
    """
    auth_header = request.headers.get("Authorization")
    if auth_header is None:
        return False, failure_response("Missing authorization header.", 400)
    
    # Header looks like "Authorization: Bearer <token>"
    bearer_token = auth_header.replace("Bearer ", "").strip()

    if bearer_token is None or not bearer_token:
        return False, failure_response("Invalid authorization header", 400)

    return True, bearer_token

def verify_user(email, password):
    """
    helper function that checks user provided email and password are valid
    """
    user = User.query.filter(User.email == email).first()

    if user is None:
        return False, None

    return user.verify_password(password), user

def verify_session_token(request):
    """
    helper function that verifies if a session token is valid and grants access to protected endpoints
    """
    success, session_token = extract_token(request)

    if not success:
        return False, None

    user = User.query.filter(User.session_token == session_token).first()

    if user is None or not user.verify_session_token(session_token):
        return False, None
    
    return True, user

# base endpoint
@app.route("/")
def hello_world():
    return json.dumps("hello world!")

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
    password = body.get("password")
    
    if name == None or email == None or password == None:
        return failure_response("Missing required fields", 400)
    
    if User.query.filter_by(email = email).first():
        return failure_response("Email already in use", 400)
    
    user = User(name = name, email = email, password = password)

    db.session.add(user)
    db.session.commit()

    return success_response({
        "session_token": user.session_token,
        "session_expiration": str(user.session_expiration),
        "update_token": user.update_token
    })
    

@app.route("/api/users/<int:user_id>/")
def get_user(user_id):
    """
    returns a specific user based on their user id
    """
    user = User.query.filter_by(id = user_id).first()
    if not user:
        return failure_response("User not found", 404)
    return success_response(user.serialize())

@app.route("/api/users/claim/<int:user_id>/")
def get_claims(user_id):
    """
    returns all claims on objects lost by a user
    """
    user = User.query.filter_by(id = user_id).first()
    if user is None:
        return failure_response("User not found", 404)

    claims = [c.serialize() for c in Claim.query.filter(Claim.user_id == user_id)]
    return success_response(claims)

@app.route("/api/users/claim/", methods = ["POST"])
def create_claim():
    """
    submits a claim to a lost object
    """
    body = json.loads(request.data)
    item_id = body.get("item_id")
    finder_email = body.get("finder_email")

    if item_id is None or finder_email is None:
        return failure_response("Missing information!")

    item = Item.query.filter_by(id = item_id).first()

    if item is None:
        return failure_response("Item doesn't exist!", 404)

    claim = Claim(item_id = item_id, finder_email = finder_email, user_id = item.user_id)
    db.session.add(claim)
    db.session.commit()

    return success_response(claim.serialize())


@app.route("/api/users/delete/", methods=["DELETE"])
def delete_user():
    """
    deletes a user
    """
    success, user = verify_session_token(request)    

    if not success:
        return failure_response("Could not verify session token!", 404)
    
    db.session.delete(user)
    db.session.commit()
    return success_response(user.serialize())

@app.route("/api/users/login/", methods = ["POST"])
def login():
    """
    attempts to verify user and returns credentials if successful
    """
    body = json.loads(request.data)
    email = body.get("email")
    password = body.get("password")
    
    if email is None or password is None:
        return failure_response("Missing email or password", 400)

    success, user = verify_user(email, password)

    if not success:
        return failure_response("Incorrect email or password", 401)

    user.renew_session()
    db.session.commit()

    return success_response(
        {"session_token": user.session_token,
        "session_expiration": str(user.session_expiration),
        "update_token": user.update_token}
    )

@app.route("/api/users/session/", methods = ["POST"])
def update_session():
    """
    updates a users session when it expires
    """
    success, update_token = extract_token(request)

    if not success:
        return failure_response("Could not extract update token", 400)

    optional_user = User.query.filter(User.update_token == update_token).first()

    if optional_user is None:
        return failure_response("Invalid update token!", 400)

    optional_user.renew_session()
    db.session.commit()

    return success_response({
        "session_token": optional_user.session_token,
        "session_expiration": str(optional_user.session_expiration),
        "update_token": optional_user.update_token
    })

@app.route("/api/users/logout/", methods = ["POST"])
def logout():
    """
    logs out a user
    """

    success, session_token = extract_token(request)

    if not success:
        return failure_response("Could not extract session token")
    
    user = User.query.filter(User.session_token == session_token).first()

    if user is None or not user.verify_session_token(session_token):
        return failure_response("Invalid session token!")

    user.session_token = ""
    user.session_expiration = datetime.datetime.now()
    user.update_token = ""
    db.session.commit()

    return success_response({"message": "You have successfully logged out"})

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
    body = json.loads(request.data)
    description = body.get("description")
    found = body.get("found")
    location_id = body.get("location_id")
    user_id = body.get("user_id")
    bounty = body.get("bounty")
    link = body.get("link")

    if description == None or found == None or location_id == None or user_id == None or bounty == None or link is None:
        return failure_response("Missing information!")

    user = User.query.filter_by(id = user_id).first()
    if user is None:
        return failure_response("User doesn't exist!", 404)

    item = Item(
        description = description,
        found = found,
        location_id = location_id,
        user_id = user_id,
        bounty = bounty,
        link = link
    )

    db.session.add(item)
    db.session.commit()
    return success_response(item.serialize(), 201)

@app.route("/api/items/<int:item_id>/", methods=["GET"])
def get_item(item_id):
    """
    returns a specific item based on item id
    """
    item = Item.query.filter_by(id = item_id).first()

    if item is None:
        return failure_response("Item does not exist!", 404)

    return success_response(item.serialize())

@app.route("/api/items/<int:item_id>/", methods=["DELETE"])
def delete_item(item_id):
    """
    deletes an item based on item id (protected endpoint)
    """
    item = Item.query.filter_by(id = item_id).first()
    if item is None:
        return failure_response("Item does not exist!", 404)

    success, user = verify_session_token(request)    

    if not success:
        return failure_response("Could not verify session token!", 404)

    if user.id != item.user_id:
        return failure_response("Could not verify item belongs to user", 404)

    
    
    db.session.delete(item)
    db.session.commit()

    return success_response(item.serialize())

@app.route("/api/items/<int:item_id>/", methods = ["POST"])
def update_item(item_id):
    """
    updates an item given item id; cannot edit user or location (protected endpoint)
    """
    item = Item.query.filter_by(id = item_id).first()
    if item is None:
        return failure_response("Item does not exist!", 404)

    success, user = verify_session_token(request)    

    if not success:
        return failure_response("Could not verify session token!", 404)

    if user.id != item.user_id:
        return failure_response("Could not verify item belongs to user", 404)

    body = json.loads(request.data)
    description = body.get("description")
    found = body.get("found")
    bounty = body.get("bounty")

    if description is None or found is None or bounty is None:
        return failure_response("Missing information!")
    
    item.description = description
    item.found = found
    item.bounty = bounty

    db.session.commit()
    return success_response(item.serialize())

# image upload route

@app.route("/api/upload/", methods=["POST"])
def upload():
    """
    Endpoint for uploading an image to AWS given its base64 form,
    then storing/returning the URL of that image
    """
    body = json.loads(request.data)
    image_data = body.get("image_data")

    if image_data is None:
        return failure_response("No base64 image found!")
    
    asset = Asset(image_data = image_data)
    db.session.add(asset)
    db.session.commit()

    return success_response(asset.serialize(), 201)

    

# location routes

@app.route("/api/locations/", methods = ["POST"])
def create_location():
    """
    creates a location object
    """
    body = json.loads(request.data)
    description = body.get("description")

    if description is None:
        return failure_response("Missing description!")

    location = Location(description = description)
    db.session.add(location)
    db.session.commit()

    return success_response(location.serialize())

@app.route("/api/locations/")
def get_locations():
    """
    returns all locations
    """
    return success_response({"Locations": [
        l.serialize() for l in Location.query.all()
    ]})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
