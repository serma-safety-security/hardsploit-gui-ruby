#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../gui/gui_chip_clone'
class Chip_clone < Qt::Widget
  slots 'clone()'

  def initialize(parent, chip)
    super()
    @parent = parent
    @chip = chip
    @view = Ui_Chip_clone.new
    centerWindow(self)
    @view.setupUi(self)
    inputRestrict(@view.lie_reference,   2)
  end

  def clone
    #Chip
    clone = @chip.dup
    clone.reference = @view.lie_reference.text
    clone.save
    #Pins
    @chip.pins.each do |pin|
      npin = pin.dup
      npin.chip_id = clone.id
      npin.save
    end
    #Setting(s)
    unless @chip.parallel_setting.nil?
    clone.parralel_setting = @chip.parallel_setting.dup
    clone.parralel_setting.save
    end
    unless @chip.spi_setting.nil?
    clone.spi_setting = @chip.spi_setting.dup
    clone.spi_setting.save
    end
    unless @chip.i2c_setting.nil?
      clone.i2c_setting = @chip.i2c_setting.dup
      clone.i2c_setting.save
    end
    unless @chip.swd_setting.nil?
      clone.swd_setting = @chip.swd_setting.dup
      clone.swd_setting.save
    end
    unless @chip.uart_setting.nil?
      clone.uart_setting = @chip.uart_setting.dup
      clone.uart_setting.save
    end
    #Command(s) and cmd bytes
    unless @chip.commands.nil?
      @chip.commands.each do |cmd|
        clone_cmd = cmd.dup
        clone_cmd.chip_id = clone.id
        clone_cmd.save
        cmd.bytes.each do |byte|
          clone_byte = byte.dup
          clone_byte.command_id = clone_cmd.id
          clone_byte.save
        end
      end
    end
    @parent.feed_chip_array
    self.close
  end
end
