#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../HardsploitAPI/HardsploitAPI'
require_relative '../../gui/gui_generic_import'

class Parallel_import < Qt::Widget
  slots 'import()'
  slots 'select_import_file()'

  def initialize(api, chip)
    super()
    @parallel_import_gui = Ui_Generic_import.new
    centerWindow(self)
    @parallel_import_gui.setupUi(self)
    @parallel_import_gui.lbl_chip.setText(chip.chip_reference)
    inputRestrict(@parallel_import_gui.lie_start, 0)
    @api = api
    @chip_settings = Parallel.find_by(parallel_chip: chip.chip_id)
  end

  def select_import_file
    @filepath = Qt::FileDialog.getOpenFileName(self, tr('Select a file'), '/', tr('Bin file (*.bin)'))
    unless @filepath.nil?
      $file = File.open("#{@filepath}", 'w')
      @parallel_import_gui.btn_import.setEnabled(true)
    end
  rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while openning the export file. Consult the logs for more details').exec
  end

  def close_file
    unless $file.nil?
      $file.close
    end
  rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while closing the export file. Consult the logs for more details').exec
  end

  def import
    return 0 if control_import_settings.zero?
    start = @parallel_import_gui.lie_start.text.to_i
    Firmware.new(@api, 'PARALLEL')
    time = Time.new
    # API COMMAND GOES HERE
  rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while partial import operation. Consult the logs for more details').exec
  end

  def control_import_settings
    file_size = File.size("#{@filepath}")
    if @chip_settings.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing parallel settings', 'No settings saved for this chip').exec
      return 0
    end
    if @chip_settings.parallel_total_size.nil? || @chip_settings.parallel_word_size.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing parallel settings', 'Total size or word size settings missing').exec
      return 0
    end
    if @chip_settings.parallel_page_size.nil? || @chip_settings.parallel_write_latency.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing parallel settings', 'Page size or write latency settings missing').exec
      return 0
    end
    if @parallel_import_gui.lie_start.text.empty?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Missing start address', 'Please fill the start address field').exec
      return 0
    end
    if file_size > @chip_settings.parallel_total_size
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Incorrect file size', 'The file size is superior to the chip capacity').exec
      return 0
    end
    if file_size > (@chip_settings.parallel_total_size - @parallel_import_gui.lie_start)
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Incorrect file size', 'Starting at this address, the file size is superior to the chip capacity').exec
      return 0
    end
    return 1
  end
end
