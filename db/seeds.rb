# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
include Faker
Article.destroy_all
user = User.first

1000.times do | index |
  article = Article.create(
      title: Book.title,
      body: Lorem.paragraph,
      user_id: user.id
  )
  puts article.user_id
  article.save
end