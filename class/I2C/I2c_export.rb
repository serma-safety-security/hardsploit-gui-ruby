#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_generic_export'
require_relative '../../HardsploitAPI/Modules/I2C/HardsploitAPI_I2C'
class I2c_export < Qt::Widget
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
    @filepath = Qt::FileDialog.getSaveFileName(self, tr('Select a file'), '/', tr('*.*'))
    unless @filepath.nil?
      @view.btn_export.setEnabled(true)
      @view.btn_full_export.setEnabled(true)
      @view.lbl_selected_file.setText("#{@filepath.split("/").last}")
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def export
    $file = File.open("#{@filepath}", 'w') unless @filepath.nil?
    if sender.objectName == 'btn_full_export'
      return false unless control_export_settings('full')
      start   = 0
      stop    = @chip.i2c_setting.total_size - 1
      control = @chip.i2c_setting.total_size
    else
      return false unless control_export_settings('partial')
      start   =  @view.lie_start.text.to_i
      stop    =  @view.lie_stop.text.to_i
      control = (stop - start) + 1
    end
    Firmware.new('I2C')
    $pgb = Progress_bar.new("I²C: Exporting...")
    $pgb.show

    if [40, 100, 400, 1000].include?(@chip.i2c_setting.frequency)
      speed = 0 if @chip.i2c_setting.frequency == 100
      speed = 1 if @chip.i2c_setting.frequency == 400
      speed = 2 if @chip.i2c_setting.frequency == 1000
      speed = 3 if @chip.i2c_setting.frequency == 40
      i2c = HardsploitAPI_I2C.new(speed: speed)
      i2c.i2c_Generic_Dump(
        i2cBaseAddress: @chip.i2c_setting.address_w.to_i(16),
        startAddress:   start,
        stopAddress:    stop,
        sizeMax:        @chip.i2c_setting.total_size
      )
    end
    $file.close unless $file.nil?
    ErrorMsg.new.filesize_error unless control == File.size(@filepath)
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def control_export_settings(type)
    return ErrorMsg.new.settings_missing   if @chip.i2c_setting.nil?
    return ErrorMsg.new.frequency_missing  if @chip.i2c_setting.frequency.nil?
    return ErrorMsg.new.mode_missing       if @chip.i2c_setting.address_w.nil?
    return ErrorMsg.new.full_size_error    if @chip.i2c_setting.total_size.nil?
    return ErrorMsg.new.full_size_error    if @chip.i2c_setting.total_size.zero?
    if type == 'partial'
      return ErrorMsg.new.start_stop_missing if @view.lie_start.text.empty?
      return ErrorMsg.new.start_stop_missing if @view.lie_stop.text.empty?
      start = @view.lie_start.text.to_i
      stop = @view.lie_stop.text.to_i
      total_size = @chip.i2c_setting.total_size
      return ErrorMsg.new.start_neq_stop    if start == stop
      return ErrorMsg.new.start_inf_to_stop if start > stop
      return ErrorMsg.new.inf_to_total_size if start > (total_size - 1)
      return ErrorMsg.new.inf_to_total_size if stop > (total_size - 1)
    end
    return true
  end
end
