# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Camera::create( label: 'CF-01',
                ipv4: '192.168.1.33',
                username: 'developer',
                password: 'dev123' )

User::create( username: 'admin',
              password: '0',
              password_confirmation: '0',
              cameras: '',
              is_admin: true )