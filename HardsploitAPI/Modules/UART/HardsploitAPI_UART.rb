#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../Core/HardsploitAPI'
class HardsploitAPI_UART
public
	def initialize(baud_rate:,word_width:,use_parity_bit:,parity_type:,nb_stop_bits:,idle_line_level:)
		#to be sure the singleton was initialize
		HardsploitAPI.instance
		self.baud_rate 			 = baud_rate
		self.word_width 		 = word_width
		self.use_parity_bit  = use_parity_bit
		self.parity_type 		 = parity_type
		self.nb_stop_bits 	 = nb_stop_bits
		self.idle_line_level = idle_line_level
		setSettings

		@payload_TX = Array.new
	end

	def baud_rate
		return 150000000 / @baud_rate
	end

	def baud_rate=(baud_rate)
		if (baud_rate >= 2400) and (baud_rate <= 1036800) then
			@baud_rate = 150000000 / baud_rate
		else
			raise HardsploitAPI::ERROR::UART_WrongSettings
		end
	end

	def word_width
		return @word_width
	end

	def word_width=(word_width)
		if (word_width >= 5) and (word_width <= 8) then
			@word_width = word_width
		else
			raise HardsploitAPI::ERROR::UART_WrongSettings
		end
	end

	def use_parity_bit
		return @use_parity_bit
	end

	def use_parity_bit=(use_parity_bit)
		if (use_parity_bit >= 0) and (use_parity_bit <= 1) then
			@use_parity_bit = use_parity_bit
		else
			raise HardsploitAPI::ERROR::UART_WrongSettings
		end
	end

	def parity_type
		return @parity_type
	end

	def parity_type=(parity_type)
		if (parity_type >= 0) and (parity_type <= 1) then
			@parity_type = parity_type
		else
			raise HardsploitAPI::ERROR::UART_WrongSettings
		end
	end

	def nb_stop_bits
		return @nb_stop_bits
	end

	def nb_stop_bits=(nb_stop_bits)
		if (nb_stop_bits >= 1) and (nb_stop_bits <= 2) then
			@nb_stop_bits = nb_stop_bits
		else
			raise HardsploitAPI::ERROR::UART_WrongSettings
		end
	end

	def idle_line_level
		return @idle_line_level
	end

	def idle_line_level=(idle_line_level)
		if (idle_line_level >= 0) and (idle_line_level <= 1) then
			@idle_line_level = idle_line_level
		else
			raise HardsploitAPI::ERROR::UART_WrongSettings
		end
	end

	#  write
	# * +payload+:: Byte array want to send
	# * Return nothing
	def write(payload:)
		if ( (@payload_TX.size + payload.size)  > 4000) then
			raise HardsploitAPI::ERROR::UART_WrongTxPayloadSize
		end
		@payload_TX.concat payload #Add data
	end

  # sendAndReceived  ( send and receive)
	# First write data if needed and refresh (data are sent and reveived data if needed) and you obtain available data
	# * Return nothing
	def sendAndReceived
		packet = HardsploitAPI.prepare_packet
		packet.push 0x20 #Send command
		packet.concat @payload_TX

		begin
			tmp = HardsploitAPI.instance.sendAndReceiveDATA(packet,1000)
		rescue
			raise HardsploitAPI::ERROR::USB_ERROR
		end

		@payload_TX.clear
		#remove header (4 bytes   2 for size 2 for type of command 1 dummy byte)
		return tmp.drop(5)
	end

	# enableMeasureBaudRate
	#
	# *
	def enableMeasureBaudRate
		packet = HardsploitAPI.prepare_packet
		packet.push 0x41 # command
		begin
			tmp = HardsploitAPI.instance.sendAndReceiveDATA(packet,1000)
		rescue
			raise HardsploitAPI::ERROR::USB_ERROR
		end
	end

	# disableMeasureBaudRate
	#
	# *
	def disableMeasureBaudRate
		packet = HardsploitAPI.prepare_packet
		packet.push 0x40 # command
		begin
			tmp = HardsploitAPI.instance.sendAndReceiveDATA(packet,1000)
		rescue
			raise HardsploitAPI::ERROR::USB_ERROR
		end
	end

	# measureBaudRate
	#
	# * Return 32 bits period
	def measureBaudRate
		packet = HardsploitAPI.prepare_packet
		packet.push 0x30 # command

		begin
			tmp = HardsploitAPI.instance.sendAndReceiveDATA(packet,1000)
		rescue
			raise HardsploitAPI::ERROR::USB_ERROR
		end
		#remove header (4 bytes   2 for size 2 for type of command)
		tmp = tmp.drop(4)
		period =  tmp[0] + (tmp[1] << 8 )  + (tmp[2] << 16 ) +  (tmp[3] << 24 )
		period = period * 33.33*(10**-9) #s
		if period > 0 then
			return (1 / period).to_i
		else
			return 0
		end
	end

	#  settings
	# * Return nothing
	def setSettings
		packet = HardsploitAPI.prepare_packet
		packet.push 0x00 #Settings command
		packet.push ((@parity_type & 0b1) <<  7) ||  ((@use_parity_bit & 0b1) <<  6) || 	((@nb_stop_bits & 0b11) <<  4) || (@word_width & 0b1111)
		packet.push @idle_line_level & 1
		packet.push HardsploitAPI.lowByte(word: @baud_rate)
		packet.push HardsploitAPI.highByte(word: @baud_rate)

		begin
			HardsploitAPI.instance.sendPacket packet
			sleep(1)
		#	tmp= HardsploitAPI.instance.receiveDATA(1000)
			#remove header (4 bytes   2 for size 2 for type of command)
		#	return tmp.bytes.drop(4)
		rescue
			raise HardsploitAPI::ERROR::USB_ERROR
		end
	end
end
