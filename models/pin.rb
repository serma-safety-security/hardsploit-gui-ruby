class Pin < ActiveRecord::Base
	# Validations
	validates :number,
	numericality: {
		only_integer: true,
		greater_than_or_equal_to: 1,
	},
	presence: true

	# Associations
	belongs_to	:chip
	belongs_to	:signall,
		foreign_key:	"signal_id"
end
