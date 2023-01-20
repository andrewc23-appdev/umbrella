require ("open-uri")
require ("json")

p "Where are you located?"

# getting location

#location = gets.chomp
location = "Chicago"
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{ENV.fetch("GMAPS_KEY")}"

# getting lat and long
gmaps_raw_data = URI.open(gmaps_url).read
parsed_data = JSON.parse(gmaps_raw_data)
only_result = parsed_data.fetch("results")[0]
geometry = only_result.fetch("geometry")
location = geometry.fetch("location")
lat = location.fetch("lat")
lng = location.fetch("lng")

p "Your coordinates are #{lat}, #{lng}."

#getting 
darksky_url = "https://api.darksky.net/forecast/#{ENV.fetch("DARK_SKY_KEY")}/#{lat},#{lng}"
darksky_raw_data = URI.open(darksky_url).read
darksky_parsed_data = JSON.parse(darksky_raw_data)
currently = darksky_parsed_data.fetch("currently")
temperature = currently.fetch("temperature")

p "It is currently #{temperature}°F."

hourly = darksky_parsed_data.fetch("hourly")
hourly_data = hourly.fetch("data")

p "Next hour: #{hourly_data[1].fetch("summary")}"

counter = 1
rain_prob = 0
umbrella = nil

while counter <= 5
  rain_prob = hourly_data[counter].fetch("precipProbability")
  p "In #{counter - 1} hours, there is a #{(rain_prob * 100).to_i}% chance of precipitation."
  
  if (umbrella == true || (rain_prob * 100) >= 20)
    umbrella = true
  end

  counter = counter + 1
end

if umbrella
  p "You might want to take an umbrella!"
else
  p "You probably won't need an umbrella."
end
