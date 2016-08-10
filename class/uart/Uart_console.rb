#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_uart_console'
require_relative '../../gui/gui_uart_settings'
require_relative '../../HardsploitAPI/Modules/UART/HardsploitAPI_UART'
class Uart_console < Qt::Widget
  slots 'send()'
  slots 'update()'
  slots 'connect()'
  slots 'disconnect()'
  slots 'clear_console()'
  slots 'open_settings()'

  def initialize(chip)
    super()
    Firmware.new('UART')
    @view = Ui_Uart_console.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    @chip = chip
    @data = ''
  end

  def closeEvent(event)
    @timer.killTimer(@timer.timerId) unless @timer.nil?
  end

  def keyPressEvent(event)
    send if event.key() == Qt::Key_Enter or event.key() == Qt::Key_Return
  end

  def connect
    @uart = HardsploitAPI_UART.new(
      baud_rate:        @chip.uart_setting.baud_rate,
      word_width:       @chip.uart_setting.word_size,
      use_parity_bit:   @chip.uart_setting.parity_bit,
      parity_type:      @chip.uart_setting.parity_type,
      nb_stop_bits:     @chip.uart_setting.stop_bits_nbr,
      idle_line_level:  @chip.uart_setting.idle_line
    )
    @timer = Qt::Timer.new
    Qt::Object.connect(@timer, SIGNAL('timeout()'), self, SLOT('update()'))
    @timer.start(100)
    @data << 'Listening and ready to go !' + 0x0d.chr
    @view.console.setPlainText(@data)
    scroll_down
    sender.setEnabled(false)
    @view.btn_disconnect.setEnabled(true)
  end

  def disconnect
    @timer.killTimer(@timer.timerId)
    @data << 'Disconnected' + 0x0d.chr
    @view.console.setPlainText(@data)
    scroll_down
    sender.setEnabled(false)
    @view.btn_connect.setEnabled(true)
  end

  def send
    return false if @uart.nil? or @timer.nil?
    return ErrorMsg.new.ascii_only unless @view.lie_cmd.text.ascii_only?
    packet = []
    @view.lie_cmd.text.each_byte do |x|
      packet.push x
    end
    packet.push 13 if @chip.uart_setting.return_type == 0
    packet.push 10 if @chip.uart_setting.return_type == 1
    if @chip.uart_setting.return_type == 2
      packet.push 13
      packet.push 10
    end
    @view.lie_cmd.clear
		@uart.write(payload: packet)
  #Rescue
  end

  def update
    received = @uart.sendAndReceived.collect{|i| i.chr}
    unless received.empty?
      @data << "#{received.join('')}"
      @view.console.setPlainText(@data)
    end
    scroll_down
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
		ErrorMsg.new.hardsploit_not_found
  rescue HardsploitAPI::ERROR::USB_ERROR
	  ErrorMsg.new.usb_error
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def clear_console
    @view.console.clear
    @data = ''
  end

  def open_settings
    settingsUART = Uart_settings.new(@chip)
    settingsUART.setWindowModality(Qt::ApplicationModal)
    settingsUART.show
  end

  def scroll_down
    sb = Qt::ScrollBar.new
    sb = @view.console.verticalScrollBar
    sb.setValue(sb.maximum())
  end
end
