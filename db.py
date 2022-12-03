from flask_sqlalchemy import SQLAlchemy
import datetime
import hashlib
import os
import bcrypt
import base64
import boto3
import io
from io import BytesIO
from mimetypes import guess_type, guess_extension
import os
from PIL import Image
import random
import re
import string

db = SQLAlchemy()

# Asset class for images

EXTENSIONS = ["png", "gif", "jpg", "jpeg"]
BASE_DIR = os.getcwd()
S3_BUCKET_NAME = os.environ.get("S3_BUCKET_NAME")
S3_BASE_URL = f"https://{S3_BUCKET_NAME}.s3.us-east-2.amazonaws.com"

class Asset(db.Model):
    """
    Asset model to support images
    """

    __tablename__ = "asset"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    base_url = db.Column(db.String, nullable = False)
    salt = db.Column(db.String, nullable = False)
    extension = db.Column(db.String, nullable = False)
    width = db.Column(db.Integer, nullable = False)
    height = db.Column(db.Integer, nullable = False)
    created_at = db.Column(db.DateTime, nullable = False)

    def __init__(self, **kwargs):
        """
        initializes an Asset object
        """

        self.create(kwargs.get("image_data"))

    def create(self, image_data):
        """
        given an image in base64 encoding, does the following:
        1. rejects the image if it is not a supported filename
        2. generate a random string for the image filename
        3. decodes the image and attempts to upload it to AWS
        """

        try:
            ext = guess_extension(guess_type(image_data)[0])[1:]

            if ext not in EXTENSIONS:
                raise Exception(f"Extension {ext} is not valid!")

            salt = "".join(
                random.SystemRandom().choice(
                    string.ascii_uppercase + string.digits
                )
                for _ in range(16)
            )

            img_str = re.sub("^data:image/.+;base64,", "", image_data)
            img_data = base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))

            self.base_url = S3_BASE_URL
            self.salt = salt
            self.extension = ext
            self.width = img.width
            self.height = img.height
            self.created_at = datetime.datetime.now()

            img_filename = f"{self.salt}.{self.extension}"

            self.upload(img, img_filename)

        except Exception as e:
            print(f"Error when creating image: {e}")
    
    def upload(self, img, img_filename):
        """
        attempts to upload the image into the specified S3 bucket
        """

        try:
            #save image into temporary location in computer
            img_temp_loc = f"{BASE_DIR}/{img_filename}"
            img.save(img_temp_loc)

            #upload image into s3 bucket
            s3_client = boto3.client("s3")
            s3_client.upload_file(img_temp_loc, S3_BUCKET_NAME, img_filename)

            s3_resource = boto3.resource("s3")
            object_acl = s3_resource.ObjectAcl(S3_BUCKET_NAME, img_filename)
            object_acl.put(ACL = "public-read")
            
            #remove image from temporary location
            os.remove(img_temp_loc)

        except Exception as e:
            print(f"Error when uploaindg image: {e}")
    
    def serialize(self):
        """
        serializes an Asset object
        """
        return {
            "url": f"{self.base_url}/{self.salt}.{self.extension}",
            "created_at": str(self.created_at)
        }


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
    found = db.Column(db.Boolean, nullable = False)
    bounty = db.Column(db.Integer, nullable = False)
    location_id = db.Column(db.Integer, db.ForeignKey("location.id"), nullable = False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable = False)
    image_link = db.Column(db.String, nullable = False)

    def __init__(self, **kwargs):
        """
        initializes an item object
        """
        self.description = kwargs.get("description")
        self.found = kwargs.get("found")
        self.location_id = kwargs.get("location_id")
        self.user_id = kwargs.get("user_id")
        self.bounty = kwargs.get("bounty")
        self.image_link = kwargs.get("link")

    def serialize(self):
        """
        serializes an item object
        """
        return {
            "id": self.id,
            "description": self.description,
            "found": self.found,
            "user": User.query.filter_by(id = self.user_id).first().simple_serialize(),
            "bounty": self.bounty,
            "link": self.image_link
        }

    def simple_serialize(self):
        """
        simple serializes an item object
        """
        return {
            "id": self.id,
            "description": self.description,
            "found": self.found,
            "bounty": self.bounty,
            "link": self.image_link
        }

# claim class
class Claim(db.Model):
    """
    a claim that can be submitted by the finder of that object, one to many relationship with user
    """

    __tablename__ = "claim"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable = False)
    item_id = db.Column(db.Integer, db.ForeignKey("item.id"), nullable = False)
    finder_email = db.Column(db.String, nullable = False)

    def __init__(self, **kwargs):
        """
        initializes a claim object
        """
        self.item_id = kwargs.get("item_id")
        self.finder_email = kwargs.get("finder_email")
        self.user_id = kwargs.get("user_id")

    def serialize(self):
        """
        serializes a claim object
        """
        return {
            "id": self.id,
            "item": Item.query.filter_by(id = self.item_id).first().simple_serialize(),
            "finder_email": self.finder_email
        }

    def simple_serialize(self):
        """
        simple serializes a claim object
        """
        return {
            "id": self.id,
            "finder_email": self.finder_email
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