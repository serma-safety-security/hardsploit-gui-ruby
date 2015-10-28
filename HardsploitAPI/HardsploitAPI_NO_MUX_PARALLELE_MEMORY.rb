#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
public

# Read parallele memory in asynchronous mode (blocking function) but callBack data is used to receive packet
# * +addressStart+:: 32 bits address
# * +addressStop+:: 32 bits address
# * +bits8_or_bits16_DataSize+:: 0 for 8 bits operation  & 1 for 16 bits operation
# * +latency+:: latency in ns  range 7ns to 1600ns=1,6ms
# Return USB_STATE   End with  TIMEOUT_RECEIVE  but need to check if received the right number of bytes to ensure all is correct
	def read_Memory_WithoutMultiplexing(*args)
		parametters = checkParametters(["addressStart","addressStop","bits8_or_bits16_DataSize","latency"],args)
   	addressStart = parametters[:addressStart]
		addressStop = parametters[:addressStop]
		bits8_or_bits16_DataSize = parametters[:bits8_or_bits16_DataSize]
		latency = parametters[:latency]

		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push lowByte(USB_COMMAND::FPGA_COMMAND)
		packet.push highByte(USB_COMMAND::FPGA_COMMAND)

		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO

		#Chek if 8bits or 16 bits
		if bits8_or_bits16_DataSize == true then
			packet.push 1
		else
			packet.push	0
		end

		#Check latency value
		if ((latency >= 7)  and (latency <= 1600)) then
			packet.push (latency/6.66).floor
		else
			raise TypeError, 'Latency value must be from 7 to 1695'
		end

		#Check address
		if (addressStop < addressStart  ) then
			raise TypeError, 'Stop address is less than start address'
		end

		packet.push  ((addressStart & 0xFF000000) >> 24 ) #AddStart3
		packet.push  ((addressStart & 0x00FF0000) >> 16 ) #AddStart2
		packet.push  ((addressStart & 0x0000FF00) >> 8 )  #AddStart1
		packet.push  ((addressStart & 0x000000FF) >> 0)   #AddStart0

		packet.push 0x10 #Memory read command
		packet.push  ((addressStop & 0xFF000000) >> 24 ) #AddStart3
		packet.push  ((addressStop & 0x00FF0000) >> 16 ) #AddStop2
		packet.push  ((addressStop & 0x0000FF00) >> 8 )  #AddStop1
		packet.push  ((addressStop & 0x000000FF) >> 0)   #AddStop0

		sendPacket(packet)

		while true
			tmp= receiveDATA(1000)
			case tmp
				when HardsploitAPI::USB_STATE::BUSY
					return USB_STATE::BUSY
				when HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
					return USB_STATE::TIMEOUT_RECEIVE
				else
					#remove header (4 bytes   2 for size 2 for type of command)
					consoleData( tmp.bytes.drop(4))
				end
			end
		end
end
