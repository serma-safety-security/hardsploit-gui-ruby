=begin
** Form generated from reading ui file 'gui_uart_baudrate.ui'
**
** Created: mer. mars 8 11:15:09 2017
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Uart_baudrate
    attr_reader :gridLayout
    attr_reader :verticalLayout
    attr_reader :lbl_tip
    attr_reader :horizontalLayout
    attr_reader :btn_start
    attr_reader :btn_stop
    attr_reader :lbl_baudrate
    attr_reader :horizontalLayout_2
    attr_reader :horizontalSpacer
    attr_reader :pushButton
    attr_reader :btn_close

    def setupUi(uart_baudrate)
    if uart_baudrate.objectName.nil?
        uart_baudrate.objectName = "uart_baudrate"
    end
    uart_baudrate.resize(259, 114)
    @gridLayout = Qt::GridLayout.new(uart_baudrate)
    @gridLayout.objectName = "gridLayout"
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @lbl_tip = Qt::Label.new(uart_baudrate)
    @lbl_tip.objectName = "lbl_tip"

    @verticalLayout.addWidget(@lbl_tip)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @btn_start = Qt::PushButton.new(uart_baudrate)
    @btn_start.objectName = "btn_start"

    @horizontalLayout.addWidget(@btn_start)

    @btn_stop = Qt::PushButton.new(uart_baudrate)
    @btn_stop.objectName = "btn_stop"
    @btn_stop.enabled = false

    @horizontalLayout.addWidget(@btn_stop)


    @verticalLayout.addLayout(@horizontalLayout)

    @lbl_baudrate = Qt::Label.new(uart_baudrate)
    @lbl_baudrate.objectName = "lbl_baudrate"

    @verticalLayout.addWidget(@lbl_baudrate)

    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.objectName = "horizontalLayout_2"
    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_2.addItem(@horizontalSpacer)

    @pushButton = Qt::PushButton.new(uart_baudrate)
    @pushButton.objectName = "pushButton"

    @horizontalLayout_2.addWidget(@pushButton)

    @btn_close = Qt::PushButton.new(uart_baudrate)
    @btn_close.objectName = "btn_close"

    @horizontalLayout_2.addWidget(@btn_close)


    @verticalLayout.addLayout(@horizontalLayout_2)


    @gridLayout.addLayout(@verticalLayout, 0, 0, 1, 1)


    retranslateUi(uart_baudrate)
    Qt::Object.connect(@btn_start, SIGNAL('clicked()'), uart_baudrate, SLOT('start_detect()'))
    Qt::Object.connect(@btn_stop, SIGNAL('clicked()'), uart_baudrate, SLOT('stop_detect()'))
    Qt::Object.connect(@btn_close, SIGNAL('clicked()'), uart_baudrate, SLOT('close()'))
    Qt::Object.connect(@pushButton, SIGNAL('clicked()'), uart_baudrate, SLOT('copy()'))

    Qt::MetaObject.connectSlotsByName(uart_baudrate)
    end # setupUi

    def setup_ui(uart_baudrate)
        setupUi(uart_baudrate)
    end

    def retranslateUi(uart_baudrate)
    uart_baudrate.windowTitle = Qt::Application.translate("Uart_baudrate", "Hardsploit - Baudrate autodetect", nil, Qt::Application::UnicodeUTF8)
    @lbl_tip.text = Qt::Application.translate("Uart_baudrate", "Push \"Start\", restart your target then click \"Stop\"", nil, Qt::Application::UnicodeUTF8)
    @btn_start.text = Qt::Application.translate("Uart_baudrate", "Start", nil, Qt::Application::UnicodeUTF8)
    @btn_stop.text = Qt::Application.translate("Uart_baudrate", "Stop", nil, Qt::Application::UnicodeUTF8)
    @lbl_baudrate.text = Qt::Application.translate("Uart_baudrate", "Baud rate detected:", nil, Qt::Application::UnicodeUTF8)
    @pushButton.text = Qt::Application.translate("Uart_baudrate", "Copy to settings", nil, Qt::Application::UnicodeUTF8)
    @btn_close.text = Qt::Application.translate("Uart_baudrate", "Close", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(uart_baudrate)
        retranslateUi(uart_baudrate)
    end

end

module Ui
    class Uart_baudrate < Ui_Uart_baudrate
    end
end  # module Ui

