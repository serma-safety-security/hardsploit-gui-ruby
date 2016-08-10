#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

ABSOLUTE_PATH = File.expand_path(File.dirname(__FILE__)) + "/"

Dir[ABSOLUTE_PATH + "../models/*.rb"].each {|file| require_relative file }
Dir[ABSOLUTE_PATH + "*.rb"].each {|file| require_relative file }
Dir[ABSOLUTE_PATH + "parallel/*.rb"].each {|file| require_relative file }
Dir[ABSOLUTE_PATH + "spi/*.rb"].each {|file| require_relative file }
Dir[ABSOLUTE_PATH + "i2c/*.rb"].each {|file| require_relative file }
Dir[ABSOLUTE_PATH + "swd/*.rb"].each {|file| require_relative file }
Dir[ABSOLUTE_PATH + "uart/*.rb"].each {|file| require_relative file }

class Chip_management < Qt::MainWindow
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
  slots 'import()'
  slots 'export()'
  slots 'open_signal_mapper()'

  def initialize(versionGUI)
    super()
    @view = Ui_Chip_management.new
    @view.setupUi(self)
    @view.img_search.setPixmap(Qt::Pixmap.new(File.expand_path(File.dirname(__FILE__)) + "/../images/search.png"))
    inputRestrict(@view.lie_search, 2)
    feed_chip_array
		feed_manufacturer_cbx
		feed_type_cbx
    @console = Console.new(@view.tbl_console)
    @versionGUI = versionGUI
    check_hardsploit_connection
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
    return false
  end

	def feed_type_cbx
      Manufacturer.all.each do |m|
        @view.cbx_manufacturer.addItem(m.name)
      end
	end

	def feed_manufacturer_cbx
    ChipType.all.each do |c|
      @view.cbx_type.addItem(c.name)
    end
	end

  def console_view
    sender.isChecked ? @view.tbl_console.show : @view.tbl_console.hide
  end

	def get_chip_buses(chip)
		chip_buses = []
    chip.pins.each do |pin|
      chip_buses.push(pin.signall.buses[0].name)
    end
    chip_buses.delete("NA")
		return chip_buses.uniq
	end

  def load_tree(line, column)
    return 0 unless column.zero?
    @view.tw_chip.clear
    @chip_clicked = Chip.find_by(reference: @view.tbl_chip.item(line, column).text)
    # CHIP LEVEL
    chip_lvl = Qt::TreeWidgetItem.new
    chip_lvl.setText(0, @view.tbl_chip.item(line, column).text)
    @view.tw_chip.addTopLevelItem(chip_lvl)
    chip_lvl.setExpanded(true)
    # ACTION LEVEL
    action_lvl = Qt::TreeWidgetItem.new
    action_lvl.setText(0, 'Manage')
    chip_lvl.addChild(create_action_nodes(action_lvl))
    action_lvl.setExpanded(true)

    # BUS LEVEL(S)
    chip_bus = get_chip_buses(@chip_clicked)
    chip_bus.each do |b|
      @bus_lvl = Qt::TreeWidgetItem.new
      @bus_lvl.setText(0, b)
      chip_lvl.addChild(create_bus_nodes(b, @bus_lvl))
      @bus_lvl.setExpanded(true) unless @bus_lvl.nil?
    end
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
    when 'UART'
      settings_lvl = Qt::TreeWidgetItem.new
      settings_lvl.setText(0, "Settings")
      parent_node.addChild(settings_lvl)
      console_lvl = Qt::TreeWidgetItem.new
      console_lvl.setText(0, "Console")
      parent_node.addChild(console_lvl)
    when 'SWD'
      settings_lvl = Qt::TreeWidgetItem.new
      settings_lvl.setText(0, "Settings")
      parent_node.addChild(settings_lvl)
      scan_lvl = Qt::TreeWidgetItem.new
      scan_lvl.setText(0, "PIN Scanner")
      parent_node.addChild(scan_lvl)
      detect_lvl = Qt::TreeWidgetItem.new
      detect_lvl.setText(0, "Detect")
      parent_node.addChild(detect_lvl)
      import_lvl = Qt::TreeWidgetItem.new
      import_lvl.setText(0, "Import")
      parent_node.addChild(import_lvl)
      export_lvl = Qt::TreeWidgetItem.new
      export_lvl.setText(0, "Dump")
      parent_node.addChild(export_lvl)
      erase_lvl = Qt::TreeWidgetItem.new
      erase_lvl.setText(0, "Erase")
      parent_node.addChild(erase_lvl)
    when 'SPI'
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
      sniffer_lvl = Qt::TreeWidgetItem.new
      sniffer_lvl.setText(0, "Sniffer")
      parent_node.addChild(sniffer_lvl)
    when 'I2C'
      settings_lvl = Qt::TreeWidgetItem.new
      settings_lvl.setText(0, "Settings")
      parent_node.addChild(settings_lvl)
      scanner_lvl = Qt::TreeWidgetItem.new
      scanner_lvl.setText(0, "PIN Scanner")
      parent_node.addChild(scanner_lvl)
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
    @view.tbl_chip.clearContents
    chips = filter_chips
    @view.tbl_chip.setRowCount(chips.count);
    # Insert chip table rows
    chips.to_enum.with_index(0).each do |c, i|
      # Reference
      item = Qt::TableWidgetItem.new(c.reference)
      item.setFlags(Qt::ItemIsSelectable|Qt::ItemIsEnabled)
      @view.tbl_chip.setItem(i, 0, item)
      # Chip Type
      item2 = Qt::TableWidgetItem.new(ChipType.find(c.chip_type_id).name)
      item2.setFlags(Qt::ItemIsEnabled)
      @view.tbl_chip.setItem(i, 1, item2)
      # Chip Manufacturer
      item3 = Qt::TableWidgetItem.new(Manufacturer.find(c.manufacturer_id).name)
      item3.setFlags(Qt::ItemIsEnabled)
      @view.tbl_chip.setItem(i, 2, item3)
			bus_list = get_chip_buses(c)
      bus_list_str = ''
      bus_list.each do |b|
        bus_list_str = bus_list_str + "#{b} "
      end
      # Chip Bus(es)
			item4 = Qt::TableWidgetItem.new(bus_list_str)
			item4.setFlags(Qt::ItemIsEnabled)
			@view.tbl_chip.setItem(i, 3, item4)
    end
    @view.tbl_chip.resizeColumnsToContents
    @view.tbl_chip.resizeRowsToContents
    @view.tbl_chip.horizontalHeader.stretchLastSection = true
    @view.tbl_console.horizontalHeader.stretchLastSection = true
  end

  def filter_chips
    if @view.lie_search.text.empty?
      chips = Chip.all
    else
      chips = Chip.where("reference LIKE ?", "%#{@view.lie_search.text}%")
    end
    unless @view.cbx_manufacturer.currentIndex.zero?
      man_id = Manufacturer.find_by(name: @view.cbx_manufacturer.currentText).id
      chips = chips.where(manufacturer_id: man_id)
    end
    unless @view.cbx_type.currentIndex.zero?
      type_id = ChipType.find_by(name: @view.cbx_type.currentText).id
      chips = chips.where(chip_type_id: type_id)
    end
    return chips
  end

  def load_chip_action(item, column)
    return 0 unless item.childCount.zero?
    if item.parent.text(0) == 'Manage'
      case item.text(0)
      when 'Wiring'   ; wire_chip
      when 'Edit'     ; edit_chip
      when 'Template' ; add_chip
      when 'Delete'   ; delete_chip
      end
    else
      case item.parent.text(0)
      when 'SPI'      ; load_spi_module(item.text(0))
      when 'I2C'      ; load_i2c_module(item.text(0))
      when 'PARALLEL' ; load_parallel_module(item.text(0))
      when 'SWD'      ; load_swd_module(item.text(0))
      when 'UART'     ; load_uart_module(item.text(0))
      end
    end
  end

  def load_spi_module(spi_module)
    case spi_module
    when 'Settings' ; Spi_settings.new(@chip_clicked).show
    when 'Commands' ; Generic_commands.new(@chip_clicked, 'SPI').show
    when 'Import'   ; Spi_import.new(@chip_clicked).show
    when 'Export'   ; Spi_export.new(@chip_clicked).show
    when 'Sniffer'  ; Spi_sniffer.new(@chip_clicked).show
    end
  end

  def load_i2c_module(i2c_module)
    case i2c_module
    when 'Settings'    ; I2c_settings.new(@chip_clicked).show
    when 'PIN Scanner' ; I2c_scanner.new.show
    when 'Commands'    ; Generic_commands.new(@chip_clicked, 'I2C').show
    when 'Import'      ; I2c_import.new(@chip_clicked).show
    when 'Export'      ; I2c_export.new(@chip_clicked).show
    end
  end

  def load_parallel_module(parallel_module)
    case parallel_module
    when 'Settings' ; Parallel_settings.new(@chip_clicked).show
    when 'Import'   ; Parallel_import.new(@chip_clicked).show
    when 'Export'   ; Parallel_export.new(@chip_clicked).show
    end
  end

  def load_swd_module(swd_module)
    case swd_module
    when 'Settings'     ; Swd_settings.new(@chip_clicked).show
    when 'PIN Scanner'  ; Swd_scanner.new.show
    when 'Detect'       ; Swd.new(@chip_clicked, @console).detect
    when 'Import'
      filepath = Qt::FileDialog.getOpenFileName(self, tr('Select a file'), '/')
      Swd.new(@chip_clicked, @console).import(filepath) unless filepath.nil?
    when 'Dump'
      filepath = Qt::FileDialog.getSaveFileName(self, tr('Select a file'), '/')
      Swd.new(@chip_clicked, @console).export(filepath) unless filepath.nil?
    when 'Erase'    ; Swd.new(@chip_clicked, @console).erase
    end
  end

  def load_uart_module(uart_module)
    case uart_module
    when 'Settings'
      settingsUart = Uart_settings.new(@chip_clicked)
      settingsUart.setWindowModality(Qt::ApplicationModal)
      settingsUart.show
    when 'Console'
      consoleUart = Uart_console.new(@chip_clicked)
      consoleUart.setWindowModality(Qt::ApplicationModal)
      consoleUart.show
    end
  end

  def add_chip

    if sender.objectName == 'tw_chip' or sender.objectName == 'actionTemplate'
      unless @chip_clicked.nil?
        add_chip = Chip_editor.new(self, @chip_clicked, 'temp')
      else
        ErrorMsg.new.no_chip_loaded
      end
    else
      add_chip = Chip_editor.new(self, 'none', 'new')
    end
    add_chip.show
  end

  def edit_chip
    return ErrorMsg.new.no_chip_loaded if @chip_clicked.nil?
    edit_chip = Chip_editor.new(self, @chip_clicked, 'edit')
    edit_chip.show
  end

  def delete_chip
    return ErrorMsg.new.no_chip_loaded if @chip_clicked.nil?
    msg = Qt::MessageBox.new
    msg.setWindowTitle("Delete current chip")
    msg.setText("Delete #{@chip_clicked.reference}? Commands will be deleted too.")
    msg.setIcon(Qt::MessageBox::Question)
    msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
    msg.setDefaultButton(Qt::MessageBox::Cancel)
    if msg.exec == Qt::MessageBox::Ok
      @chip_clicked.destroy
      @chip_clicked = nil
      feed_chip_array
      @view.tw_chip.clear
    end
  end

  def wire_chip
    return ErrorMsg.new.hardsploit_not_found unless HardsploitAPI.getNumberOfBoardAvailable > 0
    return ErrorMsg.new.no_chip_loaded if @chip_clicked.nil?
    wire_helper = Wire_helper.new(@chip_clicked)
    wire_helper.setWindowModality(Qt::ApplicationModal)
    wire_helper.show
  end

  def import
    if @chip_clicked.nil?
      import = Import.new(self)
    else
      import = Import.new(self, @chip_clicked)
    end
    import.setWindowModality(Qt::ApplicationModal)
    import.show
  end

  def export
    return ErrorMsg.new.no_chip_loaded if @chip_clicked.nil?
    export = Export.new(@view.tbl_chip.selectedItems)
    export.setWindowModality(Qt::ApplicationModal)
    export.show
  end

  def display_current_firmware
    if $currentFirmware.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Firmware',
        'No firmware loaded'
      ).exec
    else
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Firmware',
        "Actual firmware: #{$currentFirmware}"
      ).exec
    end
  end

  def set_firmware
    Firmware.new(sender.objectName[6, sender.objectName.length])
    display_current_firmware
  end

  def update_uc_firmware
    Firmware.new('uC')
  end

  def get_hardsploit_versions
    if HardsploitAPI.getNumberOfBoardAvailable > 0
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Hardsploit versions',
        "GUI VERSION : #{@versionGUI}\n"+
        "API VERSION : #{HardsploitAPI::VERSION::API}\n"+
        "BOARD : #{HardsploitAPI.instance.getVersionNumber}"
      ).exec
    else
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Hardsploit versions',
        "GUI VERSION : #{@versionGUI}\n "+
        "API VERSION : #{HardsploitAPI::VERSION::API}"
      ).exec
    end
  end

  def get_log_path
    msg = Qt::MessageBox.new
    msg.setWindowTitle('Log file path')
    msg.setText("Path: #{$logFilePath}")
    msg.setIcon(Qt::MessageBox::Information)
    close_btn = msg.setStandardButtons(Qt::MessageBox::Close)
    open_btn = msg.addButton('Open folder', Qt::MessageBox::ActionRole)
    open_btn.setObjectName('open_btn')
    msg.exec
    if msg.clickedButton.objectName == 'open_btn'
      system("xdg-open #{$logFilePath}")
    end
  end

	def get_db_path
    msg = Qt::MessageBox.new
    msg.setWindowTitle('Database path')
    msg.setText("Path: #{$dbFilePath}\n")
    msg.setIcon(Qt::MessageBox::Information)
    close_btn = msg.setStandardButtons(Qt::MessageBox::Close)
    open_btn = msg.addButton('Open folder', Qt::MessageBox::ActionRole)
    open_btn.setObjectName('open_btn')
    backup_btn = msg.addButton('Create backup', Qt::MessageBox::ActionRole)
    backup_btn.setObjectName('backup_btn')
    msg.exec
    if msg.clickedButton.objectName == 'backup_btn'
      system("cp #{$dbFilePath} #{$dbFilePath}.bck")
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Backup status',
        'db.bck created'
      ).exec
    end
    if msg.clickedButton.objectName == 'open_btn'
      system("xdg-open #{$dbFilePath}")
    end
	end

	def get_hardsploit_website
		Qt::MessageBox.new(
      Qt::MessageBox::Information,
      'Hardsploit website',
      'Find all the news about Hardsploit on our website: http://hardsploit.io'
    ).exec
	end

  def open_signal_mapper
    signal_mapper = Signal_mapper.new
    signal_mapper.setWindowModality(Qt::ApplicationModal)
    signal_mapper.show
  end

  def check_hardsploit_connection
    if HardsploitAPI.getNumberOfBoardAvailable > 0
      HardsploitAPI.id = ARGV[0].to_i
      @console.print(
        "Hardsploit board detected GUI V#{@versionGUI} "+
        "API V#{HardsploitAPI::VERSION::API} "+
        "BOARD : #{HardsploitAPI.instance.getVersionNumber}"
      )
      @console.print('Hardsploit ready to suck chip souls !')
    else
      @console.print(
        'Hardsploit board unconnected: '+
        'Wiring and command execution disabled'
      )
    end
  end
end
