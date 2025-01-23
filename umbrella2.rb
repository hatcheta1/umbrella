require "http"
require "json"
require "dotenv/load"

gmaps_api_key = ENV.fetch("GOOGLE_MAPS_KEY")
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

puts "========================================"
puts "Will you need an umbrella today?".center(40)
puts "========================================"
puts "\n"

puts "Where are you?"
user_location = gets.chomp

puts "Checking the weather at #{user_location}..."

# Retrieve the coordinates from the Google Maps API
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_api_key}"

response = HTTP.get(gmaps_url).to_s
parsed_response = JSON.parse(response)

first_result = parsed_response.fetch("results")[0]
geo = first_result.fetch("geometry")
location = geo.fetch("location")

latitude = location.fetch("lat")
longitude = location.fetch("lng")

puts "Your coordinates are #{latitude}, #{longitude}."

# Retrieve the weather data from the Pirate Weather API
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{latitude.to_s}, #{longitude.to_s}"

response = HTTP.get(pirate_weather_url).to_s
parsed_response = JSON.parse(response)

# Display current weather
currently = parsed_response.fetch("currently")
current_temperature = currently.fetch("temperature")
puts "It is currently #{current_temperature}ºF."

# Display forecast for the next hour
hourly = parsed_response.fetch("hourly")
hourly_data = hourly.fetch("data")
next_hour = hourly_data[0].fetch("summary")
puts "Next hour: #{next_hour}"

# Display chance of precipitation for the next 12 hours
hours_with_rain = []

12.times do |counter|
  hour = hourly_data.at(counter - 1)
  precipitation_probability = hour.fetch("precipProbability")

  if precipitation_probability > 0.1
    puts "In the next #{counter} hours, there is a #{(precipitation_probability * 100).to_i}% change of precipitation."
    hours_with_rain.push(hour)
  end
end

if hours_with_rain.count > 0
  puts "You might want to carry an umbrella!"
else
  puts "You probably won't need an umbrella today."
end
