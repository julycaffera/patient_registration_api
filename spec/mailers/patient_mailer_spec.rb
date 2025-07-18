require 'rails_helper'

RSpec.describe PatientMailer, type: :mailer do
  describe 'confirmation_email' do
    let(:patient) do
      patient = Patient.new(
        name: 'John Doe',
        email: 'john@example.com',
        phone: '+1234567890',
        address: '123 Main Street, City, State 12345'
      )
      patient.document_photo.attach(
        io: StringIO.new("fake image content"),
        filename: 'test.jpg',
        content_type: 'image/jpeg'
      )
      patient.save!
      patient
    end

    let(:mail) { PatientMailer.confirmation_email(patient) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Registration Confirmation')
      expect(mail.to).to eq([ patient.email ])
      expect(mail.from).to eq([ 'noreply@patient-registration.com' ])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Welcome, John Doe!')
      expect(mail.body.encoded).to match('You have registered successfully!')
      expect(mail.body.encoded).to match('john@example.com')
      expect(mail.body.encoded).to match('\\+1234567890')
      expect(mail.body.encoded).to match('123 Main Street, City, State 12345')
    end

    it 'includes patient details in the email' do
      expect(mail.body.encoded).to include('Name: John Doe')
      expect(mail.body.encoded).to include('Email: john@example.com')
      expect(mail.body.encoded).to include('Phone: +1234567890')
      expect(mail.body.encoded).to include('Address: 123 Main Street, City, State 12345')
    end
  end
end
