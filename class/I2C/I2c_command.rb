#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_i2c_command'
class I2c_command < Qt::Widget
  slots 'open_generic_cmd()'

  def initialize(chip, bus_id, parent)
    super()
    @view = Ui_I2c_command.new
    centerWindow(self)
    @view.setupUi(self)
    @view.rbn_read.setChecked(true)
    inputRestrict(@view.lie_size, 0)
    @chip = chip
    @chip_settings = chip.i2c_setting
    @bus_id = bus_id
    @parent = parent
  end

  def open_generic_cmd
    return 0 if check_form_param.zero?
    if @view.rbn_read.isChecked
      mode = "r"
      addr = @chip_settings.address_r
    else
      mode = "w"
      addr = @chip_settings.address_w
    end
    i2c_cmd_form = Command_editor.new(0, nil, @chip, @bus_id, @parent, :mode => mode, :size => @view.lie_size.text, :addr => addr)
    i2c_cmd_form.setWindowModality(Qt::ApplicationModal)
    i2c_cmd_form.show
    close
  end

  def check_form_param
    if @view.lie_size.text.empty? || @view.lie_size.text.to_i.zero?
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        "Form invalid",
        "Payload size must be filled and superior to 0"
      ).exec
      return 0
    end
    return 1
  end
end
