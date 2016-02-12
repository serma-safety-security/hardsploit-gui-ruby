#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../HardsploitAPI/HardsploitAPI'
class HardsploitGUI < Qt::MainWindow
  VERSION = "2.1"
  slots 'load_tree(int, int)'
  slots 'load_chip_action(QTreeWidgetItem*, int)'
  slots 'feed_chip_array()'
  slots 'update_uc_firmware()'
  slots 'get_hardsploit_versions()'
  slots 'get_log_path()'
  slots 'get_db_path()'
  slots 'get_hardsploit_website()'
  slots 'set_firmware()'
  slots 'display_current_firmware()'
  slots 'console_view()'
  slots 'add_chip()'
  slots 'edit_chip()'
  slots 'wire_chip()'
  slots 'delete_chip()'
  slots 'swd_detect()'
  slots 'swd_import()'
  slots 'swd_export()'
  slots 'swd_erase()'

  def initialize(api)
    super()
    @cm = Ui_Chip_management.new
    @cm.setupUi(self)
    @api = api
    @cm.img_search.setPixmap(Qt::Pixmap.new(File.expand_path(File.dirname(__FILE__)) + "/../images/search.png"))
    inputRestrict(@cm.lie_search, 2)
    feed_chip_array
		feed_manufacturer_cbx
		feed_type_cbx
    @cm.tbl_chip.resizeColumnsToContents
    @cm.tbl_chip.resizeRowsToContents
    @cm.tbl_chip.horizontalHeader.stretchLastSection = true
    @cm.tbl_console.horizontalHeader.stretchLastSection = true
    @console = Console.new(@cm.tbl_console)
    check_hardsploit_connection(api)
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "GUI Error", "Error while loading Hardsploit GUI").exec
  end

	def feed_type_cbx
      manufacturer = Manufacturer.all
      manufacturer.each do |m|
        @cm.cbx_manufacturer.addItem(m.manufacturer_name)
      end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Error while loading the manufacturer list from the database").exec
	end

	def feed_manufacturer_cbx
    cType = CType.all
    cType.each do |c|
      @cm.cbx_type.addItem(c.cType_name)
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Error while loading the type list from the database").exec
	end

  def console_view
    if @cm.check_console.isChecked
      @cm.tbl_console.show
    else
      @cm.tbl_console.hide
    end
  end

	def get_chip_buses(chip)
		chip_bus_name = []
		chip_bus_id = []
		chipSignalId = chip.pin.pluck(:pin_signal)
    chipSignalId.delete(62) # NA
    chipSignalId.each do |s|
      chip_bus_id.push(Use.find_by(signal_id: s).bus_id)
    end
    chip_bus_id.uniq.each do |b|
     chip_bus_name.push(Bus.find_by(bus_id: b).bus_name)
    end
		return chip_bus_name
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Error while getting the bus list").exec
	end

  def load_tree(line, column)
    return 0 unless column.zero?
    @cm.tw_chip.clear
    @chip_clicked = Chip.find_by(chip_reference: @cm.tbl_chip.item(line, column).text)
    # CHIP LEVEL
    chip_lvl = Qt::TreeWidgetItem.new
    chip_lvl.setText(0, @cm.tbl_chip.item(line, column).text)
    # ACTION LEVEL
    action_lvl = Qt::TreeWidgetItem.new
    action_lvl.setText(0, 'Manage')
    chip_lvl.addChild(create_action_nodes(action_lvl))
    # BUS LEVEL(S)
    chip_bus = get_chip_buses(@chip_clicked)
    chip_bus.each do |b|
      bus_lvl = Qt::TreeWidgetItem.new
      bus_lvl.setText(0, b)
      chip_lvl.addChild(create_bus_nodes(b, bus_lvl))
    end
    # ADD THE PARENT NODE
    @cm.tw_chip.addTopLevelItem(chip_lvl)
  end

  def create_action_nodes(parent_node)
    wiring_lvl = Qt::TreeWidgetItem.new
    wiring_lvl.setText(0, "Wiring")
    parent_node.addChild(wiring_lvl)
    edit_lvl = Qt::TreeWidgetItem.new
    edit_lvl.setText(0, "Edit")
    parent_node.addChild(edit_lvl)
    template_lvl = Qt::TreeWidgetItem.new
    template_lvl.setText(0, "Template")
    parent_node.addChild(template_lvl)
    delete_lvl = Qt::TreeWidgetItem.new
    delete_lvl.setText(0, "Delete")
    parent_node.addChild(delete_lvl)
    return parent_node
  end

  def create_bus_nodes(bus, parent_node)
    case bus
    when 'SPI', 'I2C'
      settings_lvl = Qt::TreeWidgetItem.new
      settings_lvl.setText(0, "Settings")
      parent_node.addChild(settings_lvl)
      cmd_lvl = Qt::TreeWidgetItem.new
      cmd_lvl.setText(0, "Commands")
      parent_node.addChild(cmd_lvl)
      import_lvl = Qt::TreeWidgetItem.new
      import_lvl.setText(0, "Import")
      parent_node.addChild(import_lvl)
      export_lvl = Qt::TreeWidgetItem.new
      export_lvl.setText(0, "Export")
      parent_node.addChild(export_lvl)
    when 'PARALLEL'
      settings_lvl = Qt::TreeWidgetItem.new
      settings_lvl.setText(0, "Settings")
      parent_node.addChild(settings_lvl)
      # Not implemented yet
      #import_lvl = Qt::TreeWidgetItem.new
      #import_lvl.setText(0, "Import")
      #parent_node.addChild(import_lvl)
      export_lvl = Qt::TreeWidgetItem.new
      export_lvl.setText(0, "Export")
      parent_node.addChild(export_lvl)
    end
    return parent_node
  end

  def feed_chip_array
    @cm.tbl_chip.clearContents
    ref = @cm.lie_search.text
    if @cm.cbx_manufacturer.currentIndex != 0
      manufacturer = Manufacturer.find_by(manufacturer_name: @cm.cbx_manufacturer.currentText).manufacturer_id
    end
    if @cm.cbx_type.currentIndex != 0
      type = CType.find_by(cType_name: @cm.cbx_type.currentText).cType_id
    end
    if ref.empty?
      chip = Chip.all
    else
      chip = Chip.where("chip_reference LIKE ?", "%#{ref}%")
    end
    chip = chip.where("chip_manufacturer = ?", manufacturer) unless manufacturer.nil?
    chip = chip.where("chip_type = ?", type) unless type.nil?
    @cm.tbl_chip.setRowCount(chip.count);
    # Insert elements
    chip.to_enum.with_index(0).each do |c, i|
      item = Qt::TableWidgetItem.new(c.chip_reference)
      item.setFlags(Qt::ItemIsSelectable|Qt::ItemIsEnabled)
      @cm.tbl_chip.setItem(i, 0, item)

      item2 = Qt::TableWidgetItem.new(CType.find(c.chip_type).cType_name)
      item2.setFlags(Qt::ItemIsEnabled)
      @cm.tbl_chip.setItem(i, 1, item2)

      item3 = Qt::TableWidgetItem.new(Manufacturer.find(c.chip_manufacturer).manufacturer_name)
      item3.setFlags(Qt::ItemIsEnabled)
      @cm.tbl_chip.setItem(i, 2, item3)
			bus_list = get_chip_buses(c)
      bus_list_str = ''
      bus_list.each do |b|
        bus_list_str = bus_list_str + "#{b} "
      end

			item4 = Qt::TableWidgetItem.new(bus_list_str)
			item4.setFlags(Qt::ItemIsEnabled)
			@cm.tbl_chip.setItem(i, 3, item4)
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while loading the chip array").exec
  end

  def load_chip_action(item, column)
    return 0 unless item.childCount.zero?
    if item.parent.text(0) == 'Manage'
      case item.text(0)
      when 'Wiring'
        wire_chip
      when 'Edit'
        edit_chip
      when 'Template'
        add_chip
      when 'Delete'
        delete_chip
      end
    else
      case item.parent.text(0)
      when 'SPI'
        load_spi_module(item.text(0))
      when 'I2C'
        load_i2c_module(item.text(0))
      when 'PARALLEL'
        load_parallel_module(item.text(0))
      when 'SWD'
        load_swd_module(item.text(0))
      end
    end
  end

  def load_spi_module(spi_module)
    case spi_module
    when 'Settings'
      spi_settings_window = Spi_settings.new(@chip_clicked)
      spi_settings_window.show
    when 'Commands'
      generic_command_window = Generic_commands.new(@api, @chip_clicked, 'SPI')
      generic_command_window.show
    when 'Import'
      spi_import_window = Spi_import.new(@api, @chip_clicked)
      spi_import_window.show
    when 'Export'
      spi_export_window = Spi_export.new(@api, @chip_clicked)
      spi_export_window.show
    end
  end

  def load_i2c_module(i2c_module)
    case i2c_module
    when 'Settings'
      bus_settings_window = I2c_settings.new(@api, @chip_clicked)
      bus_settings_window.show
    when 'Commands'
      bus_command_window = Generic_commands.new(@api, @chip_clicked, 'I2C')
      bus_command_window.show
    when 'Import'
      bus_import_window = I2c_import.new(@api, @chip_clicked)
      bus_import_window.show
    when 'Export'
      bus_export_window = I2c_export.new(@api, @chip_clicked)
      bus_export_window.show
    end
  end

  def load_parallel_module(parallel_module)
    case parallel_module
    when 'Settings'
      bus_settings_window = Parallel_settings.new(@chip_clicked)
      bus_settings_window.show
    when 'Import'
      bus_import_window = Parallel_import.new(@api, @chip_clicked)
      bus_import_window.show
    when 'Export'
      bus_export_window = Parallel_export.new(@api, @chip_clicked)
      bus_export_window.show
    end
  end

  def add_chip
    if sender.objectName == 'tw_chip'
      unless @chip_clicked.nil?
        add_chip = Chip_editor.new(self, @chip_clicked, 'temp')
      else
        Qt::MessageBox.new(Qt::MessageBox::Information, "Chip template", "No chip loaded").exec
        return 0
      end
    else
      add_chip = Chip_editor.new(self, 'none', 'new')
    end
    add_chip.setWindowModality(Qt::ApplicationModal)
    add_chip.show
  end

  def edit_chip
    unless @chip_clicked.nil?
      edit_chip = Chip_editor.new(self, @chip_clicked, 'edit')
      edit_chip.setWindowModality(Qt::ApplicationModal)
      edit_chip.show
    else
      Qt::MessageBox.new(Qt::MessageBox::Information, "Edit chip", "No chip loaded").exec
    end
  end

  def delete_chip
    unless @chip_clicked.nil?
      msg = Qt::MessageBox.new
      msg.setWindowTitle("Delete this chip")
      msg.setText("By deleting this chip, all the commands linked to it will be deleted too. Continue ?")
      msg.setIcon(Qt::MessageBox::Question)
      msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
      msg.setDefaultButton(Qt::MessageBox::Cancel)
      if msg.exec == Qt::MessageBox::Ok
        @chip_clicked.destroy
        feed_chip_array
        @cm.tw_chip.clear
      end
    else
      Qt::MessageBox.new(Qt::MessageBox::Information, "Delete chip", "No chip loaded").exec
    end
  end

  def wire_chip
    unless @chip_clicked.nil?
      wire_helper = Wire_helper.new(@chip_clicked, @api)
      wire_helper.setWindowModality(Qt::ApplicationModal)
      wire_helper.show
    else
      Qt::MessageBox.new(Qt::MessageBox::Information, "Wire chip", "No chip loaded").exec
    end
  end

  def swd_detect
    Firmware.new(@api, 'SWD')
    @api.runSWD
    code = @api.obtainCodes
    @console.print('New action: SWD Detect')
    Qt::MessageBox.new(Qt::MessageBox::Information, "SWD detection", "Detected:\nDP.IDCODE: #{code[:DebugPortId].to_s(16)}\nAP.IDCODE: #{code[:AccessPortId].to_s(16)}\nCPU ID : #{code[:CpuId].to_s(16)}\nDEVICE ID : #{code[:DeviceId].to_s(16)}").exec
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "No device found, check the wiring").exec
  end

  def swd_export
    Firmware.new(@api, 'SWD')
    @api.runSWD
    filepath = Qt::FileDialog.getSaveFileName(self, tr('Select a file'), '/', tr('Bin file (*.bin)'))
    unless filepath.nil?
      @api.dumpFlash(filepath)
      Qt::MessageBox.new(Qt::MessageBox::Information, "Export status", "Dump finished").exec
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "No device found, check the wiring").exec
  end

  def swd_import
    Firmware.new(@api, 'SWD')
    @api.runSWD
    filepath = Qt::FileDialog.getOpenFileName(self, tr('Select a file'), '/')
    unless filepath.nil?
      @api.writeFlash(filepath)
      Qt::MessageBox.new(Qt::MessageBox::Information, "Import status", "Import finished").exec
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "No device found, check the wiring").exec
  end

  def swd_erase
    msg = Qt::MessageBox.new
    msg.setWindowTitle("Delete the data")
    msg.setText("You are going to delete all the data. Continue?")
    msg.setIcon(Qt::MessageBox::Critical)
    msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
    msg.setDefaultButton(Qt::MessageBox::Cancel)
    if msg.exec == Qt::MessageBox::Ok
      Firmware.new(@api, 'SWD')
      @api.runSWD
      @api.eraseFlash
      Qt::MessageBox.new(Qt::MessageBox::Information, "Erase status", "Erase finished").exec
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "No device found, check the wiring").exec
  end

  def display_current_firmware
    if $currentFirmware.nil?
      Qt::MessageBox.new(Qt::MessageBox::Information, "Firmware", "No firmware loaded").exec
    else
      Qt::MessageBox.new(Qt::MessageBox::Information, "Firmware", "Actual firmware: #{$currentFirmware}").exec
    end
  end

  def set_firmware
    Firmware.new(@api,sender.objectName[6, sender.objectName.length])
    Qt::MessageBox.new(Qt::MessageBox::Information, "Firmware", "#{sender.objectName[6, sender.objectName.length]} firmware loaded").exec
  end

  def update_uc_firmware
      msg = Qt::MessageBox.new
      msg.setWindowTitle("Microcontroler update")
      msg.setText("Hardsploit must be launch in bootloader mod and dfu-util package must be installed in order to continue. Proceed ?")
      msg.setIcon(Qt::MessageBox::Question)
      msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
      msg.setDefaultButton(Qt::MessageBox::Cancel)
      if msg.exec == Qt::MessageBox::Ok
        system("dfu-util -D 0483:df11 -a 0 -s 0x08000000 -R --download #{File.expand_path(File.dirname(__FILE__))}'/../Firmware/UC/HARDSPLOIT_FIRMWARE_UC.bin'")
      end
  end

  def get_hardsploit_versions
    if $usbConnected == true
      Qt::MessageBox.new(Qt::MessageBox::Information, "Hardsploit versions", "GUI VERSION : #{VERSION}\nAPI VERSION : #{HardsploitAPI::VERSION::API}\nBOARD : #{@api.getVersionNumber}").exec
    else
      Qt::MessageBox.new(Qt::MessageBox::Information, "Hardsploit versions", "GUI VERSION : #{VERSION}\nAPI VERSION : #{HardsploitAPI::VERSION::API}").exec
    end
  end

  def get_log_path
    Qt::MessageBox.new(Qt::MessageBox::Information, 'Log path', "#{$logFilePath}").exec
  end

	def get_db_path
		Qt::MessageBox.new(Qt::MessageBox::Information, 'Database path', "#{$dbFilePath}").exec
	end

	def get_hardsploit_website
		Qt::MessageBox.new(Qt::MessageBox::Information, 'Hardsploit website', 'Find all the new about Hardsploit on our website: http://hardsploit.io').exec
	end

  def check_hardsploit_connection(api)
    case api.connect
    when HardsploitAPI::USB_STATE::NOT_CONNECTED
      $usbConnected = false
      @console.print('Hardsploit board unconnected, wiring and command execution disabled')
    when HardsploitAPI::USB_STATE::UNKNOWN_CONNECTED
      @console.print('The device may be BUSY or a another device with the same IdVendor and IdProduct was found')
    when HardsploitAPI::USB_STATE::CONNECTED
      $usbConnected = true
      api.startFPGA
      @console.print("Hardsploit board detected GUI V#{VERSION} API V#{HardsploitAPI::VERSION::API} BOARD : #{api.getVersionNumber}")
      @console.print('Hardsploit ready to suck chip souls !')
    else
      @console.print('You are in the else part of a case that should normally never be triggered. Good luck.')
    end
  end
end
