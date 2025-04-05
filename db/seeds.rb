# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'open-uri'
require 'json'

Script.destroy_all # Clear existing records to avoid duplicates

# URL for GitHub API endpoint for the 'overrides/scripts' directory in the repo
url = "https://api.github.com/repos/Nomi-CEu/Nomi-CEu/contents/overrides/scripts?ref=main"

begin
  response = URI.open(url).read
  files = JSON.parse(response)
rescue StandardError => e
  puts "Error fetching scripts: #{e.message}"
  files = []
end

files.each do |file|
  # Skip directories, only process files
  next if file["type"] != "file"

  # Create a new script record.
  # file['name'] is the filename, and file['path'] is the relative path in the repo.
  Script.find_or_create_by!(name: file["name"]) do |script|
    script.path = file["path"]
    # Set defaults if needed (for example, assigned and completed)
    script.assigned = false
    script.completed = false
  end
end

puts "Seeded #{files.count} scripts."
