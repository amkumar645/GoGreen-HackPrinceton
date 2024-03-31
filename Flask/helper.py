def list_to_string(list):
    s = ''
    for item in list:
        s += str(item) + ','
    return s[:-1]

def get_json_for_user(user):
  user_json = {
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
  return user_json

def get_json_for_pets(pets, user):
  pets_json = {
    'username': pets.username,
    'pets_photos': list_to_string(pets.pets_photos),
    'pets_names': list_to_string(pets.pets_names),
    'pets_levels': list_to_string(pets.pets_levels),
    'pets_current_xp': list_to_string(pets.pets_current_xp),
    'user_current_xp': user.user_current_xp
  }
  return pets_json