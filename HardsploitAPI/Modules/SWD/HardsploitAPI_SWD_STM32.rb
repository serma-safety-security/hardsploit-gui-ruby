#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative 'HardsploitAPI_SWD_MEM_AP'

class SWD_STM32
attr_accessor :ahb

	def initialize(debugPort)
		@ahb = SWD_MEM_AP.new(debugPort, 0)
		@debugPort = debugPort
	end

	def halt
			# halt the processor core
			@ahb.writeWord(0xE000EDF0, 0xA05F0003)
	end
	def unhalt
			# unhalt the processor core
			@ahb.writeWord(0xE000EDF0, 0xA05F0000)
	end
	def sysReset
			# restart the processor and peripherals
			@ahb.writeWord(0xE000ED0C, 0x05FA0004)
	end

	def	flashRead(address,size)
		data = Array.new
		# Read a word of 32bits (4 Bytes in same time)
		size = size / 4
		#Chunk to 1k block for SWD
		#	ARM_debug_interface_v5 	Automatic address increment is only guaranteed to operate on the bottom 10-bits  of the
		# address held in the TAR. Auto address incrementing of bit [10] and beyond is
		# IMPLEMENTATION DEFINED. This means that auto address incrementing at a 1KB boundary
		# is IMPLEMENTATION DEFINED

		#But for hardsploit max 8192  so chuck to  1k due to swd limitation

		packet_size = 1024
		number_complet_packet = (size / packet_size).floor
		size_last_packet =  size % packet_size
		startTime = Time.now
		#number_complet_packet
		for i in 0..number_complet_packet - 1 do
 			data.push(*self.ahb.readBlock(i * 4 * packet_size + address, packet_size))
			#puts "Read #{packet_size} KB : #{i}"
			HardsploitAPI.instance.consoleProgress(
				percent:	 100 * (i + 1) / (number_complet_packet + (size_last_packet.zero? ? 0 : 1)),
				startTime: startTime,
				endTime:	 Time.new
			)
		end
		#Last partial packet
		if size_last_packet > 0 then
	  	data.push(*self.ahb.readBlock(number_complet_packet*4*packet_size+address,size_last_packet))
				#puts "Read last packet : #{size_last_packet} packet of 4 bytes"
				HardsploitAPI.instance.consoleProgress(
					percent:	 100,
					startTime: startTime,
					endTime:	 Time.new
				)
		end
		return data
	end

	def	flashWrite(address,data)
			#Chunk to 1k block for SWD
			packet_size = 1024 #1024
			number_complet_packet = (data.size/packet_size).floor
			size_last_packet =  data.size % packet_size
			startTime = Time.now
			#ahb.csw(2, 1) # 16-bit packed incrementing addressing
			#number_complet_packet
			for i in 0..number_complet_packet-1 do
				self.ahb.writeBlock(address+i*packet_size,data[i*packet_size..i*packet_size-1+packet_size])
				#puts "Write #{packet_size} KB : #{i}"
				HardsploitAPI.instance.consoleProgress(
					percent: 100 * (i + 1) / (number_complet_packet + (size_last_packet.zero? ? 0 : 1)),
					startTime: startTime,
					endTime:Time.new
				)
			end
			#Last partial packet
			if size_last_packet > 0 then
					self.ahb.writeBlock(address+number_complet_packet*packet_size,data[number_complet_packet*packet_size..number_complet_packet*packet_size+size_last_packet])
					#puts "Write last packet : #{size_last_packet} packet"
			  	HardsploitAPI.instance.consoleProgress(percent:100,startTime:startTime,endTime:Time.new)
			end
			ahb.csw(1, 2) # set to default 32-bit incrementing addressing
	end

	def flashUnlock
			# unlock main flash
			@ahb.writeWord(0x40022004, 0x45670123)
			@ahb.writeWord(0x40022004, 0xCDEF89AB)
	end
	def flashErase
			HardsploitAPI.instance.consoleInfo "Flash unlock"
			flashUnlock
			# start the mass erase
			@ahb.writeWord(0x40022010, 0x00000204)
			@ahb.writeWord(0x40022010, 0x00000244)
			# check the BSY flag
			while (@ahb.readWord(0x4002200C) & 1) == 1
					HardsploitAPI.instance.consoleInfo "waiting for erase completion..."
			end
			@ahb.writeWord(0x40022010, 0x00000200)
			HardsploitAPI.instance.consoleInfo "Finish unlock flash"
	end
	def flashProgram
			@ahb.writeWord(0x40022010, 0x00000201)
	end
	def flashProgramEnd
			@ahb.writeWord(0x40022010, 0x00000200)
	end
end
