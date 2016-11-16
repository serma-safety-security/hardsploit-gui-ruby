=begin
** Form generated from reading ui file 'gui_uart_console.ui'
**
** Created: mer. nov. 16 20:48:14 2016
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Uart_console
    attr_reader :actionSend
    attr_reader :gridLayout
    attr_reader :verticalLayout
    attr_reader :horizontalLayout_2
    attr_reader :lbl_chip
    attr_reader :label
    attr_reader :btn_connect
    attr_reader :btn_disconnect
    attr_reader :pushButton
    attr_reader :horizontalSpacer
    attr_reader :btn_clear
    attr_reader :console
    attr_reader :horizontalLayout
    attr_reader :lie_cmd
    attr_reader :btn_send

    def setupUi(uart_console)
    if uart_console.objectName.nil?
        uart_console.objectName = "uart_console"
    end
    uart_console.windowModality = Qt::WindowModal
    uart_console.resize(710, 587)
    @actionSend = Qt::Action.new(uart_console)
    @actionSend.objectName = "actionSend"
    @gridLayout = Qt::GridLayout.new(uart_console)
    @gridLayout.objectName = "gridLayout"
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.objectName = "horizontalLayout_2"
    @lbl_chip = Qt::Label.new(uart_console)
    @lbl_chip.objectName = "lbl_chip"

    @horizontalLayout_2.addWidget(@lbl_chip)

    @label = Qt::Label.new(uart_console)
    @label.objectName = "label"

    @horizontalLayout_2.addWidget(@label)

    @btn_connect = Qt::PushButton.new(uart_console)
    @btn_connect.objectName = "btn_connect"

    @horizontalLayout_2.addWidget(@btn_connect)

    @btn_disconnect = Qt::PushButton.new(uart_console)
    @btn_disconnect.objectName = "btn_disconnect"
    @btn_disconnect.enabled = false

    @horizontalLayout_2.addWidget(@btn_disconnect)

    @pushButton = Qt::PushButton.new(uart_console)
    @pushButton.objectName = "pushButton"

    @horizontalLayout_2.addWidget(@pushButton)

    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_2.addItem(@horizontalSpacer)

    @btn_clear = Qt::PushButton.new(uart_console)
    @btn_clear.objectName = "btn_clear"

    @horizontalLayout_2.addWidget(@btn_clear)


    @verticalLayout.addLayout(@horizontalLayout_2)

    @console = Qt::TextEdit.new(uart_console)
    @console.objectName = "console"
    @palette = Qt::Palette.new
    brush = Qt::Brush.new(Qt::Color.new(170, 255, 0, 255))
    brush.style = Qt::SolidPattern
    @palette.setBrush(Qt::Palette::Active, Qt::Palette::Text, brush)
    brush1 = Qt::Brush.new(Qt::Color.new(0, 0, 0, 255))
    brush1.style = Qt::SolidPattern
    @palette.setBrush(Qt::Palette::Active, Qt::Palette::Base, brush1)
    @palette.setBrush(Qt::Palette::Inactive, Qt::Palette::Text, brush)
    @palette.setBrush(Qt::Palette::Inactive, Qt::Palette::Base, brush1)
    brush2 = Qt::Brush.new(Qt::Color.new(120, 120, 120, 255))
    brush2.style = Qt::SolidPattern
    @palette.setBrush(Qt::Palette::Disabled, Qt::Palette::Text, brush2)
    brush3 = Qt::Brush.new(Qt::Color.new(240, 240, 240, 255))
    brush3.style = Qt::SolidPattern
    @palette.setBrush(Qt::Palette::Disabled, Qt::Palette::Base, brush3)
    @console.palette = @palette
    @font = Qt::Font.new
    @font.family = "Small Fonts"
    @font.bold = false
    @font.weight = 50
    @console.font = @font
    @console.frameShape = Qt::Frame::StyledPanel
    @console.frameShadow = Qt::Frame::Sunken
    @console.readOnly = true

    @verticalLayout.addWidget(@console)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @lie_cmd = Qt::LineEdit.new(uart_console)
    @lie_cmd.objectName = "lie_cmd"

    @horizontalLayout.addWidget(@lie_cmd)

    @btn_send = Qt::PushButton.new(uart_console)
    @btn_send.objectName = "btn_send"

    @horizontalLayout.addWidget(@btn_send)


    @verticalLayout.addLayout(@horizontalLayout)


    @gridLayout.addLayout(@verticalLayout, 0, 0, 1, 1)


    retranslateUi(uart_console)
    Qt::Object.connect(@btn_send, SIGNAL('clicked()'), uart_console, SLOT('send()'))
    Qt::Object.connect(@btn_connect, SIGNAL('clicked()'), uart_console, SLOT('connect()'))
    Qt::Object.connect(@btn_disconnect, SIGNAL('clicked()'), uart_console, SLOT('disconnect()'))
    Qt::Object.connect(@btn_clear, SIGNAL('clicked()'), uart_console, SLOT('clear_console()'))
    Qt::Object.connect(@pushButton, SIGNAL('clicked()'), uart_console, SLOT('open_settings()'))

    Qt::MetaObject.connectSlotsByName(uart_console)
    end # setupUi

    def setup_ui(uart_console)
        setupUi(uart_console)
    end

    def retranslateUi(uart_console)
    uart_console.windowTitle = Qt::Application.translate("Uart_console", "Hardsploit - UART console", nil, Qt::Application::UnicodeUTF8)
    @actionSend.text = Qt::Application.translate("Uart_console", "Send", nil, Qt::Application::UnicodeUTF8)
    @actionSend.shortcut = Qt::Application.translate("Uart_console", "Return", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Uart_console", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("Uart_console", "UART console", nil, Qt::Application::UnicodeUTF8)
    @btn_connect.text = Qt::Application.translate("Uart_console", "Connect", nil, Qt::Application::UnicodeUTF8)
    @btn_disconnect.text = Qt::Application.translate("Uart_console", "Disconnect", nil, Qt::Application::UnicodeUTF8)
    @pushButton.text = Qt::Application.translate("Uart_console", "Settings", nil, Qt::Application::UnicodeUTF8)
    @btn_clear.text = Qt::Application.translate("Uart_console", "Clear", nil, Qt::Application::UnicodeUTF8)
    @btn_send.text = Qt::Application.translate("Uart_console", "Send", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(uart_console)
        retranslateUi(uart_console)
    end

end

module Ui
    class Uart_console < Ui_Uart_console
    end
end  # module Ui

