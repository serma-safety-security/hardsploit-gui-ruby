=begin
** Form generated from reading ui file 'gui_chip_editor.ui'
**
** Created: mar. déc. 22 16:54:43 2015
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Chip_editor
    attr_reader :gridLayout
    attr_reader :tbl_pins
    attr_reader :lbl_advice
    attr_reader :hl
    attr_reader :hs
    attr_reader :btn_cancel
    attr_reader :btn_add
    attr_reader :vl
    attr_reader :fl
    attr_reader :lbl_ref
    attr_reader :lbl_package
    attr_reader :hl1
    attr_reader :cbx_package
    attr_reader :btn_pack_remove
    attr_reader :lbl_pack_new
    attr_reader :lbl_name
    attr_reader :lie_pack_name
    attr_reader :lbl_pack_pin
    attr_reader :lie_pack_pin
    attr_reader :lbl_pack_shape
    attr_reader :lie_reference
    attr_reader :hl2
    attr_reader :groupBox
    attr_reader :rbn_3v
    attr_reader :rbn_5v
    attr_reader :lbl_voltage
    attr_reader :hl3
    attr_reader :groupBox_2
    attr_reader :rbn_square
    attr_reader :rbn_rectangular
    attr_reader :lbl_manu
    attr_reader :lie_manu_name
    attr_reader :lbl_type
    attr_reader :hl5
    attr_reader :cbx_type
    attr_reader :btn_type_remove
    attr_reader :lie_type_name
    attr_reader :lbl_description
    attr_reader :lie_description
    attr_reader :hl4
    attr_reader :cbx_manufacturer
    attr_reader :btn_manu_remove

    def setupUi(chip_editor)
    if chip_editor.objectName.nil?
        chip_editor.objectName = "chip_editor"
    end
    chip_editor.resize(414, 594)
    @gridLayout = Qt::GridLayout.new(chip_editor)
    @gridLayout.objectName = "gridLayout"
    @tbl_pins = Qt::TableWidget.new(chip_editor)
    @tbl_pins.objectName = "tbl_pins"
    @tbl_pins.minimumSize = Qt::Size.new(0, 200)
    @tbl_pins.maximumSize = Qt::Size.new(16777215, 16777215)

    @gridLayout.addWidget(@tbl_pins, 1, 0, 1, 1)

    @lbl_advice = Qt::Label.new(chip_editor)
    @lbl_advice.objectName = "lbl_advice"

    @gridLayout.addWidget(@lbl_advice, 2, 0, 1, 1)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)

    @btn_cancel = Qt::PushButton.new(chip_editor)
    @btn_cancel.objectName = "btn_cancel"

    @hl.addWidget(@btn_cancel)

    @btn_add = Qt::PushButton.new(chip_editor)
    @btn_add.objectName = "btn_add"

    @hl.addWidget(@btn_add)


    @gridLayout.addLayout(@hl, 3, 0, 1, 1)

    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @fl = Qt::FormLayout.new()
    @fl.objectName = "fl"
    @lbl_ref = Qt::Label.new(chip_editor)
    @lbl_ref.objectName = "lbl_ref"

    @fl.setWidget(0, Qt::FormLayout::LabelRole, @lbl_ref)

    @lbl_package = Qt::Label.new(chip_editor)
    @lbl_package.objectName = "lbl_package"

    @fl.setWidget(7, Qt::FormLayout::LabelRole, @lbl_package)

    @hl1 = Qt::HBoxLayout.new()
    @hl1.objectName = "hl1"
    @cbx_package = Qt::ComboBox.new(chip_editor)
    @cbx_package.objectName = "cbx_package"

    @hl1.addWidget(@cbx_package)

    @btn_pack_remove = Qt::PushButton.new(chip_editor)
    @btn_pack_remove.objectName = "btn_pack_remove"
    @btn_pack_remove.maximumSize = Qt::Size.new(30, 16777215)

    @hl1.addWidget(@btn_pack_remove)


    @fl.setLayout(7, Qt::FormLayout::FieldRole, @hl1)

    @lbl_pack_new = Qt::Label.new(chip_editor)
    @lbl_pack_new.objectName = "lbl_pack_new"

    @fl.setWidget(10, Qt::FormLayout::LabelRole, @lbl_pack_new)

    @lbl_name = Qt::Label.new(chip_editor)
    @lbl_name.objectName = "lbl_name"

    @fl.setWidget(11, Qt::FormLayout::LabelRole, @lbl_name)

    @lie_pack_name = Qt::LineEdit.new(chip_editor)
    @lie_pack_name.objectName = "lie_pack_name"
    @lie_pack_name.maxLength = 30

    @fl.setWidget(11, Qt::FormLayout::FieldRole, @lie_pack_name)

    @lbl_pack_pin = Qt::Label.new(chip_editor)
    @lbl_pack_pin.objectName = "lbl_pack_pin"

    @fl.setWidget(12, Qt::FormLayout::LabelRole, @lbl_pack_pin)

    @lie_pack_pin = Qt::LineEdit.new(chip_editor)
    @lie_pack_pin.objectName = "lie_pack_pin"
    @lie_pack_pin.maxLength = 3

    @fl.setWidget(12, Qt::FormLayout::FieldRole, @lie_pack_pin)

    @lbl_pack_shape = Qt::Label.new(chip_editor)
    @lbl_pack_shape.objectName = "lbl_pack_shape"

    @fl.setWidget(13, Qt::FormLayout::LabelRole, @lbl_pack_shape)

    @lie_reference = Qt::LineEdit.new(chip_editor)
    @lie_reference.objectName = "lie_reference"
    @lie_reference.maxLength = 30

    @fl.setWidget(0, Qt::FormLayout::FieldRole, @lie_reference)

    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @groupBox = Qt::GroupBox.new(chip_editor)
    @groupBox.objectName = "groupBox"
    @rbn_3v = Qt::RadioButton.new(@groupBox)
    @rbn_3v.objectName = "rbn_3v"
    @rbn_3v.geometry = Qt::Rect.new(10, 0, 70, 21)
    @rbn_3v.checked = true
    @rbn_3v.autoExclusive = true
    @rbn_5v = Qt::RadioButton.new(@groupBox)
    @rbn_5v.objectName = "rbn_5v"
    @rbn_5v.geometry = Qt::Rect.new(90, 0, 109, 21)
    @rbn_5v.autoExclusive = true

    @hl2.addWidget(@groupBox)


    @fl.setLayout(2, Qt::FormLayout::FieldRole, @hl2)

    @lbl_voltage = Qt::Label.new(chip_editor)
    @lbl_voltage.objectName = "lbl_voltage"

    @fl.setWidget(2, Qt::FormLayout::LabelRole, @lbl_voltage)

    @hl3 = Qt::HBoxLayout.new()
    @hl3.objectName = "hl3"
    @groupBox_2 = Qt::GroupBox.new(chip_editor)
    @groupBox_2.objectName = "groupBox_2"
    @rbn_square = Qt::RadioButton.new(@groupBox_2)
    @rbn_square.objectName = "rbn_square"
    @rbn_square.geometry = Qt::Rect.new(10, 0, 81, 20)
    @rbn_square.checked = true
    @rbn_square.autoExclusive = true
    @rbn_rectangular = Qt::RadioButton.new(@groupBox_2)
    @rbn_rectangular.objectName = "rbn_rectangular"
    @rbn_rectangular.geometry = Qt::Rect.new(110, 0, 109, 20)
    @rbn_rectangular.checked = false
    @rbn_rectangular.autoExclusive = true

    @hl3.addWidget(@groupBox_2)


    @fl.setLayout(13, Qt::FormLayout::FieldRole, @hl3)

    @lbl_manu = Qt::Label.new(chip_editor)
    @lbl_manu.objectName = "lbl_manu"

    @fl.setWidget(3, Qt::FormLayout::LabelRole, @lbl_manu)

    @lie_manu_name = Qt::LineEdit.new(chip_editor)
    @lie_manu_name.objectName = "lie_manu_name"
    @lie_manu_name.maxLength = 30

    @fl.setWidget(4, Qt::FormLayout::FieldRole, @lie_manu_name)

    @lbl_type = Qt::Label.new(chip_editor)
    @lbl_type.objectName = "lbl_type"

    @fl.setWidget(5, Qt::FormLayout::LabelRole, @lbl_type)

    @hl5 = Qt::HBoxLayout.new()
    @hl5.objectName = "hl5"
    @cbx_type = Qt::ComboBox.new(chip_editor)
    @cbx_type.objectName = "cbx_type"

    @hl5.addWidget(@cbx_type)

    @btn_type_remove = Qt::PushButton.new(chip_editor)
    @btn_type_remove.objectName = "btn_type_remove"
    @btn_type_remove.maximumSize = Qt::Size.new(30, 16777215)

    @hl5.addWidget(@btn_type_remove)


    @fl.setLayout(5, Qt::FormLayout::FieldRole, @hl5)

    @lie_type_name = Qt::LineEdit.new(chip_editor)
    @lie_type_name.objectName = "lie_type_name"
    @lie_type_name.maxLength = 30

    @fl.setWidget(6, Qt::FormLayout::FieldRole, @lie_type_name)

    @lbl_description = Qt::Label.new(chip_editor)
    @lbl_description.objectName = "lbl_description"

    @fl.setWidget(1, Qt::FormLayout::LabelRole, @lbl_description)

    @lie_description = Qt::LineEdit.new(chip_editor)
    @lie_description.objectName = "lie_description"
    @lie_description.maxLength = 200

    @fl.setWidget(1, Qt::FormLayout::FieldRole, @lie_description)

    @hl4 = Qt::HBoxLayout.new()
    @hl4.objectName = "hl4"
    @cbx_manufacturer = Qt::ComboBox.new(chip_editor)
    @cbx_manufacturer.objectName = "cbx_manufacturer"

    @hl4.addWidget(@cbx_manufacturer)

    @btn_manu_remove = Qt::PushButton.new(chip_editor)
    @btn_manu_remove.objectName = "btn_manu_remove"
    @btn_manu_remove.maximumSize = Qt::Size.new(30, 16777215)

    @hl4.addWidget(@btn_manu_remove)


    @fl.setLayout(3, Qt::FormLayout::FieldRole, @hl4)


    @vl.addLayout(@fl)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)


    retranslateUi(chip_editor)
    Qt::Object.connect(@lie_pack_pin, SIGNAL('editingFinished()'), chip_editor, SLOT('fill_pin_table()'))
    Qt::Object.connect(@btn_manu_remove, SIGNAL('clicked()'), chip_editor, SLOT('delete_cbx_element()'))
    Qt::Object.connect(@btn_type_remove, SIGNAL('clicked()'), chip_editor, SLOT('delete_cbx_element()'))
    Qt::Object.connect(@btn_pack_remove, SIGNAL('clicked()'), chip_editor, SLOT('delete_cbx_element()'))
    Qt::Object.connect(@cbx_package, SIGNAL('currentIndexChanged(int)'), chip_editor, SLOT('select_package()'))
    Qt::Object.connect(@cbx_type, SIGNAL('currentIndexChanged(int)'), chip_editor, SLOT('select_type()'))
    Qt::Object.connect(@cbx_manufacturer, SIGNAL('currentIndexChanged(int)'), chip_editor, SLOT('select_manufacturer()'))
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), chip_editor, SLOT('close()'))

    Qt::MetaObject.connectSlotsByName(chip_editor)
    end # setupUi

    def setup_ui(chip_editor)
        setupUi(chip_editor)
    end

    def retranslateUi(chip_editor)
    chip_editor.windowTitle = Qt::Application.translate("Chip_editor", "Hardsploit - Chip editor", nil, Qt::Application::UnicodeUTF8)
    if @tbl_pins.columnCount < 3
        @tbl_pins.columnCount = 3
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("Chip_editor", "Pin Number", nil, Qt::Application::UnicodeUTF8))
    @tbl_pins.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("Chip_editor", "Bus", nil, Qt::Application::UnicodeUTF8))
    @tbl_pins.setHorizontalHeaderItem(1, __colItem1)

    __colItem2 = Qt::TableWidgetItem.new
    __colItem2.setText(Qt::Application.translate("Chip_editor", "Signal", nil, Qt::Application::UnicodeUTF8))
    @tbl_pins.setHorizontalHeaderItem(2, __colItem2)
    @lbl_advice.text = Qt::Application.translate("Chip_editor", "To complete this form, please report to the component datasheet.", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("Chip_editor", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @btn_add.text = Qt::Application.translate("Chip_editor", "Add", nil, Qt::Application::UnicodeUTF8)
    @lbl_ref.text = Qt::Application.translate("Chip_editor", "Name / Reference:", nil, Qt::Application::UnicodeUTF8)
    @lbl_package.text = Qt::Application.translate("Chip_editor", "Package:", nil, Qt::Application::UnicodeUTF8)
    @cbx_package.insertItems(0, [Qt::Application.translate("Chip_editor", "Select...", nil, Qt::Application::UnicodeUTF8)])
    @btn_pack_remove.text = Qt::Application.translate("Chip_editor", "X", nil, Qt::Application::UnicodeUTF8)
    @lbl_pack_new.text = Qt::Application.translate("Chip_editor", "Not in the list ? Create a new one", nil, Qt::Application::UnicodeUTF8)
    @lbl_name.text = Qt::Application.translate("Chip_editor", "Package name:", nil, Qt::Application::UnicodeUTF8)
    @lie_pack_name.placeholderText = Qt::Application.translate("Chip_editor", "30 chars max", nil, Qt::Application::UnicodeUTF8)
    @lbl_pack_pin.text = Qt::Application.translate("Chip_editor", "Package pin number:", nil, Qt::Application::UnicodeUTF8)
    @lie_pack_pin.inputMask = ''
    @lie_pack_pin.placeholderText = Qt::Application.translate("Chip_editor", "4-144", nil, Qt::Application::UnicodeUTF8)
    @lbl_pack_shape.text = Qt::Application.translate("Chip_editor", "Package shape:", nil, Qt::Application::UnicodeUTF8)
    @lie_reference.placeholderText = Qt::Application.translate("Chip_editor", "30 chars max", nil, Qt::Application::UnicodeUTF8)
    @groupBox.title = ''
    @rbn_3v.text = Qt::Application.translate("Chip_editor", "3,3V", nil, Qt::Application::UnicodeUTF8)
    @rbn_5v.text = Qt::Application.translate("Chip_editor", "5V", nil, Qt::Application::UnicodeUTF8)
    @lbl_voltage.text = Qt::Application.translate("Chip_editor", "Voltage:", nil, Qt::Application::UnicodeUTF8)
    @groupBox_2.title = ''
    @rbn_square.text = Qt::Application.translate("Chip_editor", "Square", nil, Qt::Application::UnicodeUTF8)
    @rbn_rectangular.text = Qt::Application.translate("Chip_editor", "Rectangular", nil, Qt::Application::UnicodeUTF8)
    @lbl_manu.text = Qt::Application.translate("Chip_editor", "Manufacturer:", nil, Qt::Application::UnicodeUTF8)
    @lie_manu_name.placeholderText = Qt::Application.translate("Chip_editor", "Other...", nil, Qt::Application::UnicodeUTF8)
    @lbl_type.text = Qt::Application.translate("Chip_editor", "Type:", nil, Qt::Application::UnicodeUTF8)
    @cbx_type.insertItems(0, [Qt::Application.translate("Chip_editor", "Select...", nil, Qt::Application::UnicodeUTF8)])
    @btn_type_remove.text = Qt::Application.translate("Chip_editor", "X", nil, Qt::Application::UnicodeUTF8)
    @lie_type_name.text = ''
    @lie_type_name.placeholderText = Qt::Application.translate("Chip_editor", "Other...", nil, Qt::Application::UnicodeUTF8)
    @lbl_description.text = Qt::Application.translate("Chip_editor", "Description:", nil, Qt::Application::UnicodeUTF8)
    @lie_description.placeholderText = Qt::Application.translate("Chip_editor", "200 chars max", nil, Qt::Application::UnicodeUTF8)
    @cbx_manufacturer.insertItems(0, [Qt::Application.translate("Chip_editor", "Select...", nil, Qt::Application::UnicodeUTF8)])
    @btn_manu_remove.text = Qt::Application.translate("Chip_editor", "X", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(chip_editor)
        retranslateUi(chip_editor)
    end

end

module Ui
    class Chip_editor < Ui_Chip_editor
    end
end  # module Ui

