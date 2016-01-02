#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../HardsploitAPI/HardsploitAPI'
require_relative '../../gui/gui_generic_import'

class Spi_import < Qt::Widget
  slots 'import()'
  slots 'select_import_file()'

  def initialize(api, chip)
    super()
    @spi_import_gui = Ui_Generic_import.new
    centerWindow(self)
    @spi_import_gui.setupUi(self)
    @spi_import_gui.lbl_chip.setText(chip.chip_reference)
    inputRestrict(@spi_import_gui.lie_start, 0)
    @api = api
    @chip_settings = Spi.find_by(spi_chip: chip.chip_id)
    @speeds = {
      '25.00' => 3,
      '18.75' => 4,
      '15.00' => 5,
      '12.50' => 6,
      '10.71' => 7,
      '9.38' => 8,
      '7.50' => 10,
      '5.00' => 15,
      '3.95' => 19,
      '3.00' => 25,
      '2.03' => 37,
      '1.00' => 75,
      '0.50' => 150,
      '0.29' => 255
    }
  end

  def select_import_file
    @filepath = Qt::FileDialog.getOpenFileName(self, tr('Select a file'), '/', tr('Bin file (*.bin)'))
    unless @filepath.nil?
      $file = File.open("#{@filepath}", 'w')
      @spi_import_gui.btn_import.setEnabled(true)
    end
  rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while openning the export file. Consult the logs for more details').exec
  end

  def close_file
    unless $file.nil?
      $file.close
    end
  rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while closing the export file. Consult the logs for more details').exec
  end

  def import
    return 0 if control_import_settings.zero?
    start = @spi_import_gui.lie_start.text.to_i
    Firmware.new(@api, 'SPI')
    time = Time.new
    @api.spi_Generic_Dump(@chip_settings.spi_mode, @speeds[@chip_settings.spi_frequency], @chip_settings.spi_command_read, @spi_import_gui.lie_start.text.to_i, @chip_settings.spi_total_size.to_i)
  rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while partial import operation. Consult the logs for more details').exec
  end

  def control_import_result(type, stop, pathfile, time)
    # TO COME
  end

  def control_import_settings
    file_size = File.size("#{@filepath}")
    if @chip_settings.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing SPI settings', 'No settings saved for this chip').exec
      return 0
    end
    if @chip_settings.spi_total_size.nil? || @chip_settings.spi_page_size.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing SPI settings', 'Total size or page size settings missing').exec
      return 0
    end
    if @chip_settings.spi_read_command.nil? || @chip_settings.spi_frequency.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing SPI settings', 'Read command or frequency settings missing').exec
      return 0
    end
    if @chip_settings.spi_mode.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing SPI setting', 'Mode setting missing').exec
      return 0
    end
    if @spi_import_gui.lie_start.text.empty?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing start address', 'Please fill the Start address field').exec
      return 0
    end
    if file_size > @chip_settings.spi_total_size
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Incorrect file size', 'The file size is superior to the chip capacity').exec
      return 0
    end
    if file_size > (@chip_settings.spi_total_size - @spi_import_gui.lie_start)
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Incorrect file size', 'Starting at this address, the file size is superior to the chip capacity').exec
      return 0
    end
    return 1
  end
end
