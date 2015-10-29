#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class Ui_ChipManagement
    attr_reader :actionOnline_help
    attr_reader :actionVersions
    attr_reader :actionFPGA_Firmware_update
    attr_reader :actionLog_file_path
    attr_reader :actionDatabase_file_path
    attr_reader :centralwidget
    attr_reader :cbx_manufacturer
    attr_reader :cbx_action
    attr_reader :cbx_type
    attr_reader :lbl_searchFilter
    attr_reader :btn_next
    attr_reader :lbl_loupe
    attr_reader :btn_create
    attr_reader :lie_search
    attr_reader :tbl_chip
    attr_reader :menubar
    attr_reader :menuHelp
    attr_reader :statusbar

    def setupUi(chipManagement)
    if chipManagement.objectName.nil?
        chipManagement.objectName = "chipManagement"
    end
    chipManagement.resize(530, 390)
    chipManagement.minimumSize = Qt::Size.new(530, 390)
    chipManagement.maximumSize = Qt::Size.new(530, 390)
    chipManagement.autoFillBackground = false
    @actionOnline_help = Qt::Action.new(chipManagement)
    @actionOnline_help.objectName = "actionOnline_help"
    @actionVersions = Qt::Action.new(chipManagement)
    @actionVersions.objectName = "actionVersions"
    @actionFPGA_Firmware_update = Qt::Action.new(chipManagement)
    @actionFPGA_Firmware_update.objectName = "actionFPGA_Firmware_update"
    @actionLog_file_path = Qt::Action.new(chipManagement)
    @actionLog_file_path.objectName = "actionLog_file_path"
    @actionDatabase_file_path = Qt::Action.new(chipManagement)
    @actionDatabase_file_path.objectName = "actionDatabase_file_path"
    @centralwidget = Qt::Widget.new(chipManagement)
    @centralwidget.objectName = "centralwidget"
    @cbx_manufacturer = Qt::ComboBox.new(@centralwidget)
    @cbx_manufacturer.objectName = "cbx_manufacturer"
    @cbx_manufacturer.geometry = Qt::Rect.new(200, 40, 131, 22)
    @font = Qt::Font.new
    @font.family = "Arial"
    @cbx_manufacturer.font = @font
    @cbx_action = Qt::ComboBox.new(@centralwidget)
    @cbx_action.objectName = "cbx_action"
    @cbx_action.geometry = Qt::Rect.new(310, 310, 121, 22)
    @cbx_type = Qt::ComboBox.new(@centralwidget)
    @cbx_type.objectName = "cbx_type"
    @cbx_type.geometry = Qt::Rect.new(340, 40, 121, 22)
    @cbx_type.font = @font
    @lbl_searchFilter = Qt::Label.new(@centralwidget)
    @lbl_searchFilter.objectName = "lbl_searchFilter"
    @lbl_searchFilter.geometry = Qt::Rect.new(10, 10, 161, 21)
    @btn_next = Qt::PushButton.new(@centralwidget)
    @btn_next.objectName = "btn_next"
    @btn_next.geometry = Qt::Rect.new(440, 310, 81, 23)
    @btn_next.font = @font
    @lbl_loupe = Qt::Label.new(@centralwidget)
    @lbl_loupe.objectName = "lbl_loupe"
    @lbl_loupe.geometry = Qt::Rect.new(10, 40, 31, 21)
    @btn_create = Qt::PushButton.new(@centralwidget)
    @btn_create.objectName = "btn_create"
    @btn_create.geometry = Qt::Rect.new(200, 310, 91, 23)
    @btn_create.font = @font
    @lie_search = Qt::LineEdit.new(@centralwidget)
    @lie_search.objectName = "lie_search"
    @lie_search.geometry = Qt::Rect.new(40, 40, 151, 20)
    @tbl_chip = Qt::TableWidget.new(@centralwidget)
    @tbl_chip.objectName = "tbl_chip"
    @tbl_chip.geometry = Qt::Rect.new(10, 80, 511, 221)
    @tbl_chip.font = @font
    @tbl_chip.sortingEnabled = true
    chipManagement.centralWidget = @centralwidget
    @menubar = Qt::MenuBar.new(chipManagement)
    @menubar.objectName = "menubar"
    @menubar.geometry = Qt::Rect.new(0, 0, 530, 21)
    @menuHelp = Qt::Menu.new(@menubar)
    @menuHelp.objectName = "menuHelp"
    chipManagement.setMenuBar(@menubar)
    @statusbar = Qt::StatusBar.new(chipManagement)
    @statusbar.objectName = "statusbar"
    chipManagement.statusBar = @statusbar

    @menubar.addAction(@menuHelp.menuAction())
    @menuHelp.addAction(@actionFPGA_Firmware_update)
    @menuHelp.addAction(@actionVersions)
    @menuHelp.addAction(@actionLog_file_path)
    @menuHelp.addAction(@actionDatabase_file_path)

    retranslateUi(chipManagement)
    Qt::Object.connect(@btn_create, SIGNAL('clicked()'), chipManagement, SLOT('openChipWizard()'))
    Qt::Object.connect(@btn_next, SIGNAL('clicked()'), chipManagement, SLOT('execAction()'))
    Qt::Object.connect(@cbx_manufacturer, SIGNAL('currentIndexChanged(int)'), chipManagement, SLOT('feedChipArray()'))
    Qt::Object.connect(@cbx_type, SIGNAL('currentIndexChanged(int)'), chipManagement, SLOT('feedChipArray()'))
    Qt::Object.connect(@lie_search, SIGNAL('textEdited(QString)'), chipManagement, SLOT('feedChipArray()'))
    Qt::Object.connect(@tbl_chip, SIGNAL('cellClicked(int,int)'), chipManagement, SLOT('activAction()'))
    Qt::Object.connect(@cbx_action, SIGNAL('currentIndexChanged(int)'), chipManagement, SLOT('verifAction()'))
    Qt::Object.connect(@actionFPGA_Firmware_update, SIGNAL('triggered()'), chipManagement, SLOT('updateUcFirmware()'))
    Qt::Object.connect(@actionVersions, SIGNAL('triggered()'), chipManagement, SLOT('getVersions()'))
    Qt::Object.connect(@actionLog_file_path, SIGNAL('triggered()'), chipManagement, SLOT('getLogPath()'))
    Qt::Object.connect(@actionDatabase_file_path, SIGNAL('triggered()'), chipManagement, SLOT('getDbPath()'))

    Qt::MetaObject.connectSlotsByName(chipManagement)
    end # setupUi

    def setup_ui(chipManagement)
        setupUi(chipManagement)
    end

    def retranslateUi(chipManagement)
    chipManagement.windowTitle = Qt::Application.translate("ChipManagement", "Hardsploit - Chip management", nil, Qt::Application::UnicodeUTF8)
    @actionOnline_help.text = Qt::Application.translate("ChipManagement", "Online help", nil, Qt::Application::UnicodeUTF8)
    @actionVersions.text = Qt::Application.translate("ChipManagement", "Versions", nil, Qt::Application::UnicodeUTF8)
    @actionFPGA_Firmware_update.text = Qt::Application.translate("ChipManagement", "Firmware update", nil, Qt::Application::UnicodeUTF8)
    @actionLog_file_path.text = Qt::Application.translate("ChipManagement", "Log file path", nil, Qt::Application::UnicodeUTF8)
    @actionDatabase_file_path.text = Qt::Application.translate("ChipManagement", "Database file path", nil, Qt::Application::UnicodeUTF8)
    @cbx_manufacturer.insertItems(0, [Qt::Application.translate("ChipManagement", "Manufacturer...", nil, Qt::Application::UnicodeUTF8)])
    @cbx_action.insertItems(0, [Qt::Application.translate("ChipManagement", "Action...", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("ChipManagement", "Wiring", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("ChipManagement", "Commands", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("ChipManagement", "Use as template", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("ChipManagement", "Edit", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("ChipManagement", "Delete", nil, Qt::Application::UnicodeUTF8)])
    @cbx_type.insertItems(0, [Qt::Application.translate("ChipManagement", "Type...", nil, Qt::Application::UnicodeUTF8)])
    @lbl_searchFilter.text = Qt::Application.translate("ChipManagement", "Search filters:", nil, Qt::Application::UnicodeUTF8)
    @btn_next.text = Qt::Application.translate("ChipManagement", "Next", nil, Qt::Application::UnicodeUTF8)
    @lbl_loupe.text = Qt::Application.translate("ChipManagement", "loupe", nil, Qt::Application::UnicodeUTF8)
    @btn_create.text = Qt::Application.translate("ChipManagement", "Create new", nil, Qt::Application::UnicodeUTF8)
    if @tbl_chip.columnCount < 3
        @tbl_chip.columnCount = 3
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("ChipManagement", "Ref", nil, Qt::Application::UnicodeUTF8))
    @tbl_chip.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("ChipManagement", "Type", nil, Qt::Application::UnicodeUTF8))
    @tbl_chip.setHorizontalHeaderItem(1, __colItem1)

    __colItem2 = Qt::TableWidgetItem.new
    __colItem2.setText(Qt::Application.translate("ChipManagement", "Manufacturer", nil, Qt::Application::UnicodeUTF8))
    @tbl_chip.setHorizontalHeaderItem(2, __colItem2)
    @menuHelp.title = Qt::Application.translate("ChipManagement", "Option", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(chipManagement)
        retranslateUi(chipManagement)
    end

end

module Ui
    class ChipManagement < Ui_ChipManagement
    end
end  # module Ui

