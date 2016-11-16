=begin
** Form generated from reading ui file 'gui_export_manager.ui'
**
** Created: mer. nov. 16 20:48:14 2016
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Export_manager
    attr_reader :gridLayout
    attr_reader :verticalLayout
    attr_reader :lbl_result
    attr_reader :tbl_result
    attr_reader :horizontalLayout
    attr_reader :horizontalSpacer
    attr_reader :cbx_export
    attr_reader :btn_save

    def setupUi(export_manager)
    if export_manager.objectName.nil?
        export_manager.objectName = "export_manager"
    end
    export_manager.windowModality = Qt::ApplicationModal
    export_manager.resize(276, 601)
    @gridLayout = Qt::GridLayout.new(export_manager)
    @gridLayout.objectName = "gridLayout"
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @lbl_result = Qt::Label.new(export_manager)
    @lbl_result.objectName = "lbl_result"
    @lbl_result.minimumSize = Qt::Size.new(241, 16)
    @lbl_result.maximumSize = Qt::Size.new(240, 16)

    @verticalLayout.addWidget(@lbl_result)

    @tbl_result = Qt::TableWidget.new(export_manager)
    @tbl_result.objectName = "tbl_result"

    @verticalLayout.addWidget(@tbl_result)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout.addItem(@horizontalSpacer)

    @cbx_export = Qt::ComboBox.new(export_manager)
    @cbx_export.objectName = "cbx_export"

    @horizontalLayout.addWidget(@cbx_export)

    @btn_save = Qt::PushButton.new(export_manager)
    @btn_save.objectName = "btn_save"

    @horizontalLayout.addWidget(@btn_save)


    @verticalLayout.addLayout(@horizontalLayout)


    @gridLayout.addLayout(@verticalLayout, 0, 0, 1, 1)


    retranslateUi(export_manager)
    Qt::Object.connect(@btn_save, SIGNAL('clicked()'), export_manager, SLOT('save_result()'))

    Qt::MetaObject.connectSlotsByName(export_manager)
    end # setupUi

    def setup_ui(export_manager)
        setupUi(export_manager)
    end

    def retranslateUi(export_manager)
    export_manager.windowTitle = Qt::Application.translate("Export_manager", "Hardsploit - Export", nil, Qt::Application::UnicodeUTF8)
    @lbl_result.text = Qt::Application.translate("Export_manager", "Command result:", nil, Qt::Application::UnicodeUTF8)
    @cbx_export.insertItems(0, [Qt::Application.translate("Export_manager", "Debug (CSV file)", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Export_manager", "Data only (Read)", nil, Qt::Application::UnicodeUTF8)])
    @btn_save.text = Qt::Application.translate("Export_manager", "Save...", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(export_manager)
        retranslateUi(export_manager)
    end

end

module Ui
    class Export_manager < Ui_Export_manager
    end
end  # module Ui

