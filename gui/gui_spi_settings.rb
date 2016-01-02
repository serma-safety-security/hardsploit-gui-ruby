=begin
** Form generated from reading ui file 'gui_spi_settings.ui'
**
** Created: jeu. déc. 3 15:41:20 2015
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Spi_settings
    attr_reader :gridLayout
    attr_reader :hl2
    attr_reader :fl
    attr_reader :lbl_frequency
    attr_reader :cbx_frequency
    attr_reader :lbl_cmd_read
    attr_reader :lie_cmd_read
    attr_reader :lbl_page_size
    attr_reader :lie_page_size
    attr_reader :fl2
    attr_reader :lbl_total_size
    attr_reader :lie_total_size
    attr_reader :lbl_mode
    attr_reader :cbx_mode
    attr_reader :btn_save
    attr_reader :hl
    attr_reader :lbl_chip
    attr_reader :lbl_param
    attr_reader :hs

    def setupUi(spi_settings)
    if spi_settings.objectName.nil?
        spi_settings.objectName = "spi_settings"
    end
    spi_settings.resize(531, 125)
    @gridLayout = Qt::GridLayout.new(spi_settings)
    @gridLayout.objectName = "gridLayout"
    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @fl = Qt::FormLayout.new()
    @fl.objectName = "fl"
    @lbl_frequency = Qt::Label.new(spi_settings)
    @lbl_frequency.objectName = "lbl_frequency"

    @fl.setWidget(1, Qt::FormLayout::LabelRole, @lbl_frequency)

    @cbx_frequency = Qt::ComboBox.new(spi_settings)
    @cbx_frequency.objectName = "cbx_frequency"
    @cbx_frequency.maximumSize = Qt::Size.new(100, 16777215)

    @fl.setWidget(1, Qt::FormLayout::FieldRole, @cbx_frequency)

    @lbl_cmd_read = Qt::Label.new(spi_settings)
    @lbl_cmd_read.objectName = "lbl_cmd_read"

    @fl.setWidget(2, Qt::FormLayout::LabelRole, @lbl_cmd_read)

    @lie_cmd_read = Qt::LineEdit.new(spi_settings)
    @lie_cmd_read.objectName = "lie_cmd_read"
    @lie_cmd_read.maximumSize = Qt::Size.new(100, 16777215)
    @lie_cmd_read.maxLength = 5

    @fl.setWidget(2, Qt::FormLayout::FieldRole, @lie_cmd_read)

    @lbl_page_size = Qt::Label.new(spi_settings)
    @lbl_page_size.objectName = "lbl_page_size"

    @fl.setWidget(0, Qt::FormLayout::LabelRole, @lbl_page_size)

    @lie_page_size = Qt::LineEdit.new(spi_settings)
    @lie_page_size.objectName = "lie_page_size"
    @lie_page_size.maximumSize = Qt::Size.new(100, 16777215)

    @fl.setWidget(0, Qt::FormLayout::FieldRole, @lie_page_size)


    @hl2.addLayout(@fl)

    @fl2 = Qt::FormLayout.new()
    @fl2.objectName = "fl2"
    @lbl_total_size = Qt::Label.new(spi_settings)
    @lbl_total_size.objectName = "lbl_total_size"

    @fl2.setWidget(0, Qt::FormLayout::LabelRole, @lbl_total_size)

    @lie_total_size = Qt::LineEdit.new(spi_settings)
    @lie_total_size.objectName = "lie_total_size"
    @lie_total_size.maximumSize = Qt::Size.new(100, 16777215)
    @lie_total_size.maxLength = 20

    @fl2.setWidget(0, Qt::FormLayout::FieldRole, @lie_total_size)

    @lbl_mode = Qt::Label.new(spi_settings)
    @lbl_mode.objectName = "lbl_mode"

    @fl2.setWidget(1, Qt::FormLayout::LabelRole, @lbl_mode)

    @cbx_mode = Qt::ComboBox.new(spi_settings)
    @cbx_mode.objectName = "cbx_mode"
    @cbx_mode.maximumSize = Qt::Size.new(100, 16777215)

    @fl2.setWidget(1, Qt::FormLayout::FieldRole, @cbx_mode)

    @btn_save = Qt::PushButton.new(spi_settings)
    @btn_save.objectName = "btn_save"
    @btn_save.maximumSize = Qt::Size.new(100, 16777215)

    @fl2.setWidget(2, Qt::FormLayout::FieldRole, @btn_save)


    @hl2.addLayout(@fl2)


    @gridLayout.addLayout(@hl2, 2, 0, 1, 1)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @lbl_chip = Qt::Label.new(spi_settings)
    @lbl_chip.objectName = "lbl_chip"

    @hl.addWidget(@lbl_chip)

    @lbl_param = Qt::Label.new(spi_settings)
    @lbl_param.objectName = "lbl_param"

    @hl.addWidget(@lbl_param)

    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)


    @gridLayout.addLayout(@hl, 1, 0, 1, 1)


    retranslateUi(spi_settings)
    Qt::Object.connect(@btn_save, SIGNAL('clicked()'), spi_settings, SLOT('save_settings()'))

    Qt::MetaObject.connectSlotsByName(spi_settings)
    end # setupUi

    def setup_ui(spi_settings)
        setupUi(spi_settings)
    end

    def retranslateUi(spi_settings)
    spi_settings.windowTitle = Qt::Application.translate("Spi_settings", "Hardsploit - Bus settings", nil, Qt::Application::UnicodeUTF8)
    @lbl_frequency.text = Qt::Application.translate("Spi_settings", "Frequency (Mhz):", nil, Qt::Application::UnicodeUTF8)
    @cbx_frequency.insertItems(0, [Qt::Application.translate("Spi_settings", "25.00", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "18.75", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "15.00", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "12.50", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "10.71", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "9.38", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "7.50", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "5.00", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "3.95", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "3.00", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "2.03", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "1.00", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "0.50", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "0.29", nil, Qt::Application::UnicodeUTF8)])
    @lbl_cmd_read.text = Qt::Application.translate("Spi_settings", "SPI command read:", nil, Qt::Application::UnicodeUTF8)
    @lie_cmd_read.text = Qt::Application.translate("Spi_settings", "3", nil, Qt::Application::UnicodeUTF8)
    @lbl_page_size.text = Qt::Application.translate("Spi_settings", "Page size:", nil, Qt::Application::UnicodeUTF8)
    @lbl_total_size.text = Qt::Application.translate("Spi_settings", "Total size (8 bits word):", nil, Qt::Application::UnicodeUTF8)
    @lbl_mode.text = Qt::Application.translate("Spi_settings", "Mode:", nil, Qt::Application::UnicodeUTF8)
    @cbx_mode.insertItems(0, [Qt::Application.translate("Spi_settings", "0", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "1", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "2", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_settings", "3", nil, Qt::Application::UnicodeUTF8)])
    @btn_save.text = Qt::Application.translate("Spi_settings", "Save", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Spi_settings", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_param.text = Qt::Application.translate("Spi_settings", "PARAMETERS", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(spi_settings)
        retranslateUi(spi_settings)
    end

end

module Ui
    class Spi_settings < Ui_Spi_settings
    end
end  # module Ui

