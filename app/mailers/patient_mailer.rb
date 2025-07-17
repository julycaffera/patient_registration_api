class PatientMailer < ApplicationMailer
  def confirmation_email(patient)
    @patient = patient
    mail(
      to: @patient.email,
      subject: "Registration Confirmation"
    )
  end
end
