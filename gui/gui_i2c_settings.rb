=begin
** Form generated from reading ui file 'gui_i2c_settings.ui'
**
** Created: ven. févr. 12 11:41:41 2016
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_I2c_settings
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :hl2
    attr_reader :lbl_chip
    attr_reader :lbl_parameters
    attr_reader :hs2
    attr_reader :fl
    attr_reader :lbl_address_w
    attr_reader :lie_address_w
    attr_reader :lbl_address_r
    attr_reader :lie_address_r
    attr_reader :lbl_frequency
    attr_reader :cbx_frequency
    attr_reader :lbl_full_size
    attr_reader :lie_total_size
    attr_reader :lbl_bus_scan
    attr_reader :btn_bus_scan
    attr_reader :lie_page_size
    attr_reader :lbl_page_size
    attr_reader :lbl_write_page_latency
    attr_reader :lie_write_page_latency
    attr_reader :tbl_bus_scan
    attr_reader :hl
    attr_reader :hs
    attr_reader :btn_cancel
    attr_reader :btn_save

    def setupUi(i2c_settings)
    if i2c_settings.objectName.nil?
        i2c_settings.objectName = "i2c_settings"
    end
    i2c_settings.resize(358, 396)
    @gridLayout = Qt::GridLayout.new(i2c_settings)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @lbl_chip = Qt::Label.new(i2c_settings)
    @lbl_chip.objectName = "lbl_chip"

    @hl2.addWidget(@lbl_chip)

    @lbl_parameters = Qt::Label.new(i2c_settings)
    @lbl_parameters.objectName = "lbl_parameters"

    @hl2.addWidget(@lbl_parameters)

    @hs2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl2.addItem(@hs2)


    @vl.addLayout(@hl2)

    @fl = Qt::FormLayout.new()
    @fl.objectName = "fl"
    @lbl_address_w = Qt::Label.new(i2c_settings)
    @lbl_address_w.objectName = "lbl_address_w"

    @fl.setWidget(1, Qt::FormLayout::LabelRole, @lbl_address_w)

    @lie_address_w = Qt::LineEdit.new(i2c_settings)
    @lie_address_w.objectName = "lie_address_w"
    @lie_address_w.maxLength = 2

    @fl.setWidget(1, Qt::FormLayout::FieldRole, @lie_address_w)

    @lbl_address_r = Qt::Label.new(i2c_settings)
    @lbl_address_r.objectName = "lbl_address_r"

    @fl.setWidget(2, Qt::FormLayout::LabelRole, @lbl_address_r)

    @lie_address_r = Qt::LineEdit.new(i2c_settings)
    @lie_address_r.objectName = "lie_address_r"
    @lie_address_r.maxLength = 2

    @fl.setWidget(2, Qt::FormLayout::FieldRole, @lie_address_r)

    @lbl_frequency = Qt::Label.new(i2c_settings)
    @lbl_frequency.objectName = "lbl_frequency"

    @fl.setWidget(3, Qt::FormLayout::LabelRole, @lbl_frequency)

    @cbx_frequency = Qt::ComboBox.new(i2c_settings)
    @cbx_frequency.objectName = "cbx_frequency"

    @fl.setWidget(3, Qt::FormLayout::FieldRole, @cbx_frequency)

    @lbl_full_size = Qt::Label.new(i2c_settings)
    @lbl_full_size.objectName = "lbl_full_size"

    @fl.setWidget(6, Qt::FormLayout::LabelRole, @lbl_full_size)

    @lie_total_size = Qt::LineEdit.new(i2c_settings)
    @lie_total_size.objectName = "lie_total_size"

    @fl.setWidget(6, Qt::FormLayout::FieldRole, @lie_total_size)

    @lbl_bus_scan = Qt::Label.new(i2c_settings)
    @lbl_bus_scan.objectName = "lbl_bus_scan"

    @fl.setWidget(7, Qt::FormLayout::LabelRole, @lbl_bus_scan)

    @btn_bus_scan = Qt::PushButton.new(i2c_settings)
    @btn_bus_scan.objectName = "btn_bus_scan"

    @fl.setWidget(7, Qt::FormLayout::FieldRole, @btn_bus_scan)

    @lie_page_size = Qt::LineEdit.new(i2c_settings)
    @lie_page_size.objectName = "lie_page_size"

    @fl.setWidget(5, Qt::FormLayout::FieldRole, @lie_page_size)

    @lbl_page_size = Qt::Label.new(i2c_settings)
    @lbl_page_size.objectName = "lbl_page_size"

    @fl.setWidget(5, Qt::FormLayout::LabelRole, @lbl_page_size)

    @lbl_write_page_latency = Qt::Label.new(i2c_settings)
    @lbl_write_page_latency.objectName = "lbl_write_page_latency"

    @fl.setWidget(4, Qt::FormLayout::LabelRole, @lbl_write_page_latency)

    @lie_write_page_latency = Qt::LineEdit.new(i2c_settings)
    @lie_write_page_latency.objectName = "lie_write_page_latency"

    @fl.setWidget(4, Qt::FormLayout::FieldRole, @lie_write_page_latency)


    @vl.addLayout(@fl)

    @tbl_bus_scan = Qt::TableWidget.new(i2c_settings)
    @tbl_bus_scan.objectName = "tbl_bus_scan"

    @vl.addWidget(@tbl_bus_scan)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)

    @btn_cancel = Qt::PushButton.new(i2c_settings)
    @btn_cancel.objectName = "btn_cancel"

    @hl.addWidget(@btn_cancel)

    @btn_save = Qt::PushButton.new(i2c_settings)
    @btn_save.objectName = "btn_save"
    @btn_save.maximumSize = Qt::Size.new(16777215, 16777215)

    @hl.addWidget(@btn_save)


    @vl.addLayout(@hl)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)


    retranslateUi(i2c_settings)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), i2c_settings, SLOT('close()'))
    Qt::Object.connect(@btn_save, SIGNAL('clicked()'), i2c_settings, SLOT('save_settings()'))
    Qt::Object.connect(@btn_bus_scan, SIGNAL('clicked()'), i2c_settings, SLOT('bus_scan()'))

    Qt::MetaObject.connectSlotsByName(i2c_settings)
    end # setupUi

    def setup_ui(i2c_settings)
        setupUi(i2c_settings)
    end

    def retranslateUi(i2c_settings)
    i2c_settings.windowTitle = Qt::Application.translate("I2c_settings", "Hardsploit - I\302\262C settings", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("I2c_settings", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_parameters.text = Qt::Application.translate("I2c_settings", "PARAMETERS", nil, Qt::Application::UnicodeUTF8)
    @lbl_address_w.text = Qt::Application.translate("I2c_settings", "Base address (W):", nil, Qt::Application::UnicodeUTF8)
    @lie_address_w.placeholderText = Qt::Application.translate("I2c_settings", "in hexadecimal", nil, Qt::Application::UnicodeUTF8)
    @lbl_address_r.text = Qt::Application.translate("I2c_settings", "Base address (R):", nil, Qt::Application::UnicodeUTF8)
    @lie_address_r.placeholderText = Qt::Application.translate("I2c_settings", "in hexadecimal", nil, Qt::Application::UnicodeUTF8)
    @lbl_frequency.text = Qt::Application.translate("I2c_settings", "Frequency (Khz):", nil, Qt::Application::UnicodeUTF8)
    @cbx_frequency.insertItems(0, [Qt::Application.translate("I2c_settings", "100", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("I2c_settings", "400", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("I2c_settings", "1000", nil, Qt::Application::UnicodeUTF8)])
    @lbl_full_size.text = Qt::Application.translate("I2c_settings", "Total size:", nil, Qt::Application::UnicodeUTF8)
    @lie_total_size.placeholderText = Qt::Application.translate("I2c_settings", "in octet, to a maximum of 4Go", nil, Qt::Application::UnicodeUTF8)
    @lbl_bus_scan.text = Qt::Application.translate("I2c_settings", "Bus scan:", nil, Qt::Application::UnicodeUTF8)
    @btn_bus_scan.text = Qt::Application.translate("I2c_settings", "Launch", nil, Qt::Application::UnicodeUTF8)
    @lie_page_size.text = ''
    @lie_page_size.placeholderText = Qt::Application.translate("I2c_settings", "in octet", nil, Qt::Application::UnicodeUTF8)
    @lbl_page_size.text = Qt::Application.translate("I2c_settings", "Page size:", nil, Qt::Application::UnicodeUTF8)
    @lbl_write_page_latency.text = Qt::Application.translate("I2c_settings", "Write page latency:", nil, Qt::Application::UnicodeUTF8)
    @lie_write_page_latency.placeholderText = Qt::Application.translate("I2c_settings", "in miliseconds", nil, Qt::Application::UnicodeUTF8)
    if @tbl_bus_scan.columnCount < 2
        @tbl_bus_scan.columnCount = 2
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("I2c_settings", "Address", nil, Qt::Application::UnicodeUTF8))
    @tbl_bus_scan.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("I2c_settings", "R/W", nil, Qt::Application::UnicodeUTF8))
    @tbl_bus_scan.setHorizontalHeaderItem(1, __colItem1)
    @btn_cancel.text = Qt::Application.translate("I2c_settings", "Close", nil, Qt::Application::UnicodeUTF8)
    @btn_save.text = Qt::Application.translate("I2c_settings", "Save", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(i2c_settings)
        retranslateUi(i2c_settings)
    end

end

module Ui
    class I2c_settings < Ui_I2c_settings
    end
end  # module Ui

