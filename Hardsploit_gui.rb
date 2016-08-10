#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require 'Qt4'
require 'sqlite3'
require 'active_record'
require_relative 'db/database.rb'
require_relative 'gui/gui_chip_management'
require_relative 'class/Chip_management'
require_relative 'HardsploitAPI/Core/HardsploitAPI'
require_relative 'Firmwares/UC/VersionUC'
require_relative 'Firmwares/FPGA/VersionFPGA'
include VersionFPGA::VERSION_FPGA
include VersionUC::VERSION_UC

class Hardsploit_gui
  VERSION = "2.3.2"
  def initialize
    HardsploitAPI.callbackInfo = method(:callbackInfo)
    HardsploitAPI.callbackData = method(:callbackData)
    HardsploitAPI.callbackSpeedOfTransfert = method(:callbackSpeedOfTransfert)
    HardsploitAPI.callbackProgress = method(:callbackProgress)
    $file = nil
    $currentFirmware = nil
    $logFilePath = File.expand_path(File.dirname(__FILE__)) + "/logs/error.log"
    $dbFilePath = File.expand_path(File.dirname(__FILE__)) + "/db/hs.db"
    # Launch GUI
    Qt::Application.new(ARGV) do
      $app = self
      w = Chip_management.new(VERSION)
      centerWindow(w)
      w.show
      exec
    end
  end

  def callbackInfo(receiveData)
    print receiveData  + "\n"
  end

  def callbackProgress(percent:, startTime:, endTime:)
    print "\r\e[#{31}mIn progress : #{percent}%\e[0m"
    $pgb.update_value(percent) unless $pgb.nil?
    if percent == 100
      duration = (endTime-startTime).round(2)
      $pgb.display_time("Total duration: #{duration} second(s)")
    end
    $app.processEvents
  end

  def callbackSpeedOfTransfert(receiveData)
    #puts receiveData
  end

  def callbackData(receiveData)
    $file.write(receiveData.pack('C*'))
  end

  def check_ReceivedData
    result = HardsploitAPI.receiveDATA(2000)
  end
end

def check_for_errors(result)
  return false if result.errors.messages.empty?
  error_message = ""
  result.errors.messages.each do |msg|
    error_message << "Error: #{msg[0]} #{msg[1][0]}\n"
  end
  Qt::MessageBox.new(Qt::MessageBox::Warning, 'Warning', error_message).exec
  return true
end

def inputRestrict(lineEdit, type)
  case type
  when 0 ; reg = Qt::RegExp.new("[0-9]+")
  when 1 ; reg = Qt::RegExp.new("^[a-zA-Z_@-]+( [a-zA-Z_@-]+)*$")
  when 2 ; reg = Qt::RegExp.new("^[a-zA-Z0-9_@-]+( [a-zA-Z0-9_@-]+)*$")
  when 3 ; reg = Qt::RegExp.new("^[A-Fa-f0-9]{2}")
  when 4 ; reg = Qt::RegExp.new("^[A-Fa-f0-9]{8}")
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
