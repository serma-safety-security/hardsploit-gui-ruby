#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../HardsploitAPI/HardsploitAPI'
class CommandBase < Qt::Widget
  slots 'addCmd()'
  slots 'editCmd()'
  slots 'addRow()'
  slots 'activAction()'
  slots 'cloneRow()'
  slots 'removeRow()'
  slots 'checkTxeContent()'
  slots 'checkCellContent(QTableWidgetItem*)'

  def initialize(action, cmdName, chipId, busId, parent, api, busParam={})
    super()
    @cb = Ui_CommandBase.new
    centerWindow(self)
    @cb.setupUi(self)
    @chipId = chipId
    @cmdName = cmdName
    @busId = busId
    @parent = parent

    inputRestrict(@cb.lie_name, 2)

    # Get chip and bus name/ref
    @bus = Bus.find_by(bus_id: @busId)
    chipRef = Chip.find_by(chip_id: chipId).chip_reference
    @cb.lbl_chip.text = "Current chip: #{chipRef}"
    @cb.lbl_bus.text = "Current BUS: #{@bus.bus_name}"
    @cb.btn_clone.enabled = false
    @cb.btn_remove.enabled = false
    @cb.tbl_bytes.resizeColumnsToContents()
    @cb.tbl_bytes.resizeRowsToContents()
    @cb.tbl_bytes.horizontalHeader.stretchLastSection = true
    @cb.tabWidget.setCurrentIndex(0)
    # Deactivate text2byte for non spi buses
    if @bus.bus_name != "SPI"
      @cb.lie_text2bytes.setEnabled(false)
      @cb.lie_text2bytes.hide
    end
    case action
    when 0
      # Add
      @cb.lbl_cmd.text = "Current CMD: -"
      Qt::Object.connect(@cb.btn_validate, SIGNAL('clicked()'), self, SLOT('addCmd()'))
    when 1
      # Temp
      @cb.lbl_cmd.text = "Current CMD: #{cmdName}"
      fillForm
      @cb.lie_name.setText("")
      Qt::Object.connect(@cb.btn_validate, SIGNAL('clicked()'), self, SLOT('addCmd()'))
    else
      # Edit
      @cb.lbl_cmd.text = "Current CMD: #{cmdName}"
      fillForm
      @cb.btn_validate.setText("Edit")
      Qt::Object.connect(@cb.btn_validate, SIGNAL('clicked()'), self, SLOT('editCmd()'))
    end
    if !busParam.empty?
      if busParam[:mode] == "w"
        # Byte table size
        @cb.tbl_bytes.setRowCount(3 + busParam[:size].to_i)
        # Size 1
        @cb.tbl_bytes.setItem(0, 1, Qt::TableWidgetItem.new(api.lowByte(busParam[:size].to_i).to_s))
        @cb.tbl_bytes.setItem(0, 2, Qt::TableWidgetItem.new("0"))
        @cb.tbl_bytes.setItem(0, 3, Qt::TableWidgetItem.new("Payload size - low"))
        # Index
        item =  Qt::TableWidgetItem.new
        item.setData(0, Qt::Variant.new(1))
        @cb.tbl_bytes.setItem(0, 0, item)
        # Size 2
        @cb.tbl_bytes.setItem(1, 1, Qt::TableWidgetItem.new(api.highByte(busParam[:size].to_i).to_s))
        @cb.tbl_bytes.setItem(1, 2, Qt::TableWidgetItem.new("0"))
        @cb.tbl_bytes.setItem(1, 3, Qt::TableWidgetItem.new("Payload size - high"))
        # Index
        item =  Qt::TableWidgetItem.new
        item.setData(0, Qt::Variant.new(2))
        @cb.tbl_bytes.setItem(1, 0, item)
        # Address
        @cb.tbl_bytes.setItem(2, 1, Qt::TableWidgetItem.new(busParam[:addr]))
        @cb.tbl_bytes.setItem(2, 2, Qt::TableWidgetItem.new("0"))
        @cb.tbl_bytes.setItem(2, 3, Qt::TableWidgetItem.new("Write address (control byte)"))
        # Index
        item =  Qt::TableWidgetItem.new
        item.setData(0, Qt::Variant.new(3))
        @cb.tbl_bytes.setItem(2, 0, item)
        for i in 3...(busParam[:size].to_i + 3) do
          @cb.tbl_bytes.setItem(i, 1, Qt::TableWidgetItem.new(""))
          @cb.tbl_bytes.setItem(i, 2, Qt::TableWidgetItem.new("0"))
          @cb.tbl_bytes.setItem(i, 3, Qt::TableWidgetItem.new("Payload byte"))
          # Index
          item =  Qt::TableWidgetItem.new
          item.setData(0, Qt::Variant.new((i + 1)))
          @cb.tbl_bytes.setItem(i, 0, item)
        end
        @cb.btn_addRow.setEnabled(false)
      else
        # Byte table size
        @cb.tbl_bytes.setRowCount(3)
        # Size 1
        @cb.tbl_bytes.setItem(0, 1, Qt::TableWidgetItem.new(api.lowByte(busParam[:size].to_i).to_s))
        @cb.tbl_bytes.setItem(0, 2, Qt::TableWidgetItem.new("0"))
        @cb.tbl_bytes.setItem(0, 3, Qt::TableWidgetItem.new("Payload size - low"))
        # Index
        item =  Qt::TableWidgetItem.new
        item.setData(0, Qt::Variant.new(1))
        @cb.tbl_bytes.setItem(0, 0, item)
        # Size 2
        @cb.tbl_bytes.setItem(1, 1, Qt::TableWidgetItem.new(api.highByte(busParam[:size].to_i).to_s))
        @cb.tbl_bytes.setItem(1, 2, Qt::TableWidgetItem.new("0"))
        @cb.tbl_bytes.setItem(1, 3, Qt::TableWidgetItem.new("Payload size - high"))
        # Index
        item =  Qt::TableWidgetItem.new
        item.setData(0, Qt::Variant.new(2))
        @cb.tbl_bytes.setItem(1, 0, item)
        # Address
        @cb.tbl_bytes.setItem(2, 1, Qt::TableWidgetItem.new(busParam[:addr]))
        @cb.tbl_bytes.setItem(2, 2, Qt::TableWidgetItem.new("0"))
        @cb.tbl_bytes.setItem(2, 3, Qt::TableWidgetItem.new("Read address (control byte)"))
        # Index
        item =  Qt::TableWidgetItem.new
        item.setData(0, Qt::Variant.new(3))
        @cb.tbl_bytes.setItem(2, 0, item)

        @cb.tbl_bytes.setEnabled(false)
        @cb.btn_addRow.setEnabled(false)
      end
    end
    rescue Exception => msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while loading the GUI. Consult the logs for more details").exec
      logger = Logger.new($logFilePath)
      logger.error msg
  end

  def checkTxeContent
    reg = Qt::RegExp.new("^[a-zA-Z0-9_@-]+( [a-zA-Z0-9_@-]+)*$")
    regVal = Qt::RegExpValidator.new(reg, self)
    if regVal.validate(sender.toPlainText, sender.toPlainText.length) == 0
      sender.setPlainText(sender.toPlainText.chop)
      sender.moveCursor(Qt::TextCursor::End, Qt::TextCursor::MoveAnchor)
    end
  end

  def checkCellContent(item)
    case item.column
    when 1
      reg = Qt::RegExp.new("^[A-Fa-f0-9]{2}")
      regVal = Qt::RegExpValidator.new(reg, self)
      if regVal.validate(item.text, item.text.length) == 0
        item.setText("")
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Wrong data", "Only hexadecimal values are accepted in this cell").exec
      end
    when 2
      reg = Qt::RegExp.new("[0-9]+")
      regVal = Qt::RegExpValidator.new(reg, self)
      if regVal.validate(item.text, item.text.length) == 0
        item.setText("0")
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Wrong data", "Only interger values are accepted in this cell").exec
      end
    when 3
      if !item.text.nil?
        reg = Qt::RegExp.new("^[a-zA-Z0-9_@-\s]+$")
        regVal = Qt::RegExpValidator.new(reg, self)
        if regVal.validate(item.text, item.text.length) == 0
          item.setText("")
          Qt::MessageBox.new(Qt::MessageBox::Warning, "Wrong data", "Wrong characters in this cell").exec
        end
      end
    end
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while verifying the command byte column. Consult the logs for more details").exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def checkCmdSize
    # SPI
    if @bus.bus_name == "SPI"
      if @cb.tbl_bytes.rowCount > 4000
        return false
      else
        return true
      end
    #I2C
    elsif @bus.bus_name == "I2C"
      count = 0
      i = 0
      while i <= (@cb.tbl_bytes.rowCount)-1 do

        if @cb.tbl_bytes.item(i, 1).nil?
          Qt::MessageBox.new(Qt::MessageBox::Critical, "Command error", "I2C command incorrectly formated: Payload size (low) missing").exec
          return false
        else
          lowByte = @cb.tbl_bytes.item(i, 1).text
        end

        if @cb.tbl_bytes.item(i + 1, 1).nil?
          Qt::MessageBox.new(Qt::MessageBox::Critical, "Command error", "I2C command incorrectly formated: Payload size (high) missing").exec
          return false
        else
          highByte = @cb.tbl_bytes.item(i + 1, 1).text
        end

        if @cb.tbl_bytes.item(i + 2, 1).nil?
          Qt::MessageBox.new(Qt::MessageBox::Critical, "Command error", "I2C command incorrectly formated: Read or Write address missing").exec
          return false
        else
          commandType = @cb.tbl_bytes.item(i + 2, 1).text
        end

        count = count + (lowByte.to_i + highByte.to_i)
        if commandType.to_i(16) % 2 == 0 #WRITE
          i = (i + ((lowByte.to_i + highByte.to_i) + 3))
        else #READ
          i = (i + 3)
        end
      end

      if i != @cb.tbl_bytes.rowCount
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Command error", "I2C command incorrectly formated: The payload size doesn't match with the row number").exec
        return false
      end

      if count > 2000
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Command error", "Your payload is too big (> 2000)").exec
        return false
      else
        return true
      end

    else
      return false
    end
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while verifying the command size. Consult the logs for more details").exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def addCmd
    if @cb.lie_name.text.empty? || @cb.txe_description.plainText.empty?
      Qt::MessageBox.new(Qt::MessageBox::Warning, "Information missing", "Name and description are requiered").exec
      return
    elsif @cb.tbl_bytes.rowCount == 0
      Qt::MessageBox.new(Qt::MessageBox::Warning, "Bytes table empty", "The bytes table is empty").exec
      return
    else
      for i in 0..(@cb.tbl_bytes.rowCount) - 1 do
        if @cb.tbl_bytes.item(i, 2).text == ""
          @cb.tbl_bytes.item(i, 2).setText("0")
        end
        if @cb.tbl_bytes.item(i, 1).text == ""
          Qt::MessageBox.new(Qt::MessageBox::Warning, "Empty data", "One or several rows in the table contain empty data.").exec
          return
        end
      end
      if !checkCmdSize
        return false
      end
      begin
        cmd = Cmd.new
        cmd.cmd_name = @cb.lie_name.text
        cmd.cmd_desc = @cb.txe_description.plainText
        cmd.cmd_bus = @busId
        cmd.cmd_chip = @chipId
        cmd.save

        #Add bytes
        @cb.tbl_bytes.sortItems(0, Qt::AscendingOrder)
        for i in 0..(@cb.tbl_bytes.rowCount)-1 do
          byte = Byte.new
          byte.byte_index = i + 1
          byte.byte_value = @cb.tbl_bytes.item(i, 1).text
          byte.byte_iteration = @cb.tbl_bytes.item(i, 2).text
          byte.byte_description = @cb.tbl_bytes.item(i, 3).text
          byte.byte_cmd = Cmd.ids.last
          byte.byte_type = 1
          byte.save
        end
        @parent.feedCmdArray
        close
      rescue Exception => msg
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while adding the command. Consult the logs for more details").exec
        logger = Logger.new($logFilePath)
        logger.error msg
      end
    end
  end

  def editCmd
    if @cb.lie_name.text.empty? || @cb.txe_description.plainText.empty?
      Qt::MessageBox.new(Qt::MessageBox::Warning, "Information missing", "Name and description are requiered").exec
    elsif @cb.tbl_bytes.rowCount == 0
      Qt::MessageBox.new(Qt::MessageBox::Warning, "Bytes table empty", "The bytes table is empty").exec
    elsif !checkCmdSize
      return false
    else
      for i in 0..(@cb.tbl_bytes.rowCount)-1 do
        if @cb.tbl_bytes.item(i, 2).text == ""
          @cb.tbl_bytes.item(i, 2).setText("0")
        end
        if @cb.tbl_bytes.item(i, 1).text == ""
          Qt::MessageBox.new(Qt::MessageBox::Warning, "Empty data", "One or several rows in the table contain empty data.").exec
          return
        end
      end
      begin
        cmd = Cmd.find_by(cmd_name: @cmdName, cmd_chip: @chipId)
        if cmd.cmd_name != @cb.lie_name.text
          cmd.update(cmd_name: @cb.lie_name.text)
        end
        if cmd.cmd_desc != @cb.txe_description.plainText
          cmd.update(cmd_desc: @cb.txe_description.plainText)
        end

        #Add bytes
        @cb.tbl_bytes.sortItems(0, Qt::AscendingOrder)
        bytes = Byte.where(byte_cmd: cmd.cmd_id)
        bytes.destroy_all
        for i in 0..(@cb.tbl_bytes.rowCount)-1 do
          byte = Byte.new
          byte.byte_index = i + 1
          byte.byte_value = @cb.tbl_bytes.item(i, 1).text
          byte.byte_iteration = @cb.tbl_bytes.item(i, 2).text
          byte.byte_description = @cb.tbl_bytes.item(i, 3).text
          byte.byte_cmd = cmd.cmd_id
          byte.byte_type = 1
          byte.save
        end
        @parent.feedCmdArray
        close
      rescue Exception => msg
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while adding the command. Consult the logs for more details").exec
        logger = Logger.new($logFilePath)
        logger.error msg
      end
    end
  end

  def fillForm
    cmd = Cmd.find_by(cmd_name: @cmdName)
    @cb.lie_name.setText(@cmdName)
    @cb.txe_description.setPlainText(cmd.cmd_desc)
    bytes = cmd.byte
    bytes.to_enum.with_index(0).each do |b, i|
      @cb.tbl_bytes.setRowCount(@cb.tbl_bytes.rowCount + 1)
      @cb.tbl_bytes.setItem(i, 1, Qt::TableWidgetItem.new(b.byte_value))
      @cb.tbl_bytes.setItem(i, 2, Qt::TableWidgetItem.new(b.byte_iteration.to_s))
      @cb.tbl_bytes.setItem(i, 3, Qt::TableWidgetItem.new(b.byte_description.to_s))
      item =  Qt::TableWidgetItem.new
      item.setData(0, Qt::Variant.new(b.byte_index))
      @cb.tbl_bytes.setItem(i, 0, item)
    end
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured when adding the command. Consult the logs for more details").exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def addRow
    if @cb.lie_text2bytes.text.empty?
      @cb.tbl_bytes.setRowCount(@cb.tbl_bytes.rowCount+1)
      @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 1, Qt::TableWidgetItem.new("00"))
      @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 2, Qt::TableWidgetItem.new("0"))
      @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 3, Qt::TableWidgetItem.new)
      item =  Qt::TableWidgetItem.new
      item.setData(0, Qt::Variant.new(@cb.tbl_bytes.rowCount))
      @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 0, item)
    else
      if @cb.lie_text2bytes.text.ascii_only?
        @cb.lie_text2bytes.text.each_byte do |x|
          @cb.tbl_bytes.setRowCount(@cb.tbl_bytes.rowCount+1)
          @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 1, Qt::TableWidgetItem.new(x.to_s(16)))
          @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 2, Qt::TableWidgetItem.new("0"))
          @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 3, Qt::TableWidgetItem.new(x.chr))
          item =  Qt::TableWidgetItem.new
          item.setData(0, Qt::Variant.new(@cb.tbl_bytes.rowCount))
          @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 0, item)
        end
        @cb.lie_text2bytes.setText("")
      else
        Qt::MessageBox.new(Qt::MessageBox::Warning, "String error", "Only ASCII characters can be specify").exec
      end
    end
  end

  def cloneRow
      @cb.tbl_bytes.setRowCount(@cb.tbl_bytes.rowCount+1)
      if !@cb.tbl_bytes.item(@cb.tbl_bytes.currentRow, 1).nil?
        @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 1, Qt::TableWidgetItem.new(@cb.tbl_bytes.item(@cb.tbl_bytes.currentRow, 1).text))
      end
      if !@cb.tbl_bytes.item(@cb.tbl_bytes.currentRow, 2).nil?
        @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 2, Qt::TableWidgetItem.new(@cb.tbl_bytes.item(@cb.tbl_bytes.currentRow, 2).text))
      end
      if !@cb.tbl_bytes.item(@cb.tbl_bytes.currentRow, 3).nil?
        @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 3, Qt::TableWidgetItem.new(@cb.tbl_bytes.item(@cb.tbl_bytes.currentRow, 3).text))
      end
      if !@cb.tbl_bytes.item(@cb.tbl_bytes.currentRow, 0).nil?
        item =  Qt::TableWidgetItem.new
        item.setData(0, Qt::Variant.new(@cb.tbl_bytes.item(@cb.tbl_bytes.currentRow, 0).text.to_i))
        @cb.tbl_bytes.setItem(@cb.tbl_bytes.rowCount-1, 0, item)
      end
  end

  def removeRow
      @cb.tbl_bytes.removeRow(@cb.tbl_bytes.currentRow)
      if @cb.tbl_bytes.rowCount == 0
        @cb.btn_clone.setEnabled(false)
        @cb.btn_remove.setEnabled(false)
      end
  end

  def activAction
      @cb.btn_clone.setEnabled(true)
      @cb.btn_remove.setEnabled(true)
  end
end