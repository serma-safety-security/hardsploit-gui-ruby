#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
	module Error
    class Standard < StandardError; end

    class FileIssue < Standard
			def initialize(msg="Issue with file")
					super(msg)
			end
    end


    class I2CWrongSpeed < Standard
			def initialize(msg="Uknown speed")
					super(msg)
			end
		end

		class WrongStartAddress < Standard
			def initialize(msg="Start address can't be negative and not more than size max - 1")
					super(msg)
			end
		end

		class SpiError < Standard
			def initialize(msg="Error during SPI processing")
					super(msg)
			end
		end
	end
end
