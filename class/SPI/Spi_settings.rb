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
    @spi_settings_gui = Ui_Spi_settings.new
    centerWindow(self)
    @spi_settings_gui.setupUi(self)
    @spi_settings_gui.lbl_chip.setText(chip.chip_reference)
    inputRestrict(@spi_settings_gui.lie_total_size, 0)
    inputRestrict(@spi_settings_gui.lie_page_size, 0)
    inputRestrict(@spi_settings_gui.lie_write_page_latency, 0)
    inputRestrict(@spi_settings_gui.lie_cmd_read, 0)
    inputRestrict(@spi_settings_gui.lie_cmd_write, 0)
    inputRestrict(@spi_settings_gui.lie_cmd_write_enable, 0)
    inputRestrict(@spi_settings_gui.lie_cmd_erase, 0)
    inputRestrict(@spi_settings_gui.lie_erase_time, 0)
    @chip_settings = Spi.find_by(spi_chip: chip.chip_id)
    @chip = chip
    feed_settings_form
  end

  def save_settings
    if @chip_settings.nil?
      create
    else
      @chip_settings = Spi.find_by(spi_chip: @chip.chip_id)
      update
    end
  end

  def feed_settings_form
    unless @chip_settings.nil?
      @spi_settings_gui.cbx_mode.setCurrentIndex(@spi_settings_gui.cbx_mode.findText(@chip_settings.spi_mode.to_s))
      @spi_settings_gui.cbx_frequency.setCurrentIndex(@spi_settings_gui.cbx_frequency.findText(@chip_settings.spi_frequency))
      @spi_settings_gui.lie_cmd_read.setText(@chip_settings.spi_command_read.to_s)
      @spi_settings_gui.lie_cmd_write.setText(@chip_settings.spi_command_write.to_s)
      @spi_settings_gui.lie_write_page_latency.setText(@chip_settings.spi_write_page_latency.to_s)
      @spi_settings_gui.lie_cmd_write_enable.setText(@chip_settings.spi_command_write_enable.to_s)
      @spi_settings_gui.lie_cmd_erase.setText(@chip_settings.spi_command_erase.to_s)
      @spi_settings_gui.lie_erase_time.setText(@chip_settings.spi_erase_time.to_s)
      @spi_settings_gui.lie_page_size.setText(@chip_settings.spi_page_size.to_s)
      @spi_settings_gui.lie_total_size.setText(@chip_settings.spi_total_size.to_s)
      unless @chip_settings.spi_is_flash.nil?
        if @chip_settings.spi_is_flash.zero?
          @spi_settings_gui.rbn_no.setChecked(true)
        else
          @spi_settings_gui.rbn_yes.setChecked(true)
        end
      end
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error while loading the form. Consult the log for more details').exec
  end

  def is_flash?
    if @spi_settings_gui.rbn_no.isChecked
      return 0
    else
      return 1
    end
  end

  def create
    @chip_settings = Spi.create(
      spi_mode: @spi_settings_gui.cbx_mode.currentText,
      spi_frequency: @spi_settings_gui.cbx_frequency.currentText,
      spi_write_page_latency: @spi_settings_gui.lie_write_page_latency.text,
      spi_command_read: @spi_settings_gui.lie_cmd_read.text,
      spi_command_write: @spi_settings_gui.lie_cmd_write.text,
      spi_command_write_enable: @spi_settings_gui.lie_cmd_write_enable.text,
      spi_command_erase: @spi_settings_gui.lie_cmd_erase.text,
      spi_erase_time: @spi_settings_gui.lie_erase_time.text,
      spi_is_flash: is_flash?,
      spi_page_size: @spi_settings_gui.lie_page_size.text,
      spi_total_size: @spi_settings_gui.lie_total_size.text,
      spi_chip: @chip.chip_id
    )
    Qt::MessageBox.new(Qt::MessageBox::Information, 'Succes', 'SPI parameters created successfully').exec
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when saving the SPI parameters. Consult the log for more details').exec
  end

  def update
    if @chip_settings.spi_mode != @spi_settings_gui.cbx_mode.currentText.to_i
      @chip_settings.update(spi_mode: @spi_settings_gui.cbx_mode.currentText.to_i)
    end
    if @chip_settings.spi_frequency != @spi_settings_gui.cbx_frequency.currentText
      @chip_settings.update(spi_frequency: @spi_settings_gui.cbx_frequency.currentText)
    end
    if @chip_settings.spi_write_page_latency != @spi_settings_gui.lie_write_page_latency.text
      @chip_settings.update(spi_write_page_latency: @spi_settings_gui.lie_write_page_latency.text)
    end
    if @chip_settings.spi_command_read != @spi_settings_gui.lie_cmd_read.text
      @chip_settings.update(spi_command_read: @spi_settings_gui.lie_cmd_read.text)
    end
    if @chip_settings.spi_command_write != @spi_settings_gui.lie_cmd_write.text
      @chip_settings.update(spi_command_write: @spi_settings_gui.lie_cmd_write.text)
    end
    if @chip_settings.spi_command_write_enable != @spi_settings_gui.lie_cmd_write_enable.text
      @chip_settings.update(spi_command_write_enable: @spi_settings_gui.lie_cmd_write_enable.text)
    end
    if @chip_settings.spi_command_erase != @spi_settings_gui.lie_cmd_erase.text
      @chip_settings.update(spi_command_erase: @spi_settings_gui.lie_cmd_erase.text)
    end
    if @chip_settings.spi_erase_time != @spi_settings_gui.lie_erase_time.text
      @chip_settings.update(spi_erase_time: @spi_settings_gui.lie_erase_time.text)
    end
    if @chip_settings.spi_page_size != @spi_settings_gui.lie_page_size.text
      @chip_settings.update(spi_page_size: @spi_settings_gui.lie_page_size.text)
    end
    if @chip_settings.spi_total_size != @spi_settings_gui.lie_total_size.text
      @chip_settings.update(spi_total_size: @spi_settings_gui.lie_total_size.text)
    end
    if @chip_settings.spi_is_flash != is_flash?
      @chip_settings.update(spi_is_flash: is_flash?)
    end
    Qt::MessageBox.new(Qt::MessageBox::Information, 'Succes', 'SPI parameters saved successfully').exec
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when saving the SPI parameters. Consult the log for more details').exec
  end
end
