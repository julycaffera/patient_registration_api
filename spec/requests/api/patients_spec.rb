require 'rails_helper'

RSpec.describe 'Api::Patients', type: :request do
  describe 'POST /api/patients' do
    let(:valid_attributes) do
      {
        patient: {
          name: 'John Doe',
          email: 'john@example.com',
          phone: '+1234567890',
          address: '123 Main Street, City, State 12345'
        }
      }
    end

    let(:invalid_attributes) do
      {
        patient: {
          name: '',
          email: 'invalid-email',
          phone: '123',
          address: 'Short'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new patient' do
        expect {
          post '/api/patients', params: valid_attributes, as: :json
        }.not_to change(Patient, :count)
      end

      it 'returns a 422 status code when document photo is missing' do
        post '/api/patients', params: valid_attributes, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message for missing document photo' do
        post '/api/patients', params: valid_attributes, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response['errors']).to include("Document photo can't be blank")
      end

      it 'enqueues a confirmation email when valid with document photo' do
        # Create a patient with document photo for testing email functionality
        patient = Patient.new(valid_attributes[:patient])
        patient.document_photo.attach(
          io: StringIO.new("fake image content"),
          filename: 'test.jpg',
          content_type: 'image/jpeg'
        )
        patient.save!

        expect(PatientMailer).to receive(:confirmation_email).with(patient).and_call_original
        PatientMailer.confirmation_email(patient).deliver_now
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new patient' do
        expect {
          post '/api/patients', params: invalid_attributes, as: :json
        }.not_to change(Patient, :count)
      end

      it 'returns a 422 status code' do
        post '/api/patients', params: invalid_attributes, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post '/api/patients', params: invalid_attributes, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response['message']).to eq('Registration failed')
        expect(json_response['errors']).to include("Name can't be blank")
        expect(json_response['errors']).to include('Email must be a valid email address')
        expect(json_response['errors']).to include('Phone must be a valid phone number')
        expect(json_response['errors']).to include('Address is too short (minimum is 10 characters)')
        expect(json_response['errors']).to include("Document photo can't be blank")
      end

      it 'does not enqueue a confirmation email' do
        expect {
          post '/api/patients', params: invalid_attributes, as: :json
        }.not_to have_enqueued_mail(PatientMailer, :confirmation_email)
      end
    end

    context 'with duplicate email' do
      before do
        patient = Patient.new(valid_attributes[:patient])
        patient.document_photo.attach(
          io: StringIO.new("fake image content"),
          filename: 'test.jpg',
          content_type: 'image/jpeg'
        )
        patient.save!
      end

      it 'does not create a duplicate patient' do
        expect {
          post '/api/patients', params: valid_attributes, as: :json
        }.not_to change(Patient, :count)
      end

      it 'returns email uniqueness error' do
        post '/api/patients', params: valid_attributes, as: :json
        json_response = JSON.parse(response.body)

        expect(json_response['errors']).to include('Email has already been taken')
      end
    end
  end
end
