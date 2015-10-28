#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class Ui_ChipWizard
    attr_reader :btn_add
    attr_reader :btn_cancel
    attr_reader :tabWidget
    attr_reader :tab_package
    attr_reader :lbl_package
    attr_reader :cbx_package
    attr_reader :line
    attr_reader :lbl_newPackage
    attr_reader :lbl_name
    attr_reader :lie_packageName
    attr_reader :lbl_pinNumber
    attr_reader :lie_pinNumber
    attr_reader :rbn_rectangular
    attr_reader :rbn_square
    attr_reader :lbl_geoShape
    attr_reader :btn_removePackage
    attr_reader :tab_chara
    attr_reader :lbl_voltage
    attr_reader :rbn_5v
    attr_reader :rbn_3v
    attr_reader :cbx_type
    attr_reader :lie_typeOther
    attr_reader :lbl_type
    attr_reader :lbl_ref
    attr_reader :lie_ref
    attr_reader :cbx_manufacturer
    attr_reader :lbl_manu
    attr_reader :lie_manufacturerName
    attr_reader :btn_removeManufacturer
    attr_reader :btn_removeType
    attr_reader :tab_pins
    attr_reader :tbl_pins
    attr_reader :lbl_advicePin
    attr_reader :tab_misc
    attr_reader :txe_info
    attr_reader :label_9
    attr_reader :lbl_adviceForm

    def setupUi(chipWizard)
    if chipWizard.objectName.nil?
        chipWizard.objectName = "chipWizard"
    end
    chipWizard.windowModality = Qt::WindowModal
    chipWizard.resize(425, 420)
    chipWizard.minimumSize = Qt::Size.new(425, 420)
    chipWizard.maximumSize = Qt::Size.new(425, 420)
    @btn_add = Qt::PushButton.new(chipWizard)
    @btn_add.objectName = "btn_add"
    @btn_add.geometry = Qt::Rect.new(340, 380, 75, 23)
    @btn_cancel = Qt::PushButton.new(chipWizard)
    @btn_cancel.objectName = "btn_cancel"
    @btn_cancel.geometry = Qt::Rect.new(250, 380, 75, 23)
    @tabWidget = Qt::TabWidget.new(chipWizard)
    @tabWidget.objectName = "tabWidget"
    @tabWidget.geometry = Qt::Rect.new(10, 10, 401, 321)
    @tab_package = Qt::Widget.new()
    @tab_package.objectName = "tab_package"
    @lbl_package = Qt::Label.new(@tab_package)
    @lbl_package.objectName = "lbl_package"
    @lbl_package.geometry = Qt::Rect.new(10, 30, 131, 20)
    @cbx_package = Qt::ComboBox.new(@tab_package)
    @cbx_package.objectName = "cbx_package"
    @cbx_package.geometry = Qt::Rect.new(140, 30, 171, 22)
    @line = Qt::Frame.new(@tab_package)
    @line.objectName = "line"
    @line.geometry = Qt::Rect.new(10, 60, 361, 16)
    @line.setFrameShape(Qt::Frame::HLine)
    @line.setFrameShadow(Qt::Frame::Sunken)
    @lbl_newPackage = Qt::Label.new(@tab_package)
    @lbl_newPackage.objectName = "lbl_newPackage"
    @lbl_newPackage.geometry = Qt::Rect.new(10, 80, 411, 21)
    @lbl_name = Qt::Label.new(@tab_package)
    @lbl_name.objectName = "lbl_name"
    @lbl_name.geometry = Qt::Rect.new(10, 120, 101, 20)
    @lie_packageName = Qt::LineEdit.new(@tab_package)
    @lie_packageName.objectName = "lie_packageName"
    @lie_packageName.geometry = Qt::Rect.new(140, 120, 161, 20)
    @lie_packageName.maxLength = 30
    @lbl_pinNumber = Qt::Label.new(@tab_package)
    @lbl_pinNumber.objectName = "lbl_pinNumber"
    @lbl_pinNumber.geometry = Qt::Rect.new(10, 160, 101, 20)
    @lie_pinNumber = Qt::LineEdit.new(@tab_package)
    @lie_pinNumber.objectName = "lie_pinNumber"
    @lie_pinNumber.geometry = Qt::Rect.new(140, 160, 71, 20)
    @lie_pinNumber.maxLength = 3
    @rbn_rectangular = Qt::RadioButton.new(@tab_package)
    @rbn_rectangular.objectName = "rbn_rectangular"
    @rbn_rectangular.geometry = Qt::Rect.new(140, 210, 101, 21)
    @rbn_rectangular.checked = true
    @rbn_square = Qt::RadioButton.new(@tab_package)
    @rbn_square.objectName = "rbn_square"
    @rbn_square.geometry = Qt::Rect.new(270, 210, 82, 21)
    @lbl_geoShape = Qt::Label.new(@tab_package)
    @lbl_geoShape.objectName = "lbl_geoShape"
    @lbl_geoShape.geometry = Qt::Rect.new(10, 210, 151, 21)
    @btn_removePackage = Qt::PushButton.new(@tab_package)
    @btn_removePackage.objectName = "btn_removePackage"
    @btn_removePackage.geometry = Qt::Rect.new(320, 30, 21, 21)
    @tabWidget.addTab(@tab_package, Qt::Application.translate("chipWizard", "Package", nil, Qt::Application::UnicodeUTF8))
    @tab_chara = Qt::Widget.new()
    @tab_chara.objectName = "tab_chara"
    @lbl_voltage = Qt::Label.new(@tab_chara)
    @lbl_voltage.objectName = "lbl_voltage"
    @lbl_voltage.geometry = Qt::Rect.new(10, 200, 111, 20)
    @rbn_5v = Qt::RadioButton.new(@tab_chara)
    @rbn_5v.objectName = "rbn_5v"
    @rbn_5v.geometry = Qt::Rect.new(230, 200, 61, 21)
    @rbn_3v = Qt::RadioButton.new(@tab_chara)
    @rbn_3v.objectName = "rbn_3v"
    @rbn_3v.geometry = Qt::Rect.new(150, 200, 71, 21)
    @rbn_3v.checked = true
    @cbx_type = Qt::ComboBox.new(@tab_chara)
    @cbx_type.objectName = "cbx_type"
    @cbx_type.geometry = Qt::Rect.new(140, 100, 161, 22)
    @lie_typeOther = Qt::LineEdit.new(@tab_chara)
    @lie_typeOther.objectName = "lie_typeOther"
    @lie_typeOther.geometry = Qt::Rect.new(140, 130, 161, 20)
    @lie_typeOther.maxLength = 30
    @lbl_type = Qt::Label.new(@tab_chara)
    @lbl_type.objectName = "lbl_type"
    @lbl_type.geometry = Qt::Rect.new(10, 100, 81, 20)
    @lbl_ref = Qt::Label.new(@tab_chara)
    @lbl_ref.objectName = "lbl_ref"
    @lbl_ref.geometry = Qt::Rect.new(10, 160, 121, 20)
    @lie_ref = Qt::LineEdit.new(@tab_chara)
    @lie_ref.objectName = "lie_ref"
    @lie_ref.geometry = Qt::Rect.new(140, 160, 161, 20)
    @lie_ref.maxLength = 30
    @cbx_manufacturer = Qt::ComboBox.new(@tab_chara)
    @cbx_manufacturer.objectName = "cbx_manufacturer"
    @cbx_manufacturer.geometry = Qt::Rect.new(140, 30, 161, 22)
    @lbl_manu = Qt::Label.new(@tab_chara)
    @lbl_manu.objectName = "lbl_manu"
    @lbl_manu.geometry = Qt::Rect.new(10, 30, 101, 20)
    @lie_manufacturerName = Qt::LineEdit.new(@tab_chara)
    @lie_manufacturerName.objectName = "lie_manufacturerName"
    @lie_manufacturerName.geometry = Qt::Rect.new(140, 60, 161, 20)
    @lie_manufacturerName.maxLength = 30
    @btn_removeManufacturer = Qt::PushButton.new(@tab_chara)
    @btn_removeManufacturer.objectName = "btn_removeManufacturer"
    @btn_removeManufacturer.geometry = Qt::Rect.new(310, 30, 21, 21)
    @btn_removeType = Qt::PushButton.new(@tab_chara)
    @btn_removeType.objectName = "btn_removeType"
    @btn_removeType.geometry = Qt::Rect.new(310, 100, 21, 21)
    @tabWidget.addTab(@tab_chara, Qt::Application.translate("chipWizard", "Characteristics", nil, Qt::Application::UnicodeUTF8))
    @tab_pins = Qt::Widget.new()
    @tab_pins.objectName = "tab_pins"
    @tbl_pins = Qt::TableWidget.new(@tab_pins)
    @tbl_pins.objectName = "tbl_pins"
    @tbl_pins.geometry = Qt::Rect.new(10, 20, 371, 221)
    @lbl_advicePin = Qt::Label.new(@tab_pins)
    @lbl_advicePin.objectName = "lbl_advicePin"
    @lbl_advicePin.geometry = Qt::Rect.new(20, 260, 331, 21)
    @tabWidget.addTab(@tab_pins, Qt::Application.translate("chipWizard", "Pins", nil, Qt::Application::UnicodeUTF8))
    @tab_misc = Qt::Widget.new()
    @tab_misc.objectName = "tab_misc"
    @txe_info = Qt::TextEdit.new(@tab_misc)
    @txe_info.objectName = "txe_info"
    @txe_info.geometry = Qt::Rect.new(10, 40, 371, 221)
    @txe_info.acceptRichText = false
    @label_9 = Qt::Label.new(@tab_misc)
    @label_9.objectName = "label_9"
    @label_9.geometry = Qt::Rect.new(10, 10, 331, 16)
    @tabWidget.addTab(@tab_misc, Qt::Application.translate("chipWizard", "Misc", nil, Qt::Application::UnicodeUTF8))
    @lbl_adviceForm = Qt::Label.new(chipWizard)
    @lbl_adviceForm.objectName = "lbl_adviceForm"
    @lbl_adviceForm.geometry = Qt::Rect.new(20, 340, 361, 31)
    Qt::Widget.setTabOrder(@cbx_package, @lie_packageName)
    Qt::Widget.setTabOrder(@lie_packageName, @lie_pinNumber)
    Qt::Widget.setTabOrder(@lie_pinNumber, @cbx_manufacturer)
    Qt::Widget.setTabOrder(@cbx_manufacturer, @lie_manufacturerName)
    Qt::Widget.setTabOrder(@lie_manufacturerName, @lie_ref)
    Qt::Widget.setTabOrder(@lie_ref, @cbx_type)
    Qt::Widget.setTabOrder(@cbx_type, @lie_typeOther)
    Qt::Widget.setTabOrder(@lie_typeOther, @tbl_pins)
    Qt::Widget.setTabOrder(@tbl_pins, @txe_info)
    Qt::Widget.setTabOrder(@txe_info, @btn_cancel)
    Qt::Widget.setTabOrder(@btn_cancel, @btn_add)

    retranslateUi(chipWizard)
    Qt::Object.connect(@cbx_package, SIGNAL('currentIndexChanged(int)'), chipWizard, SLOT('select_package()'))
    Qt::Object.connect(@lie_pinNumber, SIGNAL('editingFinished()'), chipWizard, SLOT('fill_pin_table()'))
    Qt::Object.connect(@cbx_manufacturer, SIGNAL('currentIndexChanged(int)'), chipWizard, SLOT('select_manufacturer()'))
    Qt::Object.connect(@cbx_type, SIGNAL('currentIndexChanged(int)'), chipWizard, SLOT('select_type()'))
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), chipWizard, SLOT('close()'))
    Qt::Object.connect(@btn_removePackage, SIGNAL('clicked()'), chipWizard, SLOT('delete_cbx_element()'))
    Qt::Object.connect(@btn_removeManufacturer, SIGNAL('clicked()'), chipWizard, SLOT('delete_cbx_element()'))
    Qt::Object.connect(@btn_removeType, SIGNAL('clicked()'), chipWizard, SLOT('delete_cbx_element()'))
    Qt::Object.connect(@txe_info, SIGNAL('textChanged()'), chipWizard, SLOT('check_txe_content()'))

    @tabWidget.setCurrentIndex(2)


    Qt::MetaObject.connectSlotsByName(chipWizard)
    end # setupUi

    def setup_ui(chipWizard)
        setupUi(chipWizard)
    end

    def retranslateUi(chipWizard)
    chipWizard.windowTitle = Qt::Application.translate("chipWizard", "Hardsploit - Chip Wizard", nil, Qt::Application::UnicodeUTF8)
    @btn_add.text = Qt::Application.translate("chipWizard", "Add", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("chipWizard", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @lbl_package.text = Qt::Application.translate("chipWizard", "Existing package", nil, Qt::Application::UnicodeUTF8)
    @cbx_package.insertItems(0, [Qt::Application.translate("chipWizard", "Select...", nil, Qt::Application::UnicodeUTF8)])
    @lbl_newPackage.text = Qt::Application.translate("chipWizard", "Not in the list ? Create a new one :", nil, Qt::Application::UnicodeUTF8)
    @lbl_name.text = Qt::Application.translate("chipWizard", "Name", nil, Qt::Application::UnicodeUTF8)
    @lie_packageName.placeholderText = Qt::Application.translate("chipWizard", "30 chars max", nil, Qt::Application::UnicodeUTF8)
    @lbl_pinNumber.text = Qt::Application.translate("chipWizard", "Pin number", nil, Qt::Application::UnicodeUTF8)
    @lie_pinNumber.inputMask = ''
    @lie_pinNumber.placeholderText = Qt::Application.translate("chipWizard", "4-144", nil, Qt::Application::UnicodeUTF8)
    @rbn_rectangular.text = Qt::Application.translate("chipWizard", "Rectangular", nil, Qt::Application::UnicodeUTF8)
    @rbn_square.text = Qt::Application.translate("chipWizard", "Square", nil, Qt::Application::UnicodeUTF8)
    @lbl_geoShape.text = Qt::Application.translate("chipWizard", "Geometric shape", nil, Qt::Application::UnicodeUTF8)
    @btn_removePackage.text = Qt::Application.translate("chipWizard", "X", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_package), Qt::Application.translate("chipWizard", "Package", nil, Qt::Application::UnicodeUTF8))
    @lbl_voltage.text = Qt::Application.translate("chipWizard", "Voltage", nil, Qt::Application::UnicodeUTF8)
    @rbn_5v.text = Qt::Application.translate("chipWizard", "5V", nil, Qt::Application::UnicodeUTF8)
    @rbn_3v.text = Qt::Application.translate("chipWizard", "3,3V", nil, Qt::Application::UnicodeUTF8)
    @cbx_type.insertItems(0, [Qt::Application.translate("chipWizard", "Select...", nil, Qt::Application::UnicodeUTF8)])
    @lie_typeOther.text = ''
    @lie_typeOther.placeholderText = Qt::Application.translate("chipWizard", "Other...", nil, Qt::Application::UnicodeUTF8)
    @lbl_type.text = Qt::Application.translate("chipWizard", "Type", nil, Qt::Application::UnicodeUTF8)
    @lbl_ref.text = Qt::Application.translate("chipWizard", "Name / Reference", nil, Qt::Application::UnicodeUTF8)
    @cbx_manufacturer.insertItems(0, [Qt::Application.translate("chipWizard", "Select...", nil, Qt::Application::UnicodeUTF8)])
    @lbl_manu.text = Qt::Application.translate("chipWizard", "Manufacturer", nil, Qt::Application::UnicodeUTF8)
    @lie_manufacturerName.placeholderText = Qt::Application.translate("chipWizard", "Other...", nil, Qt::Application::UnicodeUTF8)
    @btn_removeManufacturer.text = Qt::Application.translate("chipWizard", "X", nil, Qt::Application::UnicodeUTF8)
    @btn_removeType.text = Qt::Application.translate("chipWizard", "X", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_chara), Qt::Application.translate("chipWizard", "Characteristics", nil, Qt::Application::UnicodeUTF8))
    if @tbl_pins.columnCount < 3
        @tbl_pins.columnCount = 3
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("chipWizard", "Pin Number", nil, Qt::Application::UnicodeUTF8))
    @tbl_pins.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("chipWizard", "BUS", nil, Qt::Application::UnicodeUTF8))
    @tbl_pins.setHorizontalHeaderItem(1, __colItem1)

    __colItem2 = Qt::TableWidgetItem.new
    __colItem2.setText(Qt::Application.translate("chipWizard", "SIGNAL", nil, Qt::Application::UnicodeUTF8))
    @tbl_pins.setHorizontalHeaderItem(2, __colItem2)
    @lbl_advicePin.text = Qt::Application.translate("chipWizard", "Change the number of pin in the \"Package\" tab", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_pins), Qt::Application.translate("chipWizard", "Pins", nil, Qt::Application::UnicodeUTF8))
    @label_9.text = Qt::Application.translate("chipWizard", "Other information about the chip", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_misc), Qt::Application.translate("chipWizard", "Misc", nil, Qt::Application::UnicodeUTF8))
    @lbl_adviceForm.text = Qt::Application.translate("chipWizard", "To complete this form, please report to the datasheet.", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(chipWizard)
        retranslateUi(chipWizard)
    end

end

module Ui
    class ChipWizard < Ui_ChipWizard
    end
end  # module Ui

