#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class Ui_ExportManager
    attr_reader :tbl_resultI2C
    attr_reader :btn_save
    attr_reader :cbx_export
    attr_reader :lbl_result
    attr_reader :tbl_resultSPI

    def setupUi(exportManager)
    if exportManager.objectName.nil?
        exportManager.objectName = "exportManager"
    end
    exportManager.resize(256, 620)
    exportManager.minimumSize = Qt::Size.new(256, 620)
    exportManager.maximumSize = Qt::Size.new(256, 620)
    @tbl_resultI2C = Qt::TableWidget.new(exportManager)
    @tbl_resultI2C.objectName = "tbl_resultI2C"
    @tbl_resultI2C.geometry = Qt::Rect.new(10, 30, 241, 531)
    @btn_save = Qt::PushButton.new(exportManager)
    @btn_save.objectName = "btn_save"
    @btn_save.geometry = Qt::Rect.new(170, 580, 75, 31)
    @cbx_export = Qt::ComboBox.new(exportManager)
    @cbx_export.objectName = "cbx_export"
    @cbx_export.geometry = Qt::Rect.new(10, 580, 141, 31)
    @lbl_result = Qt::Label.new(exportManager)
    @lbl_result.objectName = "lbl_result"
    @lbl_result.geometry = Qt::Rect.new(10, 10, 241, 16)
    @lbl_result.minimumSize = Qt::Size.new(241, 16)
    @lbl_result.maximumSize = Qt::Size.new(240, 16)
    @tbl_resultSPI = Qt::TableWidget.new(exportManager)
    @tbl_resultSPI.objectName = "tbl_resultSPI"
    @tbl_resultSPI.geometry = Qt::Rect.new(10, 30, 241, 531)

    retranslateUi(exportManager)
    Qt::Object.connect(@btn_save, SIGNAL('clicked()'), exportManager, SLOT('saveResult()'))

    Qt::MetaObject.connectSlotsByName(exportManager)
    end # setupUi

    def setup_ui(exportManager)
        setupUi(exportManager)
    end

    def retranslateUi(exportManager)
    exportManager.windowTitle = Qt::Application.translate("exportManager", "Hardsploit - Export", nil, Qt::Application::UnicodeUTF8)
    if @tbl_resultI2C.columnCount < 3
        @tbl_resultI2C.columnCount = 3
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("exportManager", "R/W", nil, Qt::Application::UnicodeUTF8))
    @tbl_resultI2C.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("exportManager", "(N)ACK", nil, Qt::Application::UnicodeUTF8))
    @tbl_resultI2C.setHorizontalHeaderItem(1, __colItem1)

    __colItem2 = Qt::TableWidgetItem.new
    __colItem2.setText(Qt::Application.translate("exportManager", "DATA", nil, Qt::Application::UnicodeUTF8))
    @tbl_resultI2C.setHorizontalHeaderItem(2, __colItem2)
    @btn_save.text = Qt::Application.translate("exportManager", "Save...", nil, Qt::Application::UnicodeUTF8)
    @cbx_export.insertItems(0, [Qt::Application.translate("exportManager", "Debug (CSV file)", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("exportManager", "Data only (Read)", nil, Qt::Application::UnicodeUTF8)])
    @lbl_result.text = Qt::Application.translate("exportManager", "Command result:", nil, Qt::Application::UnicodeUTF8)
    if @tbl_resultSPI.columnCount < 2
        @tbl_resultSPI.columnCount = 2
    end

    __colItem3 = Qt::TableWidgetItem.new
    __colItem3.setText(Qt::Application.translate("exportManager", "Data send", nil, Qt::Application::UnicodeUTF8))
    @tbl_resultSPI.setHorizontalHeaderItem(0, __colItem3)

    __colItem4 = Qt::TableWidgetItem.new
    __colItem4.setText(Qt::Application.translate("exportManager", "Data receive", nil, Qt::Application::UnicodeUTF8))
    @tbl_resultSPI.setHorizontalHeaderItem(1, __colItem4)
    end # retranslateUi

    def retranslate_ui(exportManager)
        retranslateUi(exportManager)
    end

end

module Ui
    class ExportManager < Ui_ExportManager
    end
end  # module Ui

