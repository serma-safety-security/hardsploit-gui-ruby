#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
public

#  SPI interact
# * +mode+:: SPI mode 0,1,2,3
# * +speed+:: Range 1-255  SPI clock =  150Mhz / (2*speed) tested from 3 to 255 (25Mhz to about 0.3Khz)
# * +payload+:: Byte array want to send
# * Return SPI data received
def spi_Interact(*args)
	parametters = checkParametters(["mode","speed","payload"],args)
	mode = parametters[:mode]
	speed = parametters[:speed]
	payload = parametters[:payload]

	if (mode < 0)  and (mode >3) then
		raise TypeError, 'Mode must be between 0 and 3'
	end
	if (speed <= 2)  and (speed >256) then
		raise TypeError, 'Speed must be between 3 and 255'
	end

	if (payload.size > 4000) then
		raise TypeError, 'Size of the data need to be less than 4000'
	end

	packet = Array.new
	packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
	packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
	packet.push lowByte(USB_COMMAND::FPGA_COMMAND)
	packet.push highByte(USB_COMMAND::FPGA_COMMAND)

	packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO

	packet.push mode #Add mode
	packet.push speed #Add speed
	packet.concat payload #Add data

	sendPacket packet

	tmp= receiveDATA(1000)
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

# Spi generic dump
# * +mode+:: SPI mode 0,1,2,3
# * +speed+:: Range 1-255  SPI clock =  150Mhz / (2*speed) tested from 3 to 255 (25Mhz to about 0.3Khz)
# * +readSpiCommand+:: The read command
# * +startAddress+:: Start address (included)
# * +stopAddress+:: Stop address (included)
# * +sizeMax+:: Size max of memory (important to calculate automaticly the number of byte to set address)
	def spi_Generic_Dump (*args)
		parametters = checkParametters(["mode","speed","readSpiCommand","startAddress","stopAddress","sizeMax"],args)
		mode = parametters[:mode]
		speed = parametters[:speed]
		readSpiCommand = parametters[:readSpiCommand]
		startAddress = parametters[:startAddress]
		stopAddress = parametters[:stopAddress]
		sizeMax = parametters[:sizeMax]

		if ((startAddress < 0)  or (startAddress > sizeMax-1)) then
			raise TypeError, "Start address can't be negative and not more than size max - 1"
		end
		if ((stopAddress < 0)  or (stopAddress > (sizeMax-1))) then
			raise TypeError, "Stop address can't be negative and not more than size max-1 because start at 0"
		end

		if (stopAddress < startAddress) then
			raise TypeError, "Stop address need to be greater than start address"
		end

		numberOfByteAddress = (((Math.log(sizeMax-1,2)).floor + 1) / 8.0).ceil
		if numberOfByteAddress > 4 then
			raise TypeError, "Size max must be less than 2^32 about 4Gb"
		end

		if numberOfByteAddress <= 0 then
			raise TypeError, "There is an issue with calculating of number of byte needed"
		end

		packet_size = 4000 - numberOfByteAddress - 1
		number_complet_packet = ( (stopAddress-startAddress+1) / packet_size).floor
		size_last_packet =  (stopAddress-startAddress+1) % packet_size

		#SEND the first complete trame
		for i in 0..number_complet_packet-1 do
			packet = generate_spi_read_command numberOfByteAddress,readSpiCommand,i*packet_size+startAddress,packet_size

			temp = spi_Interact(mode,speed,packet)
			case temp
				when HardsploitAPI::USB_STATE::PACKET_IS_TOO_LARGE
					puts "PACKET_IS_TOO_LARGE max: #{HardsploitAPI::USB::USB_TRAME_SIZE}"
				when HardsploitAPI::USB_STATE::ERROR_SEND
					puts "ERROR_SEND\n"
				when HardsploitAPI::USB_STATE::BUSY
					puts "BUSY"
				when HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
					puts "TIMEOUT_RECEIVE\n"
				else
					#Remove header, result of read command and numberOfByte Address too
					puts "receive real size #{temp.size}"
					consoleData temp.drop(numberOfByteAddress+1)
			end
		end

			packet = generate_spi_read_command numberOfByteAddress,readSpiCommand,number_complet_packet*packet_size+startAddress,size_last_packet
			temp = spi_Interact(mode,speed,packet)
			case temp
				when HardsploitAPI::USB_STATE::PACKET_IS_TOO_LARGE
					puts "PACKET_IS_TOO_LARGE max: #{HardsploitAPI::USB::USB_TRAME_SIZE}"
				when HardsploitAPI::USB_STATE::ERROR_SEND
					puts "ERROR_SEND\n"
				when HardsploitAPI::USB_STATE::BUSY
					puts "BUSY"
				when HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
					puts "TIMEOUT_RECEIVE\n"
				else
					#Remove header, result of read command and numberOfByte Address too
					puts "receive real size #{temp.size}"
					consoleData temp.drop(numberOfByteAddress+1)
			end
		end

protected
	def generate_spi_read_command ( numberOfByteAddress,readSpiCommand,startAddress,size)
		packet = Array.new

		#Push read command
		packet.push readSpiCommand

		case  numberOfByteAddress
			when 1
				packet.push  ((startAddress & 0x000000FF) >> 0)   #AddStart0

			when 2
				packet.push  ((startAddress & 0x0000FF00) >> 8 )  #AddStart1
				packet.push  ((startAddress & 0x000000FF) >> 0)   #AddStart0

			when 3
				packet.push  ((startAddress & 0x00FF0000) >> 16 ) #AddStart2
				packet.push  ((startAddress & 0x0000FF00) >> 8 )  #AddStart1
				packet.push  ((startAddress & 0x000000FF) >> 0)   #AddStart0

			when 4
				packet.push  ((startAddress & 0xFF000000) >> 24 ) #AddStart3
				packet.push  ((startAddress & 0x00FF0000) >> 16 ) #AddStart2
				packet.push  ((startAddress & 0x0000FF00) >> 8 )  #AddStart1
				packet.push  ((startAddress & 0x000000FF) >> 0)   #AddStart0
			else
				raise TypeError, "Issue in generate_spi_read_command function when parse number of byte address"

		end

		#put N dummy byte to read size data
		packet.push *Array.new(size, 0)

	puts  " Send real size #{packet.size}"
		if packet.size > 4000 then
			raise TypeError, "Too many byte to send in spi mode not more than 4000 is needed"
		end

		return packet
	end
end
