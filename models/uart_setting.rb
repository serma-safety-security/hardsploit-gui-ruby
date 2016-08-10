class UartSetting < ActiveRecord::Base
	# Validations
	validates :baud_rate,
    numericality: {
			only_integer: true,
      allow_nil: true
    }
  validates :idle_line,
    numericality: {
			only_integer: true,
      less_than_or_equal_to: 8,
      message: "Idle line length must be equal to 8",
      allow_nil: true
    }
  validates :parity_bit,
    numericality: {
			only_integer: true,
      less_than_or_equal_to: 8,
      message: "Parity bit length must be equal to 8",
      allow_nil: true
    }
  validates :parity_type,
    numericality: {
			only_integer: true,
      less_than_or_equal_to: 8,
      message: "Parity type length must be equal to 8",
      allow_nil: true
    }
  validates :stop_bits_nbr,
    numericality: {
			only_integer: true,
      less_than_or_equal_to: 8,
      message: "Stop bits number length must be equal to 8",
      allow_nil: true
    }
  validates :word_size,
    numericality: {
			only_integer: true,
      less_than_or_equal_to: 8,
      message: "Word size length must be equal to 8",
      allow_nil: true
    }
		validates :return_type,
	    numericality: {
				only_integer: true,
	      less_than_or_equal_to: 2,
	      message: "Word size CR / LF type",
	      allow_nil: true
	    }
	# Associations
	belongs_to	:chip
end
