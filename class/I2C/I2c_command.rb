#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_i2c_command'
class I2c_command < Qt::Widget
  slots 'open_generic_cmd()'

  def initialize(api, chip, bus_id, parent)
    super()
    @i2c_command_gui = Ui_I2c_command.new
    centerWindow(self)
    @i2c_command_gui.setupUi(self)
    @i2c_command_gui.rbn_read.setChecked(true)
    inputRestrict(@i2c_command_gui.lie_size, 0)
    @chip = chip
    @chip_settings = I2C.find_by(i2c_chip: chip.chip_id)
    @api = api
    @bus_id = bus_id
    @parent = parent
  end

  def open_generic_cmd
    return 0 if check_form_param.zero?
    if @i2c_command_gui.rbn_read.isChecked
      mode = "r"
      addr = @chip_settings.i2c_address_r
    else
      mode = "w"
      addr = @chip_settings.i2c_address_w
    end
    i2c_cmd_form = Command_editor.new(0, nil, @chip, @bus_id, @parent, @api, :mode => mode, :size => @i2c_command_gui.lie_size.text, :addr => addr)
    i2c_cmd_form.setWindowModality(Qt::ApplicationModal)
    i2c_cmd_form.show
    close
  end

  def check_form_param
    if @i2c_command_gui.lie_size.text.empty? || @i2c_command_gui.lie_size.text.to_i.zero?
      Qt::MessageBox.new(Qt::MessageBox::Information, "Form invalid", "Payload size must be filled and superior to 0").exec
      return 0
    end
    return 1
  end
end
