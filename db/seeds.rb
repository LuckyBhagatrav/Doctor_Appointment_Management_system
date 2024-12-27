# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users according roles. And also created auth_token for each user.
doctor1 = User.create(email: "doctor1@yopmail.com", password: "Password@123", first_name: "Mr.", last_name: "Doctor1", phone: "+919876543210", status: "active")
doctor1.add_role(:doctor)
payload = { timestamp: Time.now, email: doctor1.email }
secret_key = Rails.application.secrets.secret_key_base
auth_token = JWT.encode(payload, secret_key, "HS256")
DeviceDetail.create(authentication_token: auth_token, user_id: doctor1.id)

doctor2 = User.create(email: "doctor2@yopmail.com", password: "Password@123", first_name: "Mr.", last_name: "Doctor2", phone: "+919876543211", status: "active")
doctor2.add_role(:doctor)
payload = { timestamp: Time.now, email: doctor2.email }
secret_key = Rails.application.secrets.secret_key_base
auth_token = JWT.encode(payload, secret_key, "HS256")
DeviceDetail.create(authentication_token: auth_token, user_id: doctor2.id)

patient1 = User.create(email: "patient1@yopmail.com", password: "Password@123", first_name: "Mr.", last_name: "Patient1", phone: "+919876543212", status: "active")
patient1.add_role(:patient)
payload = { timestamp: Time.now, email: patient1.email }
secret_key = Rails.application.secrets.secret_key_base
auth_token = JWT.encode(payload, secret_key, "HS256")
DeviceDetail.create(authentication_token: auth_token, user_id: patient1.id)

patient2 = User.create(email: "patient2@yopmail.com", password: "Password@123", first_name: "Mr.", last_name: "Patient2", phone: "+919876543213", status: "active")
patient2.add_role(:patient)
payload = { timestamp: Time.now, email: patient2.email }
secret_key = Rails.application.secrets.secret_key_base
auth_token = JWT.encode(payload, secret_key, "HS256")
DeviceDetail.create(authentication_token: auth_token, user_id: patient2.id)

admin = User.create(email: "admin@yopmail.com", password: "Password@123", first_name: "Mr.", last_name: "Admin", phone: "+919876543213", status: "active")
admin.add_role(:admin)
payload = { timestamp: Time.now, email: admin.email }
secret_key = Rails.application.secrets.secret_key_base
auth_token = JWT.encode(payload, secret_key, "HS256")
DeviceDetail.create(authentication_token: auth_token, user_id: admin.id)