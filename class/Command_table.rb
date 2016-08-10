#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class Command_table < Qt::Widget

  def initialize(cmd_table, bus)
    super()
    @cmd_table = cmd_table
    @bus = bus
    cmd_table.insertColumn(0)
    cmd_table.setHorizontalHeaderItem(0, Qt::TableWidgetItem.new('Order'))
    cmd_table.insertColumn(1)
    cmd_table.setHorizontalHeaderItem(1, Qt::TableWidgetItem.new('Byte (Hexa)'))
    cmd_table.insertColumn(2)
    cmd_table.setHorizontalHeaderItem(2, Qt::TableWidgetItem.new('Description'))
  end

  def build_spi
    @cmd_table.insertColumn(2)
    @cmd_table.setHorizontalHeaderItem(2, Qt::TableWidgetItem.new('Repetition'))
  end

  def fill_byte_table(byte_list)
    byte_list.to_enum.with_index(0).each do |b, i|
      @cmd_table.insertRow(@cmd_table.rowCount)
      @cmd_table.setItem(i, 1, Qt::TableWidgetItem.new(b.value))
      if @bus == 'SPI'
        item =  Qt::TableWidgetItem.new
        item.setData(0, Qt::Variant.new(b.iteration))
        @cmd_table.setItem(i, 2, item)
        @cmd_table.setItem(i, 3, Qt::TableWidgetItem.new(b.description))
      else
        @cmd_table.setItem(i, 2, Qt::TableWidgetItem.new(b.description))
      end
      item =  Qt::TableWidgetItem.new
      item.setData(0, Qt::Variant.new(b.index))
      @cmd_table.setItem(i, 0, item)
    end
  end

  def add_row
    @cmd_table.insertRow(@cmd_table.rowCount)
    @cmd_table.setItem(@cmd_table.rowCount - 1, 1, Qt::TableWidgetItem.new('00'))
    if @bus == 'SPI'
      item =  Qt::TableWidgetItem.new
      item.setData(0, Qt::Variant.new(0))
      @cmd_table.setItem(@cmd_table.rowCount - 1, 2, item)
      @cmd_table.setItem(@cmd_table.rowCount - 1, 3, Qt::TableWidgetItem.new)
    else
      @cmd_table.setItem(@cmd_table.rowCount - 1, 2, Qt::TableWidgetItem.new)
    end
    item =  Qt::TableWidgetItem.new
    item.setData(0, Qt::Variant.new(@cmd_table.rowCount))
    @cmd_table.setItem(@cmd_table.rowCount - 1, 0, item)
  end

  def add_text_rows(txt)
      return ErrorMsg.new.ascii_only unless txt.ascii_only?
      txt.each_byte do |x|
        @cmd_table.insertRow(@cmd_table.rowCount)
        @cmd_table.setItem(@cmd_table.rowCount - 1, 1, Qt::TableWidgetItem.new(x.to_s(16)))
        item =  Qt::TableWidgetItem.new
        item.setData(0, Qt::Variant.new(0))
        @cmd_table.setItem(@cmd_table.rowCount - 1, 2, item)
        @cmd_table.setItem(@cmd_table.rowCount - 1, 3, Qt::TableWidgetItem.new(x.chr))
        item =  Qt::TableWidgetItem.new
        item.setData(0, Qt::Variant.new(@cmd_table.rowCount))
        @cmd_table.setItem(@cmd_table.rowCount - 1, 0, item)
      end
  end

  def clone_rows
    return 0 if @cmd_table.currentItem.nil?
    rows_to_delete = []
    @cmd_table.selectedItems.each do |item|
      rows_to_delete.push item.row
    end
    rows_to_delete.uniq!
    rows_to_delete.each_with_index do |row, i|
      @cmd_table.insertRow(@cmd_table.rowCount)
      unless @cmd_table.item(row, 1).nil?
        @cmd_table.setItem(@cmd_table.rowCount - 1, 1, Qt::TableWidgetItem.new(@cmd_table.item(row, 1).text))
      end
      if @bus == 'SPI'
        unless @cmd_table.item(row, 2).nil?
          repetition_item =  Qt::TableWidgetItem.new
          repetition_item.setData(0, Qt::Variant.new(@cmd_table.item(row, 2).text.to_i))
          @cmd_table.setItem(@cmd_table.rowCount - 1, 2, repetition_item)
        end
        unless @cmd_table.item(row, 3).nil?
          @cmd_table.setItem(@cmd_table.rowCount - 1, 3, Qt::TableWidgetItem.new(@cmd_table.item(row, 3).text))
        end
      else
        unless @cmd_table.item(row, 2).nil?
          @cmd_table.setItem(@cmd_table.rowCount - 1, 2, Qt::TableWidgetItem.new(@cmd_table.item(row, 2).text))
        end
      end
      unless @cmd_table.item(row, 0).nil?
        order_item =  Qt::TableWidgetItem.new
        order_item.setData(0, Qt::Variant.new(@cmd_table.item(row, 0).text.to_i))
        @cmd_table.setItem(@cmd_table.rowCount - 1, 0, order_item)
      end
    end
  end

  def remove_rows
    return 0 if @cmd_table.currentItem.nil?
    rows_to_delete = []
    @cmd_table.selectedItems.each do |item|
      rows_to_delete.push item.row
    end
    rows_to_delete.uniq!
    rows_to_delete.each_with_index do |row, i|
      @cmd_table.removeRow(row - i)
    end
  end

  def i2c_read_cmd(write_address, cmd_size)
    # Byte array size
    @cmd_table.setRowCount(3)
    # Size 1
    @cmd_table.setItem(0, 1, Qt::TableWidgetItem.new(HardsploitAPI.lowByte(word: cmd_size).to_s(16).upcase))
    @cmd_table.setItem(0, 2, Qt::TableWidgetItem.new('Payload size - low'))
    # Index
    item =  Qt::TableWidgetItem.new
    item.setData(0, Qt::Variant.new(1))
    @cmd_table.setItem(0, 0, item)
    # Size 2
    @cmd_table.setItem(1, 1, Qt::TableWidgetItem.new(HardsploitAPI.highByte(word: cmd_size).to_s(16).upcase))
    @cmd_table.setItem(1, 2, Qt::TableWidgetItem.new('Payload size - high'))
    # Index
    item =  Qt::TableWidgetItem.new
    item.setData(0, Qt::Variant.new(2))
    @cmd_table.setItem(1, 0, item)
    # Address
    @cmd_table.setItem(2, 1, Qt::TableWidgetItem.new(write_address))
    @cmd_table.setItem(2, 2, Qt::TableWidgetItem.new('Read address (control byte)'))
    # Index
    item =  Qt::TableWidgetItem.new
    item.setData(0, Qt::Variant.new(3))
    @cmd_table.setItem(2, 0, item)
  end

  def i2c_write_cmd(write_address, cmd_size)
    # Byte array size
    @cmd_table.setRowCount(3 + cmd_size)
    # Payload size low
    # -byte
    itemLB1 = Qt::TableWidgetItem.new(HardsploitAPI.lowByte(word: cmd_size).to_s(16).upcase)
    @cmd_table.setItem(0, 1, itemLB1)
    # -description
    itemLB3 = Qt::TableWidgetItem.new('Payload size - low')
    @cmd_table.setItem(0, 2, itemLB3)
    # -order
    itemLB0 =  Qt::TableWidgetItem.new
    itemLB0.setData(0, Qt::Variant.new(1))
    @cmd_table.setItem(0, 0, itemLB0)
    # Payload size high
    # -byte
    itemHB1 = Qt::TableWidgetItem.new(HardsploitAPI.highByte(word: cmd_size).to_s(16).upcase)
    @cmd_table.setItem(1, 1, itemHB1)
    # -description
    itemHB3 = Qt::TableWidgetItem.new('Payload size - high')
    @cmd_table.setItem(1, 2, itemHB3)
    # -order
    itemHB0 = Qt::TableWidgetItem.new
    itemHB0.setData(0, Qt::Variant.new(2))
    @cmd_table.setItem(1, 0, itemHB0)
    # Address
    # -byte
    itemA1 = Qt::TableWidgetItem.new(write_address)
    @cmd_table.setItem(2, 1, itemA1)
    # -description
    itemA3 = Qt::TableWidgetItem.new('Write address (control byte)')
    @cmd_table.setItem(2, 2, itemA3)
    # -order
    itemA0 = Qt::TableWidgetItem.new
    itemA0.setData(0, Qt::Variant.new(3))
    @cmd_table.setItem(2, 0, itemA0)
    # Payload bytes
    for i in 3...(cmd_size + 3) do
      @cmd_table.setItem(i, 1, Qt::TableWidgetItem.new(''))
      @cmd_table.setItem(i, 2, Qt::TableWidgetItem.new('Payload byte'))
      # Index
      item =  Qt::TableWidgetItem.new
      item.setData(0, Qt::Variant.new(i.next))
      @cmd_table.setItem(i, 0, item)
    end
  end

  def resize_to_content
    @cmd_table.resizeColumnsToContents
    @cmd_table.resizeRowsToContents
    @cmd_table.horizontalHeader.stretchLastSection = true
  end

  def count_total_repetition
	  repetition_value = 0
	  @cmd_table.rowCount.times do |i|
			repetition_value += @cmd_table.item(i, 2).text.to_i
		end
		return repetition_value
	end

  def empty_data_exist?
    # ARRAY SIZE
		if @cmd_table.rowCount == 0
		  Qt::MessageBox.new(Qt::MessageBox::Warning, 'Bytes array empty', 'The bytes array is empty').exec
			return true
    end
		@cmd_table.rowCount.times do |i|
			# EMPTY BYTE CELL
			if @cmd_table.item(i, 1).text == ''
				@cmd_table.setCurrentItem(@cmd_table.item(i, 1))
				Qt::MessageBox.new(Qt::MessageBox::Warning, 'Empty byte', 'Empty byte cell detected').exec
				return true
			end
      if @bus == 'SPI'
  			# EMPTY REPETITION CELL
  			if @cmd_table.item(i, 2).text == ''
  				@cmd_table.setCurrentItem(@cmd_table.item(i, 2))
  				Qt::MessageBox.new(Qt::MessageBox::Warning, 'Empty repetition', 'Empty repetition cell detected').exec
  				return true
  			end
      end
		end
		return false
	end
end
