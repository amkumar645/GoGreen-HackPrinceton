import sqlalchemy.ext.declarative
import sqlalchemy
from sqlalchemy.dialects.postgresql import ARRAY

Base = sqlalchemy.ext.declarative.declarative_base()

# Users Table
class Users (Base):
  __tablename__ = 'users'
  # Username
  username = sqlalchemy.Column(sqlalchemy.String, primary_key=True)
  date_started = sqlalchemy.Column(sqlalchemy.String)
  distance = sqlalchemy.Column(sqlalchemy.Float)
  num_pets = sqlalchemy.Column(sqlalchemy.Integer)
  emissions_saved = sqlalchemy.Column(sqlalchemy.Float)
  user_current_xp = sqlalchemy.Column(sqlalchemy.Integer)
  total_xp = sqlalchemy.Column(sqlalchemy.Integer)
  distance_breakdown_walk = sqlalchemy.Column(sqlalchemy.Float)
  distance_breakdown_subway = sqlalchemy.Column(sqlalchemy.Float)
  distance_breakdown_drive = sqlalchemy.Column(sqlalchemy.Float)

class Pets (Base):
  __tablename__ = 'pets'
  username = sqlalchemy.Column(sqlalchemy.String, primary_key=True)
  pets_photos = sqlalchemy.Column(sqlalchemy.ARRAY(sqlalchemy.String))
  pets_names = sqlalchemy.Column(sqlalchemy.ARRAY(sqlalchemy.String))
  pets_levels = sqlalchemy.Column(sqlalchemy.ARRAY(sqlalchemy.Integer))
  pets_current_xp = sqlalchemy.Column(sqlalchemy.ARRAY(sqlalchemy.Integer))  