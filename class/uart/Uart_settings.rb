#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_uart_settings'
class Uart_settings < Qt::Widget
  slots 'save_settings()'
  slots 'autodetect()'

  def initialize(chip)
    super()
    @view = Ui_Uart_settings.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    inputRestrict(@view.lie_baud_rate,     0)
    inputRestrict(@view.lie_idle_line_lvl, 0)
    inputRestrict(@view.lie_parity_bit,    0)
    inputRestrict(@view.lie_parity_type,   0)
    inputRestrict(@view.lie_stop_bits_nbr, 0)
    inputRestrict(@view.lie_word_size,     0)
    @chip = chip
    feed_settings_form unless chip.uart_setting.nil?
  end

  def save_settings
    @chip.uart_setting.nil? ? create : update
    @chip.reload
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def feed_settings_form
    @view.lie_baud_rate.setText(@chip.uart_setting.baud_rate.to_s)
    @view.lie_idle_line_lvl.setText(@chip.uart_setting.idle_line.to_s)
    @view.lie_parity_bit.setText(@chip.uart_setting.parity_bit.to_s)
    @view.lie_parity_type.setText(@chip.uart_setting.parity_type.to_s)
    @view.lie_stop_bits_nbr.setText(@chip.uart_setting.stop_bits_nbr.to_s)
    @view.lie_word_size.setText(@chip.uart_setting.word_size.to_s)
    @view.rbn_cr.setChecked(true) if @chip.uart_setting.return_type == 0
    @view.rbn_lf.setChecked(true) if @chip.uart_setting.return_type == 1
    @view.rbn_both.setChecked(true) if @chip.uart_setting.return_type == 2
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def create
    chip_settings = UartSetting.create(
      baud_rate:     @view.lie_baud_rate.text.to_i,
      idle_line:     @view.lie_idle_line_lvl.text.to_i,
      parity_bit:    @view.lie_parity_bit.text.to_i,
      parity_type:   @view.lie_parity_type.text.to_i,
      stop_bits_nbr: @view.lie_stop_bits_nbr.text.to_i,
      word_size:     @view.lie_word_size.text.to_i,
      return_type:   get_return_type,
      chip_id:       @chip.id
    )
    unless check_for_errors(chip_settings)
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Succes',
        'UART settings saved'
      ).exec
      close
    end
  end

  def update
    @chip.uart_setting.update(
      baud_rate:     @view.lie_baud_rate.text.to_i,
      idle_line:     @view.lie_idle_line_lvl.text.to_i,
      parity_bit:    @view.lie_parity_bit.text.to_i,
      parity_type:   @view.lie_parity_type.text.to_i,
      stop_bits_nbr: @view.lie_stop_bits_nbr.text.to_i,
      word_size:     @view.lie_word_size.text.to_i,
      return_type:   get_return_type
    )
    unless check_for_errors(@chip.uart_setting)
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Succes',
        'UART settings updated'
      ).exec
      close
    end
  end

  def get_return_type
    return 0 if @view.rbn_cr.isChecked
    return 1 if @view.rbn_lf.isChecked
    return 2 if @view.rbn_both.isChecked
  end

  def autodetect
    return ErrorMsg.new.hardsploit_not_found unless HardsploitAPI.getNumberOfBoardAvailable > 0
    baudUART = Uart_baudrate.new(@view)
    baudUART.setWindowModality(Qt::ApplicationModal)
    baudUART.show
  end
end
