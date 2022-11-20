from flask_sqlalchemy import SQLAlchemy
import datetime

db = SQLAlchemy()

# join table for users and items
association_table = db.Table(
    "association",
    db.Column("user_id", db.Integer, db.ForeignKey("item.id")),
    db.Column("item_id", db.Integer, db.ForeignKey("user.id"))
)


# User class

class User(db.Model):
    """
    a user of the app, many to many relationship with item
    """

    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    items = db.relationship("Item", secondary = association_table, back_populates = "users")
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
        
    

# Item class
class Item(db.Model):
    """
    an item that has been lost, many to many relationship with user, one to many relationship with
    category, one to many relationship with location
    """


# Location class
class Location(db.Model):
    """
    a location where an item was lost/found, one to many relationship with item
    """

# category class
class Category(db.Model):
    """
    a category that a lost item falls into, one to many relationship with item
    """