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
        self.description = kwargs.get("description")
        self.found = kwargs.get("found")

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
