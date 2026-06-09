# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Cleaning the database..."
Plant.destroy_all
User.destroy_all

puts "Creating a test user..."
test_user = User.create!(
  email: "botanik@example.com",
  password: "password123",
  first_name: "Desiree",
  last_name: "Kaidi"
)

puts "Creating 5 plants (3 indoor, 2 outdoor)..."

# Plant 1 (Indoor): Monstera
Plant.create!(
  name: "Monty",
  specie: "Monstera (Swiss Cheese Plant)",
  plant_location: "Living room near the window",
  date_added: Date.today - 30,
  last_watered_on: Date.today - 4,
  last_fertilized_on: Date.today - 14,
  sunlight_exposure: "Indirect sunlight",
  system_prompt: "You are the AI care assistant for this Monstera named Monty. Consider that it is located in the living room, prefers indirect light, and needs water every 7 days in summer. Keep responses short and friendly.",
  user: test_user
)

# Plant 2 (Indoor): Snake Plant
Plant.create!(
  name: "Beni",
  specie: "Snake Plant",
  plant_location: "Hallway",
  date_added: Date.today - 15,
  last_watered_on: Date.today - 10,
  last_fertilized_on: nil,
  sunlight_exposure: "Partial shade",
  system_prompt: "You are the AI assistant for Beni the Snake Plant. It stands in a darker hallway and evaporates very little water. Be extremely conservative with watering recommendations.",
  user: test_user
)

# Plant 3 (Indoor): Peace Lily
Plant.create!(
  name: "Lily",
  specie: "Peace Lily",
  plant_location: "Bedroom",
  date_added: Date.today - 45,
  last_watered_on: Date.today - 2,
  last_fertilized_on: Date.today - 30,
  sunlight_exposure: "Shade",
  system_prompt: "You are the AI assistant for Lily the Peace Lily. This plant droops its leaves immediately when thirsty. Check the local weather and remind the user to water it if temperatures rise.",
  user: test_user
)

# Plant 4 (Outdoor): Tomato
Plant.create!(
  name: "Tommy",
  specie: "Tomato Plant",
  plant_location: "Balcony / South facing",
  date_added: Date.today - 20,
  last_watered_on: Date.today - 1,
  last_fertilized_on: Date.today - 7,
  sunlight_exposure: "Full sun",
  system_prompt: "You are the AI assistant for Tommy the Tomato plant. Crucial: This plant lives outside on a south-facing balcony. It is highly dependent on the weather. If it rains heavily today, tell the user NOT to water. If it is hot and sunny, it needs water daily.",
  user: test_user
)

# Plant 5 (Outdoor): Cucumber
Plant.create!(
  name: "Greeny",
  specie: "Cucumber Plant",
  plant_location: "Garden bed",
  date_added: Date.today - 25,
  last_watered_on: Date.today - 1,
  last_fertilized_on: Date.today - 7,
  sunlight_exposure: "Full sun",
  system_prompt: "You are the AI assistant for Greeny the Cucumber plant. It grows outdoors in a garden bed. It needs consistently moist soil and hates cold rain. Monitor the local weather data closely to adjust watering tips.",
  user: test_user
)

puts "Success! Created #{User.count} user and exactly #{Plant.count} plants in the database. 🌱"
