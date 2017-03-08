=begin
** Form generated from reading ui file 'gui_spi_sniffer.ui'
**
** Created: mer. mars 8 11:15:08 2017
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Spi_sniffer
    attr_reader :gridLayout
    attr_reader :verticalLayout
    attr_reader :horizontalLayout
    attr_reader :btn_start
    attr_reader :cbx_type
    attr_reader :btn_stop
    attr_reader :btn_close
    attr_reader :tbl_result

    def setupUi(spi_sniffer)
    if spi_sniffer.objectName.nil?
        spi_sniffer.objectName = "spi_sniffer"
    end
    spi_sniffer.resize(400, 604)
    @gridLayout = Qt::GridLayout.new(spi_sniffer)
    @gridLayout.objectName = "gridLayout"
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @btn_start = Qt::PushButton.new(spi_sniffer)
    @btn_start.objectName = "btn_start"

    @horizontalLayout.addWidget(@btn_start)

    @cbx_type = Qt::ComboBox.new(spi_sniffer)
    @cbx_type.objectName = "cbx_type"

    @horizontalLayout.addWidget(@cbx_type)

    @btn_stop = Qt::PushButton.new(spi_sniffer)
    @btn_stop.objectName = "btn_stop"
    @btn_stop.enabled = false

    @horizontalLayout.addWidget(@btn_stop)

    @btn_close = Qt::PushButton.new(spi_sniffer)
    @btn_close.objectName = "btn_close"

    @horizontalLayout.addWidget(@btn_close)


    @verticalLayout.addLayout(@horizontalLayout)

    @tbl_result = Qt::TableWidget.new(spi_sniffer)
    @tbl_result.objectName = "tbl_result"
    @tbl_result.sortingEnabled = true

    @verticalLayout.addWidget(@tbl_result)


    @gridLayout.addLayout(@verticalLayout, 0, 0, 1, 1)


    retranslateUi(spi_sniffer)
    Qt::Object.connect(@btn_close, SIGNAL('clicked()'), spi_sniffer, SLOT('close()'))
    Qt::Object.connect(@btn_start, SIGNAL('clicked()'), spi_sniffer, SLOT('start()'))
    Qt::Object.connect(@btn_stop, SIGNAL('clicked()'), spi_sniffer, SLOT('stop()'))

    Qt::MetaObject.connectSlotsByName(spi_sniffer)
    end # setupUi

    def setup_ui(spi_sniffer)
        setupUi(spi_sniffer)
    end

    def retranslateUi(spi_sniffer)
    spi_sniffer.windowTitle = Qt::Application.translate("Spi_sniffer", "Hardsploit - SPI sniffer", nil, Qt::Application::UnicodeUTF8)
    @btn_start.text = Qt::Application.translate("Spi_sniffer", "Start", nil, Qt::Application::UnicodeUTF8)
    @cbx_type.insertItems(0, [Qt::Application.translate("Spi_sniffer", "Both", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_sniffer", "MOSI", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Spi_sniffer", "MISO", nil, Qt::Application::UnicodeUTF8)])
    @btn_stop.text = Qt::Application.translate("Spi_sniffer", "Stop", nil, Qt::Application::UnicodeUTF8)
    @btn_close.text = Qt::Application.translate("Spi_sniffer", "Close", nil, Qt::Application::UnicodeUTF8)
    if @tbl_result.columnCount < 3
        @tbl_result.columnCount = 3
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("Spi_sniffer", "Number", nil, Qt::Application::UnicodeUTF8))
    @tbl_result.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("Spi_sniffer", "MOSI", nil, Qt::Application::UnicodeUTF8))
    @tbl_result.setHorizontalHeaderItem(1, __colItem1)

    __colItem2 = Qt::TableWidgetItem.new
    __colItem2.setText(Qt::Application.translate("Spi_sniffer", "MISO", nil, Qt::Application::UnicodeUTF8))
    @tbl_result.setHorizontalHeaderItem(2, __colItem2)
    end # retranslateUi

    def retranslate_ui(spi_sniffer)
        retranslateUi(spi_sniffer)
    end

end

module Ui
    class Spi_sniffer < Ui_Spi_sniffer
    end
end  # module Ui

