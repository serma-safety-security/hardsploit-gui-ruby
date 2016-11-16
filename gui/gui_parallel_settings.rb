=begin
** Form generated from reading ui file 'gui_parallel_settings.ui'
**
** Created: mer. nov. 16 20:48:14 2016
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Parallel_settings
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :hl2
    attr_reader :lbl_chip
    attr_reader :lbl_parameters
    attr_reader :hs2
    attr_reader :fl
    attr_reader :lbl_total_size
    attr_reader :lie_total_size
    attr_reader :lbl_latency
    attr_reader :lie_read_latency
    attr_reader :lbl_write_latency
    attr_reader :lie_write_latency
    attr_reader :lbl_word_size
    attr_reader :groupBox
    attr_reader :rbn_8b
    attr_reader :rbn_16b
    attr_reader :lbl_page_size
    attr_reader :lie_page_size
    attr_reader :hl
    attr_reader :hs
    attr_reader :btn_cancel
    attr_reader :btn_save

    def setupUi(parallel_settings)
    if parallel_settings.objectName.nil?
        parallel_settings.objectName = "parallel_settings"
    end
    parallel_settings.resize(384, 216)
    @gridLayout = Qt::GridLayout.new(parallel_settings)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @lbl_chip = Qt::Label.new(parallel_settings)
    @lbl_chip.objectName = "lbl_chip"

    @hl2.addWidget(@lbl_chip)

    @lbl_parameters = Qt::Label.new(parallel_settings)
    @lbl_parameters.objectName = "lbl_parameters"

    @hl2.addWidget(@lbl_parameters)

    @hs2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl2.addItem(@hs2)


    @vl.addLayout(@hl2)

    @fl = Qt::FormLayout.new()
    @fl.objectName = "fl"
    @lbl_total_size = Qt::Label.new(parallel_settings)
    @lbl_total_size.objectName = "lbl_total_size"

    @fl.setWidget(1, Qt::FormLayout::LabelRole, @lbl_total_size)

    @lie_total_size = Qt::LineEdit.new(parallel_settings)
    @lie_total_size.objectName = "lie_total_size"
    @lie_total_size.maxLength = 20

    @fl.setWidget(1, Qt::FormLayout::FieldRole, @lie_total_size)

    @lbl_latency = Qt::Label.new(parallel_settings)
    @lbl_latency.objectName = "lbl_latency"

    @fl.setWidget(2, Qt::FormLayout::LabelRole, @lbl_latency)

    @lie_read_latency = Qt::LineEdit.new(parallel_settings)
    @lie_read_latency.objectName = "lie_read_latency"
    @lie_read_latency.maxLength = 20

    @fl.setWidget(2, Qt::FormLayout::FieldRole, @lie_read_latency)

    @lbl_write_latency = Qt::Label.new(parallel_settings)
    @lbl_write_latency.objectName = "lbl_write_latency"

    @fl.setWidget(3, Qt::FormLayout::LabelRole, @lbl_write_latency)

    @lie_write_latency = Qt::LineEdit.new(parallel_settings)
    @lie_write_latency.objectName = "lie_write_latency"

    @fl.setWidget(3, Qt::FormLayout::FieldRole, @lie_write_latency)

    @lbl_word_size = Qt::Label.new(parallel_settings)
    @lbl_word_size.objectName = "lbl_word_size"

    @fl.setWidget(4, Qt::FormLayout::LabelRole, @lbl_word_size)

    @groupBox = Qt::GroupBox.new(parallel_settings)
    @groupBox.objectName = "groupBox"
    @rbn_8b = Qt::RadioButton.new(@groupBox)
    @rbn_8b.objectName = "rbn_8b"
    @rbn_8b.geometry = Qt::Rect.new(0, 0, 71, 20)
    @rbn_8b.checked = true
    @rbn_16b = Qt::RadioButton.new(@groupBox)
    @rbn_16b.objectName = "rbn_16b"
    @rbn_16b.geometry = Qt::Rect.new(80, 0, 81, 21)

    @fl.setWidget(4, Qt::FormLayout::FieldRole, @groupBox)

    @lbl_page_size = Qt::Label.new(parallel_settings)
    @lbl_page_size.objectName = "lbl_page_size"

    @fl.setWidget(5, Qt::FormLayout::LabelRole, @lbl_page_size)

    @lie_page_size = Qt::LineEdit.new(parallel_settings)
    @lie_page_size.objectName = "lie_page_size"

    @fl.setWidget(5, Qt::FormLayout::FieldRole, @lie_page_size)


    @vl.addLayout(@fl)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)

    @btn_cancel = Qt::PushButton.new(parallel_settings)
    @btn_cancel.objectName = "btn_cancel"

    @hl.addWidget(@btn_cancel)

    @btn_save = Qt::PushButton.new(parallel_settings)
    @btn_save.objectName = "btn_save"
    @btn_save.maximumSize = Qt::Size.new(16777215, 16777215)

    @hl.addWidget(@btn_save)


    @vl.addLayout(@hl)


    @gridLayout.addLayout(@vl, 1, 0, 1, 1)


    retranslateUi(parallel_settings)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), parallel_settings, SLOT('close()'))
    Qt::Object.connect(@btn_save, SIGNAL('clicked()'), parallel_settings, SLOT('save_settings()'))

    Qt::MetaObject.connectSlotsByName(parallel_settings)
    end # setupUi

    def setup_ui(parallel_settings)
        setupUi(parallel_settings)
    end

    def retranslateUi(parallel_settings)
    parallel_settings.windowTitle = Qt::Application.translate("Parallel_settings", "Hardsploit - Parallel settings", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Parallel_settings", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_parameters.text = Qt::Application.translate("Parallel_settings", "PARAMETERS", nil, Qt::Application::UnicodeUTF8)
    @lbl_total_size.text = Qt::Application.translate("Parallel_settings", "Total size:", nil, Qt::Application::UnicodeUTF8)
    @lie_total_size.text = ''
    @lie_total_size.placeholderText = Qt::Application.translate("Parallel_settings", "in bytes", nil, Qt::Application::UnicodeUTF8)
    @lbl_latency.text = Qt::Application.translate("Parallel_settings", "Read latency:", nil, Qt::Application::UnicodeUTF8)
    @lie_read_latency.placeholderText = Qt::Application.translate("Parallel_settings", " 0 to 1600 nanosecondes", nil, Qt::Application::UnicodeUTF8)
    @lbl_write_latency.text = Qt::Application.translate("Parallel_settings", "Write latency", nil, Qt::Application::UnicodeUTF8)
    @lie_write_latency.text = ''
    @lie_write_latency.placeholderText = Qt::Application.translate("Parallel_settings", "in nanosecondes (7 to 1965)", nil, Qt::Application::UnicodeUTF8)
    @lbl_word_size.text = Qt::Application.translate("Parallel_settings", "Word size:", nil, Qt::Application::UnicodeUTF8)
    @groupBox.title = ''
    @rbn_8b.text = Qt::Application.translate("Parallel_settings", "8 bits", nil, Qt::Application::UnicodeUTF8)
    @rbn_16b.text = Qt::Application.translate("Parallel_settings", "16 bits", nil, Qt::Application::UnicodeUTF8)
    @lbl_page_size.text = Qt::Application.translate("Parallel_settings", "Page size:", nil, Qt::Application::UnicodeUTF8)
    @lie_page_size.text = ''
    @lie_page_size.placeholderText = Qt::Application.translate("Parallel_settings", "in bytes", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("Parallel_settings", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @btn_save.text = Qt::Application.translate("Parallel_settings", "Save", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(parallel_settings)
        retranslateUi(parallel_settings)
    end

end

module Ui
    class Parallel_settings < Ui_Parallel_settings
    end
end  # module Ui

