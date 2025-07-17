json.id patient.id
json.name patient.name
json.email patient.email
json.phone patient.phone
json.address patient.address
json.document_photo_url patient.document_photo.attached? ? rails_blob_url(patient.document_photo) : nil
json.created_at patient.created_at
json.updated_at patient.updated_at
