#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_parallel_settings'
class Parallel_settings < Qt::Widget
  slots 'save_settings()'

  def initialize(chip)
    super()
    @parallel_settings_gui = Ui_Parallel_settings.new
    centerWindow(self)
    @parallel_settings_gui.setupUi(self)
    @parallel_settings_gui.lbl_chip.setText(chip.chip_reference)
    inputRestrict(@parallel_settings_gui.lie_total_size, 0)
    inputRestrict(@parallel_settings_gui.lie_write_latency, 0)
    inputRestrict(@parallel_settings_gui.lie_read_latency, 0)
    inputRestrict(@parallel_settings_gui.lie_page_size, 0)
    @chip_settings = Parallel.find_by(parallel_chip: chip.chip_id)
    @chip = chip
    feed_settings_form
  end

  def save_settings
    if @chip_settings.nil?
      create
    else
      @chip_settings = Parallel.find_by(parallel_chip: @chip.chip_id)
      update
    end
  end

  def feed_settings_form
    unless @chip_settings.nil?
      @parallel_settings_gui.lie_read_latency.setText(@chip_settings.parallel_read_latency.to_s)
      @parallel_settings_gui.lie_write_latency.setText(@chip_settings.parallel_write_latency.to_s)
      @parallel_settings_gui.lie_page_size.setText(@chip_settings.parallel_page_size.to_s)
      @parallel_settings_gui.lie_total_size.setText(@chip_settings.parallel_total_size.to_s)
      if @chip_settings.parallel_word_size.zero?
        @parallel_settings_gui.rbn_8b.setChecked(true)
      else
        @parallel_settings_gui.rbn_16b.setChecked(true)
      end
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error while loading the form. Consult the log for more details').exec
  end

  def create
    if @parallel_settings_gui.rbn_8b.isChecked
      word_size = 0
    else
      word_size = 1
    end
    @chip_settings = Parallel.create(
      parallel_word_size: word_size,
      parallel_write_latency: @parallel_settings_gui.lie_write_latency,
      parallel_read_latency: @parallel_settings_gui.lie_read_latency.text,
      parallel_page_size: @parallel_settings_gui.lie_page_size.text,
      parallel_total_size: @parallel_settings_gui.lie_total_size.text,
      parallel_chip: @chip.chip_id
    )
    Qt::MessageBox.new(Qt::MessageBox::Information, 'Succes', 'Parallel parameters created successfully').exec
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when saving the parallel parameters. Consult the log for more details').exec
  end

  def update
    if @parallel_settings_gui.rbn_8b.isChecked
      word_size = 0
    else
      word_size = 1
    end
    if @chip_settings.parallel_page_size != @parallel_settings_gui.lie_page_size
      @chip_settings.update(parallel_page_size: @parallel_settings_gui.lie_page_size.text)
    end
    if @chip_settings.parallel_total_size != @parallel_settings_gui.lie_total_size
      @chip_settings.update(parallel_total_size: @parallel_settings_gui.lie_total_size.text)
    end
    if @chip_settings.parallel_read_latency != @parallel_settings_gui.lie_read_latency
      @chip_settings.update(parallel_read_latency: @parallel_settings_gui.lie_read_latency.text)
    end
    if @chip_settings.parallel_write_latency != @parallel_settings_gui.lie_write_latency
      @chip_settings.update(parallel_write_latency: @parallel_settings_gui.lie_write_latency.text)
    end
    if @chip_settings.parallel_word_size != word_size
      @chip_settings.update(parallel_word_size: word_size)
    end
    Qt::MessageBox.new(Qt::MessageBox::Information, 'Succes', 'Parallel parameters saved successfully').exec
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when saving the parallel parameters. Consult the log for more details').exec
  end
end
