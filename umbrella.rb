require "http"
require "json"

gmaps_api_key = ENV[GMAPS_KEY]
pirate_weather_api_key = ENV[PIRATE_WEATHER_KEY]

# Ask the user for their location (use `gets`)
puts "Where are you?"
location = gets.chomp

# Get and store the user's location

# Get the user's latitude and longitude from the Google Maps API

# Get the weather at the user’s coordinates from the Pirate Weather API

# Display the current temperature and summary of the weather for the next hour



# For each of the next twelve hours, check if the precipitation probability is greater than 10%
# If so, print a message saying how many hours from now and what the precipitation probability is.

# If any of the next twelve hours has a precipitation probability greater than 10%, print “You might want to carry an umbrella!”
# If not, print “You probably won’t need an umbrella today.”
