# File to reset database when needed
import sqlalchemy
import sqlalchemy.orm
import models
import os

db_url = os.getenv("DATABASE_URL")

# If you need to manually add something, update the fields below according
# to the Instructions for Updating TigerJobs document
# For info on the fields, look at the TigerJobs Programmer's Guide

def add_test_user(session):
  user = models.Users(
    username = "amkumar",
    date_started = "03/29/2024",
    distance = 15233,
    num_pets = 3,
    emissions_saved = 8820.0,
    user_current_xp=1000,
    total_xp = 5732,
    distance_breakdown_drive = 2750,
    distance_breakdown_subway = 8000,
    distance_breakdown_walk = 4483
  )
  session.add(user)
  user = models.Users(
    username = "user2",
    date_started = "03/19/2024",
    distance = 15233,
    num_pets = 3,
    emissions_saved = 2120.0,
    user_current_xp=500,
    total_xp = 5732,
    distance_breakdown_drive = 2750,
    distance_breakdown_subway = 8000,
    distance_breakdown_walk = 4483
  )
  session.add(user)
  user = models.Users(
    username = "user3",
    date_started = "03/13/2024",
    distance = 15233,
    num_pets = 3,
    emissions_saved = 7320.0,
    user_current_xp=500,
    total_xp = 5732,
    distance_breakdown_drive = 2750,
    distance_breakdown_subway = 8000,
    distance_breakdown_walk = 4483
  )
  session.add(user)

def add_test_pets(session):
  pets = models.Pets(
    username = "amkumar",
    pets_photos = ["octopus.jpeg", "rainbow_monkey.jpeg", "ghost.jpg"],
    pets_names = ["Tim", "Jane", "Fluffy"],
    pets_levels = [5, 3, 1],
    pets_current_xp = [73, 68, 0]
  )
  session.add(pets)

def main():
    # Create engine and drop and recreate all tables
    engine = sqlalchemy.create_engine(db_url)
    models.Base.metadata.drop_all(engine)
    models.Base.metadata.create_all(engine)

    with sqlalchemy.orm.Session(engine) as session:
        # Add whatever you need here and uncomment corresponding functions above
        add_test_user(session)
        add_test_pets(session)
        session.commit()

    engine.dispose()

if __name__ == '__main__':
    main()