#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================
require_relative '../../Core/HardsploitAPI'
class HardsploitAPI_I2C

public

#attr_accessor :speed
#attr_reader :device_version

  # * +speed+:: I2C::KHZ_40  ,  I2C::KHZ_100  , 	I2C::KHZ_400 ,	I2C::KHZ_1000
  def initialize(speed:)
    #to be sure the singleton was initialize
    HardsploitAPI.instance.connect
    self.speed=speed
	end

  def speed
    return @speed
  end

  def speed=(speed)
    unless [HardsploitAPI::I2C::KHZ_40, HardsploitAPI::I2C::KHZ_100, HardsploitAPI::I2C::KHZ_400,HardsploitAPI::I2C::KHZ_1000].include?(speed) then
      raise HardsploitAPI::ERROR::I2CWrongSpeed
    end
    @speed = speed
  end

  # Interact with I2C bus
  # * +payload+:: payload to send
	def i2c_Interact(payload:)
		if (payload.size > 4000) then
			raise TypeError, 'Size of the data need to be less than 4000'
		end

		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(word:HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(word:HardsploitAPI::USB_COMMAND::FPGA_COMMAND)

		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO

		packet.push @speed #Add speed
		packet.concat payload #Add data

    #remove header (4 bytes   2 for size 2 for type of command)
    return HardsploitAPI.instance.sendAndReceiveDATA(packet,2000).drop(4)
  end

	# Start I2C scan to find addresses
	# * +speed+:: I2C::KHZ_100  , 	I2C::KHZ_400 ,	I2C::KHZ_1000
  # * Return  An array 256 value for each addresse if 0 not present if 1 present
	def i2c_Scan
		if (@speed < 0)  and (@speed >3) then
			I2CWrongSpeed
		end

		array_i2c_scan = Array.new
		result_scan = Array.new
		return_scan = Array.new

		#we want scan just read address it is a partial scan (fastest)
		for i in (1..255).step(2) do
			array_i2c_scan.push HardsploitAPI.lowByte(word:1)  #Count Low  Byte
			array_i2c_scan.push HardsploitAPI.highByte(word:1)   #Count High Byte
			array_i2c_scan.push i
		end

		result_scan = i2c_Interact(payload:array_i2c_scan)
		if result_scan.size != 256 then
			result_scan.clear
		end

		for i in (0..result_scan.size-1).step(2) do
			#Check if ACK_ERROR
			if result_scan[i] == 1 then
				return_scan.push 1 #For write
				return_scan.push 1 #For read
			else
				return_scan.push 0 #For write
				return_scan.push 0 #For read
			end
		end
		return return_scan
	end

	# Interact with I2C bus
	# * +speed+:: I2C::KHZ_100  , 	I2C::KHZ_400 ,	I2C::KHZ_1000
  # * +i2cBaseAddress+:: I2C base address / Write address  (8bits)
	# * +startAddress+:: Start address (included)
	# * +stopAddress+:: Stop address (included)
	# * +sizeMax+:: Size max of memory (important to calculate automaticly the number of byte to set address)
	def i2c_Generic_Dump (i2cBaseAddress:,startAddress:,stopAddress:,sizeMax:)
		if ((startAddress < 0)  or (startAddress > sizeMax-1)) then
			raise TypeError, "Start address can't be negative and not more than size max - 1"
		end

		if ((stopAddress < 0)  or (stopAddress > (sizeMax-1))) then
			raise TypeError, "Stop address can't be negative and not more than size max-1 because start at 0"
		end

		if (stopAddress <= startAddress) then
			raise TypeError, "Stop address need to be greater than start address"
		end

		numberOfByteAddress = (((Math.log(sizeMax-1,2)).floor + 1) / 8.0).ceil
		if numberOfByteAddress > 4 then
			raise TypeError, "Size max must be less than 2^32 about 4Gb"
		end

		if numberOfByteAddress <= 0 then
			raise TypeError, "There is an issue with calculating of number of byte needed"
		end
		startTime = Time.now
		packet_size = 2000 - numberOfByteAddress - 1
		number_complet_packet = ( (stopAddress-startAddress+1) / packet_size).floor
		size_last_packet =  (stopAddress-startAddress+1) % packet_size

		#SEND the first complete trame
		for i in 0..number_complet_packet - 1 do
			packet = generate_i2c_read_command(
        i2cBaseAddress:      i2cBaseAddress,
        numberOfByteAddress: numberOfByteAddress + startAddress,
        startAddress:        i * packet_size,
        size:                packet_size
      )
			#Remove header, result of read command and numberOfByte Address too
			HardsploitAPI.instance.consoleData ( process_dump_i2c_result( i2c_Interact( payload: packet )))
			HardsploitAPI.instance.consoleProgress(
        percent:   100 * ( i + 1 ) / ( number_complet_packet + ( size_last_packet.zero? ? 0 : 1 )),
        startTime: startTime,
        endTime:   Time.new
      )
		end

	if(size_last_packet > 0 ) then
		packet = generate_i2c_read_command(
      i2cBaseAddress:      i2cBaseAddress,
      numberOfByteAddress: numberOfByteAddress,
      startAddress:        number_complet_packet * packet_size + startAddress,
      size:                size_last_packet
    )
		#Remove header, result of read command and numberOfByte Address too
		HardsploitAPI.instance.consoleData( process_dump_i2c_result( i2c_Interact( payload:packet )))
		HardsploitAPI.instance.consoleProgress(
      percent:   100,
      startTime: startTime,
      endTime:   Time.new
    )
	end

	delta = Time.now - startTime
	HardsploitAPI.instance.consoleSpeed "Write in #{delta.round(4)} sec"
end

#For the moment only with EEPROM (not need to erase or activate write)
	def i2c_Generic_Import (i2cBaseAddress:,startAddress:,pageSize:,memorySize:,dataFile:,writePageLatency:)
  	startTime = Time.now
		begin
			file =	File.open(dataFile, 'rb')
			sizeFile = file.size
		rescue Exception => e
			raise Error::FileIssue, e.message
		end

		if ((startAddress < 0)  or (startAddress > memorySize - 1)) then
			raise Error::WrongStartAddress
		end

		if ((pageSize <= 0) and (pageSize > 1024)) then
			raise TypeError, "pageSize need to be greater than 0 and less than 1024"
		end

		numberOfByteAddress = (((Math.log(memorySize - 1, 2)).floor + 1) / 8.0).ceil
		if numberOfByteAddress > 4 then
			raise TypeError, "Size max must be less than 2^32 about 4Gb"
		end

		if numberOfByteAddress <= 0 then
			raise TypeError, "There is an issue with calculating of number of byte needed"
		end

		packet_size = pageSize
		number_complet_packet = (sizeFile / packet_size).floor
		size_last_packet =  sizeFile % packet_size

		#SEND the first complete trame
		for i in 0..number_complet_packet-1 do
			packet = generate_i2c_write_command(
        i2cBaseAddress:      i2cBaseAddress,
        numberOfByteAddress: numberOfByteAddress,
        startAddress:        i * packet_size,
        data:                file.read( packet_size ).unpack( "C*" )
      )

			#Remove header, result of read command and numberOfByte Address too
			process_import_i2c_result( i2c_Interact( payload: packet ))

			HardsploitAPI.instance.consoleProgress(
        percent:   100 * ( i + 1 ) / ( number_complet_packet + ( size_last_packet.zero? ? 0 : 1 )),
        startTime: startTime,
        endTime:   Time.new
      )
			#if too many error when write increase because we need to wait to write a full page
			sleep(writePageLatency)
		end

		if(size_last_packet > 0 ) then
			packet = generate_i2c_write_command(
        i2cBaseAddress:      i2cBaseAddress,
        numberOfByteAddress: numberOfByteAddress,
        startAddress:        number_complet_packet * packet_size + startAddress,
        data:                file.read( size_last_packet ).unpack( "C*" )
      )

			#Remove header, result of read command and numberOfByte Address too
			process_import_i2c_result ( i2c_Interact(payload: packet) )
			HardsploitAPI.instance.consoleProgress(
        percent:   100,
        startTime: startTime,
        endTime:   Time.new
      )
		end

		delta = Time.now - startTime
		HardsploitAPI.instance.consoleSpeed "Write in #{delta.round(4)} sec"
	end

  def find(numberOfConnectedPinFromA0:)
    posibility = HardsploitAPI.allPosibility(
			numberOfConnectedPinFromA0: numberOfConnectedPinFromA0,
			numberOfSignalsForBus: 2
		)
    compare_tab = Array.new(256, 1)
		for item in posibility
			currentWiring = 0
			for value in item
				currentWiring += 2 ** value
			end
			HardsploitAPI.instance.setWiringLeds(value: currentWiring)
			for i in 0..(63 - item.size)
				item.push i + numberOfConnectedPinFromA0
			end
			HardsploitAPI.instance.setCrossWiring(value: item)
  		begin
  		  	tab =  i2c_Scan
  				return item if tab.include?(1) and tab != compare_tab
  		  rescue Exception => msg
  		  		puts msg
  		  end
		end
  end

private

  def process_import_i2c_result (packet)
  	result = Array.new
  	for i in (0..packet.size - 1).step(2) do
  		case packet[i]
  		when 0  #Write ACK
  			#Do nothing,don't save write ack
  		else
  			raise TypeError, "Error in I2C transaction (NACK), write failed "
  		end
  	end
  	return result
  end

	def process_dump_i2c_result (packet)
		result = Array.new
		for i in (0..packet.size - 1).step(2) do
			case packet[i]
			when 1  #Read  ACK
				#Save read data
				result.push packet[i + 1]
			when 0  #Write ACK
				#Do nothing,don't save write ack
			else
				raise TypeError, "Error in I2C transaction, I2C export seems to be wrong"
			end
		end
		return result
	end

	def generate_i2c_write_command (i2cBaseAddress:, numberOfByteAddress:, startAddress:, data:)
		packet = Array.new
		#Push write command
		packet.push HardsploitAPI.lowByte(word:numberOfByteAddress+data.size)  #size of write command
		packet.push HardsploitAPI.highByte(word:numberOfByteAddress+data.size) #size of write command

		packet.push i2cBaseAddress #push Write address

		case  numberOfByteAddress
			when 1
				packet.push  ((startAddress & 0x000000FF) >> 0)   #AddStart0
			when 2
				packet.push  ((startAddress & 0x0000FF00) >> 8 )  #AddStart1
				packet.push  ((startAddress & 0x000000FF) >> 0)   #AddStart
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
				raise TypeError, "Issue in generate_i2c_write_command function when parse number of byte address"
		end

		#Push data to write
		packet.push *data
		return packet
	end

	def generate_i2c_read_command (i2cBaseAddress:, numberOfByteAddress:, startAddress:, size:)
		packet = Array.new
		#Push write command for start address
		packet.push HardsploitAPI.lowByte(word: numberOfByteAddress)  #size of write command
		packet.push HardsploitAPI.highByte(word: numberOfByteAddress) #size of write command

		packet.push i2cBaseAddress #push Write address

		case  numberOfByteAddress
			when 1
				packet.push  ((startAddress & 0x000000FF) >> 0)   #AddStart0
			when 2
				packet.push  ((startAddress & 0x0000FF00) >> 8 )  #AddStart1
				packet.push  ((startAddress & 0x000000FF) >> 0)   #AddStart
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

		#Push read command to read size data
		packet.push HardsploitAPI.lowByte(word:size)  #size of read command
		packet.push HardsploitAPI.highByte(word:size) #size of read command
		packet.push i2cBaseAddress+1  #push read address

		return packet
	end
end
