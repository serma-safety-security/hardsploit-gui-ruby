#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
public

# Obtain signal Id
# Params:
# +signal+:: Name of signal you want obtain ud
def self.getSignalId(signal:)
	wires = Hash.new

	#Parallel module
	wires["A0"]				 = 0
	wires["A1"]				 = 1
	wires["A2"]				 = 2
	wires["A3"]				 = 3
	wires["A4"]				 = 4
	wires["A5"]				 = 5
	wires["A6"]				 = 6
	wires["A7"]				 = 7
	wires["A8"]				 = 8
	wires["A9"]				 = 9
	wires["A10"]			 = 10
	wires["A11"]			 = 11
	wires["A12"]			 = 12
	wires["A13"]			 = 13
	wires["A14"]			 = 14
	wires["A15"]			 = 15
	wires["A16"]			 = 16
	wires["A17"]			 = 17
	wires["A18"]			 = 18
	wires["A19"]			 = 19
	wires["A20"]			 = 20
	wires["A21"]			 = 21
	wires["A22"]			 = 22
	wires["A23"]			 = 23
	wires["A24"]			 = 24
	wires["A25"]			 = 25
	wires["A26"]			 = 26
	wires["A27"]			 = 27
	wires["A28"]			 = 28
	wires["A29"]			 = 29
	wires["A30"]			 = 30
	wires["A31"]			 = 31

	wires["D0"] 			 = 32
	wires["D1"]				 = 33
	wires["D2"]				 = 34
	wires["D3"] 			 = 35
	wires["D4"]				 = 36
	wires["D5"] 			 = 37
	wires["D6"] 			 = 38
	wires["D7"] 			 = 39
	wires["D8"] 			 = 40
	wires["D9"] 			 = 41
	wires["D10"] 			 = 42
	wires["D11"] 			 = 43
	wires["D12"] 			 = 44
	wires["D13"]			 = 45
	wires["D14"]			 = 46
	wires["D15"] 			 = 47

	wires["RST"]			 = 48
	wires["CE"] 			 = 49
	wires["OE"] 			 = 50
	wires["WE"] 			 = 51
	wires["PARA_CLK"]	 = 52
	wires["WP"] 			 = 53
	wires["ADV"] 			 = 54

	#SPI module
	wires["SPI_CLK"]	 = 0
	wires["CS"] 	 		 = 1
	wires["MOSI"]	 		 = 2
	wires["MISO"]  		 = 3
	wires["PULSE"] 		 = 4

	#I2C module
	wires["I2C_CLK"] 	 = 0
	wires["SDA"] 	 		 = 1

	#UART module
	wires["TX"] 	 		 = 0
	wires["RX"] 	 		 = 1

	#SWD module
	wires["SWD_CLK"] 	 = 0
	wires["SWD_IO"] 	 = 1

	return wires[signal]
end

	# Power on the led for each signal specified
	# Params:
	# +signal+:: Name of signal you want visual help (set the led)
def signalHelpingWiring(signal:)
		begin
			HardsploitAPI.instance.setWiringLeds(value:2**HardsploitAPI.crossWiringValue.index(HardsploitAPI.getSignalId(signal:signal)))
		rescue
		   raise 'UNKNOWN SIGNAL'
		end
	end

	module USB_COMMAND
		GREEN_LED                    =  0
		RED_LED                      =  1
		LOOPBACK                     =  2
		ERASE_FIRMWARE               =  3
		WRITE_PAGE_FIRMWARE          =  4
		READ_PAGE_FIRMWARE           =  5
		READ_ID_FLASH                =  6
		START_FPGA                   =  7
		STOP_FPGA                    =  8
		FPGA_COMMAND                 =  9
		FPGA_DATA 			             = 10
		STOP_FPGA_DATA               = 11
		START_FPGA_DATA              = 12
		GET_SERIAL_NUMBER            = 13
		GET_VERSION_NUMBER           = 14
		VCP_ERROR                    = 0xFFFF
	end

	module I2C
		KHZ_100  = 0
		KHZ_400  = 1
		KHZ_1000 = 2
		KHZ_40   = 3
	end

	module SPISniffer
		MOSI = 1
		MISO = 2
		MISO_MOSI = 3
	end

	module USB
			OUT_ENDPOINT   = 0X02
			IN_ENDPOINT    = 0X81
			USB_TRAME_SIZE = 8192
	end
	module VERSION
		API   = "2.0.0"
	end
end
