class Byte < ActiveRecord::Base
	# Validations
	validates :index,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0
		},
		presence: true
	validates :value,
		format: {
			with: /[A-Fa-f0-9]/,
			message: "Only allow hexadecimal values"
		},
		presence: true
	validates :description,
		length: {
			maximum: 140,
      too_long: "%{count} characters maximum for the description"
		}
	validates :iteration,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}

	# Associations
	belongs_to	:command
end
