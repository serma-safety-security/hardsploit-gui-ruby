#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../HardsploitAPI/HardsploitAPI'
require_relative '../../gui/gui_generic_export'

class Spi_export < Qt::Widget
  slots 'export()'
  slots 'select_export_file()'

  def initialize(api, chip)
    super()
    @spi_export_gui = Ui_Generic_export.new
    centerWindow(self)
    @spi_export_gui.setupUi(self)
    @spi_export_gui.lbl_chip.setText(chip.chip_reference)
    inputRestrict(@spi_export_gui.lie_start, 0)
    inputRestrict(@spi_export_gui.lie_stop, 0)
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

  def select_export_file
    @filepath = Qt::FileDialog.getSaveFileName(self, tr('Select a file'), '/', tr('Bin file (*.bin)'))
    unless @filepath.nil?
      $file = File.open("#{@filepath}", 'w')
      @spi_export_gui.btn_export.setEnabled(true)
      @spi_export_gui.btn_full_export.setEnabled(true)
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

  def export
    if sender.objectName == 'btn_full_export'
      return 0 if control_export_settings('full').zero?
    else
      return 0 if control_export_settings('partial').zero?
    end
    Firmware.new(@api, 'SPI')
    time = Time.new
    if sender.objectName == 'btn_full_export'
      @api.spi_Generic_Dump(@chip_settings.spi_mode, @speeds[@chip_settings.spi_frequency], @chip_settings.spi_command_read, 0, @chip_settings.spi_total_size - 1, @chip_settings.spi_total_size.to_i)
      close_file
      control_export_result('full', @chip_settings.spi_total_size - 1, time)
    else
      @api.spi_Generic_Dump(@chip_settings.spi_mode, @speeds[@chip_settings.spi_frequency], @chip_settings.spi_command_read, @spi_export_gui.lie_start.text.to_i, @spi_export_gui.lie_stop.text.to_i, @chip_settings.spi_total_size.to_i)
      close_file
      control_export_result('partial', @spi_export_gui.lie_stop.text.to_i, time)
    end
    @spi_export_gui.btn_export.setEnabled(false)
    @spi_export_gui.btn_full_export.setEnabled(false)
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while full export operation. Consult the logs for more details').exec
  end

  def control_export_result(type, stop, time)
    time = Time.new - time
    if type == 'partial'
      toCompare = ((stop - @spi_export_gui.lie_start.text.to_i) + 1)
    else
      toCompare = @chip_settings.spi_total_size
    end
    file_size = File.size(@filepath)
    if toCompare == file_size
      Qt::MessageBox.new(Qt::MessageBox::Information, 'Information', "Dump finished at #{((file_size / time)).round(2)}Bytes/s (#{(file_size)} Bytes in  #{time.round(4)} s)").exec
    else
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Error', 'Dump error: Size does not match').exec
    end
    p "DUMP #{((file_size / time)).round(2)}Bytes/s (#{(file_size)}Bytes in  #{time.round(4)} s)"
  end

  def control_export_settings(type)
    if @chip_settings.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing SPI settings', 'No settings saved for this chip').exec
      return 0
    end
    if @chip_settings.spi_command_read.nil? || @chip_settings.spi_frequency.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing SPI settings', 'Read command or frequency settings missing').exec
      return 0
    end
    if @chip_settings.spi_mode.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing SPI setting', 'Mode setting missing').exec
      return 0
    end
    if type == 'full'
      if @chip_settings.spi_total_size.zero? || @chip_settings.spi_total_size.nil?
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Empty field', 'Full size setting missing or equal 0').exec
        return 0
      end
    else
      if @spi_export_gui.lie_start.text.empty? || @spi_export_gui.lie_stop.text.empty?
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Empty field', 'Start and stop address must be filled').exec
        return 0
      end
      if @spi_export_gui.lie_start.text.to_i > @spi_export_gui.lie_stop.text.to_i
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Wrong value', 'Start address must be inforior to the stop address').exec
        return 0
      end
      if @spi_export_gui.lie_start.text.to_i > (@chip_settings.spi_total_size - 1) || @spi_export_gui.lie_stop.text.to_i > (@chip_settings.spi_total_size - 1)
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Wrong value', 'Start and stop address must be inforior to the chip total size').exec
        return 0
      end
    end
    return 1
  end
end
