=begin
** Form generated from reading ui file 'gui_import.ui'
**
** Created: mer. mars 8 11:15:06 2017
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Import
    attr_reader :gridLayout
    attr_reader :verticalLayout
    attr_reader :lbl_import
    attr_reader :horizontalLayout_3
    attr_reader :rbn_comp
    attr_reader :rbn_cmds
    attr_reader :rbn_both
    attr_reader :horizontalLayout_2
    attr_reader :btn_file
    attr_reader :horizontalSpacer_2
    attr_reader :horizontalLayout
    attr_reader :horizontalSpacer
    attr_reader :btn_cancel
    attr_reader :btn_import

    def setupUi(import)
    if import.objectName.nil?
        import.objectName = "import"
    end
    import.resize(304, 120)
    @gridLayout = Qt::GridLayout.new(import)
    @gridLayout.objectName = "gridLayout"
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @lbl_import = Qt::Label.new(import)
    @lbl_import.objectName = "lbl_import"

    @verticalLayout.addWidget(@lbl_import)

    @horizontalLayout_3 = Qt::HBoxLayout.new()
    @horizontalLayout_3.objectName = "horizontalLayout_3"
    @rbn_comp = Qt::RadioButton.new(import)
    @rbn_comp.objectName = "rbn_comp"
    @rbn_comp.checked = true

    @horizontalLayout_3.addWidget(@rbn_comp)

    @rbn_cmds = Qt::RadioButton.new(import)
    @rbn_cmds.objectName = "rbn_cmds"

    @horizontalLayout_3.addWidget(@rbn_cmds)

    @rbn_both = Qt::RadioButton.new(import)
    @rbn_both.objectName = "rbn_both"

    @horizontalLayout_3.addWidget(@rbn_both)


    @verticalLayout.addLayout(@horizontalLayout_3)

    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.objectName = "horizontalLayout_2"
    @btn_file = Qt::PushButton.new(import)
    @btn_file.objectName = "btn_file"

    @horizontalLayout_2.addWidget(@btn_file)

    @horizontalSpacer_2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_2.addItem(@horizontalSpacer_2)


    @verticalLayout.addLayout(@horizontalLayout_2)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout.addItem(@horizontalSpacer)

    @btn_cancel = Qt::PushButton.new(import)
    @btn_cancel.objectName = "btn_cancel"

    @horizontalLayout.addWidget(@btn_cancel)

    @btn_import = Qt::PushButton.new(import)
    @btn_import.objectName = "btn_import"

    @horizontalLayout.addWidget(@btn_import)


    @verticalLayout.addLayout(@horizontalLayout)


    @gridLayout.addLayout(@verticalLayout, 1, 0, 1, 1)


    retranslateUi(import)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), import, SLOT('close()'))
    Qt::Object.connect(@btn_import, SIGNAL('clicked()'), import, SLOT('import()'))
    Qt::Object.connect(@btn_file, SIGNAL('clicked()'), import, SLOT('import_file()'))

    Qt::MetaObject.connectSlotsByName(import)
    end # setupUi

    def setup_ui(import)
        setupUi(import)
    end

    def retranslateUi(import)
    import.windowTitle = Qt::Application.translate("Import", "Import", nil, Qt::Application::UnicodeUTF8)
    @lbl_import.text = Qt::Application.translate("Import", "Importing:", nil, Qt::Application::UnicodeUTF8)
    @rbn_comp.text = Qt::Application.translate("Import", "Component", nil, Qt::Application::UnicodeUTF8)
    @rbn_cmds.text = Qt::Application.translate("Import", "Commands", nil, Qt::Application::UnicodeUTF8)
    @rbn_both.text = Qt::Application.translate("Import", "Both", nil, Qt::Application::UnicodeUTF8)
    @btn_file.text = Qt::Application.translate("Import", "File...", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("Import", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @btn_import.text = Qt::Application.translate("Import", "Import", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(import)
        retranslateUi(import)
    end

end

module Ui
    class Import < Ui_Import
    end
end  # module Ui

