#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================
require_relative 'HardsploitAPI_SWD_DEBUG'
require_relative 'HardsploitAPI_SWD_STM32'

class HardsploitAPI
attr_accessor :debugPort
attr_accessor :stm32

	def runSWD
		@debugPort = SWD_DEBUG_PORT.new(self)
		@stm32     = SWD_STM32.new(debugPort)

		resetSWD()
		#  Cortex M4 0x410FC241
		#  Cortex M3 411FC231
	end

	def obtainCodes
		resetSWD()
		code = {
		  :DebugPortId => debugPort.idcode(),
		  :AccessPortId => stm32.ahb.idcode(),
		  :CpuId => stm32.ahb.readWord(0xE000ED00),
			:DeviceId => stm32.ahb.readWord(0x1FFFF7E8)
		}
		return code
	end


	def writeFlash(path)
		resetSWD()
		dataWrite = IO.binread(path)
	  dataWrite = dataWrite.unpack("C*")
		puts "Halting Processor"
		stm32.halt()
		puts "Erasing Flash"
		stm32.flashUnlock()
		stm32.flashErase()
		puts "Programming Flash"
		stm32.flashProgram()
		time = Time.new
		stm32.flashWrite(0x08000000, dataWrite)
		time = Time.new - time
		puts "Write #{((dataWrite.size/time)).round(2)}Bytes/s #{(dataWrite.size)}Bytes in  #{time.round(4)} s"
		stm32.flashProgramEnd()
		puts "Resetting"
		stm32.sysReset()
		puts "Start"
		stm32.unhalt
	end

	def eraseFlash
		puts 'Erase'
		stm32.flashErase()
	end

	def dumpFlash(path)
		resetSWD()
		#DUMP FLASH MEMORY TO A FILE
		@stm32.halt
	  flash_size = (stm32.ahb.readWord(0x1ffff7e0) & 0xFFFF)
		puts "Flash size : #{(flash_size) } KB"
		puts "Dump flash"
	  time = Time.new
		data = @stm32.flashRead(0x08000000,(flash_size*1024))
		time = Time.new - time
		puts "DUMP #{((data.size/time)).round(2)}Bytes/s #{(data.size)}Bytes in  #{time.round(4)} s"
		IO.binwrite(path, data.pack('C*'))
		puts "Finish dump"
	end

	def writeSWD(ap,register,data)
		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(HardsploitAPI::USB_COMMAND::FPGA_COMMAND)

		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO

		packet.push 0x10 #Write mode

		packet.push (calcOpcode(ap, register, false)) #Send Request

		packet.push  ((data & 0xFF) >> 0)
		packet.push  ((data & 0xFF00) >> 8 )
		packet.push  ((data & 0xFF0000) >> 16 )
		packet.push  ((data & 0xFF000000) >> 24 )

		result = sendAndReceiveDATA(packet,1000)

		if result.class == Array then
				if result.size == 1 + 4 then #receive ACK
					if result[4] == 1 then
							return true
					elsif result[4] == 2 then
							raise "WAIT response"
					elsif result[4] == 4 then
						  raise "FAULT response"
					else
							raise "WRITE ERROR #{result[4]}"
					end
				else
					raise "Error during writing}"
				end
		else # Receive and error
			raise "Error during writing, timeout "
		end

		return false
	end

	def writeBlockAP(data)
		if data.size > 8000 then
			raise "data is too big > 8000"
		end

		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(HardsploitAPI::USB_COMMAND::FPGA_COMMAND)

		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO
		packet.push 0xBB #Write ap
		packet.push *data

		result = sendAndReceiveDATA(packet,1000)
		if result.class == Array then
				if result.size == 1 + 4 then #receive ACK
					if result[4] == 1 then
							return true
					elsif result[4] == 2 then
							raise "WAIT response"
					elsif result[4] == 4 then
						  raise "FAULT response"
					else
							raise "WRITE ERROR #{result[4]}"
					end
				else
					raise "Error during writing"
				end
		else # Receive and error
			raise "Error during writing, timeout "
		end
			return false
	end


	def readBlockAP(size)
		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(HardsploitAPI::USB_COMMAND::FPGA_COMMAND)

		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO

		packet.push 0xAA #Read mode
		packet.push HardsploitAPI.lowByte(size)
		packet.push HardsploitAPI.highByte(size)

		result = sendAndReceiveDATA(packet,1000)
		 if result.class == Array then
		 		if result.size >= 4   then #Receive read + 4bytes for header
		 			return result.drop(4)
				else
					raise "Receive just Header where is the data ? "
		 		end
		 else # Receive and error
		 		raise "Error during reading  timeout or ACK issue "
		 end
	end

	def readSWD(ap,register)
		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(HardsploitAPI::USB_COMMAND::FPGA_COMMAND)

		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO

		packet.push 0x11 #Read mode
		packet.push(calcOpcode(ap,register, true)) #Send Request

		result = sendAndReceiveDATA(packet,1000)
		 if result.class == Array then
		 		if result.size == 4 + 4  then #Receive read + 4bytes for header
		 			convert = (result[7]  << 24)  + (result[6]  << 16) + (result[5]  << 8 ) + result[4]
		 			return convert
		 		elsif result.size == 4+1 then #receive ACK
					raise "Read error  ACK : #{result[4]}"
		 		else
		 			raise "Error during reading"
		 		end
		 else # Receive and error
		 	raise "Error during reading  timeout "
		 end
	end


	#Return array with 1 byte for ACK
	#Return 32bits integer for data read here is Core ID
	#Raise if error
	def resetSWD
		packet = Array.new
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(HardsploitAPI::USB_COMMAND::FPGA_COMMAND)

		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO

		packet.push 0x00 #Reset mode

		result = sendAndReceiveDATA(packet,1000)
		if result.class == Array then
				if result.size == 4 + 4  then #Receive read + 4bytes for header
					convert = (result[7]  << 24)  + (result[6]  << 16) + (result[5]  << 8 ) + result[4]
					return convert
				elsif result.size == 4 +1 then #reveice ACK
					raise "ERROR ACK #{result[4]}"
				else
					raise "Error during reading ICCODE result != 4"
				end
		else # Receive and error
			raise "Error during reading ICCODE timeout "
		end
	end


	def calcOpcode (ap, register, read)
			opcode = 0x00
			(ap ? opcode |= 0x40 : opcode |= 0x00)
			(read ? opcode |= 0x20 : opcode |= 0x00)
			opcode = opcode | ((register & 0x01) << 4) | ((register & 0x02) << 2) #Addr AP DP  bit 2..3
			opcode = opcode | (((opcode & 0x78).to_s(2).count('1').odd? ? 1 : 0) << 2)  #0x78 mask to take only read ap and register to process parity bit
			opcode = opcode | 0x81 #Start and Park Bit
			#puts "OpCode #{opcode.to_s(16)}"
			return opcode
	end
end
