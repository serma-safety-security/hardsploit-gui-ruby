class SwdSetting < ActiveRecord::Base
	# Validations
	validates :cpu_id_address,
    length: {
      is: 8,
      wrong_length: "CPU ID address length must be equal to 8"
    }
  validates :device_id_address,
    length: {
      is: 8,
      wrong_length: "Device ID address length must be equal to 8"
    }
  validates :memory_size_address,
    length: {
      is: 8,
      wrong_length: "Memory size address length must be equal to 8"
    }
  validates :memory_start_address,
    length: {
      is: 8,
      wrong_length: "Memory start address length must be equal to 8"
    }
	# Associations
	belongs_to	:chip
end
