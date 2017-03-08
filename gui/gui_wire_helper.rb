=begin
** Form generated from reading ui file 'gui_wire_helper.ui'
**
** Created: mer. mars 8 11:15:10 2017
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Wire_helper
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :lbl_advice
    attr_reader :lbl_chip
    attr_reader :gView
    attr_reader :hl
    attr_reader :hs
    attr_reader :btn_cancel
    attr_reader :btn_rotate

    def setupUi(wire_helper)
    if wire_helper.objectName.nil?
        wire_helper.objectName = "wire_helper"
    end
    wire_helper.resize(581, 560)
    wire_helper.styleSheet = ""
    @gridLayout = Qt::GridLayout.new(wire_helper)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @lbl_advice = Qt::Label.new(wire_helper)
    @lbl_advice.objectName = "lbl_advice"

    @vl.addWidget(@lbl_advice)

    @lbl_chip = Qt::Label.new(wire_helper)
    @lbl_chip.objectName = "lbl_chip"

    @vl.addWidget(@lbl_chip)

    @gView = Qt::GraphicsView.new(wire_helper)
    @gView.objectName = "gView"
    @gView.styleSheet = "Qt::GraphicsTextItem{outline: 0;}"

    @vl.addWidget(@gView)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)

    @btn_cancel = Qt::PushButton.new(wire_helper)
    @btn_cancel.objectName = "btn_cancel"

    @hl.addWidget(@btn_cancel)

    @btn_rotate = Qt::PushButton.new(wire_helper)
    @btn_rotate.objectName = "btn_rotate"

    @hl.addWidget(@btn_rotate)


    @vl.addLayout(@hl)


    @gridLayout.addLayout(@vl, 1, 0, 1, 1)


    retranslateUi(wire_helper)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), wire_helper, SLOT('close()'))
    Qt::Object.connect(@btn_rotate, SIGNAL('clicked()'), wire_helper, SLOT('rotate_scene()'))

    Qt::MetaObject.connectSlotsByName(wire_helper)
    end # setupUi

    def setup_ui(wire_helper)
        setupUi(wire_helper)
    end

    def retranslateUi(wire_helper)
    wire_helper.windowTitle = Qt::Application.translate("Wire_helper", "Harsploit - Wiring helper", nil, Qt::Application::UnicodeUTF8)
    @lbl_advice.text = Qt::Application.translate("Wire_helper", "Click on a pin number or signal name to turn ON the corresponding LED", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Wire_helper", "Your chip:", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("Wire_helper", "Close", nil, Qt::Application::UnicodeUTF8)
    @btn_rotate.text = Qt::Application.translate("Wire_helper", "Rotate", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(wire_helper)
        retranslateUi(wire_helper)
    end

end

module Ui
    class Wire_helper < Ui_Wire_helper
    end
end  # module Ui

