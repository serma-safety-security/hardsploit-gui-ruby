#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_spi_settings'
class Spi_settings < Qt::Widget
  slots 'save_settings()'

  def initialize(chip)
    super()
    @view = Ui_Spi_settings.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    inputRestrict(@view.lie_total_size,         0)
    inputRestrict(@view.lie_page_size,          0)
    inputRestrict(@view.lie_write_page_latency, 0)
    inputRestrict(@view.lie_cmd_read,           0)
    inputRestrict(@view.lie_cmd_write,          0)
    inputRestrict(@view.lie_cmd_write_enable,   0)
    inputRestrict(@view.lie_cmd_erase,          0)
    inputRestrict(@view.lie_erase_time,         0)
    @chip = chip
    feed_settings_form unless chip.spi_setting.nil?
  end

  def save_settings
    @chip.spi_setting.nil? ? create : update
    @chip.reload
  end

  def feed_settings_form
    @view.cbx_mode.setCurrentIndex(@view.cbx_mode.findText(@chip.spi_setting.mode.to_s))
    @view.cbx_frequency.setCurrentIndex(@view.cbx_frequency.findText(@chip.spi_setting.frequency))
    @view.lie_cmd_read.setText(@chip.spi_setting.command_read.to_s)
    @view.lie_cmd_write.setText(@chip.spi_setting.command_write.to_s)
    @view.lie_write_page_latency.setText(@chip.spi_setting.write_page_latency.to_s)
    @view.lie_cmd_write_enable.setText(@chip.spi_setting.command_write_enable.to_s)
    @view.lie_cmd_erase.setText(@chip.spi_setting.command_erase.to_s)
    @view.lie_erase_time.setText(@chip.spi_setting.erase_time.to_s)
    @view.lie_page_size.setText(@chip.spi_setting.page_size.to_s)
    @view.lie_total_size.setText(@chip.spi_setting.total_size.to_s)
    @view.rbn_no.setChecked(true) if @chip.spi_setting.is_flash.zero?
  rescue Exception => msg
    ErrorMsg.new.unknow(msg)
  end

  def is_flash?
    return 0 if @view.rbn_no.isChecked
    return 1
  end

  def create
    chip_settings = SpiSetting.create(
      mode:                 @view.cbx_mode.currentText.to_i,
      frequency:            @view.cbx_frequency.currentText,
      write_page_latency:   @view.lie_write_page_latency.text,
      command_read:         @view.lie_cmd_read.text,
      command_write:        @view.lie_cmd_write.text,
      command_write_enable: @view.lie_cmd_write_enable.text,
      command_erase:        @view.lie_cmd_erase.text,
      erase_time:           @view.lie_erase_time.text,
      page_size:            @view.lie_page_size.text,
      total_size:           @view.lie_total_size.text,
      is_flash:             is_flash?,
      chip_id:              @chip.id
    )
    unless check_for_errors(chip_settings)
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Succes',
        'SPI settings saved'
      ).exec
      close
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def update
    @chip.spi_setting.update(
      mode:                 @view.cbx_mode.currentText.to_i,
      frequency:            @view.cbx_frequency.currentText,
      write_page_latency:   @view.lie_write_page_latency.text,
      command_read:         @view.lie_cmd_read.text,
      command_write:        @view.lie_cmd_write.text,
      command_write_enable: @view.lie_cmd_write_enable.text,
      command_erase:        @view.lie_cmd_erase.text,
      erase_time:           @view.lie_erase_time.text,
      page_size:            @view.lie_page_size.text,
      total_size:           @view.lie_total_size.text,
      is_flash:             is_flash?
    )
    unless check_for_errors(@chip.spi_setting)
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Succes',
        'SPI settings updated'
      ).exec
      close
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end
end
