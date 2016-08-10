class ChipType < ActiveRecord::Base
	# Validations
	validates :name,
    length: {
      in: 2..20,
      message: "must be between 2 and 20 characters (chip type)"
    },
    presence: true,
    uniqueness: true

	# Associations
	has_many :chips,
		dependent: :destroy
end
