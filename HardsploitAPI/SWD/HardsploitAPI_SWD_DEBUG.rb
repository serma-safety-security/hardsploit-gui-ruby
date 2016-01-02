#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================
class SWD_DEBUG_PORT

	def initialize(hardAPI)
		@HardAPI = hardAPI
		@HardAPI.startFPGA
		sleep(0.5)
		@HardAPI.resetSWD
		# read the IDCODE
		# if HardAPI.resetSWD() != 0x1ba01477 then
		#  		raise "warning: unexpected idcode"
		# else
		#  		puts "MCU DETECTED"
		# end
		abort(1,1,1,1,1)
		select(0,0)
		# power shit up
		puts "Power shit up"
		@HardAPI.writeSWD(FALSE, 1, 0x54000000)
		if (status() >> 24) != 0xF4 then
		 		raise "error powering up system"
				exit(0)
		else
			puts "POWERING UP SYTEM OK"
		end
		#get the SELECT register to a known state
		select(0,0)
		@curAP = 0
		@curBank = 0
	end

	def getAPI
		return @HardAPI
	end

	def idcode
			return @HardAPI.readSWD(FALSE, 0)
	end

	def abort (orunerr, wdataerr, stickyerr, stickycmp, dap)
			value = 0x00000000
			(orunerr ? value |= 0x10 : value |= 0x00)
			(wdataerr ? value |= 0x08 : value |= 0x00)
			(stickyerr ? value |= 0x04 : value |= 0x00)
			(stickycmp ? value |= 0x02 : value |= 0x00)
			(dap ? value |= 0x01 : value |= 0x00)
			@HardAPI.writeSWD(FALSE, 0, value)
	end

	def status
			val= @HardAPI.readSWD(FALSE,1)
			return val
	end

	def control (trnCount = 0, trnMode = 0, maskLane = 0, orunDetect = 0)
			value = 0x54000000
			value = value | ((trnCount & 0xFFF) << 12)
			value = value | ((maskLane & 0x00F) << 8)
			value = value | ((trnMode  & 0x003) << 2)
			(orunDetect ? value |= 0x01 : value |= 0x00)
			@HardAPI.writeSWD(False, 1, value)
	end

	def select (apsel, apbank)
			value = 0x00000000
			value = value | ((apsel  & 0xFF) << 24)
			value = value | ((apbank & 0x0F) <<  4)
			@HardAPI.writeSWD(FALSE, 2, value)
	end


	def readRB
			return @HardAPI.readSWD(FALSE, 3)
	end
	def readAP ( apsel, address)
			adrBank = (address >> 4) & 0xF
			adrReg  = (address >> 2) & 0x3
			if apsel != @curAP or adrBank != @curBank then
					select(apsel, adrBank)
					@curAP = apsel
					@curBank = adrBank
			end
			return @HardAPI.readSWD(TRUE, adrReg)
	end

	def writeAP (apsel, address, data)
			adrBank = (address >> 4) & 0xF
			adrReg  = (address >> 2) & 0x3
			if apsel != @curAP or adrBank != @curBank then
					select(apsel, adrBank)
					@curAP = apsel
					@curBank = adrBank
			end
		@HardAPI.writeSWD(TRUE, adrReg, data)
	 end
end
