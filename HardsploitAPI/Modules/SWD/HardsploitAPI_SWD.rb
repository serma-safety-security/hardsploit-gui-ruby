#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================
require_relative 'HardsploitAPI_SWD_DEBUG'
require_relative 'HardsploitAPI_SWD_STM32'
require_relative '../../Core/HardsploitAPI'

class HardsploitAPI_SWD
#attr_accessor :debugPort
#attr_accessor :stm32
	DCRDR = 0xE000EDF8  # address of Debug Core Register Data Register
	DCRSR = 0xE000EDF4  # address of Debug Core Register Selector Register

	def initialize(memory_start_address:, memory_size_address:, cpu_id_address:, device_id_address:)
		HardsploitAPI.instance.connect
		@memory_start_address = memory_start_address.hex
		@memory_size_address  = memory_size_address.hex
		@cpu_id_address 	  	= cpu_id_address.hex
		@device_id_address 	  = device_id_address.hex
	end

	def readRegs
		#halt the target before read register
		stop

		@stm32.ahb.csw(1,2)

		p read_mem8(0x1FFFF7E0,2)
		#p @stm32.ahb.readWord(@memory_size_address).to_s(16)
		for i in 0..36
			#Write DCRSR address into TAR register
			#Write core register index Rn into DRW register.
			write_mem32( DCRSR,[i,0,0,0])
			#@stm32.ahb.writeWord( DCRSR,i)

			#Write DCRDR address into TAR register.
			#Read core register value from DRW register.
			#value = @stm32.ahb.readWord( DCRDR)
			result = read_mem32(DCRDR,1)
			value = result[0] + (result[1] << 8) + (result[2] << 16) + (result[3] << 24)
			puts "R#{i} #{value.to_s(16)}"
		end
	end

	def stop
		# halt the processor core
		write_mem32(0xE000EDF0,[0x03,0x00,0x5F,0xA0])
	end

	def start
		# start the processor core
		write_mem32(0xE000EDF0,[0x00,0x00,0x5F,0xA0])
	end
	def obtainCodes
		@debugPort = SWD_DEBUG_PORT.new(self)
		@stm32     = SWD_STM32.new(@debugPort)
		#  Cortex M4 0x410FC241
		#  Cortex M3 0x411FC231
		resetSWD
		# code = {
		#   :DebugPortId  => @debugPort.idcode,
		#   :AccessPortId => @stm32.ahb.idcode,
		#   :CpuId 				=> @stm32.ahb.readWord(@cpu_id_address),
		# 	:DeviceId 		=> @stm32.ahb.readWord(@device_id_address)
		# }

		code = {
			:DebugPortId  => @debugPort.idcode,
			:AccessPortId => @stm32.ahb.idcode,
		  :CpuId 				=> @stm32.ahb.readWord(@cpu_id_address)
		}
		return code
	end

	def find(numberOfConnectedPinFromA0:)
		posibility = HardsploitAPI.allPosibility(
			numberOfConnectedPinFromA0: numberOfConnectedPinFromA0,
			numberOfSignalsForBus: 2
		)
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
		  	code =  obtainCodes
				return item
		  rescue Exception => msg
		  		puts msg
		  end
		end
	end

	def writeFlash(path)
		obtainCodes
		dataWrite = IO.binread(path)
	    dataWrite = dataWrite.unpack("C*")
		HardsploitAPI.instance.consoleInfo "Halting Processor"
		@stm32.halt
		HardsploitAPI.instance.consoleInfo "Erasing Flash"
		@stm32.flashUnlock
		@stm32.flashErase
		HardsploitAPI.instance.consoleInfo "Programming Flash"
		@stm32.flashProgram
		time = Time.new
		@stm32.flashWrite(@memory_start_address, dataWrite)
		time = Time.new - time
		HardsploitAPI.instance.consoleSpeed "Write #{((dataWrite.size/time)).round(2)}Bytes/s #{(dataWrite.size)}Bytes in  #{time.round(4)} s"
		@stm32.flashProgramEnd
		HardsploitAPI.instance.consoleInfo "Resetting"
		@stm32.sysReset
		HardsploitAPI.instance.consoleInfo "Start"
		@stm32.unhalt
	end

	def eraseFlash
		obtainCodes
		HardsploitAPI.instance.consoleInfo 'Erase'
		@stm32.flashErase
	end

	def dumpFlash(path)
		obtainCodes
		@stm32.halt
	  flash_size = (@stm32.ahb.readWord(@memory_size_address) & 0xFFFF)
		HardsploitAPI.instance.consoleInfo "Flash size : #{(flash_size)} KB"
		HardsploitAPI.instance.consoleInfo "Dump flash"
	    time = Time.new
		data = @stm32.flashRead(@memory_start_address, (flash_size * 1024))
		time = Time.new - time
		HardsploitAPI.instance.consoleSpeed "DUMP #{((data.size/time)).round(2)}Bytes/s #{(data.size)}Bytes in  #{time.round(4)} s"
		IO.binwrite(path, data.pack('C*'))
		HardsploitAPI.instance.consoleInfo "Finish dump"
	end
	def read_mem8(address,size)
		packet = HardsploitAPI.prepare_packet
		packet.push 0xAA #Read mode
		packet.push HardsploitAPI.lowByte(word: size)
		packet.push HardsploitAPI.highByte(word: size)
		packet.push ((address & 0xFF) >> 0)
		packet.push ((address & 0xFF00) >> 8 )
		packet.push ((address & 0xFF0000) >> 16 )
		packet.push ((address & 0xFF000000) >> 24 )

		# --[2:0]	Size
		# 	--Size of access field:
		# 	--b000 = 8 bits
		# 	--b001 = 16 bits
		# 	--b010 = 32 bits
		# 	--b011-111 are reserved.
		# 	--Reset value: b000
		#
		# 	--[5:4]	AddrInc
		# 	--0b00 = auto increment off.
		# 	--0b01 = increment single. Single transfer from corresponding byte lane.
		# 	--0b10 = increment packed.[b]
		# 	--0b11 = reserved. No transfer.
		# 	--Size of address increment is defined by the Size field [2:0].
		# 	--Reset value: 0b00.
		packet.push 0b00010000 # single 8 bits auto increment
		result = HardsploitAPI.instance.sendAndReceiveDATA(packet, 1000)
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during reading  timeout or ACK issue" unless result.class == Array
		#raise HardsploitAPI::ERROR::SWD_ERROR,"We need to receive #{size  } and we received #{result.size-4}"	 unless (result.size-4) == size # Receive all data
		return result.drop(4)
	end
	def read_mem32(address,size)
		packet = HardsploitAPI.prepare_packet
		packet.push 0xAA #Read mode
		packet.push HardsploitAPI.lowByte(word: size)
		packet.push HardsploitAPI.highByte(word: size)
		packet.push ((address & 0xFF) >> 0)
		packet.push ((address & 0xFF00) >> 8 )
		packet.push ((address & 0xFF0000) >> 16 )
		packet.push ((address & 0xFF000000) >> 24 )

		# --[2:0]	Size
		# 	--Size of access field:
		# 	--b000 = 8 bits
		# 	--b001 = 16 bits
		# 	--b010 = 32 bits
		# 	--b011-111 are reserved.
		# 	--Reset value: b000
		#
		# 	--[5:4]	AddrInc
		# 	--0b00 = auto increment off.
		# 	--0b01 = increment single. Single transfer from corresponding byte lane.
		# 	--0b10 = increment packed.[b]
		# 	--0b11 = reserved. No transfer.
		# 	--Size of address increment is defined by the Size field [2:0].
		# 	--Reset value: 0b00.
		packet.push 0b00010010 # single 32 bits auto increment

		result = HardsploitAPI.instance.sendAndReceiveDATA(packet, 1000)
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during reading  timeout or ACK issue" unless result.class == Array
		raise HardsploitAPI::ERROR::SWD_ERROR,"We need to receive #{size +4 } and we received #{result.size}"	 unless (result.size-4)/4 == size # Receive all data
		return result.drop(4)
	end
	def write_mem32(address,data)
		raise "Too many data (> 2000)" if data.size > 2000
		packet = HardsploitAPI.prepare_packet
		packet.push 0xBB #Write ap
		packet.push ((address & 0xFF) >> 0)
		packet.push ((address & 0xFF00) >> 8 )
		packet.push ((address & 0xFF0000) >> 16 )
		packet.push ((address & 0xFF000000) >> 24 )

		# --[2:0]	Size
		# 	--Size of access field:
		# 	--b000 = 8 bits
		# 	--b001 = 16 bits
		# 	--b010 = 32 bits
		# 	--b011-111 are reserved.
		# 	--Reset value: b000
		#
		# 	--[5:4]	AddrInc
  	# 	--0b00 = auto increment off.
		# 	--0b01 = increment single. Single transfer from corresponding byte lane.
		# 	--0b10 = increment packed.[b]
		# 	--0b11 = reserved. No transfer.
		# 	--Size of address increment is defined by the Size field [2:0].
		# 	--Reset value: 0b00.
		packet.push 0b00010010 # single 32 bits auto increment neeed to write in flash

		packet.push *data
		result = HardsploitAPI.instance.sendAndReceiveDATA(packet, 1000)
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during writing, timeout" unless result.class == Array
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during writing" 					unless result.size == 5
		return true 																													if result[4] == 1
		raise HardsploitAPI::ERROR::SWD_ERROR,"WAIT response" 								if result[4] == 2
		raise HardsploitAPI::ERROR::SWD_ERROR,"FAULT response" 								if result[4] == 4
		raise HardsploitAPI::ERROR::SWD_ERROR,"WRITE ERROR #{result[4]}"
	end

	def write_mem8(address,data)
		raise "Too many data (> 2000)" if data.size > 2000
		packet = HardsploitAPI.prepare_packet
		packet.push 0xBB #Write ap
		packet.push ((address & 0xFF) >> 0)
		packet.push ((address & 0xFF00) >> 8 )
		packet.push ((address & 0xFF0000) >> 16 )
		packet.push ((address & 0xFF000000) >> 24 )

		# --[2:0]	Size
		# 	--Size of access field:
		# 	--b000 = 8 bits
		# 	--b001 = 16 bits
		# 	--b010 = 32 bits
		# 	--b011-111 are reserved.
		# 	--Reset value: b000
		#
		# 	--[5:4]	AddrInc
				# 	--0b00 = auto increment off.
		# 	--0b01 = increment single. Single transfer from corresponding byte lane.
		# 	--0b10 = increment packed.[b]
		# 	--0b11 = reserved. No transfer.
		# 	--Size of address increment is defined by the Size field [2:0].
		# 	--Reset value: 0b00.
		packet.push 0b00010000 # single 8 bits auto increment neeed to write in flash
		packet.push *data

		packet.push 0 #Dummy need to be improve in VHDL

		result = HardsploitAPI.instance.sendAndReceiveDATA(packet, 1000)
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during writing, timeout" unless result.class == Array
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during writing" 					unless result.size == 5
		return true 																													if result[4] == 1
		raise HardsploitAPI::ERROR::SWD_ERROR,"WAIT response" 								if result[4] == 2
		raise HardsploitAPI::ERROR::SWD_ERROR,"FAULT response" 								if result[4] == 4
		raise HardsploitAPI::ERROR::SWD_ERROR,"WRITE ERROR #{result[4]}"
	end

	def write_mem16Packed(address,data)
		raise "Too many data (> 2000)" if data.size > 2000
		packet = HardsploitAPI.prepare_packet
		packet.push 0xBB #Write ap
		packet.push ((address & 0xFF) >> 0)
		packet.push ((address & 0xFF00) >> 8 )
		packet.push ((address & 0xFF0000) >> 16 )
		packet.push ((address & 0xFF000000) >> 24 )

		# --[2:0]	Size
		# 	--Size of access field:
		# 	--b000 = 8 bits
		# 	--b001 = 16 bits
		# 	--b010 = 32 bits
		# 	--b011-111 are reserved.
		# 	--Reset value: b000
		#
		# 	--[5:4]	AddrInc
  	    # 	--0b00 = auto increment off.
		# 	--0b01 = increment single. Single transfer from corresponding byte lane.
		# 	--0b10 = increment packed.[b]
		# 	--0b11 = reserved. No transfer.
		# 	--Size of address increment is defined by the Size field [2:0].
		# 	--Reset value: 0b00.
		packet.push 0b00100001 # packet 16 bits auto increment neeed to write in flash

		packet.push *data
		result = HardsploitAPI.instance.sendAndReceiveDATA(packet, 1000)
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during writing, timeout" unless result.class == Array
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during writing" 					unless result.size == 5
		return true 																													if result[4] == 1
		raise HardsploitAPI::ERROR::SWD_ERROR,"WAIT response" 								if result[4] == 2
		raise HardsploitAPI::ERROR::SWD_ERROR,"FAULT response" 								if result[4] == 4
		raise HardsploitAPI::ERROR::SWD_ERROR,"WRITE ERROR #{result[4]}"
	end

	def writeSWD(ap, register, data)
		packet = HardsploitAPI.prepare_packet
		packet.push 0x10 #Write mode
		packet.push (calcOpcode(ap, register, false)) #Send Request
		packet.push ((data & 0xFF) >> 0)
		packet.push ((data & 0xFF00) >> 8 )
		packet.push ((data & 0xFF0000) >> 16 )
		packet.push ((data & 0xFF000000) >> 24 )
		result = HardsploitAPI.instance.sendAndReceiveDATA(packet, 1000)
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during writing, timeout" unless result.class == Array
		raise HardsploitAPI::ERROR::SWD_ERROR, "Error during writing" 				unless result.size == 5
		return true 																													if result[4] == 1
		raise HardsploitAPI::ERROR::SWD_ERROR,"WAIT response" 								if result[4] == 2
		raise HardsploitAPI::ERROR::SWD_ERROR,"FAULT response" 								if result[4] == 4
		raise HardsploitAPI::ERROR::SWD_ERROR,"WRITE ERROR #{result[4]}"
	end

	def readSWD(ap, register)
		packet = HardsploitAPI.prepare_packet
		packet.push 0x11 #Read mode
		packet.push(calcOpcode(ap,register, true)) #Send Request
		result = HardsploitAPI.instance.sendAndReceiveDATA(packet, 1000)
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during reading  timeout" 			 unless result.class == Array
		raise HardsploitAPI::ERROR::SWD_ERROR,"Read error ACK : #{result[4]}" 			 if result.size == 5 # Receive ACK
		return (result[7] << 24) + (result[6] << 16) + (result[5] << 8 ) + result[4] if result.size == 8 # Receive read + 4bytes for header
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during reading"
	end

	#Return array with 1 byte for ACK
	#Return 32bits integer for data read here is Core ID
	#Raise if error
	def resetSWD
		packet = HardsploitAPI.prepare_packet
		packet.push 0x00 #Reset mode
		result = HardsploitAPI.instance.sendAndReceiveDATA(packet, 1000)
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during reading ICCODE timeout"  unless result.class == Array
		return (result[7] << 24) + (result[6] << 16) + (result[5] << 8 ) + result[4] if result.size == 8
		raise HardsploitAPI::ERROR::SWD_ERROR,"Reset error ACK #{result[4]}" 				 if result.size == 5 #reveice ACK
		raise HardsploitAPI::ERROR::SWD_ERROR,"Error during reading ICCODE result != 4"
	end

	def calcOpcode (ap, register, read)
		opcode = 0x00
		(ap ? opcode |= 0x40 : opcode |= 0x00)
		(read ? opcode |= 0x20 : opcode |= 0x00)
		opcode = opcode | ((register & 0x01) << 4) | ((register & 0x02) << 2) #Addr AP DP  bit 2..3
		opcode = opcode | (((opcode & 0x78).to_s(2).count('1').odd? ? 1 : 0) << 2)  #0x78 mask to take only read ap and register to process parity bit
		opcode = opcode | 0x81 #Start and Park Bit
		return opcode
	end
end
