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

# Obtain the number of hardsploit connected to PC
# Return number
	def self.getNumberOfBoardAvailable
	  return LIBUSB::Context.new.devices(:idVendor => 0x0483, :idProduct => 0xFFFF).size
	end

	# Connect board and get an instance to work with
	# Return USB_STATE
	def connect
		@usb = LIBUSB::Context.new
		@devices = @usb.devices(:idVendor => 0x0483, :idProduct => 0xFFFF)

		if @devices.size == 0 then
			@device = nil
			@dev = nil
			raise ERROR::HARDSPLOIT_NOT_FOUND
		else
			if @@id >= @devices.size then
				raise ERROR::HARDSPLOIT_NOT_FOUND
			else
				begin
					if @dev == nil then
						@dev = @devices[@@id].open
						 if RUBY_PLATFORM=~/linux/i && @dev.kernel_driver_active?(0)
							@dev.detach_kernel_driver(0)
						 end
						@dev.claim_interface(0)
					end
					self.startFPGA
					sleep(0.1)
					self.setStatutLed(led:USB_COMMAND::GREEN_LED,state:true);
				rescue
					raise ERROR::USB_ERROR
					end
			end
		end
	end

	def reconncet
		@usb = LIBUSB::Context.new
		@devices = @usb.devices(:idVendor => 0x0483, :idProduct => 0xFFFF)
		if @devices.size == 0 then
			@device = nil
			@dev = nil
			raise ERROR::HARDSPLOIT_NOT_FOUND
		else
			begin
				@dev = @devices[@@id].open
				 if RUBY_PLATFORM=~/linux/i && @dev.kernel_driver_active?(0)
					@dev.detach_kernel_driver(0)
				 end
				@dev.claim_interface(0)
				self.startFPGA
				sleep(0.1)
				self.setStatutLed(led:USB_COMMAND::GREEN_LED,state:true);

			rescue
				raise ERROR::USB_ERROR
			end
		end
	end

	# Obtain low byte of a word
	# * +word+:: 16 bit word
	# Return low byte of the word
	def self.lowByte(word:)
		return  word & 0xFF
	end

	# Obtain high byte of a word
	# * +word+:: 16 bit word
	# Return high byte of the word
	def self.highByte(word:)
		return  (word & 0xFF00) >> 8
	end

	# Obtain high byte of a word
	# * +lByte+:: low byte
	# * +hByte+:: high byte
	# Return 16 bits integer concatenate with low and high bytes
	def self.BytesToInt(lByte:,hByte:)
		return (lByte + (hByte<<8))
	end


	# Send data and wait to receive response
	# * +packet_send+:: array of byte
	# * +timeout+:: timeout to read response (ms)
	# Return USB_STATE or array with response (improve soon with exception)
	def sendAndReceiveDATA(packet_send,timeout)
		time = Time.new
		begin
			sendPacket(packet_send)
			received_data =  @dev.bulk_transfer(:endpoint=>IN_ENDPOINT, :dataIn=>USB::USB_TRAME_SIZE, :timeout=>timeout)
			consoleSpeed "RECEIVE #{((received_data.bytes.to_a.size/(Time.new-time))).round(2)}Bytes/s  #{(received_data.bytes.to_a.size)}Bytes in  #{(Time.new-time).round(4)} s"
			return received_data.bytes.to_a
		rescue LIBUSB::ERROR_NO_DEVICE
			raise ERROR::HARDSPLOIT_NOT_FOUND
		rescue
			raise ERROR::USB_ERROR
		end
	end

	# Wait to receive data
	# * +timeout+:: timeout to read response (ms)
	# Return USB_STATE or array with response (improve soon with exception)
	def receiveDATA(timeout)
		begin
			received_data =  @dev.bulk_transfer(:endpoint=>IN_ENDPOINT, :dataIn=>USB::USB_TRAME_SIZE, :timeout=>timeout)
			return received_data
		rescue LIBUSB::ERROR_NO_DEVICE
			raise ERROR::USB_ERROR
		rescue LIBUSB::ERROR_NO_DEVICE
			raise ERROR::HARDSPLOIT_NOT_FOUND
		end
	end

	# Send USB packet
	# * +packet+:: array with bytes
	# Return number of byte sent
	def sendPacket(packet_send)

		begin
			if packet_send.size <= 8191 then

				packet_send[0] = HardsploitAPI.lowByte(word:packet_send.size)
				packet_send[1] = HardsploitAPI.highByte(word:packet_send.size)

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
					return number_of_data_send
				 else
					raise ERROR::USB_ERROR
				 end
			else
				raise ERROR::USB_ERROR
			end
		rescue LIBUSB::ERROR_NO_DEVICE
			#TRY TO RECONNECT maybe error due to disconnecting and reconnecting board
			reconncet
		rescue
			raise ERROR::USB_ERROR
		end
	end
end
