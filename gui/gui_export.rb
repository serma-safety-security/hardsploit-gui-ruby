=begin
** Form generated from reading ui file 'gui_export.ui'
**
** Created: mer. nov. 16 20:48:14 2016
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Export
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :lbl_export
    attr_reader :hl2
    attr_reader :rbn_comp
    attr_reader :rbn_cmds
    attr_reader :rbn_both
    attr_reader :hl3
    attr_reader :btn_file
    attr_reader :hs2
    attr_reader :hl
    attr_reader :hs
    attr_reader :btn_cancel
    attr_reader :btn_export

    def setupUi(export)
    if export.objectName.nil?
        export.objectName = "export"
    end
    export.resize(303, 120)
    @gridLayout = Qt::GridLayout.new(export)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @lbl_export = Qt::Label.new(export)
    @lbl_export.objectName = "lbl_export"

    @vl.addWidget(@lbl_export)

    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @rbn_comp = Qt::RadioButton.new(export)
    @rbn_comp.objectName = "rbn_comp"
    @rbn_comp.checked = true

    @hl2.addWidget(@rbn_comp)

    @rbn_cmds = Qt::RadioButton.new(export)
    @rbn_cmds.objectName = "rbn_cmds"

    @hl2.addWidget(@rbn_cmds)

    @rbn_both = Qt::RadioButton.new(export)
    @rbn_both.objectName = "rbn_both"
    @rbn_both.checked = false

    @hl2.addWidget(@rbn_both)


    @vl.addLayout(@hl2)

    @hl3 = Qt::HBoxLayout.new()
    @hl3.objectName = "hl3"
    @btn_file = Qt::PushButton.new(export)
    @btn_file.objectName = "btn_file"

    @hl3.addWidget(@btn_file)

    @hs2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl3.addItem(@hs2)


    @vl.addLayout(@hl3)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)

    @btn_cancel = Qt::PushButton.new(export)
    @btn_cancel.objectName = "btn_cancel"

    @hl.addWidget(@btn_cancel)

    @btn_export = Qt::PushButton.new(export)
    @btn_export.objectName = "btn_export"

    @hl.addWidget(@btn_export)


    @vl.addLayout(@hl)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)


    retranslateUi(export)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), export, SLOT('close()'))
    Qt::Object.connect(@btn_export, SIGNAL('clicked()'), export, SLOT('export()'))
    Qt::Object.connect(@btn_file, SIGNAL('clicked()'), export, SLOT('export_file()'))

    Qt::MetaObject.connectSlotsByName(export)
    end # setupUi

    def setup_ui(export)
        setupUi(export)
    end

    def retranslateUi(export)
    export.windowTitle = Qt::Application.translate("Export", "Export", nil, Qt::Application::UnicodeUTF8)
    @lbl_export.text = Qt::Application.translate("Export", "Export:", nil, Qt::Application::UnicodeUTF8)
    @rbn_comp.text = Qt::Application.translate("Export", "Component", nil, Qt::Application::UnicodeUTF8)
    @rbn_cmds.text = Qt::Application.translate("Export", "Commands", nil, Qt::Application::UnicodeUTF8)
    @rbn_both.text = Qt::Application.translate("Export", "Both", nil, Qt::Application::UnicodeUTF8)
    @btn_file.text = Qt::Application.translate("Export", "File...", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("Export", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @btn_export.text = Qt::Application.translate("Export", "Export", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(export)
        retranslateUi(export)
    end

end

module Ui
    class Export < Ui_Export
    end
end  # module Ui

