require "http"
require "json"

gmaps_api_key = ENV.fetch("GMAPS_KEY")
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

# Ask the user for their location (use `gets`)
# Get and store the user's location
puts "Where are you located?"
user_location = gets.chomp
formatted_user_location = user_location.gsub(" ", "%20")

puts "Checking the weather in #{user_location}..."

# Get the user's latitude and longitude from the Google Maps API
maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + formatted_user_location + "&key=" + gmaps_api_key

resp = HTTP.get(maps_url)
raw_response = resp.to_s
parsed_response = JSON.parse(raw_response)

results = parsed_response.fetch("results") # There are 2 keys in the Hash, results is the first
first_result = results.at(0) # The value of results is an array with 1 element, which is a Hash

geo = first_result.fetch("geometry")
location = geo.fetch("location")

latitude = location.fetch("lat")
longitude = location.fetch("lng")

# Display the location for the user
puts "Your coordinates are #{latitude}, #{longitude}."

# Get the weather at the user’s coordinates from the Pirate Weather API
pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_api_key + "/" + latitude.to_s + ", " + longitude.to_s

resp = HTTP.get(pirate_weather_url)
raw_response = resp.to_s
parsed_response = JSON.parse(raw_response)

# Display the current temperature
currently = parsed_response.fetch("currently")
puts "The current temperature is #{currently.fetch("temperature")}ºF."

# Display a summary of the weather for the next hour
hourly = parsed_response.fetch("hourly")
hourly_data = hourly.fetch("data")
puts "Next hour: #{hourly_data.at(0).fetch("summary")}"

# For each of the next twelve hours, check if the precipitation probability is greater than 10%
# If so, print a message saying how many hours from now and what the precipitation probability is.
hours_with_rain = [] #Create list of the data of each hour that has rain

(1..12).each do |counter|
  hour = hourly_data.at(counter - 1) # Adjust index to access the correct hour
  if hour.fetch("precipProbability") > 0.1
    puts "In the next #{counter} hours, there is a #{(hour.fetch("precipProbability") * 100).to_i}% chance of precipitation"
    hours_with_rain.push(hour)
  end
end

# If any of the next twelve hours has a precipitation probability greater than 10%, print “You might want to carry an umbrella!”
# If not, print “You probably won’t need an umbrella today.”
if hours_with_rain.count > 0
  puts "You might want to carry an umbrella!"
else
  puts "You probably won't need an umbrella today."
end
