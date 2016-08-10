#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../gui/gui_command_editor'
class Command_editor < Qt::Widget
  slots 'add_cmd()'
  slots 'edit_cmd()'
  slots 'add_row()'
  slots 'clone_row()'
  slots 'remove_row()'
  slots 'check_cell_content(QTableWidgetItem*)'

  def initialize(action, cmd_name, chip, bus_id, parent, bus_param={})
    super()
    @view = Ui_Command_editor.new
    centerWindow(self)
    @view.setupUi(self)
    @bus = Bus.find(bus_id)
    @chip_id = chip.id
    @cmd_name = cmd_name
    @bus_id = bus_id
    @parent = parent
    @cmd_table = Command_table.new(@view.tbl_bytes, @bus.name)

    inputRestrict(@view.lie_name, 2)
    inputRestrict(@view.lie_description, 2)
    @view.lbl_chip_val.setText(chip.reference)
    @cmd_table.resize_to_content
    @cmd_table.build_spi if @bus.name == 'SPI'
    @view.lie_text_2_bytes.hide unless @bus.name == 'SPI'

    case action
    when 0
      # Add
      @view.lbl_cmd_val.setText('-')
      Qt::Object.connect(@view.btn_validate, SIGNAL('clicked()'), self, SLOT('add_cmd()'))
    when 1
      # Template
      @view.lbl_cmd_val.setText(cmd_name)
      feed_editor_form
      @view.lie_name.setText('')
      Qt::Object.connect(@view.btn_validate, SIGNAL('clicked()'), self, SLOT('add_cmd()'))
    else
      # Edit
      @view.lbl_cmd_val.setText(cmd_name)
      feed_editor_form
      @view.btn_validate.setText('Edit')
      Qt::Object.connect(@view.btn_validate, SIGNAL('clicked()'), self, SLOT('edit_cmd()'))
    end
    unless bus_param.empty?
      feed_i2c_cmd_array(bus_param)
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def feed_i2c_cmd_array(bus_param)
    if bus_param[:mode] == 'w'
      @cmd_table.i2c_write_cmd(bus_param[:addr], bus_param[:size].to_i)
    else
      @cmd_table.i2c_read_cmd(bus_param[:addr], bus_param[:size].to_i)
    end
  end

  def add_cmd
    return false if @cmd_table.empty_data_exist? || is_cmd_size_valid? == false
    @cmd = Command.create(
      name:        @view.lie_name.text,
      description: @view.lie_description.text,
      bus_id:      @bus_id,
      chip_id:     @chip_id
    )
    unless check_for_errors(@cmd)
      add_bytes
      @parent.feed_cmd_array
      close
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def edit_cmd
    return false if @cmd_table.empty_data_exist? && !is_cmd_size_valid?
    @cmd = Command.find_by(name: @cmd_name, chip_id: @chip_id)
    @cmd.update(
      name: @view.lie_name.text,
      description: @view.lie_description.text
    )
    @view.tbl_bytes.sortItems(0, Qt::AscendingOrder)
    unless check_for_errors(@cmd)
      Byte.where(command_id: @cmd.id).destroy_all
      add_bytes
      @parent.feed_cmd_array
      close
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def add_bytes
    @view.tbl_bytes.sortItems(0, Qt::AscendingOrder)
    @view.tbl_bytes.rowCount.times do |i|
      if @bus.name == 'SPI'
        iteration = @view.tbl_bytes.item(i, 2).text
        description = @view.tbl_bytes.item(i, 3).text
      else
        iteration = nil
        description = @view.tbl_bytes.item(i, 2).text
      end
      byte = Byte.create(
        index:       i.next,
        value:       @view.tbl_bytes.item(i, 1).text,
        iteration:   iteration,
        description: description,
        command_id:  @cmd.id
      )
      return false if check_for_errors(byte)
    end
    Qt::MessageBox.new(
      Qt::MessageBox::Information,
      'Command status',
      'Command saved'
    ).exec
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def check_cell_content(item)
    case @view.tbl_bytes.horizontalHeaderItem(item.column).text
    when 'Order', 'Repetition'
      if item.text.to_i < 0
        item.setData(0, Qt::Variant.new(0))
        ErrorMsg.new.positive_cell_value
      end
    when 'Byte (Hexa)'
      reg = Qt::RegExp.new("^[A-Fa-f0-9]{2}")
      reg_val = Qt::RegExpValidator.new(reg, self)
      if reg_val.validate(item.text, item.text.length) == 0
        item.setText('')
        ErrorMsg.new.hexa_cell_value
      end
    when 'Description'
      unless item.text.nil?
        reg = Qt::RegExp.new("^[a-zA-Z0-9_@-\s]+$")
        reg_val = Qt::RegExpValidator.new(reg, self)
        if reg_val.validate(item.text, item.text.length) == 0
          item.setText('')
          ErrorMsg.new.char_cell_value
        end
      end
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def is_cmd_size_valid?
    byte_table_size = @view.tbl_bytes.rowCount
    case @bus_name
    when 'SPI'
      cmd_size =  byte_table_size + @cmd_table.count_total_repetition
      return true if cmd_size < 4000
      return ErrorMsg.new.spi_cmd_too_long
    when 'I2C'
      count = i = 0
      while i <= byte_table_size - 1 do
        low_byte     = @view.tbl_bytes.item(i, 1)
        high_byte    = @view.tbl_bytes.item(i + 1, 1)
        command_byte = @view.tbl_bytes.item(i + 2, 1)
        return ErrorMsg.new.lowbyte_missing  if low_byte.nil?
        return ErrorMsg.new.highbyte_missing if high_byte.nil?
        return ErrorMsg.new.mode_missing     if command_byte.nil?
        current_count = HardsploitAPI.BytesToInt(
          lByte: low_byte.text.to_i(16),
          hByte: high_byte.text.to_i(16)
        )
        count += current_count
        (command_type.to_i(16) % 2).zero? ? i += current_count + 3 : i += 3
      end
      return ErrorMsg.new.size_neq_row_number unless i == byte_table_size
      return ErrorMsg.new.i2c_cmd_too_long    if count > 2000
      return true
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def feed_editor_form
    cmd = Command.find_by(name: @cmd_name)
    @view.lie_name.setText(@cmd_name)
    @view.lie_description.setText(cmd.description)
    @cmd_table.fill_byte_table(cmd.bytes)
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def add_row
    if @view.lie_text_2_bytes.text.empty?
      @cmd_table.add_row
    else
      @cmd_table.add_text_rows(@view.lie_text_2_bytes.text)
      @view.lie_text_2_bytes.setText('')
    end
  end

  def clone_row
    @cmd_table.clone_rows
  end

  def remove_row
    @cmd_table.remove_rows
  end
end
