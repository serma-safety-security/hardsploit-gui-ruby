#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  Updated by Konstantinos Xynos (2017)
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_spi_sniffer'
require_relative '../../hardsploit-api/HardsploitAPI/Modules/SPI_SNIFFER/HardsploitAPI_SPI_SNIFFER'

class Spi_sniffer < Qt::Widget
  slots 'start()'
  slots 'stop()'
  slots 'update()'

  def initialize(chip)
    super()
    @view = Ui_Spi_sniffer.new
    centerWindow(self)
    @view.setupUi(self)
    @chip = chip
    resize_to_content
  end

  def start
    return ErrorMsg.new.hardsploit_not_found unless HardsploitAPI.getNumberOfBoardAvailable > 0
    @view.btn_stop.setEnabled(true)
    @view.btn_start.setEnabled(false)
    @view.cbx_type.setEnabled(false)
    Firmware.new('SPI_SNIFFER')
    case @view.cbx_type.currentIndex
    when 0; type = HardsploitAPI::SPISniffer::MISO_MOSI
    when 1; type = HardsploitAPI::SPISniffer::MOSI
    when 2; type = HardsploitAPI::SPISniffer::MISO
    end
    return ErrorMsg.new.spi_mode_missing if @chip.spi_setting.mode.nil?
    @spi = HardsploitAPI_SPI_SNIFFER.new(
      mode: @chip.spi_setting.mode,
      sniff: type
    )
    @spi.spi_SetSettings
    sleep(0.5)
    @timer = Qt::Timer.new
    Qt::Object.connect(@timer, SIGNAL('timeout()'), self, SLOT('update()'))
    @timer.start(1000)
  end

  def add_ascii_when_in_range(i, cell_id, elem=0)
    if elem.between?(32, 126)
      @view.tbl_result.setItem(i, cell_id, Qt::TableWidgetItem.new("0x#{elem.to_s(16).rjust(2, "0").upcase}(#{elem.chr})"))
    elsif 
      @view.tbl_result.setItem(i, cell_id, Qt::TableWidgetItem.new("0x#{elem.to_s(16).rjust(2, "0").upcase}"))
    end 
  end

  def update
    result = @spi.spi_receive_available_data
    unless result.empty?
      if @spi.sniff == HardsploitAPI::SPISniffer::MISO_MOSI
        result[0].each_with_index do |elem, i|
          @view.tbl_result.insertRow(i)
          @view.tbl_result.setItem(i, 0, Qt::TableWidgetItem.new(i.next.to_s))
	  add_ascii_when_in_range(i, 1, elem)
          add_ascii_when_in_range(i, 2, result[1][i])
        end
      else # MOSI OR MISO
        if @spi.sniff == HardsploitAPI::SPISniffer::MISO
          result.each_with_index do |elem, i|
            @view.tbl_result.insertRow(i)
            @view.tbl_result.setItem(i, 0, Qt::TableWidgetItem.new(@view.tbl_result.rowCount.next.to_s))          
            @view.tbl_result.setItem(i, 1, Qt::TableWidgetItem.new('-'))
            add_ascii_when_in_range(i, 2, elem)
	  end
        else
          result.each_with_index do |elem, i|
            @view.tbl_result.insertRow(i)
            @view.tbl_result.setItem(i, 0, Qt::TableWidgetItem.new(@view.tbl_result.rowCount.next.to_s))
            add_ascii_when_in_range(i, 1, elem)
            @view.tbl_result.setItem(i, 2, Qt::TableWidgetItem.new('-'))
  	  end
        end
        resize_to_content
      end
    end
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
		ErrorMsg.new.hardsploit_not_found
  rescue HardsploitAPI::ERROR::USB_ERROR
	  p "Checking..."
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def stop
    @view.btn_start.setEnabled(true)
    @view.cbx_type.setEnabled(true)
    @view.btn_stop.setEnabled(false)
    @timer.killTimer(@timer.timerId)
    @timer = nil
  end

  def closeEvent(event)
    @timer.killTimer(@timer.timerId) unless @timer.nil?
  end

  def resize_to_content
    @view.tbl_result.resizeColumnsToContents
    @view.tbl_result.resizeRowsToContents
    @view.tbl_result.horizontalHeader.stretchLastSection = true
  end
end
