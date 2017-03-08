#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_generic_write'

class Parallel_write < Qt::Widget
  slots 'write()'
  slots 'select_write_file()'

  def initialize(chip)
    super()
    @view = Ui_Generic_write.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    inputRestrict(@view.lie_start, 0)
  end

  def select_write_file
    @filepath = Qt::FileDialog.getOpenFileName(self, tr('Select a file'), '/', tr('Bin file (*.bin)'))
    unless @filepath.nil?
      $file = File.open("#{@filepath}", 'w')
      @view.btn_write.setEnabled(true)
    end
  rescue Exception => msg
    ErrorMsg.new.unknow(msg)
  end

  def close_file
    unless $file.nil?
      $file.close
    end
  rescue Exception => msg
    ErrorMsg.new.unknow(msg)
  end

  def write
    return ErrorMsg.new.hardsploit_not_found unless HardsploitAPI.getNumberOfBoardAvailable > 0
    return 0 if control_write_settings.zero?
    start = @view.lie_start.text.to_i
    Firmware.new('PARALLEL')
    time = Time.new
    # API COMMAND GOES HERE
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
    return false
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
    return false
  rescue HardsploitAPI::ERROR::PARALLEL_ERROR
    ErrorMsg.new.swd_error
    return false
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
    return false
  end

  def control_write_settings
    file_size = File.size("#{@filepath}")
    if @chip.parallel_setting.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing parallel settings',
        'No settings saved for this chip'
      ).exec
      return 0
    end
    if @chip.parallel_setting.total_size.nil? || @chip.parallel_setting.word_size.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing parallel settings',
        'Total size or word size settings missing'
      ).exec
      return 0
    end
    if @chip.parallel_setting.page_size.nil? || @chip.parallel_setting.write_latency.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing parallel settings',
        'Page size or write latency settings missing'
      ).exec
      return 0
    end
    if @view.lie_start.text.empty?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing start address',
        'Please fill the start address field'
      ).exec
      return 0
    end
    if file_size > @chip.parallel_setting.total_size
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Incorrect file size',
        'The file size is superior to the chip capacity'
      ).exec
      return 0
    end
    if file_size > (@chip.parallel_setting.total_size - @view.lie_start)
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Incorrect file size',
        'Starting at this address, the file size is superior to the chip capacity'
      ).exec
      return 0
    end
    return 1
  end
end
