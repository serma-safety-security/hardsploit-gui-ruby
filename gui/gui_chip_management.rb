=begin
** Form generated from reading ui file 'gui_chip_management.ui'
**
** Created: mer. déc. 16 13:41:26 2015
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Chip_management
    attr_reader :actionVersions
    attr_reader :actionDatabase_file
    attr_reader :actionError_log_file
    attr_reader :actionUC
    attr_reader :actionParallel
    attr_reader :actionI2C
    attr_reader :actionSPI
    attr_reader :actionHardsploit_website
    attr_reader :actionAdd
    attr_reader :actionEdit
    attr_reader :actionDelete
    attr_reader :actionExport_current
    attr_reader :actionDisplay_firmware
    attr_reader :actionWire
    attr_reader :actionSWD_detect
    attr_reader :actionSWD_export
    attr_reader :actionSWD_import
    attr_reader :actionSWD_erase
    attr_reader :cl_main
    attr_reader :gridLayout
    attr_reader :hl_main
    attr_reader :tw_chip
    attr_reader :vl_body
    attr_reader :hl_filters
    attr_reader :img_search
    attr_reader :lie_search
    attr_reader :cbx_manufacturer
    attr_reader :cbx_type
    attr_reader :vl_array
    attr_reader :tbl_chip
    attr_reader :hl_options
    attr_reader :lbl_info
    attr_reader :horizontalSpacer
    attr_reader :btn_add
    attr_reader :tbl_console
    attr_reader :horizontalLayout
    attr_reader :check_console
    attr_reader :pushButton
    attr_reader :horizontalSpacer_2
    attr_reader :menubar
    attr_reader :menuMenu
    attr_reader :menuUpload_firmware
    attr_reader :menuComponent
    attr_reader :menuAbout
    attr_reader :menuPath
    attr_reader :menuSWD
    attr_reader :statusbar

    def setupUi(chip_management)
    if chip_management.objectName.nil?
        chip_management.objectName = "chip_management"
    end
    chip_management.resize(710, 589)
    chip_management.minimumSize = Qt::Size.new(710, 450)
    icon = Qt::Icon.new
    icon.addPixmap(Qt::Pixmap.new("../../../../.designer/images/logoOpale_ico.ico"), Qt::Icon::Normal, Qt::Icon::Off)
    chip_management.windowIcon = icon
    @actionVersions = Qt::Action.new(chip_management)
    @actionVersions.objectName = "actionVersions"
    @actionDatabase_file = Qt::Action.new(chip_management)
    @actionDatabase_file.objectName = "actionDatabase_file"
    @actionError_log_file = Qt::Action.new(chip_management)
    @actionError_log_file.objectName = "actionError_log_file"
    @actionUC = Qt::Action.new(chip_management)
    @actionUC.objectName = "actionUC"
    @actionParallel = Qt::Action.new(chip_management)
    @actionParallel.objectName = "actionParallel"
    @actionI2C = Qt::Action.new(chip_management)
    @actionI2C.objectName = "actionI2C"
    @actionSPI = Qt::Action.new(chip_management)
    @actionSPI.objectName = "actionSPI"
    @actionHardsploit_website = Qt::Action.new(chip_management)
    @actionHardsploit_website.objectName = "actionHardsploit_website"
    @actionAdd = Qt::Action.new(chip_management)
    @actionAdd.objectName = "actionAdd"
    @actionEdit = Qt::Action.new(chip_management)
    @actionEdit.objectName = "actionEdit"
    @actionDelete = Qt::Action.new(chip_management)
    @actionDelete.objectName = "actionDelete"
    @actionExport_current = Qt::Action.new(chip_management)
    @actionExport_current.objectName = "actionExport_current"
    @actionDisplay_firmware = Qt::Action.new(chip_management)
    @actionDisplay_firmware.objectName = "actionDisplay_firmware"
    @actionWire = Qt::Action.new(chip_management)
    @actionWire.objectName = "actionWire"
    @actionSWD_detect = Qt::Action.new(chip_management)
    @actionSWD_detect.objectName = "actionSWD_detect"
    @actionSWD_export = Qt::Action.new(chip_management)
    @actionSWD_export.objectName = "actionSWD_export"
    @actionSWD_import = Qt::Action.new(chip_management)
    @actionSWD_import.objectName = "actionSWD_import"
    @actionSWD_erase = Qt::Action.new(chip_management)
    @actionSWD_erase.objectName = "actionSWD_erase"
    @cl_main = Qt::Widget.new(chip_management)
    @cl_main.objectName = "cl_main"
    @gridLayout = Qt::GridLayout.new(@cl_main)
    @gridLayout.objectName = "gridLayout"
    @hl_main = Qt::HBoxLayout.new()
    @hl_main.objectName = "hl_main"
    @tw_chip = Qt::TreeWidget.new(@cl_main)
    @tw_chip.objectName = "tw_chip"
    @tw_chip.minimumSize = Qt::Size.new(150, 0)
    @tw_chip.maximumSize = Qt::Size.new(150, 16777215)

    @hl_main.addWidget(@tw_chip)

    @vl_body = Qt::VBoxLayout.new()
    @vl_body.objectName = "vl_body"
    @hl_filters = Qt::HBoxLayout.new()
    @hl_filters.objectName = "hl_filters"
    @img_search = Qt::Label.new(@cl_main)
    @img_search.objectName = "img_search"

    @hl_filters.addWidget(@img_search)

    @lie_search = Qt::LineEdit.new(@cl_main)
    @lie_search.objectName = "lie_search"

    @hl_filters.addWidget(@lie_search)

    @cbx_manufacturer = Qt::ComboBox.new(@cl_main)
    @cbx_manufacturer.objectName = "cbx_manufacturer"
    @cbx_manufacturer.minimumSize = Qt::Size.new(200, 0)
    @cbx_manufacturer.maximumSize = Qt::Size.new(16777215, 16777215)

    @hl_filters.addWidget(@cbx_manufacturer)

    @cbx_type = Qt::ComboBox.new(@cl_main)
    @cbx_type.objectName = "cbx_type"
    @cbx_type.minimumSize = Qt::Size.new(100, 0)
    @cbx_type.maximumSize = Qt::Size.new(100, 16777215)

    @hl_filters.addWidget(@cbx_type)


    @vl_body.addLayout(@hl_filters)

    @vl_array = Qt::VBoxLayout.new()
    @vl_array.objectName = "vl_array"
    @tbl_chip = Qt::TableWidget.new(@cl_main)
    @tbl_chip.objectName = "tbl_chip"

    @vl_array.addWidget(@tbl_chip)


    @vl_body.addLayout(@vl_array)

    @hl_options = Qt::HBoxLayout.new()
    @hl_options.objectName = "hl_options"
    @lbl_info = Qt::Label.new(@cl_main)
    @lbl_info.objectName = "lbl_info"

    @hl_options.addWidget(@lbl_info)

    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl_options.addItem(@horizontalSpacer)

    @btn_add = Qt::PushButton.new(@cl_main)
    @btn_add.objectName = "btn_add"

    @hl_options.addWidget(@btn_add)


    @vl_body.addLayout(@hl_options)


    @hl_main.addLayout(@vl_body)


    @gridLayout.addLayout(@hl_main, 2, 0, 1, 1)

    @tbl_console = Qt::TableWidget.new(@cl_main)
    @tbl_console.objectName = "tbl_console"
    @tbl_console.minimumSize = Qt::Size.new(0, 100)
    @tbl_console.maximumSize = Qt::Size.new(16777215, 100)

    @gridLayout.addWidget(@tbl_console, 6, 0, 1, 1)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @check_console = Qt::CheckBox.new(@cl_main)
    @check_console.objectName = "check_console"
    @check_console.checked = true

    @horizontalLayout.addWidget(@check_console)

    @pushButton = Qt::PushButton.new(@cl_main)
    @pushButton.objectName = "pushButton"

    @horizontalLayout.addWidget(@pushButton)

    @horizontalSpacer_2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout.addItem(@horizontalSpacer_2)


    @gridLayout.addLayout(@horizontalLayout, 4, 0, 1, 1)

    chip_management.centralWidget = @cl_main
    @menubar = Qt::MenuBar.new(chip_management)
    @menubar.objectName = "menubar"
    @menubar.geometry = Qt::Rect.new(0, 0, 710, 21)
    @menuMenu = Qt::Menu.new(@menubar)
    @menuMenu.objectName = "menuMenu"
    @menuUpload_firmware = Qt::Menu.new(@menuMenu)
    @menuUpload_firmware.objectName = "menuUpload_firmware"
    @menuComponent = Qt::Menu.new(@menuMenu)
    @menuComponent.objectName = "menuComponent"
    @menuAbout = Qt::Menu.new(@menubar)
    @menuAbout.objectName = "menuAbout"
    @menuPath = Qt::Menu.new(@menuAbout)
    @menuPath.objectName = "menuPath"
    @menuSWD = Qt::Menu.new(@menubar)
    @menuSWD.objectName = "menuSWD"
    chip_management.setMenuBar(@menubar)
    @statusbar = Qt::StatusBar.new(chip_management)
    @statusbar.objectName = "statusbar"
    chip_management.statusBar = @statusbar

    @menubar.addAction(@menuMenu.menuAction())
    @menubar.addAction(@menuSWD.menuAction())
    @menubar.addAction(@menuAbout.menuAction())
    @menuMenu.addAction(@menuUpload_firmware.menuAction())
    @menuMenu.addAction(@menuComponent.menuAction())
    @menuUpload_firmware.addAction(@actionDisplay_firmware)
    @menuUpload_firmware.addAction(@actionParallel)
    @menuUpload_firmware.addAction(@actionI2C)
    @menuUpload_firmware.addAction(@actionSPI)
    @menuUpload_firmware.addSeparator()
    @menuUpload_firmware.addAction(@actionUC)
    @menuComponent.addAction(@actionAdd)
    @menuComponent.addAction(@actionEdit)
    @menuComponent.addAction(@actionDelete)
    @menuComponent.addAction(@actionExport_current)
    @menuComponent.addAction(@actionWire)
    @menuAbout.addAction(@actionHardsploit_website)
    @menuAbout.addAction(@actionVersions)
    @menuAbout.addAction(@menuPath.menuAction())
    @menuPath.addAction(@actionDatabase_file)
    @menuPath.addAction(@actionError_log_file)
    @menuSWD.addAction(@actionSWD_detect)
    @menuSWD.addAction(@actionSWD_export)
    @menuSWD.addAction(@actionSWD_import)
    @menuSWD.addAction(@actionSWD_erase)

    retranslateUi(chip_management)
    Qt::Object.connect(@tbl_chip, SIGNAL('cellDoubleClicked(int,int)'), chip_management, SLOT('load_tree(int,int)'))
    Qt::Object.connect(@lie_search, SIGNAL('textEdited(QString)'), chip_management, SLOT('feed_chip_array()'))
    Qt::Object.connect(@cbx_manufacturer, SIGNAL('currentIndexChanged(int)'), chip_management, SLOT('feed_chip_array()'))
    Qt::Object.connect(@cbx_type, SIGNAL('currentIndexChanged(int)'), chip_management, SLOT('feed_chip_array()'))
    Qt::Object.connect(@actionError_log_file, SIGNAL('triggered()'), chip_management, SLOT('get_log_path()'))
    Qt::Object.connect(@actionHardsploit_website, SIGNAL('triggered()'), chip_management, SLOT('get_hardsploit_website()'))
    Qt::Object.connect(@actionI2C, SIGNAL('triggered()'), chip_management, SLOT('set_firmware()'))
    Qt::Object.connect(@actionParallel, SIGNAL('triggered()'), chip_management, SLOT('set_firmware()'))
    Qt::Object.connect(@actionSPI, SIGNAL('triggered()'), chip_management, SLOT('set_firmware()'))
    Qt::Object.connect(@actionUC, SIGNAL('triggered()'), chip_management, SLOT('update_uc_firmware()'))
    Qt::Object.connect(@actionVersions, SIGNAL('triggered()'), chip_management, SLOT('get_hardsploit_versions()'))
    Qt::Object.connect(@actionDatabase_file, SIGNAL('triggered()'), chip_management, SLOT('get_db_path()'))
    Qt::Object.connect(@check_console, SIGNAL('toggled(bool)'), chip_management, SLOT('console_view()'))
    Qt::Object.connect(@btn_add, SIGNAL('clicked()'), chip_management, SLOT('add_chip()'))
    Qt::Object.connect(@tw_chip, SIGNAL('itemDoubleClicked(QTreeWidgetItem*,int)'), chip_management, SLOT('load_chip_action(QTreeWidgetItem*,int)'))
    Qt::Object.connect(@actionDisplay_firmware, SIGNAL('triggered()'), chip_management, SLOT('display_current_firmware()'))
    Qt::Object.connect(@actionAdd, SIGNAL('triggered()'), chip_management, SLOT('add_chip()'))
    Qt::Object.connect(@actionDelete, SIGNAL('triggered()'), chip_management, SLOT('delete_chip()'))
    Qt::Object.connect(@actionEdit, SIGNAL('triggered()'), chip_management, SLOT('edit_chip()'))
    Qt::Object.connect(@actionWire, SIGNAL('triggered()'), chip_management, SLOT('wire_chip()'))
    Qt::Object.connect(@pushButton, SIGNAL('clicked()'), @tbl_console, SLOT('clearContents()'))
    Qt::Object.connect(@actionSWD_detect, SIGNAL('triggered()'), chip_management, SLOT('swd_detect()'))
    Qt::Object.connect(@actionSWD_export, SIGNAL('triggered()'), chip_management, SLOT('swd_export()'))
    Qt::Object.connect(@actionSWD_import, SIGNAL('triggered()'), chip_management, SLOT('swd_import()'))
    Qt::Object.connect(@actionSWD_erase, SIGNAL('triggered()'), chip_management, SLOT('swd_erase()'))

    Qt::MetaObject.connectSlotsByName(chip_management)
    end # setupUi

    def setup_ui(chip_management)
        setupUi(chip_management)
    end

    def retranslateUi(chip_management)
    chip_management.windowTitle = Qt::Application.translate("Chip_management", "Hardsploit - Chip management", nil, Qt::Application::UnicodeUTF8)
    @actionVersions.text = Qt::Application.translate("Chip_management", "Versions", nil, Qt::Application::UnicodeUTF8)
    @actionDatabase_file.text = Qt::Application.translate("Chip_management", "Database file", nil, Qt::Application::UnicodeUTF8)
    @actionError_log_file.text = Qt::Application.translate("Chip_management", "Error log file", nil, Qt::Application::UnicodeUTF8)
    @actionUC.text = Qt::Application.translate("Chip_management", "Update uC", nil, Qt::Application::UnicodeUTF8)
    @actionParallel.text = Qt::Application.translate("Chip_management", "Set parallel", nil, Qt::Application::UnicodeUTF8)
    @actionI2C.text = Qt::Application.translate("Chip_management", "Set I\302\262C", nil, Qt::Application::UnicodeUTF8)
    @actionSPI.text = Qt::Application.translate("Chip_management", "Set SPI", nil, Qt::Application::UnicodeUTF8)
    @actionHardsploit_website.text = Qt::Application.translate("Chip_management", "Hardsploit website", nil, Qt::Application::UnicodeUTF8)
    @actionAdd.text = Qt::Application.translate("Chip_management", "Add new", nil, Qt::Application::UnicodeUTF8)
    @actionAdd.shortcut = Qt::Application.translate("Chip_management", "Ctrl+A", nil, Qt::Application::UnicodeUTF8)
    @actionEdit.text = Qt::Application.translate("Chip_management", "Edit", nil, Qt::Application::UnicodeUTF8)
    @actionEdit.shortcut = Qt::Application.translate("Chip_management", "Ctrl+E", nil, Qt::Application::UnicodeUTF8)
    @actionDelete.text = Qt::Application.translate("Chip_management", "Delete", nil, Qt::Application::UnicodeUTF8)
    @actionDelete.shortcut = Qt::Application.translate("Chip_management", "Ctrl+D", nil, Qt::Application::UnicodeUTF8)
    @actionExport_current.text = Qt::Application.translate("Chip_management", "Export", nil, Qt::Application::UnicodeUTF8)
    @actionDisplay_firmware.text = Qt::Application.translate("Chip_management", "Display current firmware", nil, Qt::Application::UnicodeUTF8)
    @actionDisplay_firmware.shortcut = Qt::Application.translate("Chip_management", "Ctrl+F", nil, Qt::Application::UnicodeUTF8)
    @actionWire.text = Qt::Application.translate("Chip_management", "Wire", nil, Qt::Application::UnicodeUTF8)
    @actionWire.shortcut = Qt::Application.translate("Chip_management", "Ctrl+W", nil, Qt::Application::UnicodeUTF8)
    @actionSWD_detect.text = Qt::Application.translate("Chip_management", "Detect", nil, Qt::Application::UnicodeUTF8)
    @actionSWD_export.text = Qt::Application.translate("Chip_management", "Export (Dump)", nil, Qt::Application::UnicodeUTF8)
    @actionSWD_import.text = Qt::Application.translate("Chip_management", "Import (Write)", nil, Qt::Application::UnicodeUTF8)
    @actionSWD_erase.text = Qt::Application.translate("Chip_management", "Erase", nil, Qt::Application::UnicodeUTF8)
    @tw_chip.headerItem.setText(0, Qt::Application.translate("Chip_management", "Current chip", nil, Qt::Application::UnicodeUTF8))
    @img_search.text = Qt::Application.translate("Chip_management", "Search", nil, Qt::Application::UnicodeUTF8)
    @cbx_manufacturer.insertItems(0, [Qt::Application.translate("Chip_management", "Manufacturer...", nil, Qt::Application::UnicodeUTF8)])
    @cbx_type.insertItems(0, [Qt::Application.translate("Chip_management", "Type...", nil, Qt::Application::UnicodeUTF8)])
    if @tbl_chip.columnCount < 4
        @tbl_chip.columnCount = 4
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("Chip_management", "Reference", nil, Qt::Application::UnicodeUTF8))
    @tbl_chip.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("Chip_management", "Type", nil, Qt::Application::UnicodeUTF8))
    @tbl_chip.setHorizontalHeaderItem(1, __colItem1)

    __colItem2 = Qt::TableWidgetItem.new
    __colItem2.setText(Qt::Application.translate("Chip_management", "Manufacturer", nil, Qt::Application::UnicodeUTF8))
    @tbl_chip.setHorizontalHeaderItem(2, __colItem2)

    __colItem3 = Qt::TableWidgetItem.new
    __colItem3.setText(Qt::Application.translate("Chip_management", "BUS", nil, Qt::Application::UnicodeUTF8))
    @tbl_chip.setHorizontalHeaderItem(3, __colItem3)
    @lbl_info.text = Qt::Application.translate("Chip_management", "Double click a chip reference to load it", nil, Qt::Application::UnicodeUTF8)
    @btn_add.text = Qt::Application.translate("Chip_management", "Create component", nil, Qt::Application::UnicodeUTF8)
    if @tbl_console.columnCount < 2
        @tbl_console.columnCount = 2
    end

    __colItem4 = Qt::TableWidgetItem.new
    __colItem4.setText(Qt::Application.translate("Chip_management", "Date / Time", nil, Qt::Application::UnicodeUTF8))
    @tbl_console.setHorizontalHeaderItem(0, __colItem4)

    __colItem5 = Qt::TableWidgetItem.new
    __colItem5.setText(Qt::Application.translate("Chip_management", "Message", nil, Qt::Application::UnicodeUTF8))
    @tbl_console.setHorizontalHeaderItem(1, __colItem5)
    @check_console.text = Qt::Application.translate("Chip_management", "Console:", nil, Qt::Application::UnicodeUTF8)
    @pushButton.text = Qt::Application.translate("Chip_management", "Clear", nil, Qt::Application::UnicodeUTF8)
    @menuMenu.title = Qt::Application.translate("Chip_management", "Menu", nil, Qt::Application::UnicodeUTF8)
    @menuUpload_firmware.title = Qt::Application.translate("Chip_management", "Firmware...", nil, Qt::Application::UnicodeUTF8)
    @menuComponent.title = Qt::Application.translate("Chip_management", "Component...", nil, Qt::Application::UnicodeUTF8)
    @menuAbout.title = Qt::Application.translate("Chip_management", "About", nil, Qt::Application::UnicodeUTF8)
    @menuPath.title = Qt::Application.translate("Chip_management", "Path...", nil, Qt::Application::UnicodeUTF8)
    @menuSWD.title = Qt::Application.translate("Chip_management", "SWD", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(chip_management)
        retranslateUi(chip_management)
    end

end

module Ui
    class Chip_management < Ui_Chip_management
    end
end  # module Ui

