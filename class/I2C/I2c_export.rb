#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../HardsploitAPI/HardsploitAPI'
require_relative '../../gui/gui_generic_export'

class I2c_export < Qt::Widget
  slots 'export()'
  slots 'select_export_file()'

  def initialize(api, chip)
    super()
    @i2c_export_gui = Ui_Generic_export.new
    centerWindow(self)
    @i2c_export_gui.setupUi(self)
    @i2c_export_gui.lbl_chip.setText(chip.chip_reference)
    inputRestrict(@i2c_export_gui.lie_start, 0)
    inputRestrict(@i2c_export_gui.lie_stop, 0)
    @api = api
    @chip_settings = I2C.find_by(i2c_chip: chip.chip_id)
  end

  def select_export_file
    @filepath = Qt::FileDialog.getSaveFileName(self, tr('Select a file'), '/', tr('Bin file (*.bin)'))
    unless @filepath.nil?
      $file = File.open("#{@filepath}", 'w')
      @i2c_export_gui.btn_export.setEnabled(true)
      @i2c_export_gui.btn_full_export.setEnabled(true)
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
    Firmware.new(@api, 'I2C')
    $pgb = Progress_bar.new("I²C: Exporting...")
    $pgb.show
    if sender.objectName == 'btn_full_export'
      @api.i2c_Generic_Dump(@chip_settings.i2c_frequency, @chip_settings.i2c_address_w.to_i(16), 0, @chip_settings.i2c_total_size - 1, @chip_settings.i2c_total_size)
      close_file
      control_export_result('full', @chip_settings.i2c_total_size - 1)
    else
      @api.i2c_Generic_Dump(@chip_settings.i2c_frequency, @chip_settings.i2c_address_w.to_i(16), @i2c_export_gui.lie_start.text.to_i, @i2c_export_gui.lie_stop.text.to_i, @chip_settings.i2c_total_size)
      close_file
      control_export_result('partial', @i2c_export_gui.lie_stop.text.to_i)
    end
    @i2c_export_gui.btn_export.setEnabled(false)
    @i2c_export_gui.btn_full_export.setEnabled(false)
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while full export operation. Consult the logs for more details').exec
  end

  def control_export_result(type, stop)
    if type == 'partial'
      toCompare = ((stop - @i2c_export_gui.lie_start.text.to_i) + 1)
    else
      toCompare = @chip_settings.i2c_total_size
    end
    file_size = File.size(@filepath)
    if toCompare != file_size
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Error', 'Dump error: Size does not match').exec
    end
  end

  def control_export_settings(type)
    if @chip_settings.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing I2C settings', 'No settings saved for this chip').exec
      return 0
    end
    if @chip_settings.i2c_frequency.nil? || @chip_settings.i2c_address_w.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing I2C settings', 'Write base address or frequency settings missing').exec
      return 0
    end
    if type == 'full'
      if @chip_settings.i2c_total_size.zero? || @chip_settings.i2c_total_size.nil?
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Empty field', 'Full size setting missing or equal 0').exec
        return 0
      end
    else
      if @i2c_export_gui.lie_start.text.empty? || @i2c_export_gui.lie_stop.text.empty?
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Empty field', 'Start and stop address must be filled').exec
        return 0
      end
      if @i2c_export_gui.lie_start.text.to_i > @i2c_export_gui.lie_stop.text.to_i
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Wrong value', 'Start address must be inforior to the stop address').exec
        return 0
      end
      if @i2c_export_gui.lie_start.text.to_i > (@chip_settings.i2c_total_size - 1) || @i2c_export_gui.lie_stop.text.to_i > (@chip_settings.i2c_total_size - 1)
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Wrong value', 'Start and stop address must be inforior to the chip total size').exec
        return 0
      end
    end
    return 1
  end
end
