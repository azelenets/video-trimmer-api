# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(email: 'test@test.com', password: '12345678')

movie = user.movies.build
movie.start_time = '00:00:09'
movie.end_time = '00:00:19'
movie.file = File.open("#{Rails.root.join('tmp', 'dream_trailer.mp4')}")
movie.save!