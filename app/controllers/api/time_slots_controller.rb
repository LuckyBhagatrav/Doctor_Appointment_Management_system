module Api
  class TimeSlotsController < ApplicationController
    before_action :authenticated_user!
    before_action :set_doctor, only: [:create]
    before_action :find_doctor, only: [:index]

    def create
      time_slot = @current_user.time_slots.new(time_slot_params)
      if time_slot.save
        render json: {time_slot: time_slot, message: 'Time slot created successfully' }, status: :created
      else
        render json: { errors: time_slot.errors.full_messages }, status: :unprocessable_entity
      end
    end


    def index
      time_slots = if params[:doctor_name]
                     User.joins(:time_slots)
                         .where("LOWER(users.first_name) LIKE ? OR LOWER(users.last_name) LIKE ?", "%#{params[:doctor_name].downcase}%", "%#{params[:doctor_name].downcase}%")
                         .includes(:time_slots)
                         .map(&:time_slots)
                         .flatten
                   else
                     TimeSlot.all.includes(:doctor)
                   end
      response = time_slots.map do |slot|
        {
          doctor: "#{slot.doctor.first_name} #{slot.doctor.last_name}",
          time_slot: {
            start_time: slot.start_time,
            end_time: slot.end_time,
            for_date: slot.for_date
          }
        }
      end
      render json: response
    end


    private

    def set_doctor
      @doctor = @current_user
    end

    def find_doctor
      @doctor = User.find_by(id: params[:doctor_id])
    end

    def time_slot_params
      params.require(:time_slot).permit(:start_time, :end_time, :for_date)
    end
  end
end
