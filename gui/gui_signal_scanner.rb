=begin
** Form generated from reading ui file 'gui_signal_scanner.ui'
**
** Created: mer. juil. 27 09:23:50 2016
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Signal_scanner
    attr_reader :gridLayout
    attr_reader :verticalLayout
    attr_reader :horizontalLayout_2
    attr_reader :lbl_nbr_pin
    attr_reader :cbx_start
    attr_reader :label
    attr_reader :cbx_stop
    attr_reader :tbl_result
    attr_reader :horizontalLayout
    attr_reader :btn_scan
    attr_reader :btn_autowiring
    attr_reader :btn_close

    def setupUi(signal_scanner)
    if signal_scanner.objectName.nil?
        signal_scanner.objectName = "signal_scanner"
    end
    signal_scanner.windowModality = Qt::ApplicationModal
    signal_scanner.resize(259, 368)
    @gridLayout = Qt::GridLayout.new(signal_scanner)
    @gridLayout.objectName = "gridLayout"
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.objectName = "horizontalLayout_2"
    @lbl_nbr_pin = Qt::Label.new(signal_scanner)
    @lbl_nbr_pin.objectName = "lbl_nbr_pin"

    @horizontalLayout_2.addWidget(@lbl_nbr_pin)

    @cbx_start = Qt::ComboBox.new(signal_scanner)
    @cbx_start.objectName = "cbx_start"
    @cbx_start.minimumSize = Qt::Size.new(50, 0)
    @cbx_start.maximumSize = Qt::Size.new(50, 16777215)

    @horizontalLayout_2.addWidget(@cbx_start)

    @label = Qt::Label.new(signal_scanner)
    @label.objectName = "label"
    @label.minimumSize = Qt::Size.new(20, 0)
    @label.maximumSize = Qt::Size.new(20, 16777215)
    @label.alignment = Qt::AlignCenter

    @horizontalLayout_2.addWidget(@label)

    @cbx_stop = Qt::ComboBox.new(signal_scanner)
    @cbx_stop.objectName = "cbx_stop"
    @cbx_stop.minimumSize = Qt::Size.new(50, 0)
    @cbx_stop.maximumSize = Qt::Size.new(50, 16777215)

    @horizontalLayout_2.addWidget(@cbx_stop)


    @verticalLayout.addLayout(@horizontalLayout_2)

    @tbl_result = Qt::TableWidget.new(signal_scanner)
    @tbl_result.objectName = "tbl_result"

    @verticalLayout.addWidget(@tbl_result)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @btn_scan = Qt::PushButton.new(signal_scanner)
    @btn_scan.objectName = "btn_scan"

    @horizontalLayout.addWidget(@btn_scan)

    @btn_autowiring = Qt::PushButton.new(signal_scanner)
    @btn_autowiring.objectName = "btn_autowiring"

    @horizontalLayout.addWidget(@btn_autowiring)

    @btn_close = Qt::PushButton.new(signal_scanner)
    @btn_close.objectName = "btn_close"

    @horizontalLayout.addWidget(@btn_close)


    @verticalLayout.addLayout(@horizontalLayout)


    @gridLayout.addLayout(@verticalLayout, 1, 0, 1, 1)


    retranslateUi(signal_scanner)
    Qt::Object.connect(@btn_close, SIGNAL('clicked()'), signal_scanner, SLOT('close()'))
    Qt::Object.connect(@btn_scan, SIGNAL('clicked()'), signal_scanner, SLOT('scan()'))
    Qt::Object.connect(@btn_autowiring, SIGNAL('clicked()'), signal_scanner, SLOT('autowiring()'))
    Qt::Object.connect(@cbx_start, SIGNAL('currentIndexChanged(QString)'), signal_scanner, SLOT('update_cbx(QString)'))
    Qt::Object.connect(@cbx_stop, SIGNAL('currentIndexChanged(QString)'), signal_scanner, SLOT('update_tbl(QString)'))

    Qt::MetaObject.connectSlotsByName(signal_scanner)
    end # setupUi

    def setup_ui(signal_scanner)
        setupUi(signal_scanner)
    end

    def retranslateUi(signal_scanner)
    signal_scanner.windowTitle = Qt::Application.translate("Signal_scanner", "Hardsploit - Scanner", nil, Qt::Application::UnicodeUTF8)
    @lbl_nbr_pin.text = Qt::Application.translate("Signal_scanner", "Pin used:", nil, Qt::Application::UnicodeUTF8)
    @cbx_start.insertItems(0, [Qt::Application.translate("Signal_scanner", "B0", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Signal_scanner", "B1", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Signal_scanner", "B2", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Signal_scanner", "B3", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Signal_scanner", "B4", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Signal_scanner", "B5", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Signal_scanner", "B6", nil, Qt::Application::UnicodeUTF8)])
    @label.text = Qt::Application.translate("Signal_scanner", "to", nil, Qt::Application::UnicodeUTF8)
    if @tbl_result.columnCount < 2
        @tbl_result.columnCount = 2
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("Signal_scanner", "Hardsploit PIN", nil, Qt::Application::UnicodeUTF8))
    @tbl_result.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("Signal_scanner", "Signal found", nil, Qt::Application::UnicodeUTF8))
    @tbl_result.setHorizontalHeaderItem(1, __colItem1)
    @btn_scan.text = Qt::Application.translate("Signal_scanner", "Scan", nil, Qt::Application::UnicodeUTF8)
    @btn_autowiring.text = Qt::Application.translate("Signal_scanner", "Autowiring", nil, Qt::Application::UnicodeUTF8)
    @btn_close.text = Qt::Application.translate("Signal_scanner", "Close", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(signal_scanner)
        retranslateUi(signal_scanner)
    end

end

module Ui
    class Signal_scanner < Ui_Signal_scanner
    end
end  # module Ui

