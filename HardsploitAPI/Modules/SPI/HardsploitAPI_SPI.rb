#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../Core/HardsploitAPI'
class HardsploitAPI_SPI
public

def initialize(speed:,mode:)
	#to be sure the singleton was initialize
	HardsploitAPI.instance.connect
	self.speed=speed
	self.mode=mode
	@pulse = 0
end

def pulse
	return @pulse
end

def pulse=(pulse)
	if (pulse == 0) or (pulse == 1) then
		@pulse = pulse
		spi_SetSettings #Send an Empty array to validate the value of pulse
	else
		raise HardsploitAPI::ERROR::SPIWrongPulse
	end
end

def speed
	return @speed
end

def speed=(speed)
	if (speed <=2) or (speed >256) then
		raise HardsploitAPI::ERROR::SPIWrongSpeed
	else
		@speed = speed
	end
end

def mode
	return @mode
end

def mode=(mode)
	if ( mode < 0 ) or ( mode > 3 ) then
		raise HardsploitAPI::ERROR::SPIWrongMode
	else
		@mode = mode
	end
end

def spi_SetSettings()
	packet = Array.new
	packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
	packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
	packet.push HardsploitAPI.lowByte(word:HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
	packet.push HardsploitAPI.highByte(word:HardsploitAPI::USB_COMMAND::FPGA_COMMAND)

	packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO

	packet.push (( @pulse & 1 ) << 2 ) || ( @mode & 3 ) #Add mode and the value of pin pulse
	packet.push @speed #Add speed
	begin
		HardsploitAPI.instance.sendPacket packet
		rescue
		raise HardsploitAPI::ERROR::USB_ERROR
	end
end

#  SPI interact
# * +payload+:: Byte array want to send
# * Return SPI data received
def spi_Interact(payload:)
	if ( payload.size > 4000 ) then
		raise SPIWrongPayloadSize
	end

	packet = Array.new
	packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
	packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
	packet.push HardsploitAPI.lowByte(word:HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
	packet.push HardsploitAPI.highByte(word:HardsploitAPI::USB_COMMAND::FPGA_COMMAND)

	packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO
	packet.push (( @pulse & 1 ) << 2 ) || ( @mode & 3 ) #Add mode and the value of pin pulse
	packet.push @speed #Add speed
	packet.concat payload #Add data
	#puts "Payload : #{payload}"

	#remove header (4 bytes   2 for size 2 for type of command)
	return HardsploitAPI.instance.sendAndReceiveDATA(packet, 1000).drop(4)
end


# Spi generic Import
# * +writeSpiCommand+:: The write command most of the time 0x02
# * +startAddress+:: Start address (included)
# * +pageSize+:: Size of page
# * +memorySize+:: Size max of memory in byte (important, to calculate automatically the number of byte to set address)
# * +saveFile+:: File contain data
# * +writePageLatency+:: Time to wait after each pages written
# * +enableWriteSpiCommand+:: Enable write commad most of the time 0x06
# * +clearSpiCommand+:: Bulk erase command most of the time 0x60  chip eraseTime
# * +clearChipTime+:: Time to erase entire the memory (bulk erase) in case of flash memory, 240 seconds for a 512Mb spansion memory and  13 seconds for a 16Mb Micron memory, see the datasheet
# * +isFLASH+:: True if it is a Flash memory (add clear content)
	def spi_Generic_Import (startAddress:,pageSize:,memorySize:,dataFile:,writeSpiCommand:,writePageLatency:,enableWriteSpiCommand:,clearSpiCommand:,clearChipTime:,isFLASH:)
		#Start time
		startTime = Time.now

		file =	File.open(dataFile, 'rb')
		sizeFile = file.size

		if (( startAddress < 0 )  or ( startAddress > memorySize - 1 )) then
			raise Error::WrongStartAddress
		end

		if (( pageSize <= 0 ) and ( pageSize > 2048 )) then
			raise TypeError, "pageSize need to be greater than 0 and less than 2048"
		end

		numberOfByteAddress = ((( Math.log( memorySize - 1, 2 )).floor + 1 ) / 8.0 ).ceil
		if numberOfByteAddress > 4 then
			raise TypeError, "Size max must be less than 2^32 about 4Gb"
		end

		if numberOfByteAddress <= 0 then
			raise TypeError, "There is an issue with calculating of number of byte needed"
		end

		#if flash memory we need to erase it before and wait enought
		#time (erase cycle time in datasheet) or polling status register
		if isFLASH then
		  spi_Interact(payload:	[clearSpiCommand])
			sleep(clearChipTime)
		end

		startTime = Time.now
		packet_size = pageSize
		number_complet_packet = (sizeFile / packet_size).floor
		size_last_packet =  sizeFile % packet_size

		#SEND the first complete trame
		for i in 0..number_complet_packet - 1 do
			#Enable write latch
			spi_Interact(payload:	[enableWriteSpiCommand])
			packet = generate_spi_write_command(
				numberOfByteAddress:	numberOfByteAddress,
				writeSpiCommand:			writeSpiCommand,
				startAddress:					i * packet_size + startAddress,
				data:									file.read(packet_size).unpack("C*")
			)

			temp = spi_Interact( payload:	packet )
			#Remove header, result of read command and numberOfByte Address too
			unless packet.size == temp.size then
				raise HardsploitAPI::SpiError
			end

			HardsploitAPI.instance.consoleProgress(
				percent:	100 * ( i + 1 ) / ( number_complet_packet + ( size_last_packet.zero? ? 0 : 1 ) ),
				startTime:startTime,
				endTime:	Time.new
			)
			#if too many error when write increase because we need to wait to write a full page
			sleep(writePageLatency)
		end

		if( size_last_packet > 0 )then
			#Enable write latch
			spi_Interact( payload:	[enableWriteSpiCommand]	)
			packet = generate_spi_write_command(
				numberOfByteAddress:	numberOfByteAddress,
				writeSpiCommand:			writeSpiCommand,
				startAddress: 				number_complet_packet * packet_size + startAddress,
				data:									file.read(size_last_packet).unpack("C*")
			)
			temp = spi_Interact( payload:	packet )
			#Remove header, result of write command and numberOfByte Address too
			unless packet.size == temp.size then
				raise HardsploitAPI::SpiError
			end

			#Send 100% in case of last packet
			HardsploitAPI.instance.consoleProgress(
				percent:		100,
				startTime:	startTime,
				endTime:		Time.now
			)
		end
		delta = Time.now - startTime
		HardsploitAPI.instance.consoleSpeed "Write in #{delta.round(4)} sec"
end


# Spi generic dump
# * +readSpiCommand+:: The read command
# * +startAddress+:: Start address (included)
# * +stopAddress+:: Stop address (included)
# * +sizeMax+:: Size max of memory (important to calculate automaticly the number of byte to set address)
	def spi_Generic_Dump (readSpiCommand:,startAddress:,stopAddress:,sizeMax:)
		if (( startAddress < 0 )  or ( startAddress > sizeMax - 1 )) then
			raise TypeError, "Start address can't be negative and not more than size max - 1"
		end

		if (( stopAddress < 0 )  or ( stopAddress > ( sizeMax - 1 ))) then
			raise TypeError, "Stop address can't be negative and not more than size max-1 because start at 0"
		end

		if ( stopAddress < startAddress ) then
			raise TypeError, "Stop address need to be greater than start address"
		end

		numberOfByteAddress = ((( Math.log( sizeMax - 1, 2 )).floor + 1) / 8.0 ).ceil
		if numberOfByteAddress > 4 then
			raise TypeError, "Size max must be less than 2^32 about 4Gb"
		end

		if numberOfByteAddress <= 0 then
			raise TypeError, "There is an issue with calculating of number of byte needed"
		end

		#Start time
		startTime = Time.now
		packet_size = 4000 - numberOfByteAddress - 1
		number_complet_packet = (( stopAddress - startAddress + 1 ) / packet_size ).floor
		size_last_packet =  ( stopAddress - startAddress + 1 ) % packet_size

		#SEND the first complete trame
		for i in 0..number_complet_packet - 1 do
			packet = generate_spi_read_command(
				numberOfByteAddress:	numberOfByteAddress,
				readSpiCommand:				readSpiCommand,
				startAddress:					i * packet_size + startAddress,
				size:									packet_size
			)
			begin
				temp = spi_Interact( payload: packet )
			rescue
				raise HardsploitAPI::ERROR::USB_ERROR
			end
			#Remove header, result of read command and numberOfByte Address too
			#puts "receive real size #{temp.size}"
			HardsploitAPI.instance.consoleData temp.drop( numberOfByteAddress + 1 )
			HardsploitAPI.instance.consoleProgress(
				percent:		100 * ( i + 1 ) / ( number_complet_packet + ( size_last_packet.zero? ? 0 : 1 )),
				startTime:	startTime,
				endTime:		Time.new
			)
		end

	if( size_last_packet > 0 ) then
		packet = generate_spi_read_command(
			numberOfByteAddress:	numberOfByteAddress,
			readSpiCommand: 			readSpiCommand,
			startAddress: 				number_complet_packet * packet_size + startAddress,
			size:									size_last_packet
		)
		temp = spi_Interact( payload: packet )
		#Remove header, result of read command and numberOfByte Address too
		HardsploitAPI.instance.consoleData temp.drop( numberOfByteAddress + 1 )
		begin
			HardsploitAPI.instance.consoleProgress(
				percent: 	 100,
				startTime: startTime,
				endTime: 	 Time.now
			)
		rescue
			raise HardsploitAPI::ERROR::USB_ERROR
		end
	end
		delta = Time.now - startTime
		HardsploitAPI.instance.consoleSpeed "Write in #{delta.round(4)} sec"
end

protected
	def generate_spi_read_command (numberOfByteAddress:,readSpiCommand:,startAddress:,size:)
		packet = Array.new
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
		if packet.size > 4000 then
			raise TypeError, "Too many byte to send in spi mode not more than 4000 is needed"
		end
		return packet
	end

	def generate_spi_write_command (numberOfByteAddress:,writeSpiCommand:,startAddress:,data:)
		packet = Array.new
		packet.push writeSpiCommand
		case  numberOfByteAddress
			when 1
				packet.push  (( startAddress & 0x000000FF) >> 0 )   #AddStart0
			when 2
				packet.push  (( startAddress & 0x0000FF00) >> 8 )  #AddStart1
				packet.push  (( startAddress & 0x000000FF) >> 0 )   #AddStart0
			when 3
				packet.push  (( startAddress & 0x00FF0000) >> 16 ) #AddStart2
				packet.push  (( startAddress & 0x0000FF00) >> 8 )  #AddStart1
				packet.push  (( startAddress & 0x000000FF) >> 0 )   #AddStart0
			when 4
				packet.push  (( startAddress & 0xFF000000) >> 24 ) #AddStart3
				packet.push  (( startAddress & 0x00FF0000) >> 16 ) #AddStart2
				packet.push  (( startAddress & 0x0000FF00) >> 8 )  #AddStart1
				packet.push  (( startAddress & 0x000000FF) >> 0 )   #AddStart0
			else
				raise TypeError, "Issue in generate_spi_write_command function when parse number of byte address"
		end
		#Push data to write
		packet.push *data
		if packet.size > 4000 then
			raise TypeError, "Too many byte to send in spi mode not more than 4000 is needed"
		end
		return packet
	end
end
