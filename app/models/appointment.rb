class Appointment < ApplicationRecord
  belongs_to :doctor, class_name: 'User', foreign_key: :doctor_id
  belongs_to :patient, class_name: 'User', foreign_key: :patient_id
  belongs_to :time_slot

  validates :start_time, :end_time, :for_date, presence: true
  validate :appointment_within_time_slot
  validate :for_date_must_match_start_time_date
  validate :slot_availability
  validate :appointment_time_within_doctor_availability

  private

  def appointment_within_time_slot
    time_slot = TimeSlot.where(doctor_id: doctor_id)
                        .where('start_time <= ? AND end_time >= ?', start_time, end_time)
                        .exists?

    errors.add(:start_time, 'must be within available time slots') unless time_slot
  end

  def for_date_must_match_start_time_date
  	byebug
    if for_date.present? && time_slot.present? && for_date != time_slot.for_date.to_date
      errors.add(:for_date, "must be the same as the start time's date")
    end
  end

  def slot_availability
    if time_slot.present?
      overlapping_appointments = Appointment.where(time_slot_id: time_slot.id)
                                           .where.not(id: id)  # Exclude the current appointment (if updating)
                                           .where('start_time < ? AND end_time > ?', end_time, start_time)
                                           .exists?

      if overlapping_appointments
        errors.add(:base, "The selected time slot is already booked by another patient.")
      end
    else
      errors.add(:time_slot, "is not available for the selected time.")
    end
  end

  def appointment_time_within_doctor_availability
    if time_slot.present?
      # Check if the start and end time of the appointment are within the doctor's available time slot
      unless start_time >= time_slot.start_time && end_time <= time_slot.end_time
        errors.add(:base, "Appointment time must be within the doctor's available time slot.")
      end
    else
      errors.add(:time_slot, "is not available for the selected time.")
    end
  end
end
