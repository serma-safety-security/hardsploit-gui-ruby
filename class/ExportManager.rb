#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require "csv"
class ExportManager < Qt::Widget
  slots 'saveResult()'

  def initialize(bus, result, spiDataSended=[])
    super()
    @em = Ui_ExportManager.new
    centerWindow(self)
    @em.setupUi(self)
    @bus = bus
    @result = result
    @em.tbl_resultI2C.hide
    @em.tbl_resultSPI.hide
    # Check the bus type to adapt the table column
    if bus == "spi"
      @em.tbl_resultSPI.show
      @em.cbx_export.hide
      @em.tbl_resultSPI.setRowCount(result.size)
      (0..result.length-1).each do |i|
          @em.tbl_resultSPI.setItem(i, 0, Qt::TableWidgetItem.new(spiDataSended[i].to_s))
          @em.tbl_resultSPI.setItem(i, 1, Qt::TableWidgetItem.new(result[i].to_s))
      end
      @em.tbl_resultSPI.resizeColumnsToContents
      @em.tbl_resultSPI.resizeRowsToContents
      @em.tbl_resultSPI.horizontalHeader.stretchLastSection = true
    else
      @em.tbl_resultI2C.show
      @em.tbl_resultI2C.setRowCount(result.size/2)
      (0..result.length-1).step(2).each_with_index do |i, v|
        case result[i]
        when 0
          @em.tbl_resultI2C.setItem(v, 0, Qt::TableWidgetItem.new("Write"))
          @em.tbl_resultI2C.setItem(v, 1, Qt::TableWidgetItem.new("ACK"))
          @em.tbl_resultI2C.setItem(v, 2, Qt::TableWidgetItem.new(result[i+1].to_s))
        when 1
          @em.tbl_resultI2C.setItem(v, 0, Qt::TableWidgetItem.new("Read"))
          @em.tbl_resultI2C.setItem(v, 1, Qt::TableWidgetItem.new("ACK"))
          @em.tbl_resultI2C.setItem(v, 2, Qt::TableWidgetItem.new(result[i+1].to_s))
        when 2
          @em.tbl_resultI2C.setItem(v, 0, Qt::TableWidgetItem.new("Write"))
          @em.tbl_resultI2C.setItem(v, 1, Qt::TableWidgetItem.new("NACK"))
          @em.tbl_resultI2C.setItem(v, 2, Qt::TableWidgetItem.new(result[i+1].to_s))
        else
          @em.tbl_resultI2C.setItem(v, 0, Qt::TableWidgetItem.new("Write"))
          @em.tbl_resultI2C.setItem(v, 1, Qt::TableWidgetItem.new("NACK"))
          @em.tbl_resultI2C.setItem(v, 2, Qt::TableWidgetItem.new(result[i+1].to_s))
        end
      end
      @em.tbl_resultI2C.resizeColumnsToContents
      @em.tbl_resultI2C.resizeRowsToContents
      @em.tbl_resultI2C.horizontalHeader.stretchLastSection = true
    end
  end

  def saveResult
    if @bus == "i2c"
      if @em.cbx_export.currentIndex == 0
        resultFile = Qt::FileDialog.getSaveFileName(self, tr("Select a file"), "/", tr("Csv file (*.csv)"))
        if !resultFile.nil?
          CSV.open("#{resultFile}.csv", "wb", {:col_sep => ";"}) do |csv|
            csv << ["R/W", "(N)ACK", "DATA"]
            for i in 0..(@em.tbl_resultI2C.rowCount)-1 do
              csv << [@em.tbl_resultI2C.item(i, 0).text, @em.tbl_resultI2C.item(i, 1).text, @em.tbl_resultI2C.item(i,2).text]
            end
          end
        end
      else
        resultFile = Qt::FileDialog.getSaveFileName(self, tr("Select a file"), "/", tr("Bin file (*.bin)"))
        if !resultFile.nil?
          file = File.open("#{resultFile}", 'w')
          result = Array.new
          for i in 0..(@em.tbl_resultI2C.rowCount)-1 do
            if @em.tbl_resultI2C.item(i,0).text == "Read" && @em.tbl_resultI2C.item(i,1).text == "ACK"
              result.push(@em.tbl_resultI2C.item(i,2).text.to_i)
            end
          end
          file.write(result.pack('C*'))
          file.close
        end
      end
    # DUMP FILE SPI
    else
        resultFile = Qt::FileDialog.getSaveFileName(self, tr("Select a file"), "/", tr("Bin file (*.bin)"))
        if !resultFile.nil?
          file = File.open("#{resultFile}", 'w')
          result = Array.new
          for i in 0..(@em.tbl_resultSPI.rowCount)-1 do
            result.push(@em.tbl_resultSPI.item(i,1).text.to_i)
          end
          file.write(result.pack('C*'))
          file.close
        end
    end
    rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while file selection. Consult the logs for more details").exec
  end
end