#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_i2c_settings'
class I2c_settings < Qt::Widget
  slots 'save_settings()'
  slots 'bus_scan()'

  def initialize(chip)
    super()
    @view = Ui_I2c_settings.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    inputRestrict(@view.lie_total_size,         0)
    inputRestrict(@view.lie_page_size,          0)
    inputRestrict(@view.lie_write_page_latency, 0)
    inputRestrict(@view.lie_address_r,          3)
    inputRestrict(@view.lie_address_w,          3)
    @view.tbl_bus_scan.resizeColumnsToContents
    @view.tbl_bus_scan.resizeRowsToContents
    @view.tbl_bus_scan.horizontalHeader.stretchLastSection = true
    @chip = chip
    feed_settings_form unless @chip.i2c_setting.nil?
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def save_settings
    @chip.i2c_setting.nil? ? create : update
    @chip.reload
  end

  def feed_settings_form
    @view.lie_address_w.setText(@chip.i2c_setting.address_w)
    @view.lie_address_r.setText(@chip.i2c_setting.address_r)
    @view.cbx_frequency.setCurrentIndex(@view.cbx_frequency.findText(@chip.i2c_setting.frequency.to_s))
    @view.lie_write_page_latency.setText(@chip.i2c_setting.write_page_latency.to_s)
    @view.lie_page_size.setText(@chip.i2c_setting.page_size.to_s)
    @view.lie_total_size.setText(@chip.i2c_setting.total_size.to_s)
  end

  def create
    chip_setting = I2cSetting.create(
      address_w:          @view.lie_address_w.text,
      address_r:          @view.lie_address_r.text,
      frequency:          @view.cbx_frequency.currentText.to_i,
      write_page_latency: @view.lie_write_page_latency.text,
      page_size:          @view.lie_page_size.text,
      total_size:         @view.lie_total_size.text,
      chip_id:            @chip.id
    )
    unless check_for_errors(chip_setting)
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Succes',
        'I2C settings saved'
      ).exec
      close
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def update
    @chip.i2c_setting.update(
      address_w:          @view.lie_address_w.text,
      address_r:          @view.lie_address_r.text,
      frequency:          @view.cbx_frequency.currentText.to_i,
      write_page_latency: @view.lie_write_page_latency.text,
      page_size:          @view.lie_page_size.text,
      total_size:         @view.lie_total_size.text
    )
    unless check_for_errors(@chip.i2c_setting)
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Succes',
        'I2C settings updated'
      ).exec
      close
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def bus_scan
    return ErrorMsg.new.hardsploit_not_found unless HardsploitAPI.getNumberOfBoardAvailable > 0
    @view.tbl_bus_scan.setRowCount(0)
    Firmware.new('I2C')
    speed = 0
    if [40, 100, 400, 1000].include?(@chip.i2c_setting.frequency)
      speed = 0 if @chip.i2c_setting.frequency == 100
      speed = 1 if @chip.i2c_setting.frequency == 400
      speed = 2 if @chip.i2c_setting.frequency == 1000
      speed = 3 if @chip.i2c_setting.frequency == 40
    end
    i2c = HardsploitAPI_I2C.new(speed: speed)
    scan_result = i2c.i2c_Scan
    if scan_result.include?(1)
      scan_result.each_with_index do |v, i|
        if v == 1
          @view.tbl_bus_scan.insertRow(@view.tbl_bus_scan.rowCount)
          @view.tbl_bus_scan.setItem(
            @view.tbl_bus_scan.rowCount - 1,
            0,
            Qt::TableWidgetItem.new("0x#{i.to_s(16).upcase}")
          )
          if i % 2 == 0
            @view.tbl_bus_scan.setItem(
              @view.tbl_bus_scan.rowCount - 1,
              1,
              Qt::TableWidgetItem.new('Write')
            )
          else
            @view.tbl_bus_scan.setItem(
              @view.tbl_bus_scan.rowCount - 1,
              1,
              Qt::TableWidgetItem.new('Read')
            )
          end
        end
      end
      @view.tbl_bus_scan.resizeColumnsToContents
      @view.tbl_bus_scan.resizeRowsToContents
      @view.tbl_bus_scan.horizontalHeader.stretchLastSection = true
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        "Bus Scan",
        "Bus scan ended correctly: #{@view.tbl_bus_scan.rowCount} address(es) found"
      ).exec
    else
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        "Bus addresses",
        "No valid addresses have been returned by the scan"
      ).exec
    end
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end
end
