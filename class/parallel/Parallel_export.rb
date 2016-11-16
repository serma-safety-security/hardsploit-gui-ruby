#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_generic_export'
require_relative '../../hardsploit-api/HardsploitAPI/Modules/NO_MUX_PARALLEL_MEMORY/HardsploitAPI_NO_MUX_PARALLEL_MEMORY'

class Parallel_export < Qt::Widget
  slots 'export()'
  slots 'select_export_file()'

  def initialize(chip)
    super()
    @view = Ui_Generic_export.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    inputRestrict(@view.lie_start, 0)
    inputRestrict(@view.lie_stop, 0)
    @chip = chip
  end

  def select_export_file
    @filepath = Qt::FileDialog.getSaveFileName(self, tr('Select a file'), '/', tr('Bin file (*.bin)'))
    unless @filepath.nil?
      @view.btn_export.setEnabled(true)
      @view.btn_full_export.setEnabled(true)
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def export
    if sender.objectName == 'btn_full_export'
      return false unless control_export_settings('full')
      start = 0
      stop  = @chip.parallel_setting.total_size - 1
    else
      return false unless control_export_settings('partial')
      start = @view.lie_start.text.to_i
      stop  = @view.lie_stop.text.to_i
    end
    @chip.parallel_setting.word_size == 0 ? word_size = true : word_size = false
    Firmware.new('PARALLEL')
    parallel = HardsploitAPI_PARALLEL.new
    time = Time.new

    parallel.read_Memory_WithoutMultiplexing(
      path:                     @filepath,
      addressStart:             start,
      addressStop:              stop,
      bits8_or_bits16_DataSize: word_size,
      latency:                  @chip.parallel_setting.read_latency
    )

    control_export_result(stop, time)
    @view.btn_export.setEnabled(false)
    @view.btn_full_export.setEnabled(false)
    @filepath = nil
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def control_export_result(stop, time)
    time = Time.new - time
    file_size = File.size("#{@filepath}")
    # 8 bits test
    if @chip.parallel_setting.word_size.zero?
      if (stop - @view.lie_start.text.to_i + 1) == file_size
        Qt::MessageBox.new(
          Qt::MessageBox::Information,
          "Information",
          "Dump finished at #{((file_size / time)).round(2)}Bytes/s (#{(file_size)} Bytes in  #{time.round(4)} s)"
        ).exec
      else
        ErrorMsg.new.filesize_error
      end
    else
      if (stop - @view.lie_start.text.to_i + 1) == (file_size / 2)
        Qt::MessageBox.new(
          Qt::MessageBox::Information,
          "Information",
          "Dump finished at #{((file_size / time)).round(2)}Bytes/s (#{(file_size)} Bytes in  #{time.round(4)} s)"
        ).exec
      else
        ErrorMsg.new.filesize_error
      end
    end
    p "DUMP #{((file_size/time)).round(2)}Bytes/s (#{(file_size)}Bytes in  #{time.round(4)} s)"
  end

  def control_export_settings(type)
    return ErrorMsg.new.settings_missing  if @chip.parallel_setting.nil?
    return ErrorMsg.new.para_read_latency if @chip.parallel_setting.read_latency.nil?
    return ErrorMsg.new.para_word_size    if @chip.parallel_setting.word_size.nil?
    return ErrorMsg.new.full_size_error   if @chip.parallel_setting.total_size.nil?
    return ErrorMsg.new.full_size_error   if @chip.parallel_setting.total_size.zero?
    if type == 'partial'
      return ErrorMsg.new.start_stop_missing if @view.lie_start.text.empty?
      return ErrorMsg.new.start_stop_missing if @view.lie_stop.text.empty?
      start = @view.lie_start.text.to_i
      stop = @view.lie_stop.text.to_i
      total_size = @chip.parallel_setting.total_size
      return ErrorMsg.new.start_neq_stop    if start == stop
      return ErrorMsg.new.start_inf_to_stop if start > stop
      return ErrorMsg.new.inf_to_total_size if start > (total_size - 1)
      return ErrorMsg.new.inf_to_total_size if stop > (total_size - 1)
    end
    return true
  end
end
