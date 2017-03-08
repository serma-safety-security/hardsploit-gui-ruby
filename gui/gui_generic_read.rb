=begin
** Form generated from reading ui file 'gui_generic_read.ui'
**
** Created: mer. mars 8 11:15:04 2017
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Generic_read
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :hl2
    attr_reader :lbl_read
    attr_reader :lbl_chip
    attr_reader :hs
    attr_reader :formLayout
    attr_reader :lbl_file
    attr_reader :btn_file
    attr_reader :lbl_selected
    attr_reader :lbl_selected_file
    attr_reader :lbl_type
    attr_reader :rbn_full
    attr_reader :rbn_range
    attr_reader :lbl_start
    attr_reader :lie_start
    attr_reader :lbl_stop
    attr_reader :lie_stop
    attr_reader :hl
    attr_reader :btn_read

    def setupUi(generic_read)
    if generic_read.objectName.nil?
        generic_read.objectName = "generic_read"
    end
    generic_read.windowModality = Qt::ApplicationModal
    generic_read.resize(280, 221)
    generic_read.minimumSize = Qt::Size.new(5, 0)
    generic_read.maximumSize = Qt::Size.new(16777211, 16777215)
    @gridLayout = Qt::GridLayout.new(generic_read)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @lbl_read = Qt::Label.new(generic_read)
    @lbl_read.objectName = "lbl_read"

    @hl2.addWidget(@lbl_read)

    @lbl_chip = Qt::Label.new(generic_read)
    @lbl_chip.objectName = "lbl_chip"

    @hl2.addWidget(@lbl_chip)

    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl2.addItem(@hs)


    @vl.addLayout(@hl2)

    @formLayout = Qt::FormLayout.new()
    @formLayout.objectName = "formLayout"
    @lbl_file = Qt::Label.new(generic_read)
    @lbl_file.objectName = "lbl_file"

    @formLayout.setWidget(0, Qt::FormLayout::LabelRole, @lbl_file)

    @btn_file = Qt::PushButton.new(generic_read)
    @btn_file.objectName = "btn_file"

    @formLayout.setWidget(0, Qt::FormLayout::FieldRole, @btn_file)

    @lbl_selected = Qt::Label.new(generic_read)
    @lbl_selected.objectName = "lbl_selected"

    @formLayout.setWidget(1, Qt::FormLayout::LabelRole, @lbl_selected)

    @lbl_selected_file = Qt::Label.new(generic_read)
    @lbl_selected_file.objectName = "lbl_selected_file"
    @lbl_selected_file.maximumSize = Qt::Size.new(250, 16777215)

    @formLayout.setWidget(1, Qt::FormLayout::FieldRole, @lbl_selected_file)

    @lbl_type = Qt::Label.new(generic_read)
    @lbl_type.objectName = "lbl_type"

    @formLayout.setWidget(2, Qt::FormLayout::LabelRole, @lbl_type)

    @rbn_full = Qt::RadioButton.new(generic_read)
    @rbn_full.objectName = "rbn_full"
    @rbn_full.checked = true

    @formLayout.setWidget(2, Qt::FormLayout::FieldRole, @rbn_full)

    @rbn_range = Qt::RadioButton.new(generic_read)
    @rbn_range.objectName = "rbn_range"

    @formLayout.setWidget(3, Qt::FormLayout::FieldRole, @rbn_range)

    @lbl_start = Qt::Label.new(generic_read)
    @lbl_start.objectName = "lbl_start"

    @formLayout.setWidget(4, Qt::FormLayout::LabelRole, @lbl_start)

    @lie_start = Qt::LineEdit.new(generic_read)
    @lie_start.objectName = "lie_start"
    @lie_start.enabled = false
    @lie_start.maxLength = 20

    @formLayout.setWidget(4, Qt::FormLayout::FieldRole, @lie_start)

    @lbl_stop = Qt::Label.new(generic_read)
    @lbl_stop.objectName = "lbl_stop"

    @formLayout.setWidget(5, Qt::FormLayout::LabelRole, @lbl_stop)

    @lie_stop = Qt::LineEdit.new(generic_read)
    @lie_stop.objectName = "lie_stop"
    @lie_stop.enabled = false
    @lie_stop.maxLength = 20

    @formLayout.setWidget(5, Qt::FormLayout::FieldRole, @lie_stop)


    @vl.addLayout(@formLayout)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @btn_read = Qt::PushButton.new(generic_read)
    @btn_read.objectName = "btn_read"
    @btn_read.enabled = false

    @hl.addWidget(@btn_read)


    @vl.addLayout(@hl)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)


    retranslateUi(generic_read)
    Qt::Object.connect(@btn_read, SIGNAL('clicked()'), generic_read, SLOT('read()'))
    Qt::Object.connect(@btn_file, SIGNAL('clicked()'), generic_read, SLOT('select_read_file()'))
    Qt::Object.connect(@rbn_range, SIGNAL('toggled(bool)'), @lie_start, SLOT('setEnabled(bool)'))
    Qt::Object.connect(@rbn_range, SIGNAL('toggled(bool)'), @lie_stop, SLOT('setEnabled(bool)'))
    Qt::Object.connect(@rbn_full, SIGNAL('toggled(bool)'), @lie_start, SLOT('setDisabled(bool)'))
    Qt::Object.connect(@rbn_full, SIGNAL('toggled(bool)'), @lie_stop, SLOT('setDisabled(bool)'))

    Qt::MetaObject.connectSlotsByName(generic_read)
    end # setupUi

    def setup_ui(generic_read)
        setupUi(generic_read)
    end

    def retranslateUi(generic_read)
    generic_read.windowTitle = Qt::Application.translate("Generic_read", "Hardsploit - Read", nil, Qt::Application::UnicodeUTF8)
    @lbl_read.text = Qt::Application.translate("Generic_read", "Read from", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Generic_read", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_file.text = Qt::Application.translate("Generic_read", "Result file:", nil, Qt::Application::UnicodeUTF8)
    @btn_file.text = Qt::Application.translate("Generic_read", "File...", nil, Qt::Application::UnicodeUTF8)
    @lbl_selected.text = Qt::Application.translate("Generic_read", "Selected file:", nil, Qt::Application::UnicodeUTF8)
    @lbl_selected_file.text = Qt::Application.translate("Generic_read", "None", nil, Qt::Application::UnicodeUTF8)
    @lbl_type.text = Qt::Application.translate("Generic_read", "Type:", nil, Qt::Application::UnicodeUTF8)
    @rbn_full.text = Qt::Application.translate("Generic_read", "Full read", nil, Qt::Application::UnicodeUTF8)
    @rbn_range.text = Qt::Application.translate("Generic_read", "Range", nil, Qt::Application::UnicodeUTF8)
    @lbl_start.text = Qt::Application.translate("Generic_read", "Start address:", nil, Qt::Application::UnicodeUTF8)
    @lbl_stop.text = Qt::Application.translate("Generic_read", "Stop address:", nil, Qt::Application::UnicodeUTF8)
    @btn_read.text = Qt::Application.translate("Generic_read", "Read", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(generic_read)
        retranslateUi(generic_read)
    end

end

module Ui
    class Generic_read < Ui_Generic_read
    end
end  # module Ui

