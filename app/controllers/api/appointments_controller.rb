module Api
  class AppointmentsController < ApplicationController
    before_action :authenticated_user!
    before_action :set_doctor, only: [:create]

    def create
      appointment = Appointment.new(appointment_params.merge(patient_id: @current_user.id))
      if appointment.save
        AppointmentReminderJob.set(wait_until: appointment.start_time - 30.minutes).perform_later(appointment.id)
        render json: { appointment: appointment, message: 'Appointment booked successfully' }, status: :created
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
