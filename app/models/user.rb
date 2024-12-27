class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum status: { active: 0, disabled: 1, unverified: 2, compliant: 3, rejected: 4 }

  has_many :device_details, dependent: :destroy
  has_many :time_slots, foreign_key: :doctor_id, dependent: :destroy
  has_many :appointments, foreign_key: :patient_id, dependent: :destroy
end
