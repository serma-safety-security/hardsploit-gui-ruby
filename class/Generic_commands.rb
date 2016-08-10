#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../gui/gui_generic_commands'
require_relative '../gui/gui_export_manager'

class Generic_commands < Qt::MainWindow
  slots 'feed_cmd_array()'
  slots 'execute()'
  slots 'create()'
  slots 'edit()'
  slots 'delete()'
  slots 'template()'
  slots 'concatenate()'

  def initialize(chip, bus_name)
    super()
    @view = Ui_Generic_commands.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    @view.lbl_search.setPixmap(Qt::Pixmap.new('images/search.png'))
    inputRestrict(@view.lie_search, 2)
    @chip = chip
    @bus_name = bus_name
    @bus_id = Bus.find_by(name: bus_name).id
    select_chip_settings(bus_name)
    feed_cmd_array
  end

  def contextMenuEvent(event)
    if @view.tbl_cmd.currentItem.nil?
      return false
    else
      return false if @view.tbl_cmd.currentItem.column == 1
      menu = Qt::Menu.new(self)
      menu.addAction(@view.actionExecute)
      menu.addAction(@view.actionEdit)
      menu.addAction(@view.actionTemplate)
      menu.addAction(@view.actionDelete)
      menu.addAction(@view.actionConcatenate)
      menu.exec(event.globalPos())
    end
  end

  def execute
    return ErrorMsg.new.hardsploit_not_found unless HardsploitAPI.getNumberOfBoardAvailable > 0
    return ErrorMsg.new.no_cmd_selected if @view.tbl_cmd.currentItem.nil?
    cmd_array = prepare_cmd
    result = exec_cmd(@bus_name, cmd_array)
    if @view.check_result.isChecked && result != false
      export_manager = Export_manager.new(@bus_name, result, cmd_array)
      export_manager.setWindowModality(Qt::ApplicationModal)
      export_manager.show
    end
  end

  def create
    if @bus_name == 'I2C'
      cmdBase = I2c_command.new(@chip, @bus_id, self)
    else
      cmdBase = Command_editor.new(0, nil, @chip, @bus_id, self)
    end
    cmdBase.show
  end

  def edit
    return ErrorMsg.new.no_cmd_selected if @view.tbl_cmd.currentItem.nil?
    cmdBase = Command_editor.new(2, @view.tbl_cmd.currentItem.text, @chip, @bus_id, self)
    cmdBase.show
  end

  def template
    return ErrorMsg.new.no_cmd_selected if @view.tbl_cmd.currentItem.nil?
    cmdBase = Command_editor.new(1, @view.tbl_cmd.currentItem.text, @chip, @bus_id, self)
    cmdBase.show
  end

  def delete
    return ErrorMsg.new.no_cmd_selected if @view.tbl_cmd.currentItem.nil?
    msg = Qt::MessageBox.new
    msg.setWindowTitle('Delete command')
    msg.setText('Confirm the delete command action ?')
    msg.setIcon(Qt::MessageBox::Question)
    msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
    msg.setDefaultButton(Qt::MessageBox::Cancel)
    if msg.exec == Qt::MessageBox::Ok
      @chip.commands.find_by(name: @view.tbl_cmd.currentItem.text).destroy
      feed_cmd_array
    end
  end

  def concatenate
    return ErrorMsg.new.concat_disallow unless @bus_name == "I2C"
    return ErrorMsg.new.concat_nbr unless @view.tbl_cmd.selectedItems.count == 2
    cmd1 = Command.find_by(name: @view.tbl_cmd.selectedItems[0].text)
    cmd2 = Command.find_by(name: @view.tbl_cmd.selectedItems[1].text)
    return false unless check_concatenation_size(cmd1.bytes, cmd2.bytes)

    cmd_1 = @view.tbl_cmd.selectedItems[0].text
    cmd_2 = @view.tbl_cmd.selectedItems[1].text
    cmd = Command.create(
      name:        'New concatenation',
      description: "Concatenation of #{cmd1.name} and #{cmd2.name} commands",
      bus_id:      @bus_id,
      chip_id:     @chip.id
    )
    unless check_for_errors(cmd)
      cmd1.bytes.each do |b1|
        byte1 = Byte.create(
          index:        b1.index,
          value:        b1.value,
          description:  b1.description,
          iteration:    b1.iteration,
          command_id:   Command.last.id
        )
        check_for_errors(byte1)
      end
      cmd2.bytes.each do |b2|
        byte2 = Byte.create(
          index:        Byte.last.index + 1,
          value:        b2.value,
          description:  b2.description,
          iteration:    b2.iteration,
          command_id:   Command.last.id
        )
        check_for_errors(byte2)
      end
      feed_cmd_array
    end
  end

  def feed_cmd_array
    @view.tbl_cmd.clearContents
    cmd = @chip.commands.where(bus_id: @bus_id)
    unless @view.lie_search.text.empty?
      cmd = cmd.where('name LIKE ?', "%#{@view.lie_search.text}%")
    end
    @view.tbl_cmd.setRowCount(cmd.count);
    cmd.to_enum.with_index(0).each do |c, i|
      it1 = Qt::TableWidgetItem.new(c.name)
      it1.setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled)
      it2 =  Qt::TableWidgetItem.new(c.description)
      it2.setFlags(Qt::ItemIsEnabled)
      @view.tbl_cmd.setItem(i, 0, it1);
      @view.tbl_cmd.setItem(i, 1, it2);
    end
    @view.tbl_cmd.resizeColumnsToContents
    @view.tbl_cmd.resizeRowsToContents
    @view.tbl_cmd.horizontalHeader.stretchLastSection = true
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def select_chip_settings(bus)
    case bus
    when 'SPI'
      @chip_settings = SpiSetting.find_by(chip_id: @chip.id)
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
    when 'I2C'
      @chip_settings = @chip.i2c_setting
    end
  end

  def prepare_cmd
    byte_list = Byte.where(command_id: Command.find_by(name: @view.tbl_cmd.currentItem.text))
    packet = []
    byte_list.each do |bl|
      unless bl.iteration == 0 && bl.iteration.nil?
        packet.push(bl.value.to_i(16))
      else
        for i in 1..bl.iteration.to_i do
          packet.push(bl.value.to_i(16))
        end
      end
    end
    return packet
  end

  def exec_cmd(bus, array_sent)
    Firmware.new(bus)
    case bus
    when 'SPI'
      spi = HardsploitAPI_SPI.new(
        speed: @speeds[@chip.spi_setting.frequency],
        mode:  @chip.spi_setting.mode
      )
      return spi.spi_Interact(payload: array_sent)
    when 'I2C'
      if [40, 100, 400, 1000].include?(@chip.i2c_setting.frequency)
        speed = 0 if @chip.i2c_setting.frequency == 100
        speed = 1 if @chip.i2c_setting.frequency == 400
        speed = 2 if @chip.i2c_setting.frequency == 1000
        speed = 3 if @chip.i2c_setting.frequency == 40
        i2c = HardsploitAPI_I2C.new(speed: speed)
      end
      return i2c.i2c_Interact(payload: array_sent)
    end
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
    return false
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
    return false
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
    return false
  end

  def check_concatenation_size(bytes_cmd_1, bytes_cmd_2)
    check_size = []
    bytes_cmd_1.each do |b1|
      check_size.push(b1.value)
    end
    bytes_cmd_2.each do |b2|
      check_size.push(b2.value)
    end
    count = 0
    i = 0
    while i <= (check_size.size) - 1 do
      lowByte = check_size[i]
      highByte = check_size[i + 1]
      commandType = check_size[i + 2]
      count += (lowByte.to_i(16) + (highByte.to_i(16) << 8))
      if commandType.to_i(16) % 2 == 0 #WRITE
        i += ((lowByte.to_i(16) + (highByte.to_i(16) << 8)) + 3)
      else #READ
        i = (i + 3)
      end
    end
    if count > 2000
      Qt::MessageBox.new(
        Qt::MessageBox::Critical,
        'Critical error',
        'Command too big: unable to concatenate'
      ).exec
      return false
    end
    return true
  end
end
