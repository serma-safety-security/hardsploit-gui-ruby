class Signall < ActiveRecord::Base
	self.table_name = "signals"

	# Validations
	validates :name,
		length: {
			in: 1..10,
			wrong_length: "Signal name needs to be between 1 and 10 characters"
		},
		presence: true,
		uniqueness: true

	# Associations
	has_many :uses,
		foreign_key:	"signal_id"
	has_many :buses,
		through: :uses,
		foreign_key:	"signal_id"
	has_many :pins
end
