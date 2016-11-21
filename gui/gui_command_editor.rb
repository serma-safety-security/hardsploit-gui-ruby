=begin
** Form generated from reading ui file 'gui_command_editor.ui'
**
** Created: mer. nov. 16 20:48:14 2016
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Command_editor
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :vl2
    attr_reader :fl
    attr_reader :lbl_chip
    attr_reader :lbl_chip_val
    attr_reader :lbl_cmd
    attr_reader :lbl_cmd_val
    attr_reader :lbl_name
    attr_reader :lie_name
    attr_reader :lbl_description
    attr_reader :lie_description
    attr_reader :vl3
    attr_reader :label
    attr_reader :tbl_bytes
    attr_reader :hl2
    attr_reader :btn_clone
    attr_reader :btn_remove
    attr_reader :btn_add_row
    attr_reader :lie_text_2_bytes
    attr_reader :horizontalSpacer
    attr_reader :hl
    attr_reader :hs
    attr_reader :btn_cancel
    attr_reader :btn_validate

    def setupUi(command_editor)
    if command_editor.objectName.nil?
        command_editor.objectName = "command_editor"
    end
    command_editor.windowModality = Qt::ApplicationModal
    command_editor.resize(540, 440)
    @gridLayout = Qt::GridLayout.new(command_editor)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @vl2 = Qt::VBoxLayout.new()
    @vl2.objectName = "vl2"
    @fl = Qt::FormLayout.new()
    @fl.objectName = "fl"
    @lbl_chip = Qt::Label.new(command_editor)
    @lbl_chip.objectName = "lbl_chip"

    @fl.setWidget(2, Qt::FormLayout::LabelRole, @lbl_chip)

    @lbl_chip_val = Qt::Label.new(command_editor)
    @lbl_chip_val.objectName = "lbl_chip_val"

    @fl.setWidget(2, Qt::FormLayout::FieldRole, @lbl_chip_val)

    @lbl_cmd = Qt::Label.new(command_editor)
    @lbl_cmd.objectName = "lbl_cmd"

    @fl.setWidget(3, Qt::FormLayout::LabelRole, @lbl_cmd)

    @lbl_cmd_val = Qt::Label.new(command_editor)
    @lbl_cmd_val.objectName = "lbl_cmd_val"

    @fl.setWidget(3, Qt::FormLayout::FieldRole, @lbl_cmd_val)

    @lbl_name = Qt::Label.new(command_editor)
    @lbl_name.objectName = "lbl_name"

    @fl.setWidget(6, Qt::FormLayout::LabelRole, @lbl_name)

    @lie_name = Qt::LineEdit.new(command_editor)
    @lie_name.objectName = "lie_name"
    @lie_name.maximumSize = Qt::Size.new(300, 16777215)
    @lie_name.maxLength = 25

    @fl.setWidget(6, Qt::FormLayout::FieldRole, @lie_name)

    @lbl_description = Qt::Label.new(command_editor)
    @lbl_description.objectName = "lbl_description"

    @fl.setWidget(7, Qt::FormLayout::LabelRole, @lbl_description)

    @lie_description = Qt::LineEdit.new(command_editor)
    @lie_description.objectName = "lie_description"
    @lie_description.maximumSize = Qt::Size.new(300, 16777215)
    @lie_description.maxLength = 200

    @fl.setWidget(7, Qt::FormLayout::FieldRole, @lie_description)


    @vl2.addLayout(@fl)

    @vl3 = Qt::VBoxLayout.new()
    @vl3.objectName = "vl3"
    @label = Qt::Label.new(command_editor)
    @label.objectName = "label"

    @vl3.addWidget(@label)

    @tbl_bytes = Qt::TableWidget.new(command_editor)
    @tbl_bytes.objectName = "tbl_bytes"
    @font = Qt::Font.new
    @font.family = "Arial"
    @tbl_bytes.font = @font
    @tbl_bytes.sortingEnabled = true

    @vl3.addWidget(@tbl_bytes)

    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @btn_clone = Qt::PushButton.new(command_editor)
    @btn_clone.objectName = "btn_clone"
    @btn_clone.minimumSize = Qt::Size.new(0, 0)
    @btn_clone.maximumSize = Qt::Size.new(16777215, 16777215)

    @hl2.addWidget(@btn_clone)

    @btn_remove = Qt::PushButton.new(command_editor)
    @btn_remove.objectName = "btn_remove"
    @btn_remove.maximumSize = Qt::Size.new(30, 16777215)

    @hl2.addWidget(@btn_remove)

    @btn_add_row = Qt::PushButton.new(command_editor)
    @btn_add_row.objectName = "btn_add_row"
    @btn_add_row.maximumSize = Qt::Size.new(30, 16777215)

    @hl2.addWidget(@btn_add_row)

    @lie_text_2_bytes = Qt::LineEdit.new(command_editor)
    @lie_text_2_bytes.objectName = "lie_text_2_bytes"
    @lie_text_2_bytes.maxLength = 200

    @hl2.addWidget(@lie_text_2_bytes)

    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl2.addItem(@horizontalSpacer)


    @vl3.addLayout(@hl2)


    @vl2.addLayout(@vl3)


    @vl.addLayout(@vl2)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)

    @btn_cancel = Qt::PushButton.new(command_editor)
    @btn_cancel.objectName = "btn_cancel"

    @hl.addWidget(@btn_cancel)

    @btn_validate = Qt::PushButton.new(command_editor)
    @btn_validate.objectName = "btn_validate"

    @hl.addWidget(@btn_validate)


    @vl.addLayout(@hl)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)


    retranslateUi(command_editor)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), command_editor, SLOT('close()'))
    Qt::Object.connect(@btn_clone, SIGNAL('clicked()'), command_editor, SLOT('clone_row()'))
    Qt::Object.connect(@btn_remove, SIGNAL('clicked()'), command_editor, SLOT('remove_row()'))
    Qt::Object.connect(@btn_add_row, SIGNAL('clicked()'), command_editor, SLOT('add_row()'))
    Qt::Object.connect(@tbl_bytes, SIGNAL('itemChanged(QTableWidgetItem*)'), command_editor, SLOT('check_cell_content(QTableWidgetItem*)'))

    Qt::MetaObject.connectSlotsByName(command_editor)
    end # setupUi

    def setup_ui(command_editor)
        setupUi(command_editor)
    end

    def retranslateUi(command_editor)
    command_editor.windowTitle = Qt::Application.translate("Command_editor", "Hardsploit - Command editor", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Command_editor", "Current chip:", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip_val.text = Qt::Application.translate("Command_editor", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_cmd.text = Qt::Application.translate("Command_editor", "Current command:", nil, Qt::Application::UnicodeUTF8)
    @lbl_cmd_val.text = Qt::Application.translate("Command_editor", "[CMD]", nil, Qt::Application::UnicodeUTF8)
    @lbl_name.text = Qt::Application.translate("Command_editor", "Name:", nil, Qt::Application::UnicodeUTF8)
    @lie_name.inputMask = ''
    @lbl_description.text = Qt::Application.translate("Command_editor", "Description:", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("Command_editor", "Command bytes array:", nil, Qt::Application::UnicodeUTF8)
    @btn_clone.text = Qt::Application.translate("Command_editor", "Clone", nil, Qt::Application::UnicodeUTF8)
    @btn_remove.text = Qt::Application.translate("Command_editor", "-", nil, Qt::Application::UnicodeUTF8)
    @btn_add_row.text = Qt::Application.translate("Command_editor", "+", nil, Qt::Application::UnicodeUTF8)
    @lie_text_2_bytes.placeholderText = Qt::Application.translate("Command_editor", "Text to command bytes", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("Command_editor", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @btn_validate.text = Qt::Application.translate("Command_editor", "Add", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(command_editor)
        retranslateUi(command_editor)
    end

end

module Ui
    class Command_editor < Ui_Command_editor
    end
end  # module Ui

