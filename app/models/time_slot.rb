class TimeSlot < ApplicationRecord
  belongs_to :doctor, class_name: 'User', foreign_key: :doctor_id
  has_many :appointments, dependent: :destroy

  validates :start_time, :end_time, :for_date, presence: true
  validate :no_overlapping_time_slots
  validate :unique_availability_time_period

  private

  def no_overlapping_time_slots
    overlapping_slots = TimeSlot.where(doctor_id: doctor_id)
                                .where.not(id: id)
                                .where('for_date = ?', for_date)
                                .where('start_time < ? AND end_time > ?', end_time, start_time)

    errors.add(:base, 'Time slot overlaps with existing slot for the same date') if overlapping_slots.exists?
  end

  def unique_availability_time_period
    existing_slot = TimeSlot.where(doctor_id: doctor_id)
                            .where(for_date: for_date, start_time: start_time, end_time: end_time)
                            .exists?

    errors.add(:base, 'This availability time period already exists for the doctor') if existing_slot
  end
end
