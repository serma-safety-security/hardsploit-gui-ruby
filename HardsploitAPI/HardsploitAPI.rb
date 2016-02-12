#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require 'libusb'
require_relative 'HardsploitAPI_CONSTANT'
require_relative 'HardsploitAPI_USB_COMMUNICATION'
require_relative 'HardsploitAPI_FIRMWARE'
require_relative 'HardsploitAPI_NO_MUX_PARALLELE_MEMORY'
require_relative 'HardsploitAPI_I2C'
require_relative 'HardsploitAPI_SPI'
require_relative 'HardsploitAPI_TEST_INTERACT'
require_relative 'SWD/HardsploitAPI_SWD'
require_relative 'HardsploitAPI_ERROR'

require 'thread'

class HardsploitAPI
public

	attr_accessor :dev

	include USB
	include USB_STATE
	include USB_COMMAND

 	  # Initialize the HARDSPLOIT API
		# * +callbackData+:: callback to return data for dump function
	  # * +callbackInfo+:: callback to get back general information
	  # * +callbackError+:: callback not used for the moment and transform into progressCallback soon
		# * +callbackSpeedOfTransfert+:: callback to get back +information about speed+
	def initialize(*args)
		parametters = HardsploitAPI.checkParametters(["callbackData","callbackInfo","callbackProgress","callbackSpeedOfTransfert"],args)
		@callbackData = parametters[:callbackData]
		@callbackInfo = parametters[:callbackInfo]
		@callbackProgress = parametters[:callbackProgress]
		@callbackSpeedOfTransfert = parametters[:callbackSpeedOfTransfert]

		@packet_send = Array.new
		@usb = LIBUSB::Context.new
		@device = nil
	end

	# Set custom value to wiring led
  # * +value+:: 64 bits (8x8 Bytes) values to represent led (PortH PortG PortF PortE PortD PortC PortB PortA)
	def setWiringLeds(*args)
		parametters = HardsploitAPI.checkParametters(["value"],args)
		val = parametters[:value]

		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(USB_COMMAND::FPGA_COMMAND)

		packet.push 0x23 #Command SPI write wiring led

		packet.push  HardsploitAPI.reverseBit((val & 0x00000000000000FF) >> 0)
		packet.push  HardsploitAPI.reverseBit((val & 0x000000000000FF00) >> 8 )
		packet.push  HardsploitAPI.reverseBit((val & 0x0000000000FF0000) >> 16 )
		packet.push  HardsploitAPI.reverseBit((val & 0x00000000FF000000) >> 24 )
		packet.push  HardsploitAPI.reverseBit((val & 0x000000FF00000000) >> 32 )
		packet.push  HardsploitAPI.reverseBit((val & 0x0000FF0000000000) >> 40 )
		packet.push  HardsploitAPI.reverseBit((val & 0x00FF000000000000) >> 48 )
		packet.push  HardsploitAPI.reverseBit((val & 0xFF00000000000000) >> 56 )

		return  self.sendPacket(packet)
	end

	# Obtaint the version number of the board
	def getVersionNumber
		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(USB_COMMAND::GET_VERSION_NUMBER)
		packet.push HardsploitAPI.highByte(USB_COMMAND::GET_VERSION_NUMBER)

		#remove header
		version_number = sendAndReceiveDATA(packet,1000).drop(4)
		if version_number.size < 20 then #if size more thant 20 char error when reading version number
				return version_number.pack('U*')
		else
			return "BAD VERSION NUMBER"
		end

	end

	def self.reverseBit(byte)
		return byte.to_s(2).rjust(8, "0").reverse.to_i(2)
	end

	def self.checkParametters(arr_parametters,*args)
		params = Hash.new
		if args[0][0].class == Hash then
			hash_args = args[0][0]
				arr_parametters.each  do |param|
					if hash_args[param.to_sym] == nil then
							raise "Wrong parametters, you need to specify #{param.to_sym}"
					else
							params[param.to_sym] = hash_args[param.to_sym]
					end
				end
		else
			if args[0].length == arr_parametters.size then
					args[0].each_with_index do |value,key|
						params[arr_parametters[key].to_sym] = value
					end
			else
				raise "Error : method need #{arr_parametters.size} parametters"
			end
		end
		return params
	end

	def consoleProgress(percent:,startTime:,endTime:)
		@callbackProgress.call(percent:percent,startTime:startTime,endTime:endTime)
	end
	def consoleData(value)
		@callbackData.call(value)
	end
	def consoleSpeed(value)
		@callbackSpeedOfTransfert.call(value)
	end
	def consoleInfo(value)
		@callbackInfo.call(value)
	end


end
