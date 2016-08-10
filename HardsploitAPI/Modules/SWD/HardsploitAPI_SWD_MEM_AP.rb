#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class SWD_MEM_AP

	def initialize( dp, apsel)
		@dp = dp
		@apsel = apsel
		csw(1,2) # 32-bit auto-incrementing addressing
	end

	def csw ( addrInc, size)
	  @dp.readAP(@apsel, 0x00)
	  val = @dp.readRB() & 0xFFFFFF00
	  @dp.writeAP(@apsel, 0x00, val + (addrInc << 4) + size)
	end

	def idcode
		@dp.readAP(@apsel, 0xFC)
		id =  @dp.readRB()
		@dp.select(0,0)
		return id
	end

	def readWord (addr)
	  @dp.writeAP(@apsel, 0x04, addr)
	  @dp.readAP(@apsel, 0x0C)
	  return @dp.readRB()
	end

	def writeWord (addr, data)
	  @dp.writeAP(@apsel, 0x04, addr)
	  @dp.writeAP(@apsel, 0x0C, data)
	  return @dp.readRB()
	end

	def readBlock ( address, size)#1K boundaries and return 4K of data word alignement
		if size < 1 then
			raise "readBlock error : count must be >= 1"
		end
		if size > 1024 then
			raise "readBlock error : size must be <= 1024 "
		end
		return	@dp.getAPI.read_mem32(address,size)
	end

	def writeBlock (address,data) #1K boundaries
		if data.length < 1 then
			raise "readBlock error : count must be >= 1"
		end
		if data.length > 1024 then
			raise "readBlock error : size must be <= 1024 "
		end
		@dp.getAPI.write_mem16Packed(address,data)
	end
end
