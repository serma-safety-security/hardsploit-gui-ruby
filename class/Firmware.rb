#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class Firmware
  def initialize(api, firmware)
    if $currentFirmware != firmware
      case firmware
      when 'I2C'
        p "Upload Firmware  check : #{api.uploadFirmware(File.expand_path(File.dirname(__FILE__)) +  "/../Firmware/FPGA/I2C/I2C_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_I2C_INTERACT.rpd", false)}"
      when 'SPI'
        p "Upload Firmware  check : #{api.uploadFirmware(File.expand_path(File.dirname(__FILE__)) +  '/../Firmware/FPGA/SPI/SPI_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_SPI_INTERACT.rpd', false)}"
      when 'Parallel'
        p "Upload Firmware  check : #{api.uploadFirmware(File.expand_path(File.dirname(__FILE__)) +  "/../Firmware/FPGA/PARALLEL/NO_MUX_PARALLEL_MEMORY/HARDSPLOIT_FIRMWARE_FPGA_NO_MUX_PARALLEL_MEMORY.rpd", false)}"
      when 'SWD'
        p "Upload Firmware  check : #{api.uploadFirmware(File.expand_path(File.dirname(__FILE__)) +  "/../Firmware/FPGA/SWD/SWD_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_SWD_INTERACT.rpd", false)}"
      end
      $currentFirmware = firmware
      sleep(2)
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error while loading the firmware. Consult the log for more details').exec
  end
end
