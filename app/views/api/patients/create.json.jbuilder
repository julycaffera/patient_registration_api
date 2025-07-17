json.patient do
  json.partial! "api/patients/patient", patient: @patient
end
