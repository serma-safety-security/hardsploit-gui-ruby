class Command < ActiveRecord::Base
  # Validations
  validates :name,
    length: {
      in: 2..25,
      wrong_length: "Name needs to be between 2 and 25 characters"
    },
    presence: true
		validates :description,
	    length: {
				maximum: 140,
	      too_long: "%{count} characters maximum for the description"
	    }

  # Associations
	has_many	:bytes,
    dependent: :destroy
  belongs_to	:chip
	belongs_to	:bus
end
