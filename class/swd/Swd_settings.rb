#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_swd_settings'
class Swd_settings < Qt::Widget
  slots 'save_settings()'

  def initialize(chip)
    super()
    @view = Ui_Swd_settings.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    inputRestrict(@view.lie_cpu_id_address,     4)
    inputRestrict(@view.lie_device_id_address,  4)
    inputRestrict(@view.lie_size_address,       4)
    inputRestrict(@view.lie_start_address,      4)
    @chip = chip
    feed_settings_form unless chip.swd_setting.nil?
  end

  def save_settings
    @chip.swd_setting.nil? ? create : update
    @chip.reload
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def feed_settings_form
    @view.lie_cpu_id_address.setText(@chip.swd_setting.cpu_id_address)
    @view.lie_device_id_address.setText(@chip.swd_setting.device_id_address)
    @view.lie_size_address.setText(@chip.swd_setting.memory_size_address)
    @view.lie_start_address.setText(@chip.swd_setting.memory_start_address)
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def create
    chip_settings = SwdSetting.create(
      cpu_id_address:       @view.lie_cpu_id_address.text,
      device_id_address:    @view.lie_device_id_address.text,
      memory_size_address:  @view.lie_size_address.text,
      memory_start_address: @view.lie_start_address.text,
      chip_id:              @chip.id
    )
    unless check_for_errors(chip_settings)
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Succes',
        'SWD settings saved'
      ).exec
      close
    end
  end

  def update
    @chip.swd_setting.update(
      cpu_id_address:       @view.lie_cpu_id_address.text,
      device_id_address:    @view.lie_device_id_address.text,
      memory_size_address:  @view.lie_size_address.text,
      memory_start_address: @view.lie_start_address.text,
    )
    unless check_for_errors(@chip.swd_setting)
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Succes',
        'SWD settings updated'
      ).exec
      close
    end
  end
end
