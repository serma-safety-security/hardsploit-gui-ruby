#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
public

	# Power on the led for each signal specified
	# Params:
	# +signal+:: Name of signal you want visual help (set the led)
def signalHelpingWiring(*args)
		parametters = HardsploitAPI.checkParametters(["signal"],args)
		signal = parametters[:signal]

		wires = Hash.new

		#Parallel module
		wires["A0"] = 0
		wires["A1"] = 1
		wires["A2"] = 2
		wires["A3"] = 3
		wires["A4"] = 4
		wires["A5"] = 5
		wires["A6"] = 6
		wires["A7"] = 7
		wires["A8"] = 8
		wires["A9"] = 9
		wires["A10"] = 10
		wires["A11"] = 11
		wires["A12"] = 12
		wires["A13"] = 13
		wires["A14"] = 14
		wires["A15"] = 15
		wires["A16"] = 16
		wires["A17"] = 17
		wires["A18"] = 18
		wires["A19"] = 19
		wires["A20"] = 20
		wires["A21"] = 21
		wires["A22"] = 22
		wires["A23"] = 23
		wires["A24"] = 24
		wires["A25"] = 25
		wires["A26"] = 26
		wires["A27"] = 27
		wires["A28"] = 28
		wires["A29"] = 29
		wires["A30"] = 30
		wires["A31"] = 31

		wires["D0"] = 32
		wires["D1"] = 33
		wires["D2"] = 34
		wires["D3"] = 35
		wires["D4"] = 36
		wires["D5"] = 37
		wires["D6"] = 38
		wires["D7"] = 39
		wires["D8"] = 40
		wires["D9"] = 41
		wires["D10"] = 42
		wires["D11"] = 43
		wires["D12"] = 44
		wires["D13"] = 45
		wires["D14"] = 46
		wires["D15"] = 47

		wires["RST"] = 48
		wires["CE"] = 49
		wires["OE"] = 50
		wires["WE"] = 51
		wires["CLK"] = 52
		wires["WP"] = 53
		wires["ADV"] = 54


		#SPI module
		wires["CS"] = 0
		wires["SPI_CLK"] = 1
		wires["MOSI"] = 2
		wires["MISO"] = 3

		#I2C module
		wires["I2C_CLK"] = 0
		wires["SDA"] = 1

		begin
			setWiringLeds(2**wires[signal])
		rescue Exception => e
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
		FPGA_DATA 									 = 10
		STOP_FPGA_DATA               = 11
		START_FPGA_DATA              = 12
		GET_SERIAL_NUMBER            = 13
		GET_VERSION_NUMBER           = 14
		VCP_ERROR                    = 0xFFFF
	end

	module I2C
		KHZ_100 = 0
		KHZ_400 = 1
		KHZ_1000 = 2
	end

	module USB
			OUT_ENDPOINT   = 0X02
			IN_ENDPOINT    = 0X81
			USB_TRAME_SIZE = 8191
	end
	module VERSION
		API   = "1.2.1"
	end
	module USB_STATE
		public
		UNKNOWN_STATE   	  = -2
		BUSY     			      = -1
		NOT_CONNECTED  		  =  0
		CONNECTED   		    =  1
		UNKNOWN_CONNECTED   =  2
		SUCCESSFUL_SEND		  =  3
		PACKET_IS_TOO_LARGE =  4
		ERROR_SEND		      =  5
		SUCCESSFUL_RECEIVE  =  6
		TIMEOUT_RECEIVE     =  7

	end
end
