# Patient Registration API

A Rails API for patient registration with Docker environment setup.

## 🚀 Quick Start with Docker

### 1. Start the Application
```bash
# Build and start all services
docker compose build
docker compose up -d

# Verify all services are running
docker compose ps
```

### 2. Setup Database
```bash
# Create and migrate database
docker compose exec web bundle exec rails db:create
docker compose exec web bundle exec rails db:migrate
```

### 3. Access the Application
- **Web Application**: http://localhost:3000
- **API Endpoints**: http://localhost:3000/api/patients

## 🛠️ Development Commands

### Rails Console
```bash
# Access Rails console
docker compose exec web bundle exec rails console

# Inside console:
Patient.all
Patient.count
patient = Patient.first
patient.attributes
```

### Database Access
```bash
# Connect to PostgreSQL
docker compose exec db psql -U patient_registration_api -d patient_registration_api_development

# Inside psql:
\dt                    # List all tables
\d patients           # Describe table structure
SELECT * FROM patients; # View data
\q                    # Exit psql
```

### Application Logs
```bash
# View Rails logs
docker compose logs -f web

# View database logs
docker compose logs -f db
```

### Code Quality
```bash
# Run RuboCop
docker compose exec web bundle exec rubocop
```

### Reset Everything
```bash
# Stop and remove everything
docker compose down -v

# Rebuild from scratch
docker compose build --no-cache
docker compose up -d
docker compose exec web bundle exec rails db:create db:migrate
```

# Patient Registration API Documentation

## Overview
This API allows you to register new patients with their personal information and document photo.

## Base URL
- Development: `http://localhost:3000`

## Endpoints

### POST /api/patients
Register a new patient.

#### Request
- **Method**: POST
- **Content-Type**: `application/json` or `multipart/form-data` (for file uploads)

#### Parameters
```json
{
  "patient": {
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "address": "123 Main Street, City, State 12345",
    "document_photo": "[file upload]"
  }
}
```

#### Field Requirements
- **name**: Required, 2-100 characters
- **email**: Required, valid email format, must be unique
- **phone**: Required, valid phone format (international format supported)
- **address**: Required, 10-500 characters
- **document_photo**: Required, image file

#### Success Response Example
```json
{
  "patient": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "address": "123 Main Street, City, State 12345",
    "document_photo_url": "http://localhost:3000/rails/active_storage/blobs/...",
    "created_at": "2024-01-15T10:30:00.000Z",
    "updated_at": "2024-01-15T10:30:00.000Z"
  }
}
```

#### Error Response Example
```json
{
  "message": "Registration failed",
  "errors": [
    "Name can't be blank",
    "Email must be a valid email address",
    "Phone must be a valid phone number",
    "Address is too short (minimum is 10 characters)"
  ]
}
```

## Email Confirmation
Upon successful registration, a confirmation email is sent to the patient's email address.

### 📧 Email Development Setup
Emails are saved locally using Letter Opener and can be viewed in your browser.

#### View Sent Emails
```bash
# List all sent emails
ls -la tmp/letter_opener/

# Open the most recent email
open tmp/letter_opener/$(ls -t tmp/letter_opener/ | head -1)/rich.html

# Or manually open a specific email
open tmp/letter_opener/[EMAIL_DIRECTORY]/rich.html
```

## Background Jobs
- Email sending is handled by Sidekiq background jobs
- Jobs are queued in Redis
- Sidekiq web interface available at `/sidekiq`

## Testing
Run the test:
```bash
docker compose exec web bundle exec rspec
``` 