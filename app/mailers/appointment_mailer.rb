class AppointmentMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def reminder_email(appointment)
    @appointment = appointment
    @doctor = @appointment.doctor
    @patient = @appointment.patient
    mail(to: @patient.email, subject: 'Appointment Reminder')
  end
end
