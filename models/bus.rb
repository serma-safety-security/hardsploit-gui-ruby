class Bus < ActiveRecord::Base
	self.table_name = "buses"

	# Validations
	validates :name,
		length: {
			in: 2..10,
			wrong_length: "Bus name needs to be between 2 and 10 characters"
		},
		presence: true,
		uniqueness: true

	# Associations
	has_many :uses
	has_many :signalls,
		through: :uses,
		foreign_key:	"bus_id"
	has_many :commands
end
