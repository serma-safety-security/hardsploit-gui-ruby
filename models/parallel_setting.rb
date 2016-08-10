class ParallelSetting < ActiveRecord::Base
	# Validations
	validates :total_size,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}
	validates :page_size,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}
	validates :word_size,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}
	validates :read_latency,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			less_than_or_equal_to: 1600,
			allow_nil: true
		}
	validates :write_latency,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}

	# Associations
	belongs_to	:chip
end
