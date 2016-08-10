#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
public
	def loadFirmware(firmware)
		base_path = File.expand_path(File.dirname(__FILE__)) + '/../../Firmwares/FPGA/'
		case firmware
		when 'I2C'
			firmware_path = base_path + 'I2C/I2C_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_I2C_INTERACT.rpd'
			HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
		when 'SPI'
			firmware_path = base_path + 'SPI/SPI_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_SPI_INTERACT.rpd'
			HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
		when 'SPI_SNIFFER'
			firmware_path = base_path + 'SPI/SPI_SNIFFER/HARDSPLOIT_FIRMWARE_FPGA_SPI_SNIFFER.rpd'
			HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
		when 'PARALLEL'
			firmware_path = base_path + 'PARALLEL/NO_MUX_PARALLEL_MEMORY/HARDSPLOIT_FIRMWARE_FPGA_NO_MUX_PARALLEL_MEMORY.rpd'
			HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
		when 'SWD'
			firmware_path = base_path + 'SWD/SWD_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_SWD_INTERACT.rpd'
			HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
		when 'UART'
			firmware_path = base_path + 'UART/UART_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_UART_INTERACT.rpd'
			HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
		when 'uC'
				system("dfu-util -D 0483:df11 -a 0 -s 0x08000000 -R --download #{File.expand_path(File.dirname(__FILE__))}'/../Firmwares/UC/HARDSPLOIT_FIRMWARE_UC.bin'")
		end
	end

	# Wait to receive data
	# * +pathFirmware+:: path of rpd file (vhdl)
	# * +checkFirmware+:: boolean if check is needed (recommended false, in case issue true to check)
	# Return true if firmware write == firmware read (slow because read the firmware for check)
	def uploadFirmware(pathFirmware:,checkFirmware:)
			stopFPGA
			eraseFirmware
			firmwarewrite = self.writeFirmware(pathFirmware)#return array of bytes write
			if checkFirmware == true then
				firmwareRead = self.readFirmware(firmwarewrite.length) #return array of bytes read
				startFPGA
				sleep(1)
				return (firmwarewrite == firmwareRead)
			else
				startFPGA
				sleep(1)
				return true
			end
		end

		def startFPGA
			packet = Array.new
			packet.push HardsploitAPI.lowByte(word:4)
			packet.push HardsploitAPI.highByte(word:4)
			packet.push HardsploitAPI.lowByte(word:USB_COMMAND::START_FPGA)
			packet.push HardsploitAPI.highByte(word:USB_COMMAND::START_FPGA)
			self.sendPacket(packet)
		end
		def stopFPGA
			packet = Array.new
			packet.push HardsploitAPI.lowByte(word:4)
			packet.push HardsploitAPI.highByte(word:4)
			packet.push HardsploitAPI.lowByte(word:USB_COMMAND::STOP_FPGA)
			packet.push HardsploitAPI.highByte(word:USB_COMMAND::STOP_FPGA)
			self.sendPacket(packet)
		end


