#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => File.expand_path(File.dirname(__FILE__)) + '/hs.db'
)

class Package < ActiveRecord::Base
	self.table_name = "HS_PACKAGE"
	has_many :chips,
		foreign_key: "chip_package",
		:dependent => :delete_all
end

class Manufacturer < ActiveRecord::Base
	self.table_name = "HS_MANUFACTURER"
	validates :manufacturer_name, uniqueness: true
	has_many :chips,
		foreign_key: "chip_manufacturer",
		:dependent => :delete_all
end

class CType < ActiveRecord::Base
	self.table_name = "HS_CHIP_TYPE"
	validates :cType_name, uniqueness: true
	has_many :chips,
		foreign_key: "chip_type",
		:dependent => :delete_all
end

class Chip < ActiveRecord::Base
	self.table_name = "HS_CHIP"
	belongs_to	:package
	belongs_to	:manufacturer,
		foreign_key: "chip_manufacturer"
	belongs_to	:ctype,
		class_name:		"CType",
		foreign_key:	"chip_type"
	has_many	:pin,
		foreign_key:	"pin_chip",
		:dependent => :delete_all
	has_many	:cmd,
		foreign_key:	"cmd_chip",
		:dependent => :delete_all
end

class Parallel < ActiveRecord::Base
	self.table_name = "HS_PARAM_PARA"
	belongs_to	:chip,
		class_name:		"Chip",
		foreign_key:	"parallel_chip"
end

class Spi < ActiveRecord::Base
	self.table_name = "HS_PARAM_SPI"
	belongs_to	:chip,
		class_name:		"Chip",
		foreign_key:	"spi_chip"
end

class I2C < ActiveRecord::Base
	self.table_name = "HS_PARAM_I2C"
	belongs_to	:chip,
		class_name:		"Chip",
		foreign_key:	"i2c_chip"
end

class Pin < ActiveRecord::Base
	self.table_name = "HS_PIN"
	belongs_to	:chip
	belongs_to	:signall,
		class_name:		"Signall",
		foreign_key:	"pin_signal"
end

class Signall < ActiveRecord::Base
	self.table_name = "HS_SIGNAL"
	has_many :use,
     class_name:  "Use",
     foreign_key: "signal_id"
	has_many :bus, through: :use
	has_many :pin
end

class Use < ActiveRecord::Base
	self.table_name = "HS_USE"
	belongs_to :signall,
		class_name:		"Signall",
		foreign_key:	"signal_id"
	belongs_to :bus,
		class_name:		"Bus",
		foreign_key:	"bus_id"
end

class Bus < ActiveRecord::Base
	self.table_name = "HS_BUS"
	has_many :signall, through: :use
	has_many :cmd
end

class Cmd < ActiveRecord::Base
	self.table_name = "HS_CMD"
	has_many	:byte,
		foreign_key: "byte_cmd",
		:dependent => :delete_all
	belongs_to	:bus,
		class_name:	"Bus",
		foreign_key: "cmd_bus"
	belongs_to	:chip
end

class Byte < ActiveRecord::Base
	self.table_name = "HS_CMD_BYTE"
	belongs_to	:cmd,
		class_name:		"Cmd",
		foreign_key:	"byte_cmd"
end
