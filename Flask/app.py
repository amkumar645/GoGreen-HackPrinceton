import flask
import database
import helper
import random
import json

app = flask.Flask(__name__, template_folder='.')

pets_images = [
 "octopus.jpeg", 
 "rainbow_monkey.jpeg", 
 "ghost.jpg",
 "monster.jpeg",
 "corgi.avif"
]

@app.route('/', methods=['GET'])
def default_route():
  return "Hi"

#----------------------------------------------------------------------
# User Routes
#----------------------------------------------------------------------
# Get User Route
@app.route('/user/<username>', methods=['GET'])
def get_user(username):
  user_json = helper.get_json_for_user(database.get_user(username))
  return flask.jsonify(user_json)

@app.route('/user/all', methods=['GET'])
def get_users():
  users = database.get_all_users()
  users_json = []
  for user in users:
    users_json.append(helper.get_json_for_user(user))
  return flask.jsonify(users_json)

#----------------------------------------------------------------------
# Pets Routes
#----------------------------------------------------------------------
# Get Pets Route
@app.route('/pets/<username>', methods=['GET'])
def get_pets(username):
  pets_json = helper.get_json_for_pets(database.get_pets(username), database.get_user(username))
  return flask.jsonify(pets_json)

@app.route('/pets/<username>/add/<name>', methods=['POST'])
def add_pet(username, name):
  pets = database.get_pets(username)
  new_photo = random.choice(pets_images)
  pets.pets_photos.append(new_photo)
  pets.pets_current_xp.append(0)
  pets.pets_levels.append(1)
  pets.pets_names.append(name)
  database.update_pet(pets)

  user = database.get_user(username)
  user.user_current_xp = user.user_current_xp - 500
  user.num_pets = user.num_pets + 1
  database.update_user(user)

  pets_json = helper.get_json_for_pets(database.get_pets(username), database.get_user(username))
  return flask.jsonify(pets_json)

@app.route('/pets/<username>/levelup/<name>', methods=['POST'])
def level_up_pet(username, name):
  pets = database.get_pets(username)
  pet_index = pets.pets_names.index(name)
  pets.pets_levels[pet_index] = pets.pets_levels[pet_index] + 1
  database.update_pet(pets)

  user = database.get_user(username)
  user.user_current_xp = user.user_current_xp - 100
  database.update_user(user)

  pets_json = helper.get_json_for_pets(database.get_pets(username), database.get_user(username))
  return flask.jsonify(pets_json)
#----------------------------------------------------------------------
# Dashboard Routes
#----------------------------------------------------------------------
@app.route('/dashboard/newtrip/<username>', methods=['POST'])
def add_trip(username):
  # Extract tripSpeeds, transitStops, and totalDistance from the URL query string
  trip_speeds_json = flask.request.args.get('tripSpeeds')
  transit_stops_json = flask.request.args.get('transitStops')
  total_distance_json = flask.request.args.get('totalDistance')

  # Parse JSON data
  try:
      trip_speeds = json.loads(trip_speeds_json)
      transit_stops = json.loads(transit_stops_json)
      total_distance = json.loads(total_distance_json)
  except (json.JSONDecodeError, TypeError):
      return flask.jsonify({'error': 'Invalid JSON data in query parameters'}), 400

  # Determine mode of transportation
  max_speed = max(trip_speeds)
  if max_speed <= 10.0:
    mode_of_transportation = "Walking/Running"
  elif max_speed <= 20.0:
    mode_of_transportation = "Biking"
  else:
    transit_pattern_count = 0
    speed_drops_near_stops = 0
    current_state = None
    for i, stop in enumerate(transit_stops):
      if stop:
        if current_state is False:
          transit_pattern_count += 1
          # Check if speed drops near this stop
          if i > 0 and i < len(transit_stops) - 1:
            prev_speed = trip_speeds[i - 1]
            curr_speed = trip_speeds[i]
            next_speed = trip_speeds[i + 1]
            if prev_speed > curr_speed < next_speed:
              speed_drops_near_stops += 1
        current_state = True
      else:
        current_state = False

    if transit_pattern_count >= 3 and speed_drops_near_stops >= 2:
      mode_of_transportation = "Subway/Bus"
    else:
      mode_of_transportation = "Driving"
  if mode_of_transportation == "Walking/Running" or mode_of_transportation == "Biking":
    emissions_saved = 0.2 * total_distance
    mode_of_transportation = "Walking/Running/Biking"
  elif mode_of_transportation == "Subway/Bus":
    emissions_saved = 0.00015 * total_distance
  elif mode_of_transportation == "Driving":
    emissions_saved = 0
  
  xp_awarded = int(emissions_saved / 10)
  
  user = database.get_user(username)
  user.user_current_xp = user.user_current_xp + xp_awarded
  user.total_xp = user.total_xp + xp_awarded
  user.emissions_saved = user.emissions_saved + emissions_saved
  user.distance = user.distance + total_distance
  if mode_of_transportation == "Walking/Running/Biking":
    user.distance_breakdown_walk = user.distance_breakdown_walk + total_distance
  elif mode_of_transportation == "Subway/Bus":
    user.distance_breakdown_subway = user.distance_breakdown_subway + total_distance
  else:
    user.distance_breakdown_drive = user.distance_breakdown_drive + total_distance
  database.update_user(user)

  dashboard_json = {
    'emissions_saved': emissions_saved,
    'total_distance': total_distance,
    'mode_of_transport': mode_of_transportation,
    'xp_awarded': xp_awarded,
  }
  return dashboard_json