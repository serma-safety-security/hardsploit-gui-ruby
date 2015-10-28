#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
public

	# Wait to receive data
	# * +pathFirmware+:: path of rpd file (vhdl)
	# * +checkFirmware+:: boolean if check is needed (recommended false, in case issue true to check)
	# Return true if firmware write == firmware read (slow because read the firmware for check)
	def uploadFirmware(*args)
			parametters = checkParametters(["pathFirmware","checkFirmware"],args)
			pathFirmware = parametters[:pathFirmware]
			checkFirmware = parametters[:checkFirmware]

			stopFPGA
			eraseFirmware
			firmwarewrite = self.writeFirmware(pathFirmware)#return array of bytes write
			if checkFirmware == true then
				firmwareRead = self.readFirmware(firmwarewrite.length) #return array of bytes read
				startFPGA
				return (firmwarewrite == firmwareRead)
			else
				startFPGA
				return true
			end
		end

		def startFPGA
			packet = Array.new
			packet.push lowByte(4)
			packet.push highByte(4)
			packet.push lowByte(USB_COMMAND::START_FPGA)
			packet.push highByte(USB_COMMAND::START_FPGA)
			self.sendPacket(packet)
		end
		def stopFPGA
			packet = Array.new
			packet.push lowByte(4)
			packet.push highByte(4)
			packet.push lowByte(USB_COMMAND::STOP_FPGA)
			packet.push highByte(USB_COMMAND::STOP_FPGA)
			self.sendPacket(packet)
		end


