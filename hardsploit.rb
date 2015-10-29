#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require 'Qt4'
require_relative 'gui/mainChipManagement'
require_relative 'gui/chipWizard'
require_relative 'gui/wireWizard'
require_relative 'gui/commandWizard'
require_relative 'gui/commandBase'
require_relative 'gui/exportManager'
require_relative 'class/HardsploitGUI'
require_relative 'class/WireWizard'
require_relative 'class/ChipWizard'
require_relative 'class/CommandWizard'
require_relative 'class/CommandBase'
require_relative 'class/ExportManager'
require_relative 'db/associations'
require_relative 'HardsploitAPI/HardsploitAPI'
require_relative 'Firmware/UC/VersionUC'
require_relative 'Firmware/FPGA/VersionFPGA'
include VersionFPGA::VERSION_FPGA
include VersionUC::VERSION_UC

class Hardsploit_GUI
  def initialize
    # Launch API
    hardAPI = HardsploitAPI.new(method(:callbackData),method(:callbackInfo),method(:callbackError),method(:callbackSpeedOfTransfert))
    $file = nil
    $currentFirmware = nil
    $usbConnected = nil
    $logFilePath = File.expand_path(File.dirname(__FILE__)) + "/logs/error.log"
    $dbFilePath = File.expand_path(File.dirname(__FILE__)) + "/db/hs.db"

    # Launch GUI
    Qt::Application.new(ARGV) do
      w = HardsploitGUI.new(hardAPI)
      centerWindow(w)
      w.show
      exec
    end
  end

  #
  # CALLBACK
  #
  def callbackInfo(receiveData)
    print receiveData  + "\n"
  end

  def callbackError(receiveData)
    print receiveData  + "\n"
  end

  def callbackSpeedOfTransfert(receiveData)
    puts receiveData
  end

  def callbackData(receiveData)
    begin
      $file.write(receiveData.pack('C*'))
    rescue
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured when opening the dump file. Consult the logs for more details").exec
    end
  end

  def check_ReceivedData
    result = hardAPI.receiveDATA(2000)
    case result
      when HardsploitAPI::USB_STATE::BUSY
        puts "BUSY"
      when HardsploitAPI::USB_STATE::TIMEOUT_RECEIVE
        puts "TIMEOUT_RECEIVE\n"
      else
        puts "Received"
        p result
    end
  end

  def check_SendData(value)
    case value
      when HardsploitAPI::USB_STATE::SUCCESSFUL_SEND
        puts "SUCCESSFUL_SEND"
      when HardsploitAPI::USB_STATE::PACKET_IS_TOO_LARGE
        puts "PACKET_IS_TOO_LARGE max: #{USB::USB_TRAME_SIZE}"
      when HardsploitAPI::USB_STATE::ERROR_SEND
        puts "ERROR_SEND\n"
      else
        puts "UNKNOWN SEND STATE"
    end
  end
end

  def inputRestrict(lineEdit, type)
    case type
    when 0
      reg = Qt::RegExp.new("[0-9]+")
    when 1
      reg = Qt::RegExp.new("^[a-zA-Z_@-]+( [a-zA-Z_@-]+)*$")
    when 2
      reg = Qt::RegExp.new("^[a-zA-Z0-9_@-]+( [a-zA-Z0-9_@-]+)*$")
    end
    regVal = Qt::RegExpValidator.new(reg, self)
    lineEdit.setValidator(regVal)
  end

  def centerWindow(win)
    desktop = Qt::DesktopWidget.new
    rect  = desktop.screenGeometry(desktop.primaryScreen)
    centerX = (rect.width - win.width ) / 2
    centerY = (rect.height - win.height)  / 2
    win.move(centerX,centerY)
  end