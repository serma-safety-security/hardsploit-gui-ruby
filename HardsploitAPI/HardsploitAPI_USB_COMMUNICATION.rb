#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require "benchmark"
class HardsploitAPI
public
	# Set the leds of uC  returning nothing
	# * +led+:: USB_COMMAND::GREEN_LED  or USB_COMMAND::RED_LED
	# * +state+:: callback to return +data for dump function+
	def setStatutLed(*args)
		parametters = HardsploitAPI.checkParametters(["led","state"],args)
		led = parametters[:led]
		state = parametters[:state]

		packet_send = Array.new
		packet_send.push 0 #size set before send automatic
		packet_send.push 0	#size set before send automatic
		packet_send.push HardsploitAPI.lowByte(led)
		packet_send.push HardsploitAPI.highByte(led)
		packet_send.push (state ? 1 : 0)
		return sendPacket(packet_send)
	end

	# Connect board and get an instance to work with
	# Return USB_STATE
	def connect
		@device = @usb.devices(:idVendor => 0x0483, :idProduct => 0xFFFF).first
		if @device == nil   then
			@device_version = ""
			return USB_STATE::NOT_CONNECTED
		else
			 @dev = @device.open
			if RUBY_PLATFORM=~/linux/i && @dev.kernel_driver_active?(0)
				@dev.detach_kernel_driver(0)
			end
			@dev.claim_interface(0)
			Thread.abort_on_exception = true
			setStatutLed(USB_COMMAND::GREEN_LED,true);
			return USB_STATE::CONNECTED
		end
	end

	# Obtain low byte of a word
	# * +word+:: 16 bit word
	# Return low byte of the word
	def self.lowByte(*args)
		parametters = HardsploitAPI.checkParametters(["word"],args)
		word = parametters[:word]
		return  word & 0xFF
	end

	# Obtain high byte of a word
	# * +word+:: 16 bit word
	# Return high byte of the word
	def self.highByte(*args)
		parametters = HardsploitAPI.checkParametters(["word"],args)
		word = parametters[:word]
		return  (word & 0xFF00) >> 8
	end

	# Obtain high byte of a word
	# * +lByte+:: low byte
	# * +hByte+:: high byte
	# Return 16 bits integer concatenate with low and high bytes
	def self.BytesToInt(*args)
		parametters = HardsploitAPI.checkParametters(["lByte","hByte"],args)
		lByte = parametters[:lByte]
		hByte = parametters[:hByte]
		return (lByte + (hByte<<8))
	end


protected
		# Send data and wait to receive response
		# * +packet_send+:: array of byte
		# * +timeout+:: timeout to read response (ms)
		# Return USB_STATE or array with response (improve soon with exception)
		def sendAndReceiveDATA(packet_send,timeout)
			time = Time.new
			case sendPacket(packet_send)
				when USB_STATE::SUCCESSFUL_SEND
					received_data = receiveDATA(timeout)
					case received_data
						when USB_STATE::BUSY
							return  USB_STATE::BUSY
						when USB_STATE::TIMEOUT_RECEIVE
							return USB_STATE::TIMEOUT_RECEIVE
						else
							consoleSpeed "RECEIVE #{((received_data.bytes.to_a.size/(Time.new-time))).round(2)}Bytes/s  #{(received_data.bytes.to_a.size)}Bytes in  #{(Time.new-time).round(4)} s"
							return received_data.bytes.to_a
					end
				when USB_STATE::PACKET_IS_TOO_LARGE
					return  USB_STATE::PACKET_IS_TOO_LARGE
				when USB_STATE::ERROR_SEND
					return  USB_STATE::ERROR_SEND
				else
					return  USB_STATE::UNKNOWN_STATE
			end
		end

		# Wait to receive data
		# * +timeout+:: timeout to read response (ms)
		# Return USB_STATE or array with response (improve soon with exception)
		def receiveDATA(timeout)
			begin
				received_data =  dev.bulk_transfer(:endpoint=>IN_ENDPOINT, :dataIn=>USB::USB_TRAME_SIZE, :timeout=>timeout)
			rescue LIBUSB::ERROR_BUSY
				return USB_STATE::BUSY
			rescue LIBUSB::ERROR_TIMEOUT
				return USB_STATE::TIMEOUT_RECEIVE
			else
				return received_data
			end
		end

		# Send USB packet
		# * +packet+:: array with bytes
		# Return USB_STATE or array with response (improve soon with exception)
		def sendPacket(packet_send)
			if packet_send.size <= 8191 then

				packet_send[0] = HardsploitAPI.lowByte(packet_send.size)
				packet_send[1] = HardsploitAPI.highByte(packet_send.size)

				#if a multiple of packet size add a value to explicit the end of trame
				if packet_send.size % 64 ==0 then
					packet_send.push 0
				end

				number_of_data_send = 0
				time = Benchmark.realtime  do
					number_of_data_send =  @dev.bulk_transfer(:endpoint=>OUT_ENDPOINT, :dataOut=>packet_send.pack('c*'),:timeout=>3000)
				end
				consoleSpeed "SEND #{((number_of_data_send/time)).round(2)}Bytes/s  SEND #{(number_of_data_send)}Bytes in  #{time.round(4)} s"
				if number_of_data_send ==  packet_send.size then
					return USB_STATE::SUCCESSFUL_SEND
				else
					return USB_STATE::ERROR_SEND
				end
			else
				return USB_STATE::PACKET_IS_TOO_LARGE
			end
		end
	end
