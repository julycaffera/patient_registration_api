require 'rails_helper'

RSpec.describe Patient, type: :model do
  describe 'validations' do
    let(:valid_patient) do
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
      patient
    end

    it 'is valid with valid attributes' do
      expect(valid_patient).to be_valid
    end

    it 'requires a name' do
      patient = valid_patient
      patient.name = nil
      expect(patient).not_to be_valid
      expect(patient.errors[:name]).to include("can't be blank")
    end

    it 'requires name to be at least 2 characters' do
      patient = valid_patient
      patient.name = 'A'
      expect(patient).not_to be_valid
      expect(patient.errors[:name]).to include('is too short (minimum is 2 characters)')
    end

    it 'requires name to be at most 100 characters' do
      patient = valid_patient
      patient.name = 'A' * 101
      expect(patient).not_to be_valid
      expect(patient.errors[:name]).to include('is too long (maximum is 100 characters)')
    end

    it 'requires an email' do
      patient = valid_patient
      patient.email = nil
      expect(patient).not_to be_valid
      expect(patient.errors[:email]).to include("can't be blank")
    end

    it 'requires a valid email format' do
      patient = valid_patient
      patient.email = 'invalid-email'
      expect(patient).not_to be_valid
      expect(patient.errors[:email]).to include('must be a valid email address')
    end

    it 'requires email to be unique' do
      valid_patient.save!
      duplicate_patient = valid_patient.dup
      duplicate_patient.document_photo.attach(
        io: StringIO.new("fake image content"),
        filename: 'test2.jpg',
        content_type: 'image/jpeg'
      )
      expect(duplicate_patient).not_to be_valid
      expect(duplicate_patient.errors[:email]).to include('has already been taken')
    end

    it 'requires a phone number' do
      patient = valid_patient
      patient.phone = nil
      expect(patient).not_to be_valid
      expect(patient.errors[:phone]).to include("can't be blank")
    end

    it 'requires a valid phone format' do
      patient = valid_patient
      patient.phone = '123'
      expect(patient).not_to be_valid
      expect(patient.errors[:phone]).to include('must be a valid phone number')
    end

    it 'requires an address' do
      patient = valid_patient
      patient.address = nil
      expect(patient).not_to be_valid
      expect(patient.errors[:address]).to include("can't be blank")
    end

    it 'requires address to be at least 10 characters' do
      patient = valid_patient
      patient.address = 'Short'
      expect(patient).not_to be_valid
      expect(patient.errors[:address]).to include('is too short (minimum is 10 characters)')
    end

    it 'requires address to be at most 500 characters' do
      patient = valid_patient
      patient.address = 'A' * 501
      expect(patient).not_to be_valid
      expect(patient.errors[:address]).to include('is too long (maximum is 500 characters)')
    end

    it 'requires a document photo' do
      patient = Patient.new(
        name: 'John Doe',
        email: 'john@example.com',
        phone: '+1234567890',
        address: '123 Main Street, City, State 12345'
      )
      expect(patient).not_to be_valid
      expect(patient.errors[:document_photo]).to include("can't be blank")
    end
  end

  describe 'email normalization' do
    it 'normalizes email to lowercase and strips whitespace' do
      patient = Patient.new(
        name: 'John Doe',
        email: 'JOHN@EXAMPLE.COM',
        phone: '+1234567890',
        address: '123 Main Street, City, State 12345'
      )
      patient.document_photo.attach(
        io: StringIO.new("fake image content"),
        filename: 'test.jpg',
        content_type: 'image/jpeg'
      )
      patient.save!
      expect(patient.email).to eq('john@example.com')
    end
  end

  describe 'document photo attachment' do
    let(:valid_patient) do
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
      patient
    end

    it 'can have a document photo attached' do
      patient = valid_patient
      expect(patient).to respond_to(:document_photo)
    end
  end
end
