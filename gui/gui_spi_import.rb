=begin
** Form generated from reading ui file 'gui_spi_import.ui'
**
** Created: jeu. déc. 3 15:41:11 2015
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Spi_import
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :hl2
    attr_reader :lbl_chip
    attr_reader :lbl_export
    attr_reader :hs
    attr_reader :fl
    attr_reader :lbl_start
    attr_reader :lie_start
    attr_reader :btn_file
    attr_reader :lbl_file
    attr_reader :hl
    attr_reader :btn_import

    def setupUi(spi_import)
    if spi_import.objectName.nil?
        spi_import.objectName = "spi_import"
    end
    spi_import.resize(265, 137)
    @gridLayout = Qt::GridLayout.new(spi_import)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @hl2 = Qt::HBoxLayout.new()
    @hl2.objectName = "hl2"
    @lbl_chip = Qt::Label.new(spi_import)
    @lbl_chip.objectName = "lbl_chip"

    @hl2.addWidget(@lbl_chip)

    @lbl_export = Qt::Label.new(spi_import)
    @lbl_export.objectName = "lbl_export"

    @hl2.addWidget(@lbl_export)

    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl2.addItem(@hs)


    @vl.addLayout(@hl2)

    @fl = Qt::FormLayout.new()
    @fl.objectName = "fl"
    @lbl_start = Qt::Label.new(spi_import)
    @lbl_start.objectName = "lbl_start"

    @fl.setWidget(1, Qt::FormLayout::LabelRole, @lbl_start)

    @lie_start = Qt::LineEdit.new(spi_import)
    @lie_start.objectName = "lie_start"
    @lie_start.maxLength = 20

    @fl.setWidget(1, Qt::FormLayout::FieldRole, @lie_start)

    @btn_file = Qt::PushButton.new(spi_import)
    @btn_file.objectName = "btn_file"

    @fl.setWidget(2, Qt::FormLayout::FieldRole, @btn_file)

    @lbl_file = Qt::Label.new(spi_import)
    @lbl_file.objectName = "lbl_file"

    @fl.setWidget(2, Qt::FormLayout::LabelRole, @lbl_file)


    @vl.addLayout(@fl)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @btn_import = Qt::PushButton.new(spi_import)
    @btn_import.objectName = "btn_import"
    @btn_import.enabled = false

    @hl.addWidget(@btn_import)


    @vl.addLayout(@hl)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)


    retranslateUi(spi_import)
    Qt::Object.connect(@btn_import, SIGNAL('clicked()'), spi_import, SLOT('import()'))
    Qt::Object.connect(@btn_file, SIGNAL('clicked()'), spi_import, SLOT('select_import_file()'))

    Qt::MetaObject.connectSlotsByName(spi_import)
    end # setupUi

    def setup_ui(spi_import)
        setupUi(spi_import)
    end

    def retranslateUi(spi_import)
    spi_import.windowTitle = Qt::Application.translate("Spi_import", "Hardsploit - Import", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Spi_import", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_export.text = Qt::Application.translate("Spi_import", "Import", nil, Qt::Application::UnicodeUTF8)
    @lbl_start.text = Qt::Application.translate("Spi_import", "Start address:", nil, Qt::Application::UnicodeUTF8)
    @lie_start.text = Qt::Application.translate("Spi_import", "0", nil, Qt::Application::UnicodeUTF8)
    @btn_file.text = Qt::Application.translate("Spi_import", "File...", nil, Qt::Application::UnicodeUTF8)
    @lbl_file.text = Qt::Application.translate("Spi_import", "File:", nil, Qt::Application::UnicodeUTF8)
    @btn_import.text = Qt::Application.translate("Spi_import", "Import", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(spi_import)
        retranslateUi(spi_import)
    end

end

module Ui
    class Spi_import < Ui_Spi_import
    end
end  # module Ui

