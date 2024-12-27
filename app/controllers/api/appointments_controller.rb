module Api
  class AppointmentsController < ApplicationController
    before_action :authenticated_user!
    before_action :set_doctor, only: [:create]

    def create
      appointment = Appointment.new(appointment_params.merge(patient_id: @current_user.id))
      if appointment.save
        time_slot_ids = TimeSlot.where(doctor_id: params[:appointment][:doctor_id]).pluck(:id)
        index = time_slot_ids.index(params[:appointment][:time_slot_id])
        next_slot = if index && index + 1 < time_slot_ids.length
                      TimeSlot.find_by(id: time_slot_ids[index + 1], doctor_id: params[:appointment][:doctor_id])
                    else
                      nil
                    end
        AppointmentReminderJob.set(wait_until: appointment.start_time - 30.minutes).perform_later(appointment.id)
        render json: {
          appointment: appointment,
          next_available_slot: next_slot,
          message: 'Appointment booked successfully'
        }, status: :created
      else
        render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
      end
    end


    def index
      appointments = Appointment.all.includes(:doctor, :patient)
      render json: appointments, include: [:doctor, :patient]
    end

    private

    def set_doctor
      @doctor = User.find(params[:appointment][:doctor_id])
    end

    def appointment_params
      params.require(:appointment).permit(:doctor_id, :time_slot_id, :start_time, :end_time, :for_date)
    end
  end
end
