=begin
** Form generated from reading ui file 'gui_signal_mapper.ui'
**
** Created: mer. juil. 20 11:26:24 2016
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Signal_mapper
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :hl
    attr_reader :lbl_bus
    attr_reader :cbx_bus
    attr_reader :hs
    attr_reader :map_table
    attr_reader :hl2
    attr_reader :hs2
    attr_reader :btn_cancel
    attr_reader :btn_save

    def setupUi(signal_mapper)
    if signal_mapper.objectName.nil?
        signal_mapper.objectName = "signal_mapper"
    end
    signal_mapper.resize(268, 411)
    @gridLayout = Qt::GridLayout.new(signal_mapper)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @lbl_bus = Qt::Label.new(signal_mapper)
    @lbl_bus.objectName = "lbl_bus"

    @hl.addWidget(@lbl_bus)

    @cbx_bus = Qt::ComboBox.new(signal_mapper)
    @cbx_bus.objectName = "cbx_bus"

    @hl.addWidget(@cbx_bus)

    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)


    @vl.addLayout(@hl)

    @map_table = Qt::TableWidget.new(signal_mapper)
    @map_table.objectName = "map_table"

    @vl.addWidget(@map_table)

    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @hs2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl2.addItem(@hs2)

    @btn_cancel = Qt::PushButton.new(signal_mapper)
    @btn_cancel.objectName = "btn_cancel"

    @hl2.addWidget(@btn_cancel)

    @btn_save = Qt::PushButton.new(signal_mapper)
    @btn_save.objectName = "btn_save"

    @hl2.addWidget(@btn_save)


    @vl.addLayout(@hl2)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)


    retranslateUi(signal_mapper)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), signal_mapper, SLOT('close()'))
    Qt::Object.connect(@btn_save, SIGNAL('clicked()'), signal_mapper, SLOT('save_signal_mapping()'))
    Qt::Object.connect(@cbx_bus, SIGNAL('currentIndexChanged(QString)'), signal_mapper, SLOT('update_map_table(QString)'))
    Qt::Object.connect(@map_table, SIGNAL('itemChanged(QTableWidgetItem*)'), signal_mapper, SLOT('check_mapping_value(QTableWidgetItem*)'))

    Qt::MetaObject.connectSlotsByName(signal_mapper)
    end # setupUi

    def setup_ui(signal_mapper)
        setupUi(signal_mapper)
    end

    def retranslateUi(signal_mapper)
    signal_mapper.windowTitle = Qt::Application.translate("Signal_mapper", "Signal mapper", nil, Qt::Application::UnicodeUTF8)
    @lbl_bus.text = Qt::Application.translate("Signal_mapper", "Select a bus", nil, Qt::Application::UnicodeUTF8)
    @cbx_bus.insertItems(0, [Qt::Application.translate("Signal_mapper", "Bus...", nil, Qt::Application::UnicodeUTF8)])
    if @map_table.columnCount < 2
        @map_table.columnCount = 2
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("Signal_mapper", "Signal Name", nil, Qt::Application::UnicodeUTF8))
    @map_table.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("Signal_mapper", "Associated Pin", nil, Qt::Application::UnicodeUTF8))
    @map_table.setHorizontalHeaderItem(1, __colItem1)
    @btn_cancel.text = Qt::Application.translate("Signal_mapper", "Close", nil, Qt::Application::UnicodeUTF8)
    @btn_save.text = Qt::Application.translate("Signal_mapper", "Save", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(signal_mapper)
        retranslateUi(signal_mapper)
    end

end

module Ui
    class Signal_mapper < Ui_Signal_mapper
    end
end  # module Ui