protected
		def eraseFirmware
			usbPacket = Array.new
			usbPacket.push HardsploitAPI.lowByte(word:4) #length of trame
			usbPacket.push HardsploitAPI.highByte(word:4)
			usbPacket.push HardsploitAPI.lowByte(word:USB_COMMAND::ERASE_FIRMWARE)
			usbPacket.push HardsploitAPI.highByte(word:USB_COMMAND::ERASE_FIRMWARE)

			consoleInfo "Start to erase Firmware\n"
			t1 = Time.now

			#Timeout very high to detect the end of erasing
			received_data  = sendAndReceiveDATA(usbPacket,15000)

			t2 = Time.now
			delta = t2 - t1
			consoleSpeed "Firmware erased in #{delta.round(4)} sec\n\n"

		end

		#Just path of file and wait. is a blocking function until firmware has been uploaded
		def writeFirmware (file_path)
			t1 = Time.now
			consoleInfo "Upload firmware in progress\n"

			usbPacket= Array.new
			file = File.read(file_path,:encoding => 'iso-8859-1').unpack('C*') #string to array byte
			puts "Date of last modification of the firmware #{File.mtime(file_path)}"

			consoleInfo "FIRMARE Write #{file.size} bytes\n"

			nbFullPage = file.size/256
			nbLastByte =  file.size%256

			nbFullPacket = nbFullPage/31
			nbLastPagePacket =  nbFullPage%31
			nbSuppressBytesAtLast = 256-nbLastByte
			#complete last page with the last alone byte ( without full page)
			if nbLastByte > 0 then
				for i in 0.. (nbSuppressBytesAtLast-1)
					file.push 0xFF
				end
				nbFullPage = nbFullPage+1
				nbLastByte = 0

				#recalculating packet after complete half page to a full page
				nbFullPacket = nbFullPage/31
				nbLastPagePacket =  nbFullPage%31
			else
				nbSuppressBytesAtLast = 0
			end

			consoleInfo "REAL Write #{file.size} bytes\n"

			#Now only full page but maybe a half packet
			#Prepare the full packet (31 pages of 256 byte each)
			for ipacket in 0..nbFullPacket-1
				usbPacket= Array.new
				usbPacket.push 0  #lenght of trame modify by sendUSBPacket
				usbPacket.push 0
				usbPacket.push HardsploitAPI.lowByte(word:USB_COMMAND::WRITE_PAGE_FIRMWARE)
				usbPacket.push HardsploitAPI.highByte(word:USB_COMMAND::WRITE_PAGE_FIRMWARE)
				usbPacket.push  HardsploitAPI.lowByte(word:(ipacket)*31)  # low byte Nb of the first page
				usbPacket.push  HardsploitAPI.highByte(word:(ipacket)*31)  # high byte Nb of the first page
				usbPacket.push 31 #Nb of pages sent

				start = (ipacket)*31*256
				stop  =  (ipacket+1)*31*256 -1 #array start at index = 0

				for iFile in start..stop
					usbPacket.push HardsploitAPI.reverseBit(file[iFile])
				 end

				percent = ipacket *100 / (nbFullPacket-1)
				begin
					sendPacket(usbPacket)
					consoleSpeed "UPLOAD AT  : #{ipacket} / #{(nbFullPacket-1)} (#{percent}) %\n"
					HardsploitAPI.instance.consoleProgress(
						percent:	percent,
						startTime:t1,
						endTime:	Time.new
					)
				rescue
					raise USB_ERROR
				end
		end

		#Prepare the last packet with the rest of data
		if nbLastPagePacket >0 then
			usbPacket= Array.new
			usbPacket.push 0  #lenght of trame modify by sendUSBPacket
			usbPacket.push 0
			usbPacket.push HardsploitAPI.lowByte(word:USB_COMMAND::WRITE_PAGE_FIRMWARE)
			usbPacket.push HardsploitAPI.highByte(word:USB_COMMAND::WRITE_PAGE_FIRMWARE)

			if nbFullPacket == 0 then
				usbPacket.push  HardsploitAPI.lowByte(word:(nbFullPacket)*31)  # low byte Nb of the first page
				usbPacket.push  HardsploitAPI.highByte(word:(nbFullPacket)*31)  # high byte Nb of the first page
			else
				usbPacket.push  HardsploitAPI.lowByte(word:(nbFullPacket)*31 + 1 )  # low byte Nb of the first page
				usbPacket.push  HardsploitAPI.highByte(word:(nbFullPacket)*31+ 1 )   # high byte Nb of the first page
			end

			usbPacket.push  nbLastPagePacket # nb of page < 31

			start = (nbFullPacket)*31*256
			stop = (nbFullPacket)*31*256 + nbLastPagePacket*256 -1

			for iFile in start..stop
				#inverted LSB MSB
				usbPacket.push HardsploitAPI.reverseBit(file[iFile])
			end
			begin
				sendPacket(usbPacket)
				consoleSpeed "UPLOAD AT  :  100 %\n"
				HardsploitAPI.instance.consoleProgress(
					percent:	100,
					startTime:t1,
					endTime:	Time.new
				)
			rescue
				raise ERROR::USB_ERROR
			end
		end

		t2 = Time.now
		delta = t2 - t1
		consoleSpeed "FIRMWARE WAS WRITTEN in #{delta.round(4)} sec\n"
		file.pop(nbSuppressBytesAtLast)
		return file
	end

	#Read firmware
	def readFirmware(size)
			consoleSpeed "START READ FIRMWARE \n"
			readFirmware = Array.new
			t1 = Time.now

			nbFullPage = size/256
			nbLastByte =  size%256


			nbFullPacket = nbFullPage/31
			nbLastPagePacket =  nbFullPage%31

			if nbLastByte > 0 then
				nbSuppressBytesAtLast = 256-nbLastByte

				nbFullPage = nbFullPage+1
				nbLastByte = 0

				nbFullPacket = nbFullPage/31
				nbLastPagePacket =  nbFullPage%31
			else
				nbSuppressBytesAtLast = 0

			end

			for ipacket in 0..nbFullPacket-1
				usbPacket= Array.new
				usbPacket.push 7
				usbPacket.push 0
				usbPacket.push  HardsploitAPI.lowByte(word:USB_COMMAND::READ_PAGE_FIRMWARE)
				usbPacket.push  HardsploitAPI.highByte(word:USB_COMMAND::READ_PAGE_FIRMWARE)
				usbPacket.push  HardsploitAPI.lowByte(word:(ipacket)*31)  # low byte Nb of the first page
				usbPacket.push  HardsploitAPI.highByte(word:(ipacket)*31)  # high byte Nb of the first page
				usbPacket.push  31 # nb of page max 31 per packet

				received_data  = sendAndReceiveDATA(usbPacket,3000)
				#remove header
				received_data = received_data.drop(7)

				#reverse byte
				received_data = received_data.collect {|x| HardsploitAPI.reverseBit(x) }
				readFirmware.push *received_data
				if nbFullPacket == 1 then
					consoleSpeed "READ AT  : 1 / 2 50 %\n"
					HardsploitAPI.instance.consoleProgress(
						percent:	50,
						startTime:t1,
						endTime:	Time.new
					)
				else
				percent = ipacket *100 / (nbFullPacket-1)
				consoleSpeed "READ AT  : #{ipacket} / #{(nbFullPacket-1)} (#{percent} %) \n"
				HardsploitAPI.instance.consoleProgress(
					percent:	percent,
					startTime:t1,
					endTime:	Time.new
				)
				end
			end

			#Prepare the last packet with the rest of data
			if nbLastPagePacket >0 then
				usbPacket= Array.new
				usbPacket.push 7
				usbPacket.push 0
				usbPacket.push HardsploitAPI.lowByte(word:USB_COMMAND::READ_PAGE_FIRMWARE)
				usbPacket.push HardsploitAPI.highByte(word:USB_COMMAND::READ_PAGE_FIRMWARE)

				#Increase nb of page to add the last byte
				if nbFullPacket == 0 then
					usbPacket.push  HardsploitAPI.lowByte(word:(nbFullPacket)*31)  # low byte Nb of the first page
					usbPacket.push  HardsploitAPI.highByte(word:(nbFullPacket)*31)  # high byte Nb of the first page
				else
					usbPacket.push  HardsploitAPI.lowByte(word:(nbFullPacket)*31 + 1 )  # low byte Nb of the first page
					usbPacket.push  HardsploitAPI.highByte(word:(nbFullPacket)*31+ 1 )   # high byte Nb of the first page
				end

				usbPacket.push  nbLastPagePacket

				received_data  = sendAndReceiveDATA(usbPacket,15000)
				#remove header
				received_data = received_data.drop(7)
				#reverse byte
				received_data = received_data.collect {|x| HardsploitAPI.reverseBit(x) }
		    readFirmware.push *received_data

		    consoleSpeed "READ AT 100%\n"
			end

			#remove a fake byte at last of reading just for transmiting
			readFirmware.pop(nbSuppressBytesAtLast)

			t2 = Time.now
			delta = t2 - t1
			consoleSpeed "READ FIRMWARE FINISH  in #{delta.round(4)} sec\n"
			return readFirmware
		end
end
