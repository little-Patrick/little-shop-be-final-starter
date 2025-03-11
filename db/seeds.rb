# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d little_shop_development db/data/little_shop_development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

# Coupon.create!(name: "10% Off", code: "TENOFF", percent_off: 10, merchant: Merchant.first, active: true)
# Coupon.create!(name: "$5 Off", code: "FIVEOFF", dollars_off: 5, merchant: Merchant.first, active: true)
# Coupon.create!(name: "20% Off", code: "TWENTYOFF", percent_off: 20, merchant: Merchant.last, active: false)
# Coupon.create!(name: "$10 Off", code: "TENBUCKS", dollars_off: 10, merchant: Merchant.last, active: true)

