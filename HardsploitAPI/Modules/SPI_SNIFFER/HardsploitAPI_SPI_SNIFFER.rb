#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../Core/HardsploitAPI'
class HardsploitAPI_SPI_SNIFFER
public

	def initialize(mode:,sniff:)
		#to be sure the singleton was initialize
		HardsploitAPI.instance.connect
		self.mode=mode
		self.sniff=sniff
		spi_SetSettings
	end

	def mode
		return @mode
	end
	def sniff
		return @sniff
	end
	def mode=(mode)
		if ( mode < 0 ) or ( mode > 3 ) then
			raise HardsploitAPI::ERROR::SPIWrongMode
		else
			@mode = mode
		end
	end
	def sniff=(sniff)
		case sniff
		when HardsploitAPI::SPISniffer::MISO;			 @sniff = sniff
		when HardsploitAPI::SPISniffer::MOSI; 		 @sniff = sniff
		when HardsploitAPI::SPISniffer::MISO_MOSI; @sniff = sniff
		else
			raise HardsploitAPI::ERROR::SPIWrongMode
		end
	end
	def spi_SetSettings
		packet = HardsploitAPI.prepare_packet
		packet.push 0x10 #Command change mode
		packet.push @mode + (@sniff<<6)  #Add mode
		begin
			HardsploitAPI.instance.sendPacket packet
			rescue
			raise HardsploitAPI::ERROR::USB_ERROR
		end
	end

	def odds_and_evens(tab, return_odds)
		tab.select.with_index{|_, i| return_odds ? i.odd? : i.even?}
	end
	#  spi_receive_available_data
	# * Return data received
	def spi_receive_available_data
		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(word:HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(word:HardsploitAPI::USB_COMMAND::FPGA_COMMAND)

		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO
		packet.push 0x20 #Command receive available data

		#remove header (4 bytes   2 for size 2 for type of command)
		result = HardsploitAPI.instance.sendAndReceiveDATA(packet, 200).drop(4)

		#if half a simple array, if fullduplex  first item -> an array of MISO  and second array -> an array of MOSI
		case @sniff
		when HardsploitAPI::SPISniffer::MISO,HardsploitAPI::SPISniffer::MOSI
			return result
		else
			myresult = Array.new
			myresult.push odds_and_evens(result,true)
			myresult.push odds_and_evens(result,false)
			return myresult
		end
	end
end
