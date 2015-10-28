#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
public
		# Write value of 64 IO for testing purpose
		# * +value+:: 64bits to write on all ports
		# return [Integer] Return the value sent (lookback) (64bits)

		def test_InteractWrite(*args)
			parametters = checkParametters(["value"],args)
			val = parametters[:value]

			packet = Array.new
			packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
			packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
			packet.push lowByte(USB_COMMAND::FPGA_COMMAND)
			packet.push highByte(USB_COMMAND::FPGA_COMMAND)

			packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO

			packet.push 1 #Write mode
			packet.push  ((val & 0x00000000000000FF) >> 0)
			packet.push  ((val & 0x000000000000FF00) >> 8 )
			packet.push  ((val & 0x0000000000FF0000) >> 16 )
			packet.push  ((val & 0x00000000FF000000) >> 24 )
			packet.push  ((val & 0x000000FF00000000) >> 32 )
			packet.push  ((val & 0x0000FF0000000000) >> 40 )
			packet.push  ((val & 0x00FF000000000000) >> 48 )
			packet.push  ((val & 0xFF00000000000000) >> 56 )

			sendPacket packet

			tmp= receiveDATA(2000)
			case tmp
				when HardsploitAPI::USB_STATE::BUSY
					return USB_STATE::BUSY
				when HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
					return USB_STATE::TIMEOUT_RECEIVE
				else
					#remove header (4 bytes   2 for size 2 for type of command)
					return tmp.bytes.drop(4)
			end
		end

		# Read value of 64 IO for testing purpose
    #
		# return [Integer] 64bits

		def test_InteractRead
			packet = Array.new
			packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
			packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
			packet.push lowByte(USB_COMMAND::FPGA_COMMAND)
			packet.push highByte(USB_COMMAND::FPGA_COMMAND)

			packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO
			packet.push 0 #read mode

			packet.push 0
			packet.push 0
			packet.push 0
			packet.push 0
			packet.push 0
			packet.push 0
			packet.push 0
			packet.push 0

			sendPacket packet

			tmp= receiveDATA(2000)
			case tmp
				when HardsploitAPI::USB_STATE::BUSY
					return USB_STATE::BUSY
				when HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
					return USB_STATE::TIMEOUT_RECEIVE
				else
					#remove header (4 bytes   2 for size 2 for type of command)
					return tmp.bytes.drop(4)
			end
		end
end
