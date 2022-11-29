from flask_sqlalchemy import SQLAlchemy
import datetime
import hashlib
import os
import bcrypt

db = SQLAlchemy()

# User class

class User(db.Model):
    """
    a user of the app, one to many relationship with item
    """

    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    items = db.relationship("Item", cascade = "delete")
    name = db.Column(db.String, nullable = False)

    #user information
    email = db.Column(db.String, nullable = False, unique = True)
    # password_digest = db.Column(db.String, nullable = False)

    #session information
    # session_token = db.Column(db.String, nullable=False, unique=True)
    # session_expiration = db.Column(db.DateTime, nullable=False)
    # update_token = db.Column(db.String, nullable=False, unique=True)

    def __init__(self, **kwargs):
        """
        initializes a user object
        """
        self.name = kwargs.get("name")
        self.email = kwargs.get("email")
        self.password_digest = bcrypt.hashpw(kwargs.get("password").encode("utf8"), bcrypt.gensalt(rounds=13))
        self.renew_session()
        
    def serialize(self):
        """
        serializes a user object
        """
        return {
            "id": self.id,
            "name": self.name,
            "email": self.email,
            "items": [i.simple_serialize() for i in self.items]
        }

    def simple_serialize(self):
        """
        simple serializes a user object
        """
        return {
            "id": self.id,
            "name": self.name,
            "email": self.email
        }
    
    def _urlsafe_base_64(self):
        """
        Randomly generates hashed tokens (used for session/update tokens)
        """
        return hashlib.sha1(os.urandom(64)).hexdigest()

    def renew_session(self):
        """
        Renews the sessions, i.e.
        1. Creates a new session token
        2. Sets the expiration time of the session to be a day from now
        3. Creates a new update token
        """
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + datetime.timedelta(days=1)
        self.update_token = self._urlsafe_base_64()

    def verify_password(self, password):
        """
        Verifies the password of a user
        """
        return bcrypt.checkpw(password.encode("utf8"), self.password_digest)

    def verify_session_token(self, session_token):
        """
        Verifies the session token of a user
        """
        return session_token == self.session_token and datetime.datetime.now() < self.session_expiration

    def verify_update_token(self, update_token):
        """
        Verifies the update token of a user
        """
        return update_token == self.update_token


# Item class
class Item(db.Model):
    """
    an item that has been lost, many to many relationship with user, one to many relationship with
    category, one to many relationship with location
    """

    __tablename__ = "item"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    description = db.Column(db.String, nullable = False)
    found = db.Column(db.Integer, nullable = False)
    bounty = db.Column(db.Integer, nullable = False)
    category_id = db.Column(db.Integer, db.ForeignKey("category.id"), nullable = False)
    location_id = db.Column(db.Integer, db.ForeignKey("location.id"), nullable = False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable = False)

    def __init__(self, **kwargs):
        """
        initializes an item object
        """
        self.description = kwargs.get("description")
        self.found = kwargs.get("found")
        self.location_id = kwargs.get("location_id")
        self.user_id = kwargs.get("user_id")
        self.bounty = kwargs.get("bounty")

    def serialize(self):
        """
        serializes an item object
        """
        return {
            "id": self.id,
            "description": self.description,
            "found": self.found,
            "category": Category.query.filter_by(id = self.category_id).first().simple_serialize(),
            "location": Location.query.filter_by(id = self.location_id).first().simple_serialize(),
            "user": User.query.filter_by(id = self.user_id).first().simple_serialize()
        }

    def simple_serialize(self):
        """
        simple serializes an item object
        """
        return {
            "id": self.id,
            "description": self.description,
            "found": self.found
        }

# Location class
class Location(db.Model):
    """
    a location where an item was lost/found, one to many relationship with item
    """
    
    __tablename__ = "location"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    description = db.Column(db.String, nullable = False)
    items = db.relationship("Item")

    def __init__(self, **kwargs):
        """
        initializes a location object
        """
        self.description = kwargs.get("description")

    def serialize(self):
        """
        serializes a location object
        """
        return {
            "id": self.id,
            "description": self.description,
            "items": [i.simple_serialize() for i in self.items]
        }

    def simple_serialize(self):
        """
        simple serializes a location object
        """
        return {
            "id": self.id,
            "description": self.description
        }

# category class
class Category(db.Model):
    """
    a category that a lost item falls into, one to many relationship with item
    """

    __tablename__ = "category"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    description = db.Column(db.String, nullable = False)
    items = db.relationship("Item")

    def __init__(self, **kwargs):
        """
        initializes a category object
        """
        self.description = kwargs.get("description")

    def serialize(self):
        """
        serializes a category object
        """
        return {
            "id": self.id,
            "description": self.description,
            "items": [i.simple_serialize() for i in self.items]
        }

    def simple_serialize(self):
        """
        simple serializes a category object
        """
        return {
            "id": self.id,
            "description": self.description
        }