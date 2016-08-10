#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
	module ERROR
    class Standard < StandardError; end

		class HARDSPLOIT_NOT_FOUND < Standard
			def initialize(msg="HARDSPLOIT NOT FOUND")
					super(msg)
			end
		end
		class API_CROSS_WIRING < Standard
			def initialize(msg="The crossWiring array must be a 64 items array")
					super(msg)
			end
		end
		class API_SCANNER_WRONG_PIN_NUMBER < Standard
			def initialize(msg="You need to connect more thant pins needed by the module 2 for swd, 2 for I2C etc")
					super(msg)
			end
		end
		class FileIssue < Standard
			def initialize(msg="Issue with file")
					super(msg)
			end
		end

		class I2CWrongSpeed < Standard
			def initialize(msg="Uknown speed, speed must be KHZ_100 = 0, KHZ_400 = 1,KHZ_1000 = 2")
					super(msg)
			end
		end
		class SPIWrongPulse < Standard
			def initialize(msg="Wrong, Pulse must be 0 or 1")
					super(msg)
			end
		end
		class SPIWrongSpeed < Standard
			def initialize(msg="Speed must be between 3 and 255")
					super(msg)
			end
		end
		class SPIWrongMode < Standard
			def initialize(msg="Mode must be between 0 and 3")
					super(msg)
			end
		end

		class SPIWrongPayloadSize < Standard
			def initialize(msg="Size of the data need to be less than 4000")
					super(msg)
			end
		end

		class WrongStartAddress < Standard
			def initialize(msg="Start address can't be negative and not more than size max - 1")
					super(msg)
			end
		end

		class SpiError < Standard
			def initialize(msg="Error during SPI processing")
					super(msg)
			end
		end

		class USB_PACKET_IS_TOO_LARGE < Standard
			def initialize(msg="USB_PACKET_IS_TOO_LARGE")
					super(msg)
			end
		end

		class USB_ERROR < Standard
			def initialize(msg="USB ERROR")
					super(msg)
			end
		end

		class SWD_ERROR < Standard
			def initialize(msg="SWD ERROR, WAIT, FAUL, ACK or something like that")
					super(msg)
			end
		end

		class UART_WrongSettings < Standard
			def initialize(msg="Wrong UART settings")
					super(msg)
			end
		end

		class UART_WrongTxPayloadSize < Standard
			def initialize(msg="Wrong TX payload size")
					super(msg)
			end
		end

		class UART_WrongPayloadSize < Standard
			def initialize(msg="Size of the data need to be less than 4000")
					super(msg)
			end
		end
	end
end
