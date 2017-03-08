=begin
** Form generated from reading ui file 'gui_generic_write.ui'
**
** Created: mer. mars 8 11:15:05 2017
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Generic_write
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :hl2
    attr_reader :lbl_write
    attr_reader :lbl_chip
    attr_reader :hs
    attr_reader :formLayout
    attr_reader :lbl_file
    attr_reader :btn_file
    attr_reader :lbl_selected
    attr_reader :lbl_selected_file
    attr_reader :lbl_start
    attr_reader :lie_start
    attr_reader :hl
    attr_reader :btn_write

    def setupUi(generic_write)
    if generic_write.objectName.nil?
        generic_write.objectName = "generic_write"
    end
    generic_write.windowModality = Qt::ApplicationModal
    generic_write.resize(241, 155)
    @gridLayout = Qt::GridLayout.new(generic_write)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @lbl_write = Qt::Label.new(generic_write)
    @lbl_write.objectName = "lbl_write"

    @hl2.addWidget(@lbl_write)

    @lbl_chip = Qt::Label.new(generic_write)
    @lbl_chip.objectName = "lbl_chip"

    @hl2.addWidget(@lbl_chip)

    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl2.addItem(@hs)


    @vl.addLayout(@hl2)

    @formLayout = Qt::FormLayout.new()
    @formLayout.objectName = "formLayout"
    @lbl_file = Qt::Label.new(generic_write)
    @lbl_file.objectName = "lbl_file"

    @formLayout.setWidget(0, Qt::FormLayout::LabelRole, @lbl_file)

    @btn_file = Qt::PushButton.new(generic_write)
    @btn_file.objectName = "btn_file"

    @formLayout.setWidget(0, Qt::FormLayout::FieldRole, @btn_file)

    @lbl_selected = Qt::Label.new(generic_write)
    @lbl_selected.objectName = "lbl_selected"

    @formLayout.setWidget(1, Qt::FormLayout::LabelRole, @lbl_selected)

    @lbl_selected_file = Qt::Label.new(generic_write)
    @lbl_selected_file.objectName = "lbl_selected_file"
    @lbl_selected_file.maximumSize = Qt::Size.new(250, 16777215)

    @formLayout.setWidget(1, Qt::FormLayout::FieldRole, @lbl_selected_file)

    @lbl_start = Qt::Label.new(generic_write)
    @lbl_start.objectName = "lbl_start"

    @formLayout.setWidget(2, Qt::FormLayout::LabelRole, @lbl_start)

    @lie_start = Qt::LineEdit.new(generic_write)
    @lie_start.objectName = "lie_start"
    @lie_start.maxLength = 20

    @formLayout.setWidget(2, Qt::FormLayout::FieldRole, @lie_start)


    @vl.addLayout(@formLayout)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @btn_write = Qt::PushButton.new(generic_write)
    @btn_write.objectName = "btn_write"
    @btn_write.enabled = false

    @hl.addWidget(@btn_write)


    @vl.addLayout(@hl)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)


    retranslateUi(generic_write)
    Qt::Object.connect(@btn_write, SIGNAL('clicked()'), generic_write, SLOT('write()'))
    Qt::Object.connect(@btn_file, SIGNAL('clicked()'), generic_write, SLOT('select_write_file()'))

    Qt::MetaObject.connectSlotsByName(generic_write)
    end # setupUi

    def setup_ui(generic_write)
        setupUi(generic_write)
    end

    def retranslateUi(generic_write)
    generic_write.windowTitle = Qt::Application.translate("Generic_write", "Hardsploit - Write", nil, Qt::Application::UnicodeUTF8)
    @lbl_write.text = Qt::Application.translate("Generic_write", "Write in", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Generic_write", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_file.text = Qt::Application.translate("Generic_write", "Content to write:", nil, Qt::Application::UnicodeUTF8)
    @btn_file.text = Qt::Application.translate("Generic_write", "File...", nil, Qt::Application::UnicodeUTF8)
    @lbl_selected.text = Qt::Application.translate("Generic_write", "Selected file:", nil, Qt::Application::UnicodeUTF8)
    @lbl_selected_file.text = Qt::Application.translate("Generic_write", "None", nil, Qt::Application::UnicodeUTF8)
    @lbl_start.text = Qt::Application.translate("Generic_write", "Start address:", nil, Qt::Application::UnicodeUTF8)
    @lie_start.text = Qt::Application.translate("Generic_write", "0", nil, Qt::Application::UnicodeUTF8)
    @btn_write.text = Qt::Application.translate("Generic_write", "Write", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(generic_write)
        retranslateUi(generic_write)
    end

end

module Ui
    class Generic_write < Ui_Generic_write
    end
end  # module Ui

