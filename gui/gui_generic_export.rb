=begin
** Form generated from reading ui file 'gui_generic_export.ui'
**
** Created: mer. nov. 16 20:48:14 2016
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Generic_export
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :hl2
    attr_reader :lbl_chip
    attr_reader :lbl_export
    attr_reader :hs
    attr_reader :fl
    attr_reader :lbl_start
    attr_reader :lie_start
    attr_reader :lbl_stop
    attr_reader :lie_stop
    attr_reader :lbl_file
    attr_reader :btn_file
    attr_reader :lbl_selected
    attr_reader :lbl_selected_file
    attr_reader :hl
    attr_reader :btn_export
    attr_reader :btn_full_export

    def setupUi(generic_export)
    if generic_export.objectName.nil?
        generic_export.objectName = "generic_export"
    end
    generic_export.windowModality = Qt::ApplicationModal
    generic_export.resize(254, 203)
    @gridLayout = Qt::GridLayout.new(generic_export)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @lbl_chip = Qt::Label.new(generic_export)
    @lbl_chip.objectName = "lbl_chip"

    @hl2.addWidget(@lbl_chip)

    @lbl_export = Qt::Label.new(generic_export)
    @lbl_export.objectName = "lbl_export"

    @hl2.addWidget(@lbl_export)

    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl2.addItem(@hs)


    @vl.addLayout(@hl2)

    @fl = Qt::FormLayout.new()
    @fl.objectName = "fl"
    @lbl_start = Qt::Label.new(generic_export)
    @lbl_start.objectName = "lbl_start"

    @fl.setWidget(2, Qt::FormLayout::LabelRole, @lbl_start)

    @lie_start = Qt::LineEdit.new(generic_export)
    @lie_start.objectName = "lie_start"
    @lie_start.maxLength = 20

    @fl.setWidget(2, Qt::FormLayout::FieldRole, @lie_start)

    @lbl_stop = Qt::Label.new(generic_export)
    @lbl_stop.objectName = "lbl_stop"

    @fl.setWidget(3, Qt::FormLayout::LabelRole, @lbl_stop)

    @lie_stop = Qt::LineEdit.new(generic_export)
    @lie_stop.objectName = "lie_stop"
    @lie_stop.maxLength = 20

    @fl.setWidget(3, Qt::FormLayout::FieldRole, @lie_stop)

    @lbl_file = Qt::Label.new(generic_export)
    @lbl_file.objectName = "lbl_file"

    @fl.setWidget(4, Qt::FormLayout::LabelRole, @lbl_file)

    @btn_file = Qt::PushButton.new(generic_export)
    @btn_file.objectName = "btn_file"

    @fl.setWidget(4, Qt::FormLayout::FieldRole, @btn_file)

    @lbl_selected = Qt::Label.new(generic_export)
    @lbl_selected.objectName = "lbl_selected"

    @fl.setWidget(5, Qt::FormLayout::LabelRole, @lbl_selected)

    @lbl_selected_file = Qt::Label.new(generic_export)
    @lbl_selected_file.objectName = "lbl_selected_file"
    @lbl_selected_file.maximumSize = Qt::Size.new(250, 16777215)

    @fl.setWidget(5, Qt::FormLayout::FieldRole, @lbl_selected_file)


    @vl.addLayout(@fl)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @btn_export = Qt::PushButton.new(generic_export)
    @btn_export.objectName = "btn_export"
    @btn_export.enabled = false

    @hl.addWidget(@btn_export)

    @btn_full_export = Qt::PushButton.new(generic_export)
    @btn_full_export.objectName = "btn_full_export"
    @btn_full_export.enabled = false

    @hl.addWidget(@btn_full_export)


    @vl.addLayout(@hl)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)


    retranslateUi(generic_export)
    Qt::Object.connect(@btn_export, SIGNAL('clicked()'), generic_export, SLOT('export()'))
    Qt::Object.connect(@btn_full_export, SIGNAL('clicked()'), generic_export, SLOT('export()'))
    Qt::Object.connect(@btn_file, SIGNAL('clicked()'), generic_export, SLOT('select_export_file()'))

    Qt::MetaObject.connectSlotsByName(generic_export)
    end # setupUi

    def setup_ui(generic_export)
        setupUi(generic_export)
    end

    def retranslateUi(generic_export)
    generic_export.windowTitle = Qt::Application.translate("Generic_export", "Hardsploit - Export (Dump)", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Generic_export", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_export.text = Qt::Application.translate("Generic_export", "Export (Dump)", nil, Qt::Application::UnicodeUTF8)
    @lbl_start.text = Qt::Application.translate("Generic_export", "Start address:", nil, Qt::Application::UnicodeUTF8)
    @lbl_stop.text = Qt::Application.translate("Generic_export", "Stop address:", nil, Qt::Application::UnicodeUTF8)
    @lbl_file.text = Qt::Application.translate("Generic_export", "File:", nil, Qt::Application::UnicodeUTF8)
    @btn_file.text = Qt::Application.translate("Generic_export", "File...", nil, Qt::Application::UnicodeUTF8)
    @lbl_selected.text = Qt::Application.translate("Generic_export", "Selected file:", nil, Qt::Application::UnicodeUTF8)
    @lbl_selected_file.text = Qt::Application.translate("Generic_export", "None", nil, Qt::Application::UnicodeUTF8)
    @btn_export.text = Qt::Application.translate("Generic_export", "Export", nil, Qt::Application::UnicodeUTF8)
    @btn_full_export.text = Qt::Application.translate("Generic_export", "Full export", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(generic_export)
        retranslateUi(generic_export)
    end

end

module Ui
    class Generic_export < Ui_Generic_export
    end
end  # module Ui

