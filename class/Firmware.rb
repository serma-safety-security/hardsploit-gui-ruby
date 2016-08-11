#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class Firmware
  def initialize(firmware)
    unless $currentFirmware == firmware
      unless $currentFirmware == 'uC'
        $pgb = Progress_bar.new("Upload firmware :")
        $pgb.show
      end
      base_path = File.expand_path(File.dirname(__FILE__)) + '/../Firmwares/FPGA/'
      case firmware
      when 'I2C'
        firmware_path = base_path + 'I2C/I2C_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_I2C_INTERACT.rpd'
        HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
      when 'SPI'
        firmware_path = base_path + 'SPI/SPI_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_SPI_INTERACT.rpd'
        HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
      when 'SPI_SNIFFER'
        firmware_path = base_path + 'SPI/SPI_SNIFFER/HARDSPLOIT_FIRMWARE_FPGA_SPI_SNIFFER.rpd'
        HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
      when 'PARALLEL'
        firmware_path = base_path + 'PARALLEL/NO_MUX_PARALLEL_MEMORY/HARDSPLOIT_FIRMWARE_FPGA_NO_MUX_PARALLEL_MEMORY.rpd'
        HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
      when 'SWD'
        firmware_path = base_path + 'SWD/SWD_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_SWD_INTERACT.rpd'
        HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
      when 'UART'
        firmware_path = base_path + 'UART/UART_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_UART_INTERACT.rpd'
        HardsploitAPI.instance.uploadFirmware(pathFirmware: firmware_path, checkFirmware: false)
      when 'uC'
        msg = Qt::MessageBox.new
        msg.setWindowTitle("Microcontroller update")
        msg.setText("Hardsploit must be in bootloader mode and dfu-util package must be installed in order to continue. Proceed ?")
        msg.setIcon(Qt::MessageBox::Question)
        msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
        msg.setDefaultButton(Qt::MessageBox::Cancel)
        if msg.exec == Qt::MessageBox::Ok
          system("dfu-util -D 0483:df11 -a 0 -s 0x08000000 -R --download #{File.expand_path(File.dirname(__FILE__))}'/../Firmwares/UC/HARDSPLOIT_FIRMWARE_UC.bin'")
        end
      end
      $currentFirmware = firmware unless firmware == 'uC'
      firmware = "SPI" if firmware == "SPI_SNIFFER"
      $pgb.close
      sleep(2)
    end

    case firmware
    when 'PARALLEL', 'SWD', 'UART', 'I2C', 'SPI'
      # CrossWiring
      crossvalue = []
      for i in 0..63
        crossvalue.push i
      end
      pin_group = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
      Bus.find_by(name: firmware).signalls.each do |s|
        hardsploit_pin_number = pin_group.index(s.pin[0]) * 8 + s.pin[1].to_i
        crossvalue[hardsploit_pin_number] = HardsploitAPI.getSignalId(signal: s.name)
        crossvalue[HardsploitAPI.getSignalId(signal: s.name)] = hardsploit_pin_number
      end
      HardsploitAPI.instance.setCrossWiring(value: crossvalue)
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end
end
