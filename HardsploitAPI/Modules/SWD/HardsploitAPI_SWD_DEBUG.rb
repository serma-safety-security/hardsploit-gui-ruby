#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================
class SWD_DEBUG_PORT

	def initialize(swdAPI)
		@swdAPI = swdAPI
		sleep(0.5)
		@swdAPI.resetSWD
	
		@curAP = -1
		@curBank = -1
		abort(1,1,1,1,1)
		select(0,0) 
		
		# power shit up
		HardsploitAPI.instance.consoleInfo "Power shit up"
		
		@swdAPI.writeSWD(FALSE, 1, 0x54000000)
		if (status() >> 24) != 0xF4 then
			raise "error powering up system"
			exit(0)
		else
			HardsploitAPI.instance.consoleInfo "POWERING UP SYTEM OK"
		end
	end

	def getAPI
		return @swdAPI
	end

	def idcode
		return @swdAPI.readSWD(FALSE, 0)
	end

	def abort (orunerr, wdataerr, stickyerr, stickycmp, dap)
		value = 0x00000000
		(orunerr ? value |= 0x10 : value |= 0x00)
		(wdataerr ? value |= 0x08 : value |= 0x00)
		(stickyerr ? value |= 0x04 : value |= 0x00)
		(stickycmp ? value |= 0x02 : value |= 0x00)
		(dap ? value |= 0x01 : value |= 0x00)
		@swdAPI.writeSWD(FALSE, 0, value)
	end

	def status
		val= @swdAPI.readSWD(FALSE,1)
		return val
	end

	def control (trnCount = 0, trnMode = 0, maskLane = 0, orunDetect = 0)
		value = 0x54000000
		value = value | ((trnCount & 0xFFF) << 12)
		value = value | ((maskLane & 0x00F) << 8)
		value = value | ((trnMode  & 0x003) << 2)
		(orunDetect ? value |= 0x01 : value |= 0x00)
		@swdAPI.writeSWD(False, 1, value)
	end

	def select (apsel, apbank)
		if apsel != @curAP or apbank != @curBank then
			@curAP = apsel
			@curBank = apbank
			value = 0 | ((apsel  & 0xFF) << 24) | ((apbank & 0x0F) <<  4)
			@swdAPI.writeSWD(FALSE, 2, value)
		end
	end

	def readRB
		return @swdAPI.readSWD(FALSE, 3)
	end
	def readAP ( apsel, address)
		adrBank = (address >> 4) & 0xF
		adrReg  = (address >> 2) & 0x3
		select(apsel, adrBank)
		return @swdAPI.readSWD(TRUE, adrReg)
	end

	def writeAP (apsel, address, data)
		adrBank = (address >> 4) & 0xF
		adrReg  = (address >> 2) & 0x3
		select(apsel, adrBank)
		@swdAPI.writeSWD(TRUE, adrReg, data)
	 end
end
