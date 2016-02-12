#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../HardsploitAPI/HardsploitAPI'
require_relative '../../gui/gui_i2c_settings'
class I2c_settings < Qt::Widget
  slots 'save_settings()'
  slots 'bus_scan()'

  def initialize(api, chip)
    super()
    @i2c_settings_gui = Ui_I2c_settings.new
    centerWindow(self)
    @i2c_settings_gui.setupUi(self)
    @i2c_settings_gui.lbl_chip.setText(chip.chip_reference)
    inputRestrict(@i2c_settings_gui.lie_total_size, 0)
    inputRestrict(@i2c_settings_gui.lie_page_size, 0)
    inputRestrict(@i2c_settings_gui.lie_write_page_latency, 0)
    inputRestrict(@i2c_settings_gui.lie_address_r, 3)
    inputRestrict(@i2c_settings_gui.lie_address_w, 3)
    @i2c_settings_gui.tbl_bus_scan.resizeColumnsToContents
    @i2c_settings_gui.tbl_bus_scan.resizeRowsToContents
    @i2c_settings_gui.tbl_bus_scan.horizontalHeader.stretchLastSection = true
    @chip_settings = I2C.find_by(i2c_chip: chip.chip_id)
    @chip = chip
    @api = api
    feed_settings_form
  end

  def save_settings
    if @chip_settings.nil?
      create
    else
      @chip_settings = I2C.find_by(i2c_chip: @chip.chip_id)
      update
    end
  end

  def feed_settings_form
    unless @chip_settings.nil?
      @i2c_settings_gui.lie_address_w.setText(@chip_settings.i2c_address_w)
      @i2c_settings_gui.lie_address_r.setText(@chip_settings.i2c_address_r)
      @i2c_settings_gui.cbx_frequency.setCurrentIndex(@i2c_settings_gui.cbx_frequency.findText(@chip_settings.i2c_frequency.to_s))
      @i2c_settings_gui.lie_write_page_latency.setText(@chip_settings.i2c_write_page_latency.to_s)
      @i2c_settings_gui.lie_page_size.setText(@chip_settings.i2c_page_size.to_s)
      @i2c_settings_gui.lie_total_size.setText(@chip_settings.i2c_total_size.to_s)
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error while loading the form. Consult the log for more details').exec
  end

  def create
    @chip_settings = I2C.create(
      i2c_address_w: @i2c_settings_gui.lie_address_w.text,
      i2c_address_r: @i2c_settings_gui.lie_address_r.text,
      i2c_frequency: @i2c_settings_gui.cbx_frequency.currentText,
      i2c_write_page_latency: @i2c_settings_gui.lie_write_page_latency.text,
      i2c_page_size: @i2c_settings_gui.lie_page_size.text,
      i2c_total_size: @i2c_settings_gui.lie_total_size.text,
      i2c_chip: @chip.chip_id
    )
    Qt::MessageBox.new(Qt::MessageBox::Information, 'Succes', 'I2C parameters created successfully').exec
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when creating the I2C parameters. Consult the log for more details').exec
  end

  def update
    if @chip_settings.i2c_address_w != @i2c_settings_gui.lie_address_w.text
      @chip_settings.update(i2c_address_w: @i2c_settings_gui.lie_address_w.text)
    end
    if @chip_settings.i2c_address_r != @i2c_settings_gui.lie_address_r.text
      @chip_settings.update(i2c_address_r: @i2c_settings_gui.lie_address_r.text)
    end
    if @chip_settings.i2c_frequency != @i2c_settings_gui.cbx_frequency.currentText.to_i
      @chip_settings.update(i2c_frequency: @i2c_settings_gui.cbx_frequency.currentText.to_i)
    end
    if @chip_settings.i2c_write_page_latency != @i2c_settings_gui.lie_write_page_latency.text
      @chip_settings.update(i2c_write_page_latency: @i2c_settings_gui.lie_write_page_latency.text)
    end
    if @chip_settings.i2c_page_size != @i2c_settings_gui.lie_page_size.text
      @chip_settings.update(i2c_page_size: @i2c_settings_gui.lie_page_size.text)
    end
    if @chip_settings.i2c_total_size != @i2c_settings_gui.lie_total_size.text
      @chip_settings.update(i2c_total_size: @i2c_settings_gui.lie_total_size.text)
    end
    Qt::MessageBox.new(Qt::MessageBox::Information, 'Succes', 'I2C parameters saved successfully').exec
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when saving the I2C parameters. Consult the log for more details').exec
  end

  def bus_scan
    @i2c_settings_gui.tbl_bus_scan.setRowCount(0)
    Firmware.new(@api, 'I2C')
    scan_result = @api.i2c_Scan(0)
    if scan_result.include?(1)
      scan_result.each_with_index do |v, i|
        if v == 1
          @i2c_settings_gui.tbl_bus_scan.insertRow(@i2c_settings_gui.tbl_bus_scan.rowCount)
          @i2c_settings_gui.tbl_bus_scan.setItem(@i2c_settings_gui.tbl_bus_scan.rowCount - 1, 0, Qt::TableWidgetItem.new(i.to_s(16).upcase))
          if i % 2 == 0
            @i2c_settings_gui.tbl_bus_scan.setItem(@i2c_settings_gui.tbl_bus_scan.rowCount - 1, 1, Qt::TableWidgetItem.new('Write'))
          else
            @i2c_settings_gui.tbl_bus_scan.setItem(@i2c_settings_gui.tbl_bus_scan.rowCount - 1, 1, Qt::TableWidgetItem.new('Read'))
          end
        end
      end
      @i2c_settings_gui.tbl_bus_scan.resizeColumnsToContents
      @i2c_settings_gui.tbl_bus_scan.resizeRowsToContents
      @i2c_settings_gui.tbl_bus_scan.horizontalHeader.stretchLastSection = true
      Qt::MessageBox.new(Qt::MessageBox::Information, "Bus Scan", "Bus scan ended correctly: #{@i2c_settings_gui.tbl_bus_scan.rowCount} address(es) found").exec
    else
      Qt::MessageBox.new(Qt::MessageBox::Information, "Bus addresses", "No valid addresses have been returned by the scan").exec
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured when scanning I2C. Consult the log for more details").exec
  end
end
