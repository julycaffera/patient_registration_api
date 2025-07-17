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
