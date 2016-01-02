#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../HardsploitAPI/HardsploitAPI'
require_relative '../class/Command_table'
require_relative '../gui/gui_command_editor'
class Command_editor < Qt::Widget
  slots 'add_cmd()'
  slots 'edit_cmd()'
  slots 'add_row()'
  slots 'clone_row()'
  slots 'remove_row()'
  slots 'check_cell_content(QTableWidgetItem*)'

  def initialize(action, cmd_name, chip, bus_id, parent, api, bus_param={})
    super()
    @cmd_editor_gui = Ui_Command_editor.new
    centerWindow(self)
    @cmd_editor_gui.setupUi(self)
    @bus = Bus.find_by(bus_id: bus_id)
    @chip_id = chip.chip_id
    @cmd_name = cmd_name
    @bus_id = bus_id
    @parent = parent
    @api = api
    @cmd_table = Command_table.new(@api, @cmd_editor_gui.tbl_bytes, @bus.bus_name)

    inputRestrict(@cmd_editor_gui.lie_name, 2)
    inputRestrict(@cmd_editor_gui.lie_description, 2)
    @cmd_editor_gui.lbl_chip_val.setText(chip.chip_reference)

    @cmd_table.resize_to_content
    case @bus.bus_name
    when 'SPI'
      @cmd_table.build_spi
    end
    @cmd_editor_gui.lie_text_2_bytes.hide if @bus.bus_name != 'SPI'

    case action
    when 0
      # Add
      @cmd_editor_gui.lbl_cmd_val.text = '-'
      Qt::Object.connect(@cmd_editor_gui.btn_validate, SIGNAL('clicked()'), self, SLOT('add_cmd()'))
    when 1
      # Temp
      @cmd_editor_gui.lbl_cmd_val.text = cmd_name
      feed_editor_form
      @cmd_editor_gui.lie_name.setText('')
      Qt::Object.connect(@cmd_editor_gui.btn_validate, SIGNAL('clicked()'), self, SLOT('add_cmd()'))
    else
      # Edit
      @cmd_editor_gui.lbl_cmd_val.text = "#{cmd_name}"
      feed_editor_form
      @cmd_editor_gui.btn_validate.setText('Edit')
      Qt::Object.connect(@cmd_editor_gui.btn_validate, SIGNAL('clicked()'), self, SLOT('edit_cmd()'))
    end
    unless bus_param.empty?
      feed_i2c_cmd_array(bus_param)
    end
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while loading the GUI. Consult the logs for more details').exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def check_cell_content(item)
    case @cmd_editor_gui.tbl_bytes.horizontalHeaderItem(item.column).text
    when 'Order', 'Repetition'
      if item.text.to_i < 0
        item.setData(0, Qt::Variant.new(0))
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Wrong data', 'Only positive values are accepted in this cell').exec
      end
    when 'Byte (Hexa)'
      reg = Qt::RegExp.new("^[A-Fa-f0-9]{2}")
      reg_val = Qt::RegExpValidator.new(reg, self)
      if reg_val.validate(item.text, item.text.length) == 0
        item.setText('')
        Qt::MessageBox.new(Qt::MessageBox::Warning, 'Wrong data', 'Only hexadecimal values are accepted in this cell').exec
      end
    when 'Description'
      unless item.text.nil?
        reg = Qt::RegExp.new("^[a-zA-Z0-9_@-\s]+$")
        reg_val = Qt::RegExpValidator.new(reg, self)
        if reg_val.validate(item.text, item.text.length) == 0
          item.setText('')
          Qt::MessageBox.new(Qt::MessageBox::Warning, 'Wrong data', 'Wrong characters in this cell').exec
        end
      end
    end
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while verifying the command byte column. Consult the logs for more details').exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def is_cmd_size_valid?
    # SPI
    if @bus.bus_name == 'SPI'
      if (@cmd_editor_gui.tbl_bytes.rowCount + @cmd_table.count_total_repetition) > 4000
			  Qt::MessageBox.new(Qt::MessageBox::Warning, 'SPI command invalid', 'SPI command size is to big (> 4000)').exec
        return false
      else
        return true
      end
    # I2C
    elsif @bus.bus_name == 'I2C'
      count = 0
      i = 0
      while i <= (@cmd_editor_gui.tbl_bytes.rowCount) - 1 do
        if @cmd_editor_gui.tbl_bytes.item(i, 1).nil?
          Qt::MessageBox.new(Qt::MessageBox::Critical, 'Command error', 'Payload size invalid or payload size (low) missing').exec
          return false
        else
          lowByte = @cmd_editor_gui.tbl_bytes.item(i, 1).text
        end
        if @cmd_editor_gui.tbl_bytes.item(i + 1, 1).nil?
          Qt::MessageBox.new(Qt::MessageBox::Critical, 'Command error', 'Payload size invalid or payload size (high) missing').exec
          return false
        else
          highByte = @cmd_editor_gui.tbl_bytes.item(i + 1, 1).text
        end
        if @cmd_editor_gui.tbl_bytes.item(i + 2, 1).nil?
          Qt::MessageBox.new(Qt::MessageBox::Critical, 'Command error', 'Payload size invalid or Read / Write address missing').exec
          return false
        else
          commandType = @cmd_editor_gui.tbl_bytes.item(i + 2, 1).text
        end
        count = count + (HardsploitAPI.BytesToInt(lowByte.to_i(16), highByte.to_i(16)))
        if commandType.to_i(16) % 2 == 0 #WRITE
          i = (i + ((HardsploitAPI.BytesToInt(lowByte.to_i(16), highByte.to_i(16))) + 3))
        else #READ
          i = (i + 3)
        end
      end
      if i != @cmd_editor_gui.tbl_bytes.rowCount
        Qt::MessageBox.new(Qt::MessageBox::Critical, 'Command error', 'I2C command incorrectly formated: The payload size does not match with the row number').exec
        return false
      end
      if count > 2000
        Qt::MessageBox.new(Qt::MessageBox::Critical, 'I2C command invalid', 'Your payload is too big (> 2000)').exec
        return false
      else
        return true
      end
    else
      return false
    end
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while verifying the command size. Consult the logs for more details').exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def feed_i2c_cmd_array(bus_param)
    if bus_param[:mode] == 'w'
      @cmd_table.i2c_write_cmd(bus_param[:addr], bus_param[:size].to_i)
    else
      @cmd_table.i2c_read_cmd(bus_param[:addr], bus_param[:size].to_i)
    end
  end

  def add_cmd
    if @cmd_table.empty_data_exist? || is_cmd_size_valid? == false
			return false
    end
    if @cmd_editor_gui.lie_name.text.empty? || @cmd_editor_gui.lie_description.text.empty?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Information missing', 'Name or description empty').exec
      return false
    end
    cmd = Cmd.new
    cmd.cmd_name = @cmd_editor_gui.lie_name.text
    cmd.cmd_desc = @cmd_editor_gui.lie_description.text
    cmd.cmd_bus = @bus_id
    cmd.cmd_chip = @chip_id
    cmd.save
    @cmd_editor_gui.tbl_bytes.sortItems(0, Qt::AscendingOrder)
    @cmd_editor_gui.tbl_bytes.rowCount.times do |i|
      byte = Byte.new
      byte.byte_index = i + 1
      byte.byte_value = @cmd_editor_gui.tbl_bytes.item(i, 1).text
      if @bus.bus_name == 'SPI'
        byte.byte_iteration = @cmd_editor_gui.tbl_bytes.item(i, 2).text
        byte.byte_description = @cmd_editor_gui.tbl_bytes.item(i, 3).text
      else
        byte.byte_description = @cmd_editor_gui.tbl_bytes.item(i, 2).text
      end
      byte.byte_cmd = Cmd.ids.last
      byte.save
    end
    @parent.feed_cmd_array
    close
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while adding the command. Consult the logs for more details').exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def edit_cmd
    if @cmd_table.empty_data_exist? && !is_cmd_size_valid?
			return false
    end
    if @cmd_editor_gui.lie_name.text.empty? || @cmd_editor_gui.lie_description.text.empty?
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Information missing', 'Name or description empty').exec
      return false
    end
    cmd = Cmd.find_by(cmd_name: @cmd_name, cmd_chip: @chip_id)
    if cmd.cmd_name != @cmd_editor_gui.lie_name.text
      cmd.update(cmd_name: @cmd_editor_gui.lie_name.text)
    end
    if cmd.cmd_desc != @cmd_editor_gui.lie_description.text
      cmd.update(cmd_desc: @cmd_editor_gui.lie_description.text)
    end
    @cmd_editor_gui.tbl_bytes.sortItems(0, Qt::AscendingOrder)
    bytes = Byte.where(byte_cmd: cmd.cmd_id)
    bytes.destroy_all
    @cmd_editor_gui.tbl_bytes.rowCount.times do |i|
      byte = Byte.new
      byte.byte_index = i + 1
      byte.byte_value = @cmd_editor_gui.tbl_bytes.item(i, 1).text
      if @bus.bus_name == 'SPI'
        byte.byte_iteration = @cmd_editor_gui.tbl_bytes.item(i, 2).text
        byte.byte_description = @cmd_editor_gui.tbl_bytes.item(i, 3).text
      else
        byte.byte_description = @cmd_editor_gui.tbl_bytes.item(i, 2).text
      end
      byte.byte_cmd = cmd.cmd_id
      byte.save
    end
    @parent.feed_cmd_array
    close
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while editing the command. Consult the logs for more details').exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def feed_editor_form
    cmd = Cmd.find_by(cmd_name: @cmd_name)
    @cmd_editor_gui.lie_name.setText(@cmd_name)
    @cmd_editor_gui.lie_description.setText(cmd.cmd_desc)
    @cmd_table.fill_byte_table(cmd.byte)
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when loading the command. Consult the logs for more details').exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def add_row
    if @cmd_editor_gui.lie_text_2_bytes.text.empty?
      @cmd_table.add_row
    else
      @cmd_table.add_text_rows(@cmd_editor_gui.lie_text_2_bytes.text)
      @cmd_editor_gui.lie_text_2_bytes.setText('')
    end
  end

  def clone_row
    @cmd_table.clone_rows
  end

  def remove_row
    @cmd_table.remove_rows
  end
end
