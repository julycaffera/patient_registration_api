class Patient < ApplicationRecord
  has_one_attached :document_photo

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" },
            uniqueness: { case_sensitive: false }
  validates :phone, presence: true,
            format: { with: /\A\+?[\d\s\-\(\)]{7,20}\z/, message: "must be a valid phone number" }
  validates :address, presence: true, length: { minimum: 10, maximum: 500 }
  validates :document_photo, presence: true

  before_save :normalize_email

  private

  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end
