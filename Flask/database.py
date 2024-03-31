from typing import List
import sqlalchemy
import sqlalchemy.orm
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import func
import models
import os

# Database URL
db_url = os.getenv("DATABASE_URL")
# Global engine to use
engine =  sqlalchemy.create_engine(db_url, pool_pre_ping=True)

#----------------------------------------------------------------------
# User Queries
#----------------------------------------------------------------------
# Add user to database
def add_user(user:models.Users):
  with sqlalchemy.orm.Session(engine) as session:
    session.add(user)
  session.commit()

# Get user from username
def get_user(username) -> models.Users:
  user = None
  with sqlalchemy.orm.Session(engine) as session:
    user = session.query(models.Users).filter(
      models.Users.username == username).first()
  return user

# Get all users
def get_all_users() -> List[models.Users]:
  users = []
  with sqlalchemy.orm.Session(engine) as session:
    users = session.query(models.Users).order_by(
      models.Users.emissions_saved.desc(),
    ).all()
  return users

# Update user
def update_user(user:models.Users):
  with sqlalchemy.orm.Session(engine) as session:
    session.query(models.Users).filter(
      models.Users.username == user.username).update(
        {
          'username': user.username,
          'date_started': user.date_started,
          "distance": user.distance,
          "num_pets": user.num_pets,
          'emissions_saved': user.emissions_saved,
          'user_current_xp': user.user_current_xp,
          'total_xp': user.total_xp,
          'distance_breakdown_drive': user.distance_breakdown_drive,
          'distance_breakdown_subway': user.distance_breakdown_subway,
          'distance_breakdown_walk': user.distance_breakdown_walk
        }
      )
    session.commit()

#----------------------------------------------------------------------
# Pets Queries
#----------------------------------------------------------------------
# Get pets from username
def get_pets(username) -> models.Pets:
  pets = None
  with sqlalchemy.orm.Session(engine) as session:
    pets = session.query(models.Pets).filter(
      models.Pets.username == username).first()
  return pets

# Add pet to username
def update_pet(pet:models.Pets):
  with sqlalchemy.orm.Session(engine) as session:
    session.query(models.Pets).filter(
      models.Pets.username == pet.username).update(
        {
          'username': pet.username,
          'pets_photos': pet.pets_photos,
          'pets_names': pet.pets_names,
          'pets_levels': pet.pets_levels,
          'pets_current_xp': pet.pets_current_xp
        }
      )
    session.commit()