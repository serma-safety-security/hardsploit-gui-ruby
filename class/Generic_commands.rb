#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../HardsploitAPI/HardsploitAPI'
require_relative '../gui/gui_generic_commands'
require_relative '../gui/gui_export_manager'
require_relative '../class/I2C/I2c_command'
require_relative '../class/Export_manager'
require_relative '../class/Command_editor'


class Generic_commands < Qt::Widget
  slots 'feed_cmd_array()'
  slots 'exec_action()'
  slots 'open_cmd_form()'

  def initialize(api, chip, bus_name)
    super()
    @generic_command_gui = Ui_Generic_commands.new
    centerWindow(self)
    @generic_command_gui.setupUi(self)
    @generic_command_gui.lbl_chip.setText(chip.chip_reference)
    @generic_command_gui.lbl_search.setPixmap(Qt::Pixmap.new('images/search.png'))
    inputRestrict(@generic_command_gui.lie_search, 2)
    @generic_command_gui.check_result.setChecked(true)
    @api = api
    @chip = chip
    @bus_name = bus_name
    @bus_id = Bus.find_by(bus_name: bus_name).bus_id
    select_chip_settings(bus_name)
    feed_cmd_array
  end

  def feed_cmd_array
    @generic_command_gui.tbl_cmd.clearContents
    cmd = @chip.cmd.where(cmd_bus: @bus_id)
    unless @generic_command_gui.lie_search.text.empty?
      cmd = cmd.where('cmd_name LIKE ?', "%#{@generic_command_gui.lie_search.text}%")
    end
    @generic_command_gui.tbl_cmd.setRowCount(cmd.count);
    cmd.to_enum.with_index(0).each do |c, i|
      it1 = Qt::TableWidgetItem.new(c.cmd_name)
      it1.setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled)
      it2 =  Qt::TableWidgetItem.new(c.cmd_desc)
      it2.setFlags(Qt::ItemIsEnabled)
      @generic_command_gui.tbl_cmd.setItem(i, 0, it1);
      @generic_command_gui.tbl_cmd.setItem(i, 1, it2);
    end
    @generic_command_gui.tbl_cmd.resizeColumnsToContents
    @generic_command_gui.tbl_cmd.resizeRowsToContents
    @generic_command_gui.tbl_cmd.horizontalHeader.stretchLastSection = true
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error while loading the command array. Consult the log for more details').exec
  end

  def select_chip_settings(bus)
    case bus
    when 'SPI'
      @chip_settings = Spi.find_by(spi_chip: @chip.chip_id)
      @speeds = {
        '25.00' => 3,
        '18.75' => 4,
        '15.00' => 5,
        '12.50' => 6,
        '10.71' => 7,
        '9.38' => 8,
        '7.50' => 10,
        '5.00' => 15,
        '3.95' => 19,
        '3.00' => 25,
        '2.03' => 37,
        '1.00' => 75,
        '0.50' => 150,
        '0.29' => 255
      }
      @generic_command_gui.cbx_action.insertItem(3, 'Concatenate')
    when 'I2C'
      @chip_settings = I2C.find_by(i2c_chip: @chip.chip_id)
    end
  end

  # Execute action
  def exec_action
    if @generic_command_gui.tbl_cmd.currentItem.nil?
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Missing command', 'Select a command in the array first').exec
      return 0
    end
    case @generic_command_gui.cbx_action.currentText
    when 'Execute'
      cmd_array = prepare_cmd
      result = exec_cmd(@bus_name, cmd_array)
      if @generic_command_gui.check_result.isChecked
        export_manager = Export_manager.new(@bus_name, result, cmd_array)
        export_manager.setWindowModality(Qt::ApplicationModal)
        export_manager.show
      end
    when 'Template'
      open_cmd_form(:option_1 => 'temp')
    when 'Edit'
      open_cmd_form(:option_1 => 'edit')
    when 'Concatenate'
      concatenate_cmds
    when 'Delete'
      delete_cmd
    else
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Wrong option', 'Please choose a correct action').exec
    end
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while executing the action. Consult the logs for more details').exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def prepare_cmd
    byte_list = Byte.where(byte_cmd: Cmd.find_by(cmd_name: @generic_command_gui.tbl_cmd.currentItem.text))
    array_sent = Array.new
    byte_list.each do |bl|
      if bl.byte_iteration != 0 && !bl.byte_iteration.nil?
        for i in 1..bl.byte_iteration.to_i do
          array_sent.push(bl.byte_value.to_i(16))
        end
      else
        array_sent.push(bl.byte_value.to_i(16))
      end
    end
    return array_sent
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when preparing the command. Consult the log for more details').exec
  end

  def exec_cmd(bus, array_sent)
      Firmware.new(@api, @bus_name)
      case bus
      when 'SPI'
        return check_send_and_received_data(@api.spi_Interact(@chip_settings.spi_mode, @speeds[@chip_settings.spi_frequency], array_sent))
      when 'I2C'
        return check_send_and_received_data(@api.i2c_Interact(@chip_settings.i2c_frequency, array_sent))
      end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when executing the command. Consult the log for more details').exec
  end

  def delete_cmd
    msg = Qt::MessageBox.new
    msg.setWindowTitle('Delete command')
    msg.setText('Confirm the delete command action ?')
    msg.setIcon(Qt::MessageBox::Question)
    msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
    msg.setDefaultButton(Qt::MessageBox::Cancel)
    if msg.exec == Qt::MessageBox::Ok
      @chip.cmd.find_by(cmd_name: @generic_command_gui.tbl_cmd.currentItem.text).destroy
      feed_cmd_array
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when deleting the command. Consult the log for more details').exec
  end

  def concatenate_cmds
    if @generic_command_gui.tbl_cmd.selectedItems.count != 2
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Wrong selection', 'Select two commands in the table to concatenate them').exec
      return 0
    end
    bytesCmd1 = Byte.where(byte_cmd: Cmd.find_by(cmd_name: @generic_command_gui.tbl_cmd.selectedItems[0].text).cmd_id)
    bytesCmd2 = Byte.where(byte_cmd: Cmd.find_by(cmd_name: @generic_command_gui.tbl_cmd.selectedItems[1].text).cmd_id)
    if check_concatenation_size(bytesCmd1, bytesCmd2)
      return 0
    end
    # Save cmd
    cmd = Cmd.new
    cmd.cmd_name = 'New concatenation'
    cmd.cmd_desc = "Concatenation of #{@generic_command_gui.tbl_cmd.selectedItems[0].text} and #{@generic_command_gui.tbl_cmd.selectedItems[1].text} commands"
    cmd.cmd_bus = @bus_id
    cmd.cmd_chip = @chip.chip_id
    cmd.save
    # Save cmd bytes
    bytesCmd1.each do |b1|
      byte = Byte.new
      byte.byte_index = b1.byte_index
      byte.byte_value = b1.byte_value
      checkSize.push(b1.byte_value)
      byte.byte_description = b1.byte_description
      byte.byte_iteration = b1.byte_iteration
      byte.byte_cmd = Cmd.ids.last
      byte.byte_type = 1
      byte.save
    end
    bytesCmd2.each do |b2|
      byte2 = Byte.new
      byte2.byte_index = Byte.last.byte_index + 1
      byte2.byte_value = b2.byte_value
      checkSize.push(b2.byte_value)
      byte2.byte_description = b2.byte_description
      byte2.byte_iteration = b2.byte_iteration
      byte2.byte_cmd = Cmd.ids.last
      byte2.byte_type = 1
      byte2.save
    end
    feed_cmd_array
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when concatenating the command. Consult the log for more details').exec
  end

  def check_concatenation_size(bytesCmd1, bytesCmd2)
    checkSize = Array.new
    bytesCmd1.each do |b1|
      checkSize.push(b1.byte_value)
    end
    bytesCmd2.each do |b2|
      checkSize.push(b2.byte_value)
    end
    count = 0
    i = 0
    while i <= (checkSize.size) - 1 do
      lowByte = checkSize[i]
      highByte = checkSize[i + 1]
      commandType = checkSize[i + 2]
      count = count + (@api.BytesToInt(lowByte.to_i(16), highByte.to_i(16)))
      if commandType.to_i(16) % 2 == 0 #WRITE
        i = (i + ((@api.BytesToInt(lowByte.to_i(16), highByte.to_i(16))) + 3))
      else #READ
        i = (i + 3)
      end
    end
    if count > 2000
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Command too big: unable to concatenate').exec
      return false
    end
    return true
  end

  def open_cmd_form(options={})
      if options[:option_1].nil?
        if @bus_name == 'I2C'
          cmdBase = I2c_command.new(@api, @chip, @bus_id, self)
        else
          cmdBase = Command_editor.new(0, nil, @chip, @bus_id, self, @api)
        end
      else
        if options[:option_1] == 'temp'
          cmdBase = Command_editor.new(1, @generic_command_gui.tbl_cmd.currentItem.text, @chip, @bus_id, self, @api)
        else
          cmdBase = Command_editor.new(2, @generic_command_gui.tbl_cmd.currentItem.text, @chip, @bus_id, self, @api)
        end
      end
    cmdBase.setWindowModality(Qt::ApplicationModal)
    cmdBase.show
  end

  def check_send_and_received_data(value)
    case value
    when HardsploitAPI::USB_STATE::PACKET_IS_TOO_LARGE
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', "PACKET_IS_TOO_LARGE max: #{HardsploitAPI::USB::USB_TRAME_SIZE}").exec
    when HardsploitAPI::USB_STATE::ERROR_SEND
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'ERROR_SEND').exec
    when HardsploitAPI::USB_STATE::BUSY
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'BUSY', 'Device busy').exec
    else
      return value
    end
  end
end
