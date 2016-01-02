#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../HardsploitAPI/HardsploitAPI'
require_relative '../../gui/gui_generic_export'

class Parallel_export < Qt::Widget
  slots 'export()'
  slots 'select_export_file()'

  def initialize(api, chip)
    super()
    @parallel_export_gui = Ui_Generic_export.new
    centerWindow(self)
    @parallel_export_gui.setupUi(self)
    @parallel_export_gui.lbl_chip.setText(chip.chip_reference)
    inputRestrict(@parallel_export_gui.lie_start, 0)
    inputRestrict(@parallel_export_gui.lie_stop, 0)
    @api = api
    @chip_settings = Parallel.find_by(parallel_chip: chip.chip_id)
  end

  def select_export_file
    @filepath = Qt::FileDialog.getSaveFileName(self, tr('Select a file'), '/', tr('Bin file (*.bin)'))
    unless @filepath.nil?
      $file = File.open("#{@filepath}", 'w')
      @parallel_export_gui.btn_export.setEnabled(true)
      @parallel_export_gui.btn_full_export.setEnabled(true)
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
    Firmware.new(@api, 'PARALLEL')
    time = Time.new
    if sender.objectName == 'btn_full_export'
      if @chip_settings.parallel_word_size.zero?
        check_SendAndReceivedData(@api.read_Memory_WithoutMultiplexing(0, @chip_settings.parallel_total_size - 1, true, @chip_settings.parallel_read_latency))
      else
        check_SendAndReceivedData(@api.read_Memory_WithoutMultiplexing(0, @chip_settings.parallel_total_size - 1, false, @chip_settings.parallel_read_latency))
      end
      close_file
      control_export_result(@chip_settings.parallel_total_size - 1, time)
    else
      if @chip_settings.parallel_word_size.zero?
        check_SendAndReceivedData(@api.read_Memory_WithoutMultiplexing(@parallel_export_gui.lie_start.text.to_i, @parallel_export_gui.lie_stop.text.to_i, true, @chip_settings.parallel_read_latency))
      else
        check_SendAndReceivedData(@api.read_Memory_WithoutMultiplexing(@parallel_export_gui.lie_start.text.to_i, @parallel_export_gui.lie_stop.text.to_i, true, @chip_settings.parallel_read_latency))
      end
      close_file
      control_export_result(@parallel_export_gui.lie_stop.text.to_i, time)
    end
    @parallel_export_gui.btn_export.setEnabled(false)
    @parallel_export_gui.btn_full_export.setEnabled(false)
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while full export operation. Consult the logs for more details').exec
  end

  def control_export_result(stop, time)
    time = Time.new - time
    file_size = File.size("#{@filepath}")
    # 8 bits test
    if @chip_settings.parallel_word_size.zero?
      if (stop - @cw.lie_start.text.to_i + 1) == file_size
        Qt::MessageBox.new(Qt::MessageBox::Information, "Information", "Dump finished at #{((file_size / time)).round(2)}Bytes/s (#{(file_size)} Bytes in  #{time.round(4)} s)").exec
      else
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Dump error: Size does not match").exec
      end
    else
      if (stop - @cw.lie_start.text.to_i + 1) == (file_size / 2)
        Qt::MessageBox.new(Qt::MessageBox::Information, "Information", "Dump finished at #{((file_size / time)).round(2)}Bytes/s (#{(file_size)} Bytes in  #{time.round(4)} s)").exec
      else
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Dump error: File size and dump size does not match").exec
      end
    end
    p "DUMP #{((file_size/time)).round(2)}Bytes/s (#{(file_size)}Bytes in  #{time.round(4)} s)"
  end

  def control_export_settings(type)
    if @chip_settings.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing parallel settings', 'No settings saved for this chip').exec
      return 0
    end
    if @chip_settings.parallel_read_latency.nil? || @chip_settings.parallel_word_size.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing parallel settings', 'Read latency or word size settings missing').exec
      return 0
    end
    if type == 'full'
      if @chip_settings.parallel_total_size.zero? || @chip_settings.parallel_total_size.nil?
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Empty field', 'Full size setting missing or equal 0').exec
        return 0
      end
    else
      if @parallel_export_gui.lie_start.text.empty? || @parallel_export_gui.lie_stop.text.empty?
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Empty field', 'Start and stop address must be filled').exec
        return 0
      end
      if @parallel_export_gui.lie_start.text.to_i > @parallel_export_gui.lie_stop.text.to_i
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Wrong value', 'Start address must be inforior to the stop address').exec
        return 0
      end
      if @parallel_export_gui.lie_start.text.to_i > (@chip_settings.parallel_total_size - 1) || @parallel_export_gui.lie_stop.text.to_i > (@chip_settings.parallel_total_size - 1)
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Wrong value', 'Start and stop address must be inforior to the chip total size').exec
        return 0
      end
    end
    return 1
  end

  def check_SendAndReceivedData(value)
    case value
      when HardsploitAPI::USB_STATE::PACKET_IS_TOO_LARGE
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "PACKET_IS_TOO_LARGE max: #{HardsploitAPI::USB::USB_TRAME_SIZE}").exec
      when HardsploitAPI::USB_STATE::ERROR_SEND
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "ERROR_SEND").exec
      when HardsploitAPI::USB_STATE::BUSY
        Qt::MessageBox.new(Qt::MessageBox::Warning, "BUSY", "Device busy").exec
      else
        return value
    end
  end
end
