from flask_sqlalchemy import SQLAlchemy
import datetime

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
    password_digest = db.Column(db.String, nullable = False)

    #session information
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)

    def __init__(self, **kwargs):
        """
        initializes a user object
        """
        self.name = kwargs.get("name")
        self.email = kwargs.get("email")
        
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
    category_id = db.Column(db.Integer, db.ForeignKey("category.id"), nullable = False)
    location_id = db.Column(db.Integer, db.ForeignKey("location.id"), nullable = False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable = False)

    def __init__(self, **kwargs):
        """
        initializes an item object
        """
        self.description = kwargs.get("description")
        self.found = kwargs.get("found")
        self.category_id = kwargs.get("category_id")
        self.location_id = kwargs.get("location_id")
        self.user_id = kwargs.get("user_id")

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
    description = db.String(db.String, nullable = False)
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
    description = db.String(db.String, nullable = False)
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