protected
		def eraseFirmware
			usbPacket = Array.new
			usbPacket.push lowByte(4) #length of trame
			usbPacket.push highByte(4)
			usbPacket.push lowByte(USB_COMMAND::ERASE_FIRMWARE)
			usbPacket.push highByte(USB_COMMAND::ERASE_FIRMWARE)

			consoleInfo "Start to erase Firmware\n"
			t1 = Time.now
			received_data  = sendAndReceiveDATA(usbPacket,15000)

			case received_data
				when HardsploitAPI::USB_STATE::PACKET_IS_TOO_LARGE
					return HardsploitAPI::USB_STATE::ERROR_SEND
				when HardsploitAPI::USB_STATE::ERROR_SEND
					return HardsploitAPI::USB_STATE::ERROR_SEND
				when HardsploitAPI::USB_STATE::BUSY
					return HardsploitAPI::USB_STATE::ERROR_SEND
				when HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
					p "TIMEOUT_RECEIVE"
					return HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
				else
					t2 = Time.now
					delta = t2 - t1
					consoleSpeed "Firmware erased in #{delta.round(4)} sec\n\n"
			end
		end

		#Just path of file and wait. is a blocking function until firmware has been uploaded
		def writeFirmware (file_path)
			t1 = Time.now
			consoleInfo "Upload firmware in progress\n"

			usbPacket= Array.new
			file = File.read(file_path,:encoding => 'iso-8859-1').unpack('C*') #string to array byte
			#file = file.drop(168) #remove header of pof file
			#file.pop(52+355000) #remove footer of pof file + about 355k of unused memory

			consoleInfo "FIRMARE Write #{file.size} bytes\n"

			#firmwareFile = file.clone  #copy the file in other variable to return it not just egal because copy pointer and after is the same array we want a copy -> clone

			nbFullPage = file.size/256
			nbLastByte =  file.size%256

			nbFullPacket = nbFullPage/31
			nbLastPagePacket =  nbFullPage%31

			#complete last page with the last alone byte ( without full page)
			if nbLastByte > 0 then
				for i in 0.. (256-nbLastByte)
					file.push 0xFF
				end
				nbFullPage = nbFullPage+1
				nbLastByte = 0

				#recalculating packet after complete half page to a full page
				nbFullPacket = nbFullPage/31
				nbLastPagePacket =  nbFullPage%31
			end

			consoleInfo "REAL Write #{file.size} bytes\n"

			#Now only full page but maybe a half packet
			#Prepare the full packet (31 pages of 256 byte each)
			for ipacket in 0..nbFullPacket-1
				usbPacket= Array.new
				usbPacket.push 0  #lenght of trame modify by sendUSBPacket
				usbPacket.push 0
				usbPacket.push lowByte(USB_COMMAND::WRITE_PAGE_FIRMWARE)
				usbPacket.push highByte(USB_COMMAND::WRITE_PAGE_FIRMWARE)
				usbPacket.push  lowByte((ipacket)*31)  # low byte Nb of the first page
				usbPacket.push  highByte((ipacket)*31)  # high byte Nb of the first page
				usbPacket.push 31 #Nb of pages sent

				start = (ipacket)*31*256
				stop  =  (ipacket+1)*31*256 -1 #array start at index = 0

				for iFile in start..stop
					usbPacket.push self.reverseBit(file[iFile])
					#usbPacket.push file[iFile]
				 end

				percent = ipacket *100 / (nbFullPacket-1)

				case self.sendPacket(usbPacket)
					when USB_STATE::SUCCESSFUL_SEND
							consoleSpeed "UPLOAD AT  : #{ipacket} / #{(nbFullPacket-1)} (#{percent}) %\n"
					when USB_STATE::PACKET_IS_TOO_LARGE
						return USB_STATE::PACKET_IS_TOO_LARGE
					when USB_STATE::ERROR_SEND
						return USB_STATE::ERROR_SEND
					else
						return USB_STATE::ERROR_SEND
				end
		end

		#Prepare the last packet with the rest of data
		if nbLastPagePacket >0 then
			usbPacket= Array.new
			usbPacket.push 0  #lenght of trame modify by sendUSBPacket
			usbPacket.push 0
			usbPacket.push lowByte(USB_COMMAND::WRITE_PAGE_FIRMWARE)
			usbPacket.push highByte(USB_COMMAND::WRITE_PAGE_FIRMWARE)

			if nbFullPacket == 0 then
				usbPacket.push  lowByte((nbFullPacket)*31)  # low byte Nb of the first page
				usbPacket.push  highByte((nbFullPacket)*31)  # high byte Nb of the first page
			else
				usbPacket.push  lowByte((nbFullPacket)*31 + 1 )  # low byte Nb of the first page
				usbPacket.push  highByte((nbFullPacket)*31+ 1 )   # high byte Nb of the first page
			end

			usbPacket.push  nbLastPagePacket # nb of page < 31

			start = (nbFullPacket)*31*256
			stop = (nbFullPacket)*31*256 + nbLastPagePacket*256 -1

			for iFile in start..stop
				#inverted LSB MSB
				usbPacket.push self.reverseBit(file[iFile])
			end

			case self.sendPacket(usbPacket)
				when USB_STATE::SUCCESSFUL_SEND
						consoleSpeed "UPLOAD AT  :  100 %\n"
				when USB_STATE::PACKET_IS_TOO_LARGE
					return USB_STATE::PACKET_IS_TOO_LARGE
				when USB_STATE::ERROR_SEND
					return USB_STATE::ERROR_SEND
				else
					return USB_STATE::ERROR_SEND
			end
		end

		t2 = Time.now
		delta = t2 - t1
		consoleSpeed "FIRMWARE WAS WRITTEN in #{delta.round(4)} sec\n"
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
				usbPacket.push  lowByte(USB_COMMAND::READ_PAGE_FIRMWARE)
				usbPacket.push  highByte(USB_COMMAND::READ_PAGE_FIRMWARE)
				usbPacket.push  lowByte((ipacket)*31)  # low byte Nb of the first page
				usbPacket.push  highByte((ipacket)*31)  # high byte Nb of the first page
				usbPacket.push  31 # nb of page max 31 per packet

				received_data  = sendAndReceiveDATA(usbPacket,3000)
				#p received_data
				case received_data
					when HardsploitAPI::USB_STATE::PACKET_IS_TOO_LARGE
						return HardsploitAPI::USB_STATE::ERROR_SEND
					when HardsploitAPI::USB_STATE::ERROR_SEND
						return HardsploitAPI::USB_STATE::ERROR_SEND
					when HardsploitAPI::USB_STATE::BUSY
						return HardsploitAPI::USB_STATE::ERROR_SEND
					when HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
						return HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
					else
						#remove header
						received_data = received_data.drop(7)

						#reverse byte
						received_data = received_data.collect {|x| self.reverseBit(x) }

					    readFirmware.push *received_data

					    if nbFullPacket == 1 then
					    	consoleSpeed "READ AT  : 1 / 2 50 %\n"
					    else
					   	 	percent = ipacket *100 / (nbFullPacket-1)
							consoleSpeed "READ AT  : #{ipacket} / #{(nbFullPacket-1)} (#{percent} %) \n"
						end

				end
			end



			#Prepare the last packet with the rest of data
			if nbLastPagePacket >0 then
				usbPacket= Array.new
				usbPacket.push 7
				usbPacket.push 0
				usbPacket.push lowByte(USB_COMMAND::READ_PAGE_FIRMWARE)
				usbPacket.push highByte(USB_COMMAND::READ_PAGE_FIRMWARE)

				#Increase nb of page to add the last byte
				if nbFullPacket == 0 then
					usbPacket.push  lowByte((nbFullPacket)*31)  # low byte Nb of the first page
					usbPacket.push  highByte((nbFullPacket)*31)  # high byte Nb of the first page
				else
					usbPacket.push  lowByte((nbFullPacket)*31 + 1 )  # low byte Nb of the first page
					usbPacket.push  highByte((nbFullPacket)*31+ 1 )   # high byte Nb of the first page
				end

				usbPacket.push  nbLastPagePacket
				received_data  = sendAndReceiveDATA(usbPacket,15000)
				case received_data
					when HardsploitAPI::USB_STATE::PACKET_IS_TOO_LARGE
						return HardsploitAPI::USB_STATE::ERROR_SEND
					when HardsploitAPI::USB_STATE::ERROR_SEND
						return HardsploitAPI::USB_STATE::ERROR_SEND
					when HardsploitAPI::USB_STATE::BUSY
						return HardsploitAPI::USB_STATE::ERROR_SEND
					when HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
						return HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
					else
						#remove header
						received_data = received_data.drop(7)

						#reverse byte
						received_data = received_data.collect {|x| self.reverseBit(x) }
				    readFirmware.push *received_data

				    consoleSpeed "READ AT 100%\n"
				end
			end

			#remove a fake byte at last of reading just for transmiting
			readFirmware.pop(nbSuppressBytesAtLast)

			t2 = Time.now
			delta = t2 - t1
			consoleSpeed "READ FIRMWARE FINISH  in #{delta.round(4)} sec\n"
			return readFirmware
		end
end
