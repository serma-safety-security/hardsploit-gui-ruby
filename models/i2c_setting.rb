class I2cSetting < ActiveRecord::Base
	# Validations
	validates :address_w,
		format: {
			with: /[A-Fa-f0-9]{2}/,
			message: "Write address only allow hexadecimal values"
		}
		validates :address_r,
			format: {
				with: /[A-Fa-f0-9]{2}/,
				message: "Read address only allow hexadecimal values"
			}
		validates :frequency,
			numericality: {
				only_integer: true,
				greater_than_or_equal_to: 100,
				less_than_or_equal_to: 1000,
				allow_nil: true
			}
		validates :write_page_latency,
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

	# Associations
	belongs_to	:chip
end
