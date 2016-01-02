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
      return @dp.readRB()
	end
  def readWord (adr)
      @dp.writeAP(@apsel, 0x04, adr)
      @dp.readAP(@apsel, 0x0C)
      return @dp.readRB()
	end
  def writeWord (adr, data)
      @dp.writeAP(@apsel, 0x04, adr)
      @dp.writeAP(@apsel, 0x0C, data)
      return @dp.readRB()
	end
  def readBlock ( adr, count)#1K boundaries and return 4K of data word alignement
			if count < 1 then
				raise "readBlock error : count must be >= 1"
			end
			if count > 1024 then
				raise "readBlock error : count must be <= 1024 "
			end
			csw(1, 2) # 32-bit single-incrementing addressing
			@dp.writeAP(@apsel, 0x04, adr)
			vals = Array.new
			@dp.readAP(@apsel, 0x0C) #For the first byte
			vals.push(*@dp.getAPI.readBlockAP(count-1))  #Hardcoded function to increase speed of read block
      return vals
	end

	# def writeBlockNonInc (adr, data)
	#  		self.csw(0, 2) # 32-bit non-incrementing addressing
	#  		for val in data
	# 			@dp.writeAP(@apsel, 0x04, adr)
	# 			@dp.writeAP(@apsel, 0x0C, val)
	# 		end
	# 		self.csw(1, 2) # 32-bit auto-incrementing addressing
	# end

	def writeBlock (adr, data) #1K boundaries
    @dp.writeAP(@apsel, 0x04, adr)
		puts "writeBlock #{adr.to_s(16)}"

		@dp.getAPI.writeBlockAP(data)
		# for i in (0..data.size-1).step(4)
		# 		@dp.writeAP(@apsel, 0x0C, data[i].to_i + (data[i+1].to_i << 8) + (data[i+2].to_i << 16)+ (data[i+3].to_i << 24))
		# end
	end

  def writeHalfs (adr, data)
      self.csw(2, 1) # 16-bit packed-incrementing addressing
      @dp.writeAP(@apsel, 0x04, adr)
      for val in data
          sleep(0.001)
          @dp.writeAP(@apsel, 0x0C, val)
			end
	end
end
