class Manufacturer < ActiveRecord::Base
	#Validations
	validates :name,
		length: {
			in: 2..25,
			message: "must be between 2 and 25 characters (manufacturer)"
		},
		presence: true,
		uniqueness: true

	# Associations
	has_many :chips,
		dependent: :destroy
end
