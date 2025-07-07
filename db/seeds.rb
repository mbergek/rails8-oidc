# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Create users"
if User.count == 0
  # TODO: Remove or change test users
  User.create(:first_name => "Joe", :last_name => "Doe", :email => "test1@example.com", :password => "test", :password_confirmation => "test").save(:validate => false)
  User.create(:first_name => "Jane", :last_name => "Smith", :email => "test2@example.com", :password => "test", :password_confirmation => "test").save(:validate => false)
end