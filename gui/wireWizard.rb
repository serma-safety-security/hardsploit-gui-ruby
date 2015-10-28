#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class Ui_WireWizard
    attr_reader :gView
    attr_reader :btn_cancel
    attr_reader :lbl_yourChip
    attr_reader :label
    attr_reader :pushButton

    def setupUi(wireWizard)
    if wireWizard.objectName.nil?
        wireWizard.objectName = "wireWizard"
    end
    wireWizard.resize(590, 570)
    wireWizard.minimumSize = Qt::Size.new(590, 570)
    wireWizard.maximumSize = Qt::Size.new(590, 570)
    wireWizard.styleSheet = ""
    @gView = Qt::GraphicsView.new(wireWizard)
    @gView.objectName = "gView"
    @gView.geometry = Qt::Rect.new(10, 60, 571, 471)
    @gView.minimumSize = Qt::Size.new(561, 471)
    @gView.styleSheet = "Qt::GraphicsTextItem{outline: 0;}"
    @btn_cancel = Qt::PushButton.new(wireWizard)
    @btn_cancel.objectName = "btn_cancel"
    @btn_cancel.geometry = Qt::Rect.new(490, 540, 75, 23)
    @lbl_yourChip = Qt::Label.new(wireWizard)
    @lbl_yourChip.objectName = "lbl_yourChip"
    @lbl_yourChip.geometry = Qt::Rect.new(10, 40, 261, 16)
    @label = Qt::Label.new(wireWizard)
    @label.objectName = "label"
    @label.geometry = Qt::Rect.new(10, 10, 571, 16)
    @pushButton = Qt::PushButton.new(wireWizard)
    @pushButton.objectName = "pushButton"
    @pushButton.geometry = Qt::Rect.new(390, 540, 75, 23)

    retranslateUi(wireWizard)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), wireWizard, SLOT('close()'))
    Qt::Object.connect(@pushButton, SIGNAL('clicked()'), wireWizard, SLOT('rotateScene()'))

    Qt::MetaObject.connectSlotsByName(wireWizard)
    end # setupUi

    def setup_ui(wireWizard)
        setupUi(wireWizard)
    end

    def retranslateUi(wireWizard)
    wireWizard.windowTitle = Qt::Application.translate("wireWizard", "Harsploit - Wiring Wizard", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("wireWizard", "Close", nil, Qt::Application::UnicodeUTF8)
    @lbl_yourChip.text = Qt::Application.translate("wireWizard", "Your chip:", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("wireWizard", "Click on a pin number or signal name to turn ON the corresponding LED", nil, Qt::Application::UnicodeUTF8)
    @pushButton.text = Qt::Application.translate("wireWizard", "Rotate", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(wireWizard)
        retranslateUi(wireWizard)
    end

end

module Ui
    class WireWizard < Ui_WireWizard
    end
end  # module Ui

