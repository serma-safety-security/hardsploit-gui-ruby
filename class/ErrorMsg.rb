class ErrorMsg

	def hardsploit_not_found
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'Hardsploit Connectivity',
			'Hardsploit not detected. Please check the USB connection'
		).exec
		return true
	end

	def usb_error
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'Hardsploit USB error',
			'USB error occured'
		).exec
	end

	def no_chip_loaded
		Qt::MessageBox.new(
			Qt::MessageBox::Information,
			"Wire chip",
			"You need to load a chip first"
		).exec
		return true
	end

	def invalid_pin_nbr
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Invalid pin number value',
			'Pin number needs to be between 4 and 144'
		).exec
	end

	def filesize_error
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'Error',
			'Dump error: The file size does not match with the given parameters'
		).exec
	end

	def swd_not_found
		Qt::MessageBox.new(
			Qt::MessageBox::Information,
			'SWD Action',
			'No return from the SWD'
		).exec
	end

	def swd_error
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'SWD Action',
			'An error occured while processing the SWD scan'
		).exec
		return false
	end

	def spi_error
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'SPI Action',
			'An error occured while processing the SPI command'
		).exec
	end

	def spi_mode_missing
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'SPI mode missing',
			'Mode setting is missing for this chip'
			).exec
			return false
	end

	def spi_cmd_too_long
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'SPI command invalid',
			'SPI command size is to big (> 4000)'
			).exec
			return false
	end

	def i2c_error
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'I²C Action',
			'An error occured while processing the I²C command (I²C wrong speed)'
		).exec
		return false
	end

	def parallel_error
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'Parallel Action',
			'An error occured while processing the parallel command'
		).exec
	end
# Commands

	def no_cmd_selected
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Missing command',
			'Select a command in the array first'
		).exec
		return true
	end

	def concat_nbr
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Wrong selection',
			'Select two commands in the table to concatenate them'
		).exec
		return true
	end

	def concat_disallow
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Concatenation option',
			'This option can be used only with I2C bus commands'
		).exec
		return false
	end

	def lowbyte_missing
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'Command error',
			'Payload size invalid or payload size (low) missing'
		).exec
		return false
	end

	def highbyte_missing
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'Command error',
			'Payload size invalid or payload size (high) missing'
		).exec
		return false
	end

	def mode_missing
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'Command error',
			'Payload size invalid or Read / Write address missing'
		).exec
		return false
	end

	def size_neq_row_number
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'Command error',
			'The payload size does not match with the row number'
		).exec
		return false
	end

	def i2c_cmd_too_long
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'I2C command invalid',
			'Your payload is too big (> 2000)'
		).exec
		return false
	end

	def positive_cell_value
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Wrong data',
			'Only positive values are accepted in this cell'
		).exec
	end

	def hexa_cell_value
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Wrong data',
			'Only hexadecimal values are accepted in this cell'
		).exec
	end

	def char_cell_value
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Wrong data',
			'Wrong characters in this cell'
		).exec
	end

	def ascii_only
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'String error',
			'Only ASCII characters can be specified'
		).exec
		return false
	end

	# Global Settings

	def settings_missing
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Missing settings',
			'No settings saved for this chip'
		).exec
		return false
	end

	def frequency_missing
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Missing settings',
			'Frequency setting missing'
		).exec
		return false
	end

	def mode_missing
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Missing settings',
			'Missing write base address (I²C) or read command (SPI)'
		).exec
		return false
	end

	def full_size_error
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Empty field',
			'Full size setting missing or equal 0'
		).exec
		return false
	end

	def start_stop_missing
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Empty field',
			'Start and stop address must be filled'
		).exec
		return false
	end

	def start_neq_stop
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Wrong value',
			'Start address must not be equal to the stop address'
		).exec
		return false
	end

	def start_inf_to_stop
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Wrong value',
			'Start address must be inforior to the stop address'
		).exec
		return false
	end

	def inf_to_total_size
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Wrong value',
			'Start and stop address must be inforior to the chip total size'
		).exec
		return false
	end

	def para_read_latency
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Missing parallel settings',
			'Read latency setting missing'
		).exec
		return false
	end

	def para_word_size
		Qt::MessageBox.new(
			Qt::MessageBox::Warning,
			'Missing parallel settings',
			'Word size setting missing'
		).exec
		return false
	end

# Unknown
	def unknown(msg)
		Logger.new($logFilePath).error(msg)
		Qt::MessageBox.new(
			Qt::MessageBox::Critical,
			'Hardsploit unknown error',
			'An unknown error has been detected. Check the log for more details.'
		).exec
	end
end
