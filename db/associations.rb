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
	self.table_name = "HS_PACKAGES"
  validates :package_name, uniqueness: true
	has_many :chips,
		foreign_key: "chip_package",
		:dependent => :destroy
end

class Manufacturer < ActiveRecord::Base
	self.table_name = "HS_MANUFACTURERS"
	validates :manufacturer_name, uniqueness: true
	has_many :chips,
		foreign_key: "chip_manufacturer",
		:dependent => :destroy
end

class CType < ActiveRecord::Base
	self.table_name = "HS_CHIP_TYPES"
	validates :cType_name, uniqueness: true
	has_many :chips,
		foreign_key: "chip_type",
		:dependent => :destroy
end

class Chip < ActiveRecord::Base
	self.table_name = "HS_CHIPS"
	belongs_to	:package,
    foreign_key: "chip_package"
	belongs_to	:manufacturer,
		foreign_key: "chip_manufacturer"
	belongs_to	:ctype,
		class_name:		"CType",
		foreign_key:	"chip_type"
	has_many	:pins,
		foreign_key:	"pin_chip",
		:dependent => :destroy
	has_many	:cmds,
		foreign_key:	"cmd_chip",
		:dependent => :destroy
  has_many	:parallel,
    foreign_key:	"parallel_chip",
		:dependent => :destroy
  has_many	:spi,
    foreign_key:	"spi_chip",
		:dependent => :destroy
  has_many	:I2C,
    foreign_key:	"i2c_chip",
		:dependent => :destroy
end

class Parallel < ActiveRecord::Base
	self.table_name = "HS_PARALLEL_SETTINGS"
	belongs_to	:chip,
		class_name:		"Chip",
		foreign_key:	"parallel_chip"
end

class Spi < ActiveRecord::Base
	self.table_name = "HS_SPI_SETTINGS"
	belongs_to	:chip,
		class_name:		"Chip",
		foreign_key:	"spi_chip"
end

class I2C < ActiveRecord::Base
	self.table_name = "HS_I2C_SETTINGS"
	belongs_to	:chip,
		class_name:		"Chip",
		foreign_key:	"i2c_chip"
end

class Pin < ActiveRecord::Base
	self.table_name = "HS_PINS"
	belongs_to	:chip
	belongs_to	:signall,
		class_name:		"Signall",
		foreign_key:	"pin_signal"
end

class Signall < ActiveRecord::Base
	self.table_name = "HS_SIGNALS"
	has_many :uses,
     class_name:  "Use",
     foreign_key: "signal_id"
	has_many :buses, through: :uses
	has_many :pins
end

class Use < ActiveRecord::Base
	self.table_name = "HS_USES"
	belongs_to :signall,
		class_name:		"Signall",
		foreign_key:	"signal_id"
	belongs_to :bus,
		class_name:		"Bus",
		foreign_key:	"bus_id"
end

class Bus < ActiveRecord::Base
	self.table_name = "HS_BUSES"
	has_many :signalls, through: :uses
	has_many :cmds
end

class Cmd < ActiveRecord::Base
	self.table_name = "HS_COMMANDS"
	has_many	:bytes,
		foreign_key: "byte_cmd",
		:dependent => :destroy
	belongs_to	:bus,
		class_name:	"Bus",
		foreign_key: "cmd_bus"
	belongs_to	:chip,
  class_name:	"Chip",
  foreign_key: "cmd_chip"
end

class Byte < ActiveRecord::Base
	self.table_name = "HS_CMD_BYTES"
	belongs_to	:cmd,
		class_name:		"Cmd",
		foreign_key:	"byte_cmd"
end
