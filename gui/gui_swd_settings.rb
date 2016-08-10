=begin
** Form generated from reading ui file 'gui_swd_settings.ui'
**
** Created: mer. mai 18 14:54:28 2016
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Swd_settings
    attr_reader :gridLayout
    attr_reader :verticalLayout
    attr_reader :horizontalLayout_2
    attr_reader :lbl_chip
    attr_reader :lbl_parameters
    attr_reader :horizontalSpacer_2
    attr_reader :formLayout
    attr_reader :label_2
    attr_reader :lie_start_address
    attr_reader :label_3
    attr_reader :lie_size_address
    attr_reader :label_4
    attr_reader :label_5
    attr_reader :lie_cpu_id_address
    attr_reader :lie_device_id_address
    attr_reader :horizontalLayout
    attr_reader :horizontalSpacer
    attr_reader :btn_cancel
    attr_reader :btn_save

    def setupUi(swd_settings)
    if swd_settings.objectName.nil?
        swd_settings.objectName = "swd_settings"
    end
    swd_settings.windowModality = Qt::ApplicationModal
    swd_settings.resize(400, 179)
    @gridLayout = Qt::GridLayout.new(swd_settings)
    @gridLayout.objectName = "gridLayout"
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.objectName = "horizontalLayout_2"
    @lbl_chip = Qt::Label.new(swd_settings)
    @lbl_chip.objectName = "lbl_chip"

    @horizontalLayout_2.addWidget(@lbl_chip)

    @lbl_parameters = Qt::Label.new(swd_settings)
    @lbl_parameters.objectName = "lbl_parameters"

    @horizontalLayout_2.addWidget(@lbl_parameters)

    @horizontalSpacer_2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_2.addItem(@horizontalSpacer_2)


    @verticalLayout.addLayout(@horizontalLayout_2)

    @formLayout = Qt::FormLayout.new()
    @formLayout.objectName = "formLayout"
    @label_2 = Qt::Label.new(swd_settings)
    @label_2.objectName = "label_2"

    @formLayout.setWidget(0, Qt::FormLayout::LabelRole, @label_2)

    @lie_start_address = Qt::LineEdit.new(swd_settings)
    @lie_start_address.objectName = "lie_start_address"

    @formLayout.setWidget(0, Qt::FormLayout::FieldRole, @lie_start_address)

    @label_3 = Qt::Label.new(swd_settings)
    @label_3.objectName = "label_3"

    @formLayout.setWidget(1, Qt::FormLayout::LabelRole, @label_3)

    @lie_size_address = Qt::LineEdit.new(swd_settings)
    @lie_size_address.objectName = "lie_size_address"

    @formLayout.setWidget(1, Qt::FormLayout::FieldRole, @lie_size_address)

    @label_4 = Qt::Label.new(swd_settings)
    @label_4.objectName = "label_4"

    @formLayout.setWidget(2, Qt::FormLayout::LabelRole, @label_4)

    @label_5 = Qt::Label.new(swd_settings)
    @label_5.objectName = "label_5"

    @formLayout.setWidget(3, Qt::FormLayout::LabelRole, @label_5)

    @lie_cpu_id_address = Qt::LineEdit.new(swd_settings)
    @lie_cpu_id_address.objectName = "lie_cpu_id_address"

    @formLayout.setWidget(2, Qt::FormLayout::FieldRole, @lie_cpu_id_address)

    @lie_device_id_address = Qt::LineEdit.new(swd_settings)
    @lie_device_id_address.objectName = "lie_device_id_address"

    @formLayout.setWidget(3, Qt::FormLayout::FieldRole, @lie_device_id_address)


    @verticalLayout.addLayout(@formLayout)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout.addItem(@horizontalSpacer)

    @btn_cancel = Qt::PushButton.new(swd_settings)
    @btn_cancel.objectName = "btn_cancel"

    @horizontalLayout.addWidget(@btn_cancel)

    @btn_save = Qt::PushButton.new(swd_settings)
    @btn_save.objectName = "btn_save"

    @horizontalLayout.addWidget(@btn_save)


    @verticalLayout.addLayout(@horizontalLayout)


    @gridLayout.addLayout(@verticalLayout, 0, 0, 1, 1)


    retranslateUi(swd_settings)
    Qt::Object.connect(@btn_save, SIGNAL('clicked()'), swd_settings, SLOT('save_settings()'))
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), swd_settings, SLOT('close()'))

    Qt::MetaObject.connectSlotsByName(swd_settings)
    end # setupUi

    def setup_ui(swd_settings)
        setupUi(swd_settings)
    end

    def retranslateUi(swd_settings)
    swd_settings.windowTitle = Qt::Application.translate("Swd_settings", "Hardsploit - SWD settings", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Swd_settings", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_parameters.text = Qt::Application.translate("Swd_settings", "PARAMETERS", nil, Qt::Application::UnicodeUTF8)
    @label_2.text = Qt::Application.translate("Swd_settings", "Memory start address:", nil, Qt::Application::UnicodeUTF8)
    @lie_start_address.text = ''
    @lie_start_address.placeholderText = Qt::Application.translate("Swd_settings", "eg 1ffff7e0", nil, Qt::Application::UnicodeUTF8)
    @label_3.text = Qt::Application.translate("Swd_settings", "Memory size address:", nil, Qt::Application::UnicodeUTF8)
    @lie_size_address.placeholderText = Qt::Application.translate("Swd_settings", "eg 08000000", nil, Qt::Application::UnicodeUTF8)
    @label_4.text = Qt::Application.translate("Swd_settings", "CPU ID address:", nil, Qt::Application::UnicodeUTF8)
    @label_5.text = Qt::Application.translate("Swd_settings", "Device ID address:", nil, Qt::Application::UnicodeUTF8)
    @lie_cpu_id_address.placeholderText = Qt::Application.translate("Swd_settings", "eg E000ED00", nil, Qt::Application::UnicodeUTF8)
    @lie_device_id_address.placeholderText = Qt::Application.translate("Swd_settings", "eg 1FFFF7E8", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("Swd_settings", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @btn_save.text = Qt::Application.translate("Swd_settings", "Save", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(swd_settings)
        retranslateUi(swd_settings)
    end

end

module Ui
    class Swd_settings < Ui_Swd_settings
    end
end  # module Ui

