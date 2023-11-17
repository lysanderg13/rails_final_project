require "csv"

ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='products';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='categories';")

# open the categories.csv
file_one = Rails.root.join("db/Categories.csv")

puts "Loading Categories from the CSV file: #{file_one}"

csv_data_one = File.read(file_one)

categories_data = CSV.parse(csv_data_one, headers: true, encoding: "utf-8")

# Loop to add crews
categories_data.each do |c|
  categories = Category.create(
    category_name: c["category_name"]
  )
  puts categories.category_name
end
puts "Created #{Category.count} Categories."

# open the crews.csv
file_two = Rails.root.join("db/Product.csv")

puts "Loading Products from the CSV file: #{file_two}"

csv_data_two = File.read(file_two)

products_data = CSV.parse(csv_data_two, headers: true, encoding: "utf-8")

# Loop to add products
products_data.each do |c|
  products = Product.create(
    name:           c["name"],
    description:    c["description"],
    price:          c["price"],
    stock_quantity: c["stock_quantity"],
    image:          c["image"],
    category_id:    c["category_id"]
  )
  puts products.name
  puts products.description
  puts products.price
  puts products.stock_quantity
  puts products.category_id
end
puts "Created #{Product.count} Products."
