#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class HardsploitAPI
	class HardsploitProgress
		def initialize(percent,timeElasped)
				@Percent = percent
				@TimeElasped = timeElasped
		end
		def	getPercent
			return @Percent
		end
		def	setPercent(percent)
			 @Percent = percent
		end
		def	getTimeElasped
			return @TimeElasped
		end
		def	setTimeElasped(timeElasped)
			 @TimeElasped = timeElasped
		end
	end
end
