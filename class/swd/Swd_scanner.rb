#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_signal_scanner'
require_relative '../../HardsploitAPI/Modules/SWD/HardsploitAPI_SWD'

class Swd_scanner < Qt::Widget
  slots 'scan()'
  slots 'autowiring()'
  slots 'update_tbl(QString)'
  slots 'update_cbx(QString)'

  def initialize
    super()
    @view = Ui_Signal_scanner.new
    centerWindow(self)
    @view.setupUi(self)
    update_cbx('B0')
  end

  def scan
    @view.cbx_start.setEnabled(false)
    @view.cbx_stop.setEnabled(false)
    @view.btn_scan.setEnabled(false)
    update_tbl(@view.cbx_stop.currentText)
    Firmware.new('SWD')
    swd = HardsploitAPI_SWD.new(
    	memory_start_address: '0x08000000',
    	memory_size_address:  '0x1FFFF7E0',
    	cpu_id_address:		    '0xE000ED00',
    	device_id_address:	  '0x1FFFF7E8'
    )
    @result = swd.find(
      start_from: @view.cbx_start.currentText[1].to_i + 9,
      stop_to:    @view.cbx_stop.currentText[1].to_i + 9
    )
    unless @result[1].is_a? Array
      @view.tbl_result.setItem(@result.index(0), 1, Qt::TableWidgetItem.new('CLK'))
      @view.tbl_result.setItem(@result.index(1), 1, Qt::TableWidgetItem.new('IO'))
    end
    @view.cbx_start.setEnabled(true)
    @view.cbx_stop.setEnabled(true)
    @view.btn_scan.setEnabled(true)
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
    return false
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
    return false
  rescue HardsploitAPI::ERROR::SWD_ERROR
    return ErrorMsg.new.swd_error
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
    return false
  end

  def autowiring
    signal_found = false
    @view.tbl_result.rowCount.times do |i|
      if @view.tbl_result.item(i, 1).text == 'IO'
        signal_found = true
        current_signal = Signall.find_by(name: 'SWD_IO')
        current_signal.update(pin: @view.tbl_result.item(i, 0).text)
      elsif @view.tbl_result.item(i, 1).text == 'CLK'
        signal_found = true
        current_signal = Signall.find_by(name: 'SWD_CLK')
        current_signal.update(pin: @view.tbl_result.item(i, 0).text)
      else
        # Next row
      end
    end
    if signal_found
      Qt::MessageBox.new(
  			Qt::MessageBox::Information,
  			'Hardsploit Autowiring',
  			'Wiring saved. To change it, go to Menu > Signal mapper'
  		).exec
    else
      Qt::MessageBox.new(
  			Qt::MessageBox::Information,
  			'Hardsploit Autowiring',
  			'No signals found in the array'
  		).exec
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
    return false
  end

  def update_tbl(pin)
    unless @view.cbx_stop.count.zero?
      @view.tbl_result.setRowCount(0)
      nbr = pin[1].to_i - (@view.cbx_start.currentText[1].to_i) + 1
      nbr.times do |i|
        @view.tbl_result.insertRow(i)
        @view.tbl_result.setItem(i, 0, Qt::TableWidgetItem.new("B#{(i + @view.cbx_start.currentText[1].to_i)}"))
        @view.tbl_result.setItem(i, 1, Qt::TableWidgetItem.new('-'))
      end
      resize_to_content
    end
  end

  def resize_to_content
    @view.tbl_result.resizeColumnsToContents
    @view.tbl_result.resizeRowsToContents
    @view.tbl_result.horizontalHeader.stretchLastSection = true
  end

  def update_cbx(pin)
    @view.cbx_stop.clear
    start_at = pin[1].to_i
    end_at = 7
    (end_at - start_at).times do |i|
      @view.cbx_stop.addItem("B#{(i + start_at) + 1}")
    end
  end
end
