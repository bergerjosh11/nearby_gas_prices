require 'httparty'
require 'json'
require 'dotenv/load'

# Load API key from .env file
API_KEY = ENV['API_KEY']
BASE_URL = 'https://api.gasbuddy.com/v1'

def get_gas_stations(zip_code)
  response = HTTParty.get("#{BASE_URL}/stations", {
    query: {
      zip: zip_code,
      distance: 5, # 5 miles radius
      fuel_type: 'regular', # You can change the fuel type if needed
      api_key: API_KEY
    }
  })

  if response.code == 200
    JSON.parse(response.body)['stations']
  else
    puts "Error fetching data: #{response.message}"
    []
  end
end

def sort_stations_by_price(stations)
  stations.sort_by { |station| station['prices']['regular'] }
end

def display_stations(stations)
  stations.each do |station|
    puts "#{station['name']} - $#{station['prices']['regular']} per gallon - #{station['address']}"
  end
end

puts "Enter your ZIP code:"
zip_code = gets.chomp

stations = get_gas_stations(zip_code)
sorted_stations = sort_stations_by_price(stations)

puts "Gas stations sorted by price (lowest to highest) within 5 miles of ZIP code #{zip_code}:"
display_stations(sorted_stations)
