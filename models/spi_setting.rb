class SpiSetting < ActiveRecord::Base
	# Validations
	validates :mode,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			less_than_or_equal_to: 3,
			allow_nil: true
		}
	validates :write_page_latency,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}
	validates :command_read,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}
	validates :command_write,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}
	validates :command_write_enable,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}
	validates :command_erase,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}
	validates :erase_time,
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
	validates :total_size,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			allow_nil: true
		}
	validates :is_flash,
		numericality: {
			only_integer: true,
			greater_than_or_equal_to: 0,
			less_than_or_equal_to: 1,
			allow_nil: true
		}
	# Associations
	belongs_to	:chip
end
