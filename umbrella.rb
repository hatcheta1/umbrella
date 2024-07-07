require "http"
require "json"

gmaps_api_key = ENV.fetch("GMAPS_KEY")
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

# Ask the user for their location (use `gets`)
# Get and store the user's location
puts "Where are you located?"
#user_location = gets.chomp.gsub(" ", "%20")
user_location = "Okmulgee"

pp user_location

# Get the user's latitude and longitude from the Google Maps API
maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + gmaps_api_key

resp = HTTP.get(maps_url)
raw_response = resp.to_s
parsed_response = JSON.parse(raw_response)

results = parsed_response.fetch("results") # There are 2 keys in the Hash, results is the first
first_result = results.at(0) # The value of results is an array with 1 element, which is a Hash

geo = first_result.fetch("geometry")
location = geo.fetch("location")

latitude = location.fetch("lat")
longitude = location.fetch("lng")

# Get the weather at the user’s coordinates from the Pirate Weather API

# Display the current temperature and summary of the weather for the next hour



# For each of the next twelve hours, check if the precipitation probability is greater than 10%
# If so, print a message saying how many hours from now and what the precipitation probability is.

# If any of the next twelve hours has a precipitation probability greater than 10%, print “You might want to carry an umbrella!”
# If not, print “You probably won’t need an umbrella today.”
