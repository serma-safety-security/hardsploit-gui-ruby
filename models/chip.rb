class Chip < ActiveRecord::Base
	# Validations
	validates :reference,
    length: {
      in: 2..25,
      message: "must be between 2 and 25 characters (reference)"
    },
    presence: true,
    uniqueness: true
		validates :description,
	    length: {
				maximum: 140,
	      too_long: "%{count} characters maximum for the description"
	    }
		validates :voltage,
			numericality: true
		validates :manufacturer_id,
			numericality: true
		validates :package_id,
			numericality: true
		validates :chip_type_id,
			numericality: true
	# Associations
	belongs_to :package
	belongs_to :manufacturer
	belongs_to :chip_type
	has_many	:commands,
		dependent: :destroy
	has_many	:pins,
		dependent: :destroy
  has_one		:parallel_setting,
		dependent: :destroy
  has_one		:spi_setting,
		dependent: :destroy
  has_one		:i2c_setting,
		dependent: :destroy
	has_one		:swd_setting,
		dependent: :destroy
	has_one		:uart_setting,
		dependent: :destroy
end
