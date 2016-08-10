#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../gui/gui_progress_bar'
class Progress_bar < Qt::Widget

  def initialize(status)
    super()
    @pgb_ui = Ui_Progress_bar.new
    centerWindow(self)
    @pgb_ui.setupUi(self)
    self.update_status(status)
    @pgb_ui.lbl_close.setEnabled(false)
    self.display_time("Total duration:")
  end

  def update_status(status)
    @pgb_ui.lbl_status.setText(status)
  end

  def update_value(value)
    @pgb_ui.pgb.setValue(value) if value <= 100 && value >= 0
  end

  def display_time(time)
    @pgb_ui.lbl_time.setText(time)
  end
end
