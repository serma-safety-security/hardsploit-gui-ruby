=begin
** Form generated from reading ui file 'gui_uart_settings.ui'
**
** Created: mer. nov. 16 20:48:14 2016
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Uart_settings
    attr_reader :gridLayout
    attr_reader :verticalLayout_2
    attr_reader :horizontalLayout_2
    attr_reader :lbl_chip
    attr_reader :lbl_uart
    attr_reader :horizontalSpacer_2
    attr_reader :formLayout
    attr_reader :label
    attr_reader :lie_baud_rate
    attr_reader :label_2
    attr_reader :lie_word_size
    attr_reader :label_3
    attr_reader :lie_parity_bit
    attr_reader :label_4
    attr_reader :lie_parity_type
    attr_reader :label_5
    attr_reader :lie_stop_bits_nbr
    attr_reader :label_6
    attr_reader :lie_idle_line_lvl
    attr_reader :label_7
    attr_reader :horizontalLayout_3
    attr_reader :rbn_cr
    attr_reader :rbn_lf
    attr_reader :rbn_both
    attr_reader :label_8
    attr_reader :pushButton_3
    attr_reader :horizontalLayout
    attr_reader :horizontalSpacer
    attr_reader :pushButton_2
    attr_reader :pushButton

    def setupUi(uart_settings)
    if uart_settings.objectName.nil?
        uart_settings.objectName = "uart_settings"
    end
    uart_settings.windowModality = Qt::WindowModal
    uart_settings.resize(254, 291)
    @gridLayout = Qt::GridLayout.new(uart_settings)
    @gridLayout.objectName = "gridLayout"
    @verticalLayout_2 = Qt::VBoxLayout.new()
    @verticalLayout_2.objectName = "verticalLayout_2"
    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.objectName = "horizontalLayout_2"
    @lbl_chip = Qt::Label.new(uart_settings)
    @lbl_chip.objectName = "lbl_chip"

    @horizontalLayout_2.addWidget(@lbl_chip)

    @lbl_uart = Qt::Label.new(uart_settings)
    @lbl_uart.objectName = "lbl_uart"

    @horizontalLayout_2.addWidget(@lbl_uart)

    @horizontalSpacer_2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_2.addItem(@horizontalSpacer_2)


    @verticalLayout_2.addLayout(@horizontalLayout_2)

    @formLayout = Qt::FormLayout.new()
    @formLayout.objectName = "formLayout"
    @label = Qt::Label.new(uart_settings)
    @label.objectName = "label"

    @formLayout.setWidget(1, Qt::FormLayout::LabelRole, @label)

    @lie_baud_rate = Qt::LineEdit.new(uart_settings)
    @lie_baud_rate.objectName = "lie_baud_rate"

    @formLayout.setWidget(1, Qt::FormLayout::FieldRole, @lie_baud_rate)

    @label_2 = Qt::Label.new(uart_settings)
    @label_2.objectName = "label_2"

    @formLayout.setWidget(3, Qt::FormLayout::LabelRole, @label_2)

    @lie_word_size = Qt::LineEdit.new(uart_settings)
    @lie_word_size.objectName = "lie_word_size"

    @formLayout.setWidget(3, Qt::FormLayout::FieldRole, @lie_word_size)

    @label_3 = Qt::Label.new(uart_settings)
    @label_3.objectName = "label_3"

    @formLayout.setWidget(4, Qt::FormLayout::LabelRole, @label_3)

    @lie_parity_bit = Qt::LineEdit.new(uart_settings)
    @lie_parity_bit.objectName = "lie_parity_bit"

    @formLayout.setWidget(4, Qt::FormLayout::FieldRole, @lie_parity_bit)

    @label_4 = Qt::Label.new(uart_settings)
    @label_4.objectName = "label_4"

    @formLayout.setWidget(5, Qt::FormLayout::LabelRole, @label_4)

    @lie_parity_type = Qt::LineEdit.new(uart_settings)
    @lie_parity_type.objectName = "lie_parity_type"

    @formLayout.setWidget(5, Qt::FormLayout::FieldRole, @lie_parity_type)

    @label_5 = Qt::Label.new(uart_settings)
    @label_5.objectName = "label_5"

    @formLayout.setWidget(6, Qt::FormLayout::LabelRole, @label_5)

    @lie_stop_bits_nbr = Qt::LineEdit.new(uart_settings)
    @lie_stop_bits_nbr.objectName = "lie_stop_bits_nbr"

    @formLayout.setWidget(6, Qt::FormLayout::FieldRole, @lie_stop_bits_nbr)

    @label_6 = Qt::Label.new(uart_settings)
    @label_6.objectName = "label_6"

    @formLayout.setWidget(7, Qt::FormLayout::LabelRole, @label_6)

    @lie_idle_line_lvl = Qt::LineEdit.new(uart_settings)
    @lie_idle_line_lvl.objectName = "lie_idle_line_lvl"

    @formLayout.setWidget(7, Qt::FormLayout::FieldRole, @lie_idle_line_lvl)

    @label_7 = Qt::Label.new(uart_settings)
    @label_7.objectName = "label_7"

    @formLayout.setWidget(8, Qt::FormLayout::LabelRole, @label_7)

    @horizontalLayout_3 = Qt::HBoxLayout.new()
    @horizontalLayout_3.objectName = "horizontalLayout_3"
    @rbn_cr = Qt::RadioButton.new(uart_settings)
    @rbn_cr.objectName = "rbn_cr"
    @rbn_cr.checked = true

    @horizontalLayout_3.addWidget(@rbn_cr)

    @rbn_lf = Qt::RadioButton.new(uart_settings)
    @rbn_lf.objectName = "rbn_lf"

    @horizontalLayout_3.addWidget(@rbn_lf)

    @rbn_both = Qt::RadioButton.new(uart_settings)
    @rbn_both.objectName = "rbn_both"

    @horizontalLayout_3.addWidget(@rbn_both)


    @formLayout.setLayout(8, Qt::FormLayout::FieldRole, @horizontalLayout_3)

    @label_8 = Qt::Label.new(uart_settings)
    @label_8.objectName = "label_8"

    @formLayout.setWidget(2, Qt::FormLayout::LabelRole, @label_8)

    @pushButton_3 = Qt::PushButton.new(uart_settings)
    @pushButton_3.objectName = "pushButton_3"

    @formLayout.setWidget(2, Qt::FormLayout::FieldRole, @pushButton_3)


    @verticalLayout_2.addLayout(@formLayout)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout.addItem(@horizontalSpacer)

    @pushButton_2 = Qt::PushButton.new(uart_settings)
    @pushButton_2.objectName = "pushButton_2"

    @horizontalLayout.addWidget(@pushButton_2)

    @pushButton = Qt::PushButton.new(uart_settings)
    @pushButton.objectName = "pushButton"

    @horizontalLayout.addWidget(@pushButton)


    @verticalLayout_2.addLayout(@horizontalLayout)


    @gridLayout.addLayout(@verticalLayout_2, 0, 0, 1, 1)


    retranslateUi(uart_settings)
    Qt::Object.connect(@pushButton, SIGNAL('clicked()'), uart_settings, SLOT('save_settings()'))
    Qt::Object.connect(@pushButton_2, SIGNAL('clicked()'), uart_settings, SLOT('close()'))
    Qt::Object.connect(@pushButton_3, SIGNAL('clicked()'), uart_settings, SLOT('autodetect()'))

    Qt::MetaObject.connectSlotsByName(uart_settings)
    end # setupUi

    def setup_ui(uart_settings)
        setupUi(uart_settings)
    end

    def retranslateUi(uart_settings)
    uart_settings.windowTitle = Qt::Application.translate("Uart_settings", "Hardsploit - UART settings", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Uart_settings", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_uart.text = Qt::Application.translate("Uart_settings", "UART settings", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("Uart_settings", "Baud rate (manual):", nil, Qt::Application::UnicodeUTF8)
    @lie_baud_rate.placeholderText = Qt::Application.translate("Uart_settings", "decimal value", nil, Qt::Application::UnicodeUTF8)
    @label_2.text = Qt::Application.translate("Uart_settings", "Word size:", nil, Qt::Application::UnicodeUTF8)
    @lie_word_size.placeholderText = Qt::Application.translate("Uart_settings", "decimal value", nil, Qt::Application::UnicodeUTF8)
    @label_3.text = Qt::Application.translate("Uart_settings", "Parity bit:", nil, Qt::Application::UnicodeUTF8)
    @lie_parity_bit.placeholderText = Qt::Application.translate("Uart_settings", "decimal value", nil, Qt::Application::UnicodeUTF8)
    @label_4.text = Qt::Application.translate("Uart_settings", "Parity type:", nil, Qt::Application::UnicodeUTF8)
    @lie_parity_type.placeholderText = Qt::Application.translate("Uart_settings", "decimal value", nil, Qt::Application::UnicodeUTF8)
    @label_5.text = Qt::Application.translate("Uart_settings", "Stop bits number:", nil, Qt::Application::UnicodeUTF8)
    @lie_stop_bits_nbr.placeholderText = Qt::Application.translate("Uart_settings", "decimal value", nil, Qt::Application::UnicodeUTF8)
    @label_6.text = Qt::Application.translate("Uart_settings", "Idle line level:", nil, Qt::Application::UnicodeUTF8)
    @lie_idle_line_lvl.placeholderText = Qt::Application.translate("Uart_settings", "decimal value", nil, Qt::Application::UnicodeUTF8)
    @label_7.text = Qt::Application.translate("Uart_settings", "CR / LF:", nil, Qt::Application::UnicodeUTF8)
    @rbn_cr.text = Qt::Application.translate("Uart_settings", "CR", nil, Qt::Application::UnicodeUTF8)
    @rbn_lf.text = Qt::Application.translate("Uart_settings", "LF", nil, Qt::Application::UnicodeUTF8)
    @rbn_both.text = Qt::Application.translate("Uart_settings", "Both", nil, Qt::Application::UnicodeUTF8)
    @label_8.text = Qt::Application.translate("Uart_settings", "Baud rate (auto):", nil, Qt::Application::UnicodeUTF8)
    @pushButton_3.text = Qt::Application.translate("Uart_settings", "Autodetection", nil, Qt::Application::UnicodeUTF8)
    @pushButton_2.text = Qt::Application.translate("Uart_settings", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @pushButton.text = Qt::Application.translate("Uart_settings", "Save", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(uart_settings)
        retranslateUi(uart_settings)
    end

end

module Ui
    class Uart_settings < Ui_Uart_settings
    end
end  # module Ui

