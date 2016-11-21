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
    @view = Ui_Parallel_settings.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    inputRestrict(@view.lie_total_size,     0)
    inputRestrict(@view.lie_write_latency,  0)
    inputRestrict(@view.lie_read_latency,   0)
    inputRestrict(@view.lie_page_size,      0)
    @chip = chip
    feed_settings_form unless @chip.parallel_setting.nil?
  end

  def save_settings
    @chip.parallel_setting.nil? ? create : update
    @chip.reload
  end

  def feed_settings_form
    @view.lie_read_latency.setText(@chip.parallel_setting.read_latency.to_s)
    @view.lie_write_latency.setText(@chip.parallel_setting.write_latency.to_s)
    @view.lie_page_size.setText(@chip.parallel_setting.page_size.to_s)
    @view.lie_total_size.setText(@chip.parallel_setting.total_size.to_s)
    @view.rbn_16b.setChecked(true) unless @chip.parallel_setting.word_size.zero?
  end

  def create
    @view.rbn_8b.isChecked ? word_size = 0 : word_size = 1
    chip_setting = ParallelSetting.create(
      total_size:     @view.lie_total_size.text,
      page_size:      @view.lie_page_size.text,
      word_size:      word_size,
      read_latency:   @view.lie_read_latency.text,
      write_latency:  @view.lie_write_latency.text,
      chip_id:        @chip.id
    )
    unless check_for_errors(chip_setting)
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Succes',
        'Parallel settings saved'
      ).exec
      close
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def update
    @view.rbn_8b.isChecked ? word_size = 0 : word_size = 1
    @chip.parallel_setting.update(
    total_size:     @view.lie_total_size.text,
    page_size:      @view.lie_page_size.text,
    word_size:      word_size,
    read_latency:   @view.lie_read_latency.text,
    write_latency:  @view.lie_write_latency.text
    )
    unless check_for_errors(@chip.parallel_setting)
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Succes',
        'Parallel settings updated'
      ).exec
      close
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end
end
