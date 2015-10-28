#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class Ui_CommandBase
    attr_reader :btn_validate
    attr_reader :btn_cancel
    attr_reader :tabWidget
    attr_reader :tab
    attr_reader :lbl_chip
    attr_reader :lie_name
    attr_reader :lbl_description
    attr_reader :lbl_name
    attr_reader :txe_description
    attr_reader :lbl_cmd
    attr_reader :lbl_bus
    attr_reader :tab_2
    attr_reader :tbl_bytes
    attr_reader :btn_addRow
    attr_reader :btn_clone
    attr_reader :btn_remove
    attr_reader :lie_text2bytes

    def setupUi(commandBase)
    if commandBase.objectName.nil?
        commandBase.objectName = "commandBase"
    end
    commandBase.resize(525, 400)
    commandBase.minimumSize = Qt::Size.new(525, 400)
    commandBase.maximumSize = Qt::Size.new(525, 400)
    @btn_validate = Qt::PushButton.new(commandBase)
    @btn_validate.objectName = "btn_validate"
    @btn_validate.geometry = Qt::Rect.new(440, 370, 75, 23)
    @btn_cancel = Qt::PushButton.new(commandBase)
    @btn_cancel.objectName = "btn_cancel"
    @btn_cancel.geometry = Qt::Rect.new(350, 370, 75, 23)
    @tabWidget = Qt::TabWidget.new(commandBase)
    @tabWidget.objectName = "tabWidget"
    @tabWidget.geometry = Qt::Rect.new(10, 10, 501, 351)
    @tab = Qt::Widget.new()
    @tab.objectName = "tab"
    @lbl_chip = Qt::Label.new(@tab)
    @lbl_chip.objectName = "lbl_chip"
    @lbl_chip.geometry = Qt::Rect.new(10, 10, 361, 21)
    @lie_name = Qt::LineEdit.new(@tab)
    @lie_name.objectName = "lie_name"
    @lie_name.geometry = Qt::Rect.new(30, 130, 211, 20)
    @lie_name.maxLength = 25
    @lbl_description = Qt::Label.new(@tab)
    @lbl_description.objectName = "lbl_description"
    @lbl_description.geometry = Qt::Rect.new(30, 160, 331, 21)
    @lbl_name = Qt::Label.new(@tab)
    @lbl_name.objectName = "lbl_name"
    @lbl_name.geometry = Qt::Rect.new(30, 100, 341, 21)
    @txe_description = Qt::TextEdit.new(@tab)
    @txe_description.objectName = "txe_description"
    @txe_description.geometry = Qt::Rect.new(30, 190, 341, 111)
    @lbl_cmd = Qt::Label.new(@tab)
    @lbl_cmd.objectName = "lbl_cmd"
    @lbl_cmd.geometry = Qt::Rect.new(10, 70, 361, 21)
    @lbl_bus = Qt::Label.new(@tab)
    @lbl_bus.objectName = "lbl_bus"
    @lbl_bus.geometry = Qt::Rect.new(10, 40, 361, 21)
    @tabWidget.addTab(@tab, Qt::Application.translate("CommandBase", "Characteristics", nil, Qt::Application::UnicodeUTF8))
    @tab_2 = Qt::Widget.new()
    @tab_2.objectName = "tab_2"
    @tbl_bytes = Qt::TableWidget.new(@tab_2)
    @tbl_bytes.objectName = "tbl_bytes"
    @tbl_bytes.geometry = Qt::Rect.new(10, 10, 481, 271)
    @font = Qt::Font.new
    @font.family = "Arial"
    @tbl_bytes.font = @font
    @tbl_bytes.sortingEnabled = true
    @btn_addRow = Qt::PushButton.new(@tab_2)
    @btn_addRow.objectName = "btn_addRow"
    @btn_addRow.geometry = Qt::Rect.new(140, 290, 31, 23)
    @btn_clone = Qt::PushButton.new(@tab_2)
    @btn_clone.objectName = "btn_clone"
    @btn_clone.geometry = Qt::Rect.new(10, 290, 75, 23)
    @btn_remove = Qt::PushButton.new(@tab_2)
    @btn_remove.objectName = "btn_remove"
    @btn_remove.geometry = Qt::Rect.new(100, 290, 31, 23)
    @lie_text2bytes = Qt::LineEdit.new(@tab_2)
    @lie_text2bytes.objectName = "lie_text2bytes"
    @lie_text2bytes.geometry = Qt::Rect.new(190, 290, 291, 20)
    @tabWidget.addTab(@tab_2, Qt::Application.translate("CommandBase", "Bytes", nil, Qt::Application::UnicodeUTF8))

    retranslateUi(commandBase)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), commandBase, SLOT('close()'))
    Qt::Object.connect(@tbl_bytes, SIGNAL('cellClicked(int,int)'), commandBase, SLOT('activAction()'))
    Qt::Object.connect(@btn_remove, SIGNAL('clicked()'), commandBase, SLOT('removeRow()'))
    Qt::Object.connect(@btn_addRow, SIGNAL('clicked()'), commandBase, SLOT('addRow()'))
    Qt::Object.connect(@btn_clone, SIGNAL('clicked()'), commandBase, SLOT('cloneRow()'))
    Qt::Object.connect(@txe_description, SIGNAL('textChanged()'), commandBase, SLOT('checkTxeContent()'))
    Qt::Object.connect(@tbl_bytes, SIGNAL('itemChanged(QTableWidgetItem*)'), commandBase, SLOT('checkCellContent(QTableWidgetItem*)'))

    @tabWidget.setCurrentIndex(1)


    Qt::MetaObject.connectSlotsByName(commandBase)
    end # setupUi

    def setup_ui(commandBase)
        setupUi(commandBase)
    end

    def retranslateUi(commandBase)
    commandBase.windowTitle = Qt::Application.translate("CommandBase", "Hardsploit - Command base", nil, Qt::Application::UnicodeUTF8)
    @btn_validate.text = Qt::Application.translate("CommandBase", "Add", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("CommandBase", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("CommandBase", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lie_name.inputMask = ''
    @lbl_description.text = Qt::Application.translate("CommandBase", "Description:", nil, Qt::Application::UnicodeUTF8)
    @lbl_name.text = Qt::Application.translate("CommandBase", "Name (25 chars max):", nil, Qt::Application::UnicodeUTF8)
    @lbl_cmd.text = Qt::Application.translate("CommandBase", "[CMD]", nil, Qt::Application::UnicodeUTF8)
    @lbl_bus.text = Qt::Application.translate("CommandBase", "[BUS]", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab), Qt::Application.translate("CommandBase", "Characteristics", nil, Qt::Application::UnicodeUTF8))
    if @tbl_bytes.columnCount < 4
        @tbl_bytes.columnCount = 4
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("CommandBase", "Order", nil, Qt::Application::UnicodeUTF8))
    @tbl_bytes.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("CommandBase", "Byte (Hexa)", nil, Qt::Application::UnicodeUTF8))
    @tbl_bytes.setHorizontalHeaderItem(1, __colItem1)

    __colItem2 = Qt::TableWidgetItem.new
    __colItem2.setText(Qt::Application.translate("CommandBase", "Repetition", nil, Qt::Application::UnicodeUTF8))
    @tbl_bytes.setHorizontalHeaderItem(2, __colItem2)

    __colItem3 = Qt::TableWidgetItem.new
    __colItem3.setText(Qt::Application.translate("CommandBase", "Description", nil, Qt::Application::UnicodeUTF8))
    @tbl_bytes.setHorizontalHeaderItem(3, __colItem3)
    @btn_addRow.text = Qt::Application.translate("CommandBase", "+", nil, Qt::Application::UnicodeUTF8)
    @btn_clone.text = Qt::Application.translate("CommandBase", "Clone", nil, Qt::Application::UnicodeUTF8)
    @btn_remove.text = Qt::Application.translate("CommandBase", "-", nil, Qt::Application::UnicodeUTF8)
    @lie_text2bytes.placeholderText = Qt::Application.translate("CommandBase", "Text to command bytes", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_2), Qt::Application.translate("CommandBase", "Bytes", nil, Qt::Application::UnicodeUTF8))
    end # retranslateUi

    def retranslate_ui(commandBase)
        retranslateUi(commandBase)
    end

end

module Ui
    class CommandBase < Ui_CommandBase
    end
end  # module Ui

