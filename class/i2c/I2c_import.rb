#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_generic_import'
require_relative '../../hardsploit-api/HardsploitAPI/Modules/I2C/HardsploitAPI_I2C'
class I2c_import < Qt::Widget
  slots 'import()'
  slots 'select_import_file()'

  def initialize(chip)
    super()
    @view = Ui_Generic_import.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    inputRestrict(@view.lie_start, 0)
    @chip = chip
  end

  def select_import_file
    @filepath = Qt::FileDialog.getOpenFileName(self, tr('Select a file'), '/', tr('*.*'))
    unless @filepath.nil?
      @view.btn_import.setEnabled(true)
      @view.lbl_selected_file.setText("#{@filepath.split("/").last}")
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def import
    return 0 if control_import_settings.zero?
    Firmware.new('I2C')
    $pgb = Progress_bar.new("I²C: Exporting...")
    $pgb.show
    if [40, 100, 400, 1000].include?(@chip.i2c_setting.frequency)
      speed = 0 if @chip.i2c_setting.frequency == 100
      speed = 1 if @chip.i2c_setting.frequency == 400
      speed = 2 if @chip.i2c_setting.frequency == 1000
      speed = 3 if @chip.i2c_setting.frequency == 40
      i2c = HardsploitAPI_I2C.new(speed: speed)
      i2c.i2c_Generic_Import(
        i2cBaseAddress:   @chip.i2c_setting.address_w.to_i(16),
        startAddress:     @view.lie_start.text.to_i,
        pageSize:         @chip.i2c_setting.page_size,
        memorySize:       @chip.i2c_setting.total_size,
        dataFile:         @filepath,
        writePageLatency: @chip.i2c_setting.write_page_latency / 1000.0
      )
    end
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
  rescue HardsploitAPI::ERROR::I2CWrongSpeed
    ErrorMsg.new.i2c_error
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def control_import_settings
    if @chip.i2c_setting.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing I2C setting',
        'No settings saved for this chip'
      ).exec
      return 0
    end
    if @chip.i2c_setting.total_size.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing I2C setting',
        'Total size setting missing'
      ).exec
      return 0
    end
    if @chip.i2c_setting.page_size.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing I2C setting',
        'Page size setting missing'
      ).exec
      return 0
    end
    if @chip.i2c_setting.write_page_latency.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing I2C setting',
        'Write page latency setting missing'
      ).exec
      return 0
    end
    if @chip.i2c_setting.frequency.nil? || @chip.i2c_setting.address_w.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing I2C setting',
        'Write base address or frequency settings missing'
      ).exec
      return 0
    end
    if @view.lie_start.text.empty?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing start address',
        'Please fill the Start address field'
      ).exec
      return 0
    end
    return 1
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end
end
