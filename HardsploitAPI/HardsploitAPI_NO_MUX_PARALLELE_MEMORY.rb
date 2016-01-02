#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
public


	def readManufactuerCodeMemory
		write_command_Memory_WithoutMultiplexing(0x00000000,0x90) #ReadDeviceIdentifierCommand
		return readByteFromMemory(1) #Read from 1 to 1 = read 1 byte at 1
	end

	def readDeviceIdMemory
		write_command_Memory_WithoutMultiplexing(0x00000000,0x90) #ReadDeviceIdentifierCommand
		return readByteFromMemory(0)#Read  0
	end

	def writeByteToMemory(address,value)
		#Write data in word mode  and read Five status register
		write_command_Memory_WithoutMultiplexing(address,0x0040)
		write_command_Memory_WithoutMultiplexing(address,value)
		return readByteFromMemory(0)
	end

	def readMode
		#go in read mode
		write_command_Memory_WithoutMultiplexing(0x000000,0x00FF)
	end

	def eraseBlockMemory(blockAddress)
		#Read Five Word
		write_command_Memory_WithoutMultiplexing(blockAddress,0x0020)   #Block erase command
		statut = write_command_Memory_WithoutMultiplexing(blockAddress,0x00D0)   #Confirm Block erase command

		 timeout = 10
		# while (statut != 128 ) && (timeout >= 0)
		#
		# 	puts "#{statut}  #{timeout}"
 	# 		statut = readByteFromMemory(0) #read statut register
		# 	sleep(100)
		# 	if timeout == 0 then
		# 		return statut
		# 	else
		# 		timeout = timeout-1
		# 	end
		# end
		for ty in 0..4
			puts readByteFromMemory(0)
		end

		puts "Return timeout"
		return statut
	end

	def clearStatusRegisterOfMemory
		#Clear Statut register
		write_command_Memory_WithoutMultiplexing(0x000000,0x50)
	end

	def unlockBlock (blockAddress)
		write_command_Memory_WithoutMultiplexing(blockAddress,0x0060) #Lock Block Command
		write_command_Memory_WithoutMultiplexing(blockAddress,0x00D0) #UnLock  Command
		return readByteFromMemory(0x000000) #read statut register
	end

def write_command_Memory_WithoutMultiplexing(address,data)
		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(USB_COMMAND::FPGA_COMMAND)

		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO

		packet.push	0 #16 bits
		packet.push (1500/6.66).floor  #latency at 1500ns

		packet.push  ((address & 0xFF000000) >> 24 ) #AddStart3
		packet.push  ((address & 0x00FF0000) >> 16 ) #AddStart2
		packet.push  ((address & 0x0000FF00) >> 8 )  #AddStart1
		packet.push  ((address & 0x000000FF) >> 0)   #AddStart0
		packet.push 0x20 #Memory write command
		packet.push  ((data & 0xFF00) >> 8 )  #Data HIGHT BYTE
		packet.push  ((data & 0xFF) >> 0)  #Data LOW BYTE


		result = sendAndReceiveDATA(packet,1000)
		 if result == USB_STATE::TIMEOUT_RECEIVE then
		 	raise "TIMEOUT"
		elsif result[4] == (data & 0xFF)

		 	return readByteFromMemory(0)
		else
		 	raise "ERROR BAD RESPONSE"
		 end
	end

	def readByteFromMemory(address)
		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(USB_COMMAND::FPGA_COMMAND)

		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO


		#16 bits
		packet.push	0
		packet.push (1500/6.66).floor


		packet.push  ((address & 0xFF000000) >> 24 ) #AddStart3
		packet.push  ((address & 0x00FF0000) >> 16 ) #AddStart2
		packet.push  ((address & 0x0000FF00) >> 8 )  #AddStart1
		packet.push  ((address & 0x000000FF) >> 0)   #AddStart0

		packet.push 0x10 #Memory read command
		packet.push  ((address & 0xFF000000) >> 24 ) #AddStart3
		packet.push  ((address & 0x00FF0000) >> 16 ) #AddStop2
		packet.push  ((address & 0x0000FF00) >> 8 )  #AddStop1
		packet.push  ((address & 0x000000FF) >> 0)   #AddStop0

		result = sendAndReceiveDATA(packet,1000)

		if result == USB_STATE::TIMEOUT_RECEIVE then
			return "TIMEOUT"
		else
			if result.size == 6 then
					return HardsploitAPI.BytesToInt(result[4] , result[5])
			else
				raise "BAD RESPONSE"
			end
		end
	end





# Read parallele memory in asynchronous mode (blocking function) but callBack data is used to receive packet
# * +addressStart+:: 32 bits address
# * +addressStop+:: 32 bits address
# * +bits8_or_bits16_DataSize+:: 0 for 8 bits operation  & 1 for 16 bits operation
# * +latency+:: latency in ns  range 7ns to 1600ns=1,6ms
# Return USB_STATE   End with  TIMEOUT_RECEIVE  but need to check if received the right number of bytes to ensure all is correct
	def read_Memory_WithoutMultiplexing(*args)
		parametters = HardsploitAPI.checkParametters(["addressStart","addressStop","bits8_or_bits16_DataSize","latency"],args)
   	addressStart = parametters[:addressStart]
		addressStop = parametters[:addressStop]
		bits8_or_bits16_DataSize = parametters[:bits8_or_bits16_DataSize]
		latency = parametters[:latency]


		numberOfByteReaded = 0
		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(USB_COMMAND::FPGA_COMMAND)

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
		if (addressStop <= addressStart  ) then
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

		if bits8_or_bits16_DataSize then
			sizeCalculated = (addressStop-addressStart+1)
		else
			sizeCalculated = (addressStop-addressStart+1)*2
		end

		numberOfByteReaded = 0
		while true
			tmp= receiveDATA(2000)
			case tmp
				when HardsploitAPI::USB_STATE::BUSY
					raise  "USB_STATE::BUSY"
				when HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
					raise "Timeout"
				else
					#remove header (4 bytes   2 for size 2 for type of command)
					tmp = tmp.bytes.drop(4)
					numberOfByteReaded = numberOfByteReaded + tmp.size
					consoleData(tmp)

					puts "Receive #{numberOfByteReaded} of #{sizeCalculated}"
  				if numberOfByteReaded >= sizeCalculated then
					 	#Exit because we received all data
					 	return
					end
				end
			end
		end
end
