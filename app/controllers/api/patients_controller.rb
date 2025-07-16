module Api
  class PatientsController < BaseController
    def create
      @patient = Patient.new(patient_params)

      if @patient.save
        render :create, status: :created
      else
        render json: {
          message: "Registration failed",
          errors: @patient.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    private

    def patient_params
      params.require(:patient).permit(:name, :email, :phone, :address, :document_photo)
    end
  end
end
