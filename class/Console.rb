#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================
require 'date'
require_relative '../gui/gui_command_editor'
class Console < Qt::TableWidget

  def initialize(console)
    super()
    @console = console
  end

  def print(msg)
    @console.insertRow(@console.rowCount)
    time = Qt::TableWidgetItem.new("#{Time.now.strftime("%d/%m %H:%M")}")
    time.setFlags(Qt::ItemIsEnabled)
    msg = Qt::TableWidgetItem.new(msg)
    msg.setFlags(Qt::ItemIsEnabled)
    @console.setItem(@console.rowCount - 1, 0, time)
    @console.setItem(@console.rowCount - 1, 1, msg)
    @console.scrollToItem(time, Qt::AbstractItemView::EnsureVisible)
  end
end
