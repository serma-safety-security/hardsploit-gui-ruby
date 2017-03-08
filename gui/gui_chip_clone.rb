=begin
** Form generated from reading ui file 'gui_chip_clone.ui'
**
** Created: mer. mars 8 11:15:01 2017
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Chip_clone
    attr_reader :gridLayout
    attr_reader :verticalLayout
    attr_reader :lbl_clone
    attr_reader :lie_reference
    attr_reader :horizontalLayout
    attr_reader :btn_cancel
    attr_reader :btn_clone

    def setupUi(chip_clone)
    if chip_clone.objectName.nil?
        chip_clone.objectName = "chip_clone"
    end
    chip_clone.resize(178, 90)
    @gridLayout = Qt::GridLayout.new(chip_clone)
    @gridLayout.objectName = "gridLayout"
    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @lbl_clone = Qt::Label.new(chip_clone)
    @lbl_clone.objectName = "lbl_clone"

    @verticalLayout.addWidget(@lbl_clone)

    @lie_reference = Qt::LineEdit.new(chip_clone)
    @lie_reference.objectName = "lie_reference"
    @lie_reference.maxLength = 30

    @verticalLayout.addWidget(@lie_reference)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @btn_cancel = Qt::PushButton.new(chip_clone)
    @btn_cancel.objectName = "btn_cancel"

    @horizontalLayout.addWidget(@btn_cancel)

    @btn_clone = Qt::PushButton.new(chip_clone)
    @btn_clone.objectName = "btn_clone"
    @btn_clone.default = true

    @horizontalLayout.addWidget(@btn_clone)


    @verticalLayout.addLayout(@horizontalLayout)


    @gridLayout.addLayout(@verticalLayout, 0, 0, 1, 1)


    retranslateUi(chip_clone)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), chip_clone, SLOT('close()'))
    Qt::Object.connect(@btn_clone, SIGNAL('clicked()'), chip_clone, SLOT('clone()'))

    Qt::MetaObject.connectSlotsByName(chip_clone)
    end # setupUi

    def setup_ui(chip_clone)
        setupUi(chip_clone)
    end

    def retranslateUi(chip_clone)
    chip_clone.windowTitle = Qt::Application.translate("Chip_clone", "Chip clone", nil, Qt::Application::UnicodeUTF8)
    @lbl_clone.text = Qt::Application.translate("Chip_clone", "Clone name", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("Chip_clone", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @btn_clone.text = Qt::Application.translate("Chip_clone", "Clone", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(chip_clone)
        retranslateUi(chip_clone)
    end

end

module Ui
    class Chip_clone < Ui_Chip_clone
    end
end  # module Ui

