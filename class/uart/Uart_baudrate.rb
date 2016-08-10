#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_uart_baudrate'
require_relative '../../HardsploitAPI/Modules/UART/HardsploitAPI_UART'

class Uart_baudrate < Qt::Widget
  slots 'start_detect()'
  slots 'stop_detect()'
  slots 'copy()'

  def initialize(parent_view)
    super()
    Firmware.new('UART')
    @view = Ui_Uart_baudrate.new
    centerWindow(self)
    @view.setupUi(self)
    @parent_view = parent_view
  end

  def start_detect
    @view.btn_start.setEnabled(false)
    $app.processEvents
    @uart = HardsploitAPI_UART.new(
      baud_rate:        115200,
      word_width:       8,
      use_parity_bit:   0,
      parity_type:      0,
      nb_stop_bits:     1,
      idle_line_level:  1
    )
    @uart.enableMeasureBaudRate
    @view.btn_stop.setEnabled(true)
  end

  def stop_detect
    @view.btn_stop.setEnabled(false)
    @baudrate = @uart.measureBaudRate
    @uart.disableMeasureBaudRate
    @view.btn_start.setEnabled(true)
    unless @baudrate.zero?
      @view.lbl_baudrate.setText("Baud rate detected: #{@baudrate} Hz")
    else
      @view.lbl_baudrate.setText("Baud rate detected: None.")
    end
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
		ErrorMsg.new.hardsploit_not_found
  rescue HardsploitAPI::ERROR::USB_ERROR
	  ErrorMsg.new.usb_error
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def copy
    @parent_view.lie_baud_rate.setText(@baudrate.to_s)
    close
  end
end
