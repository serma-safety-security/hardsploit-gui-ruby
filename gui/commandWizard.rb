#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class Ui_CommandWizard
    attr_reader :btn_next
    attr_reader :btn_create
    attr_reader :lie_search
    attr_reader :tbl_cmd
    attr_reader :cbx_action
    attr_reader :lbl_loupe
    attr_reader :lbl_currentChip
    attr_reader :lbl_chip
    attr_reader :lbl_currentBus
    attr_reader :cbx_bus
    attr_reader :gbx_parallelMem
    attr_reader :lbl_start
    attr_reader :lbl_stop
    attr_reader :lie_start
    attr_reader :lie_stop
    attr_reader :rbn_8b
    attr_reader :lie_latency
    attr_reader :lbl_wordSize
    attr_reader :rbn_16b
    attr_reader :lbl_latency
    attr_reader :lbl_totalSize
    attr_reader :lie_totalSize
    attr_reader :btn_dumpPara
    attr_reader :btn_fullDumpPara
    attr_reader :line
    attr_reader :lbl_dumpPara
    attr_reader :btn_save
    attr_reader :busParamTabs
    attr_reader :spi
    attr_reader :rbn_m0
    attr_reader :rbn_m1
    attr_reader :rbn_m2
    attr_reader :rbn_m3
    attr_reader :lbl_mode
    attr_reader :btn_saveSPI
    attr_reader :lbl_frequencySPI
    attr_reader :cbx_frequencySPI
    attr_reader :lie_startSPI
    attr_reader :lie_stopSPI
    attr_reader :lie_totalSizeSPI
    attr_reader :lie_cmdReadSPI
    attr_reader :line_4
    attr_reader :lbl_startSPI
    attr_reader :lbl_stopSPI
    attr_reader :lbl_totalSizeSPI
    attr_reader :lbl_cmdReadSPI
    attr_reader :btn_dumpSPI
    attr_reader :btn_fullDumpSPI
    attr_reader :lbl_dumpSPI
    attr_reader :i2c
    attr_reader :btn_cmdI2C
    attr_reader :btn_busScanI2C
    attr_reader :tbl_scanResult
    attr_reader :lbl_scanResult
    attr_reader :lie_addrW
    attr_reader :rbn_RI2C
    attr_reader :rbn_WI2C
    attr_reader :lbl_baseAddrW
    attr_reader :line_2
    attr_reader :line_3
    attr_reader :lie_addrR
    attr_reader :lbl_baseAddrR
    attr_reader :lbl_sizeI2C
    attr_reader :lie_sizeI2C
    attr_reader :btn_saveI2C
    attr_reader :cbx_frequencyI2C
    attr_reader :lbl_frequencyI2C
    attr_reader :line_5
    attr_reader :lie_startI2C
    attr_reader :lie_stopI2C
    attr_reader :btn_dumpI2C
    attr_reader :btn_fullDumpI2C
    attr_reader :lbl_startAddressI2C
    attr_reader :lbl_stopAddressI2C
    attr_reader :lie_totalSizeI2C
    attr_reader :lbl_fullSizeI2C

    def setupUi(commandWizard)
    if commandWizard.objectName.nil?
        commandWizard.objectName = "commandWizard"
    end
    commandWizard.resize(530, 610)
    commandWizard.minimumSize = Qt::Size.new(530, 610)
    commandWizard.maximumSize = Qt::Size.new(530, 610)
    @font = Qt::Font.new
    @font.family = "Arial"
    commandWizard.font = @font
    @btn_next = Qt::PushButton.new(commandWizard)
    @btn_next.objectName = "btn_next"
    @btn_next.geometry = Qt::Rect.new(440, 580, 81, 23)
    @btn_next.font = @font
    @btn_create = Qt::PushButton.new(commandWizard)
    @btn_create.objectName = "btn_create"
    @btn_create.geometry = Qt::Rect.new(220, 580, 81, 23)
    @btn_create.font = @font
    @lie_search = Qt::LineEdit.new(commandWizard)
    @lie_search.objectName = "lie_search"
    @lie_search.geometry = Qt::Rect.new(50, 40, 151, 20)
    @lie_search.maxLength = 10
    @tbl_cmd = Qt::TableWidget.new(commandWizard)
    @tbl_cmd.objectName = "tbl_cmd"
    @tbl_cmd.geometry = Qt::Rect.new(10, 70, 511, 221)
    @tbl_cmd.font = @font
    @tbl_cmd.sortingEnabled = true
    @cbx_action = Qt::ComboBox.new(commandWizard)
    @cbx_action.objectName = "cbx_action"
    @cbx_action.geometry = Qt::Rect.new(310, 580, 121, 22)
    @lbl_loupe = Qt::Label.new(commandWizard)
    @lbl_loupe.objectName = "lbl_loupe"
    @lbl_loupe.geometry = Qt::Rect.new(20, 40, 31, 21)
    @lbl_currentChip = Qt::Label.new(commandWizard)
    @lbl_currentChip.objectName = "lbl_currentChip"
    @lbl_currentChip.geometry = Qt::Rect.new(220, 10, 111, 16)
    @lbl_chip = Qt::Label.new(commandWizard)
    @lbl_chip.objectName = "lbl_chip"
    @lbl_chip.geometry = Qt::Rect.new(330, 10, 171, 16)
    @lbl_currentBus = Qt::Label.new(commandWizard)
    @lbl_currentBus.objectName = "lbl_currentBus"
    @lbl_currentBus.geometry = Qt::Rect.new(220, 40, 111, 16)
    @cbx_bus = Qt::ComboBox.new(commandWizard)
    @cbx_bus.objectName = "cbx_bus"
    @cbx_bus.geometry = Qt::Rect.new(330, 40, 111, 22)
    @gbx_parallelMem = Qt::GroupBox.new(commandWizard)
    @gbx_parallelMem.objectName = "gbx_parallelMem"
    @gbx_parallelMem.geometry = Qt::Rect.new(10, 70, 511, 221)
    @lbl_start = Qt::Label.new(@gbx_parallelMem)
    @lbl_start.objectName = "lbl_start"
    @lbl_start.geometry = Qt::Rect.new(20, 50, 121, 16)
    @lbl_stop = Qt::Label.new(@gbx_parallelMem)
    @lbl_stop.objectName = "lbl_stop"
    @lbl_stop.geometry = Qt::Rect.new(20, 90, 121, 16)
    @lie_start = Qt::LineEdit.new(@gbx_parallelMem)
    @lie_start.objectName = "lie_start"
    @lie_start.geometry = Qt::Rect.new(150, 50, 111, 20)
    @lie_start.maxLength = 20
    @lie_stop = Qt::LineEdit.new(@gbx_parallelMem)
    @lie_stop.objectName = "lie_stop"
    @lie_stop.geometry = Qt::Rect.new(150, 90, 111, 20)
    @lie_stop.maxLength = 20
    @rbn_8b = Qt::RadioButton.new(@gbx_parallelMem)
    @rbn_8b.objectName = "rbn_8b"
    @rbn_8b.geometry = Qt::Rect.new(370, 140, 61, 17)
    @lie_latency = Qt::LineEdit.new(@gbx_parallelMem)
    @lie_latency.objectName = "lie_latency"
    @lie_latency.geometry = Qt::Rect.new(410, 90, 91, 20)
    @lie_latency.maxLength = 20
    @lbl_wordSize = Qt::Label.new(@gbx_parallelMem)
    @lbl_wordSize.objectName = "lbl_wordSize"
    @lbl_wordSize.geometry = Qt::Rect.new(290, 140, 71, 16)
    @rbn_16b = Qt::RadioButton.new(@gbx_parallelMem)
    @rbn_16b.objectName = "rbn_16b"
    @rbn_16b.geometry = Qt::Rect.new(440, 140, 81, 20)
    @lbl_latency = Qt::Label.new(@gbx_parallelMem)
    @lbl_latency.objectName = "lbl_latency"
    @lbl_latency.geometry = Qt::Rect.new(290, 90, 91, 20)
    @lbl_totalSize = Qt::Label.new(@gbx_parallelMem)
    @lbl_totalSize.objectName = "lbl_totalSize"
    @lbl_totalSize.geometry = Qt::Rect.new(290, 50, 111, 16)
    @lie_totalSize = Qt::LineEdit.new(@gbx_parallelMem)
    @lie_totalSize.objectName = "lie_totalSize"
    @lie_totalSize.geometry = Qt::Rect.new(410, 50, 91, 20)
    @lie_totalSize.maxLength = 20
    @btn_dumpPara = Qt::PushButton.new(@gbx_parallelMem)
    @btn_dumpPara.objectName = "btn_dumpPara"
    @btn_dumpPara.geometry = Qt::Rect.new(80, 140, 75, 23)
    @btn_fullDumpPara = Qt::PushButton.new(@gbx_parallelMem)
    @btn_fullDumpPara.objectName = "btn_fullDumpPara"
    @btn_fullDumpPara.geometry = Qt::Rect.new(170, 140, 91, 23)
    @line = Qt::Frame.new(@gbx_parallelMem)
    @line.objectName = "line"
    @line.geometry = Qt::Rect.new(270, 20, 20, 201)
    @line.setFrameShape(Qt::Frame::VLine)
    @line.setFrameShadow(Qt::Frame::Sunken)
    @lbl_dumpPara = Qt::Label.new(@gbx_parallelMem)
    @lbl_dumpPara.objectName = "lbl_dumpPara"
    @lbl_dumpPara.geometry = Qt::Rect.new(20, 20, 211, 21)
    @btn_save = Qt::PushButton.new(@gbx_parallelMem)
    @btn_save.objectName = "btn_save"
    @btn_save.geometry = Qt::Rect.new(420, 180, 75, 23)
    @busParamTabs = Qt::TabWidget.new(commandWizard)
    @busParamTabs.objectName = "busParamTabs"
    @busParamTabs.geometry = Qt::Rect.new(10, 300, 511, 271)
    @spi = Qt::Widget.new()
    @spi.objectName = "spi"
    @rbn_m0 = Qt::RadioButton.new(@spi)
    @rbn_m0.objectName = "rbn_m0"
    @rbn_m0.geometry = Qt::Rect.new(80, 10, 71, 21)
    @rbn_m0.checked = true
    @rbn_m1 = Qt::RadioButton.new(@spi)
    @rbn_m1.objectName = "rbn_m1"
    @rbn_m1.geometry = Qt::Rect.new(160, 10, 91, 21)
    @rbn_m2 = Qt::RadioButton.new(@spi)
    @rbn_m2.objectName = "rbn_m2"
    @rbn_m2.geometry = Qt::Rect.new(80, 40, 71, 21)
    @rbn_m3 = Qt::RadioButton.new(@spi)
    @rbn_m3.objectName = "rbn_m3"
    @rbn_m3.geometry = Qt::Rect.new(160, 40, 91, 21)
    @lbl_mode = Qt::Label.new(@spi)
    @lbl_mode.objectName = "lbl_mode"
    @lbl_mode.geometry = Qt::Rect.new(10, 10, 61, 16)
    @btn_saveSPI = Qt::PushButton.new(@spi)
    @btn_saveSPI.objectName = "btn_saveSPI"
    @btn_saveSPI.geometry = Qt::Rect.new(170, 200, 75, 23)
    @lbl_frequencySPI = Qt::Label.new(@spi)
    @lbl_frequencySPI.objectName = "lbl_frequencySPI"
    @lbl_frequencySPI.geometry = Qt::Rect.new(8, 90, 131, 16)
    @cbx_frequencySPI = Qt::ComboBox.new(@spi)
    @cbx_frequencySPI.objectName = "cbx_frequencySPI"
    @cbx_frequencySPI.geometry = Qt::Rect.new(160, 90, 81, 22)
    @lie_startSPI = Qt::LineEdit.new(@spi)
    @lie_startSPI.objectName = "lie_startSPI"
    @lie_startSPI.geometry = Qt::Rect.new(392, 50, 101, 20)
    @lie_startSPI.maxLength = 20
    @lie_stopSPI = Qt::LineEdit.new(@spi)
    @lie_stopSPI.objectName = "lie_stopSPI"
    @lie_stopSPI.geometry = Qt::Rect.new(392, 90, 101, 20)
    @lie_stopSPI.maxLength = 20
    @lie_totalSizeSPI = Qt::LineEdit.new(@spi)
    @lie_totalSizeSPI.objectName = "lie_totalSizeSPI"
    @lie_totalSizeSPI.geometry = Qt::Rect.new(162, 130, 81, 20)
    @lie_totalSizeSPI.maxLength = 20
    @lie_cmdReadSPI = Qt::LineEdit.new(@spi)
    @lie_cmdReadSPI.objectName = "lie_cmdReadSPI"
    @lie_cmdReadSPI.geometry = Qt::Rect.new(162, 170, 81, 20)
    @lie_cmdReadSPI.maxLength = 5
    @line_4 = Qt::Frame.new(@spi)
    @line_4.objectName = "line_4"
    @line_4.geometry = Qt::Rect.new(250, 10, 16, 221)
    @line_4.setFrameShape(Qt::Frame::VLine)
    @line_4.setFrameShadow(Qt::Frame::Sunken)
    @lbl_startSPI = Qt::Label.new(@spi)
    @lbl_startSPI.objectName = "lbl_startSPI"
    @lbl_startSPI.geometry = Qt::Rect.new(270, 50, 121, 16)
    @lbl_stopSPI = Qt::Label.new(@spi)
    @lbl_stopSPI.objectName = "lbl_stopSPI"
    @lbl_stopSPI.geometry = Qt::Rect.new(270, 90, 111, 16)
    @lbl_totalSizeSPI = Qt::Label.new(@spi)
    @lbl_totalSizeSPI.objectName = "lbl_totalSizeSPI"
    @lbl_totalSizeSPI.geometry = Qt::Rect.new(10, 130, 151, 16)
    @lbl_cmdReadSPI = Qt::Label.new(@spi)
    @lbl_cmdReadSPI.objectName = "lbl_cmdReadSPI"
    @lbl_cmdReadSPI.geometry = Qt::Rect.new(10, 170, 141, 16)
    @btn_dumpSPI = Qt::PushButton.new(@spi)
    @btn_dumpSPI.objectName = "btn_dumpSPI"
    @btn_dumpSPI.geometry = Qt::Rect.new(310, 120, 75, 23)
    @btn_fullDumpSPI = Qt::PushButton.new(@spi)
    @btn_fullDumpSPI.objectName = "btn_fullDumpSPI"
    @btn_fullDumpSPI.geometry = Qt::Rect.new(404, 120, 91, 23)
    @lbl_dumpSPI = Qt::Label.new(@spi)
    @lbl_dumpSPI.objectName = "lbl_dumpSPI"
    @lbl_dumpSPI.geometry = Qt::Rect.new(270, 10, 221, 21)
    @busParamTabs.addTab(@spi, Qt::Application.translate("CommandWizard", "SPI", nil, Qt::Application::UnicodeUTF8))
    @i2c = Qt::Widget.new()
    @i2c.objectName = "i2c"
    @btn_cmdI2C = Qt::PushButton.new(@i2c)
    @btn_cmdI2C.objectName = "btn_cmdI2C"
    @btn_cmdI2C.geometry = Qt::Rect.new(120, 210, 111, 23)
    @btn_busScanI2C = Qt::PushButton.new(@i2c)
    @btn_busScanI2C.objectName = "btn_busScanI2C"
    @btn_busScanI2C.geometry = Qt::Rect.new(390, 0, 101, 21)
    @tbl_scanResult = Qt::TableWidget.new(@i2c)
    @tbl_scanResult.objectName = "tbl_scanResult"
    @tbl_scanResult.geometry = Qt::Rect.new(280, 30, 211, 101)
    @lbl_scanResult = Qt::Label.new(@i2c)
    @lbl_scanResult.objectName = "lbl_scanResult"
    @lbl_scanResult.geometry = Qt::Rect.new(280, 0, 141, 20)
    @lie_addrW = Qt::LineEdit.new(@i2c)
    @lie_addrW.objectName = "lie_addrW"
    @lie_addrW.geometry = Qt::Rect.new(190, 10, 41, 20)
    @lie_addrW.maxLength = 2
    @rbn_RI2C = Qt::RadioButton.new(@i2c)
    @rbn_RI2C.objectName = "rbn_RI2C"
    @rbn_RI2C.geometry = Qt::Rect.new(70, 190, 82, 17)
    @rbn_WI2C = Qt::RadioButton.new(@i2c)
    @rbn_WI2C.objectName = "rbn_WI2C"
    @rbn_WI2C.geometry = Qt::Rect.new(160, 190, 82, 17)
    @lbl_baseAddrW = Qt::Label.new(@i2c)
    @lbl_baseAddrW.objectName = "lbl_baseAddrW"
    @lbl_baseAddrW.geometry = Qt::Rect.new(30, 10, 141, 16)
    @line_2 = Qt::Frame.new(@i2c)
    @line_2.objectName = "line_2"
    @line_2.geometry = Qt::Rect.new(240, 10, 41, 221)
    @line_2.setFrameShape(Qt::Frame::VLine)
    @line_2.setFrameShadow(Qt::Frame::Sunken)
    @line_3 = Qt::Frame.new(@i2c)
    @line_3.objectName = "line_3"
    @line_3.geometry = Qt::Rect.new(10, 150, 241, 20)
    @line_3.setFrameShape(Qt::Frame::HLine)
    @line_3.setFrameShadow(Qt::Frame::Sunken)
    @lie_addrR = Qt::LineEdit.new(@i2c)
    @lie_addrR.objectName = "lie_addrR"
    @lie_addrR.geometry = Qt::Rect.new(190, 40, 41, 20)
    @lie_addrR.maxLength = 2
    @lbl_baseAddrR = Qt::Label.new(@i2c)
    @lbl_baseAddrR.objectName = "lbl_baseAddrR"
    @lbl_baseAddrR.geometry = Qt::Rect.new(30, 40, 141, 16)
    @lbl_sizeI2C = Qt::Label.new(@i2c)
    @lbl_sizeI2C.objectName = "lbl_sizeI2C"
    @lbl_sizeI2C.geometry = Qt::Rect.new(30, 170, 111, 16)
    @lie_sizeI2C = Qt::LineEdit.new(@i2c)
    @lie_sizeI2C.objectName = "lie_sizeI2C"
    @lie_sizeI2C.geometry = Qt::Rect.new(160, 170, 71, 20)
    @btn_saveI2C = Qt::PushButton.new(@i2c)
    @btn_saveI2C.objectName = "btn_saveI2C"
    @btn_saveI2C.geometry = Qt::Rect.new(160, 130, 71, 23)
    @cbx_frequencyI2C = Qt::ComboBox.new(@i2c)
    @cbx_frequencyI2C.objectName = "cbx_frequencyI2C"
    @cbx_frequencyI2C.geometry = Qt::Rect.new(170, 70, 61, 22)
    @lbl_frequencyI2C = Qt::Label.new(@i2c)
    @lbl_frequencyI2C.objectName = "lbl_frequencyI2C"
    @lbl_frequencyI2C.geometry = Qt::Rect.new(30, 70, 131, 16)
    @line_5 = Qt::Frame.new(@i2c)
    @line_5.objectName = "line_5"
    @line_5.geometry = Qt::Rect.new(270, 130, 231, 20)
    @line_5.setFrameShape(Qt::Frame::HLine)
    @line_5.setFrameShadow(Qt::Frame::Sunken)
    @lie_startI2C = Qt::LineEdit.new(@i2c)
    @lie_startI2C.objectName = "lie_startI2C"
    @lie_startI2C.geometry = Qt::Rect.new(380, 150, 113, 20)
    @lie_stopI2C = Qt::LineEdit.new(@i2c)
    @lie_stopI2C.objectName = "lie_stopI2C"
    @lie_stopI2C.geometry = Qt::Rect.new(380, 180, 113, 20)
    @btn_dumpI2C = Qt::PushButton.new(@i2c)
    @btn_dumpI2C.objectName = "btn_dumpI2C"
    @btn_dumpI2C.geometry = Qt::Rect.new(290, 210, 81, 23)
    @btn_fullDumpI2C = Qt::PushButton.new(@i2c)
    @btn_fullDumpI2C.objectName = "btn_fullDumpI2C"
    @btn_fullDumpI2C.geometry = Qt::Rect.new(390, 210, 101, 23)
    @lbl_startAddressI2C = Qt::Label.new(@i2c)
    @lbl_startAddressI2C.objectName = "lbl_startAddressI2C"
    @lbl_startAddressI2C.geometry = Qt::Rect.new(270, 150, 101, 20)
    @lbl_stopAddressI2C = Qt::Label.new(@i2c)
    @lbl_stopAddressI2C.objectName = "lbl_stopAddressI2C"
    @lbl_stopAddressI2C.geometry = Qt::Rect.new(270, 180, 101, 16)
    @lie_totalSizeI2C = Qt::LineEdit.new(@i2c)
    @lie_totalSizeI2C.objectName = "lie_totalSizeI2C"
    @lie_totalSizeI2C.geometry = Qt::Rect.new(120, 100, 113, 20)
    @lbl_fullSizeI2C = Qt::Label.new(@i2c)
    @lbl_fullSizeI2C.objectName = "lbl_fullSizeI2C"
    @lbl_fullSizeI2C.geometry = Qt::Rect.new(30, 100, 81, 16)
    @busParamTabs.addTab(@i2c, Qt::Application.translate("CommandWizard", "I2C", nil, Qt::Application::UnicodeUTF8))

    retranslateUi(commandWizard)
    Qt::Object.connect(@btn_create, SIGNAL('clicked()'), commandWizard, SLOT('openCmdForm()'))
    Qt::Object.connect(@btn_next, SIGNAL('clicked()'), commandWizard, SLOT('execCmdAction()'))
    Qt::Object.connect(@cbx_action, SIGNAL('currentIndexChanged(int)'), commandWizard, SLOT('verifCmdAction()'))
    Qt::Object.connect(@cbx_bus, SIGNAL('currentIndexChanged(int)'), commandWizard, SLOT('changeCmdBus()'))
    Qt::Object.connect(@lie_search, SIGNAL('textEdited(QString)'), commandWizard, SLOT('feedCmdArray()'))
    Qt::Object.connect(@tbl_cmd, SIGNAL('cellClicked(int,int)'), commandWizard, SLOT('activCmdAction()'))
    Qt::Object.connect(@btn_dumpPara, SIGNAL('clicked()'), commandWizard, SLOT('dumpParallel()'))
    Qt::Object.connect(@btn_fullDumpPara, SIGNAL('clicked()'), commandWizard, SLOT('dumpParallel()'))
    Qt::Object.connect(@btn_save, SIGNAL('clicked()'), commandWizard, SLOT('saveParallelParam()'))
    Qt::Object.connect(@btn_saveI2C, SIGNAL('clicked()'), commandWizard, SLOT('saveI2CParam()'))
    Qt::Object.connect(@btn_busScanI2C, SIGNAL('clicked()'), commandWizard, SLOT('busScanI2C()'))
    Qt::Object.connect(@btn_saveSPI, SIGNAL('clicked()'), commandWizard, SLOT('saveSpiParam()'))
    Qt::Object.connect(@btn_cmdI2C, SIGNAL('clicked()'), commandWizard, SLOT('createCmdI2C()'))
    Qt::Object.connect(@btn_dumpSPI, SIGNAL('clicked()'), commandWizard, SLOT('dumpSPI()'))
    Qt::Object.connect(@btn_fullDumpSPI, SIGNAL('clicked()'), commandWizard, SLOT('dumpSPI()'))
    Qt::Object.connect(@btn_dumpI2C, SIGNAL('clicked()'), commandWizard, SLOT('dumpI2C()'))
    Qt::Object.connect(@btn_fullDumpI2C, SIGNAL('clicked()'), commandWizard, SLOT('dumpI2C()'))

    @busParamTabs.setCurrentIndex(1)


    Qt::MetaObject.connectSlotsByName(commandWizard)
    end # setupUi

    def setup_ui(commandWizard)
        setupUi(commandWizard)
    end

    def retranslateUi(commandWizard)
    commandWizard.windowTitle = Qt::Application.translate("CommandWizard", "Hardsploit - Command Wizard", nil, Qt::Application::UnicodeUTF8)
    @btn_next.text = Qt::Application.translate("CommandWizard", "Next", nil, Qt::Application::UnicodeUTF8)
    @btn_create.text = Qt::Application.translate("CommandWizard", "New", nil, Qt::Application::UnicodeUTF8)
    @lie_search.inputMask = ''
    if @tbl_cmd.columnCount < 2
        @tbl_cmd.columnCount = 2
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("CommandWizard", "Name", nil, Qt::Application::UnicodeUTF8))
    @tbl_cmd.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("CommandWizard", "Description", nil, Qt::Application::UnicodeUTF8))
    @tbl_cmd.setHorizontalHeaderItem(1, __colItem1)
    @cbx_action.insertItems(0, [Qt::Application.translate("CommandWizard", "Action...", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "Execute", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "Use as template", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "Edit", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "Concatenate", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "Delete", nil, Qt::Application::UnicodeUTF8)])
    @lbl_loupe.text = Qt::Application.translate("CommandWizard", "loupe", nil, Qt::Application::UnicodeUTF8)
    @lbl_currentChip.text = Qt::Application.translate("CommandWizard", "Current chip:", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("CommandWizard", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    @lbl_currentBus.text = Qt::Application.translate("CommandWizard", "Current BUS:", nil, Qt::Application::UnicodeUTF8)
    @gbx_parallelMem.title = ''
    @lbl_start.text = Qt::Application.translate("CommandWizard", "Start address:", nil, Qt::Application::UnicodeUTF8)
    @lbl_stop.text = Qt::Application.translate("CommandWizard", "Stop address:", nil, Qt::Application::UnicodeUTF8)
    @rbn_8b.text = Qt::Application.translate("CommandWizard", "8 bits", nil, Qt::Application::UnicodeUTF8)
    @lbl_wordSize.text = Qt::Application.translate("CommandWizard", "Word size:", nil, Qt::Application::UnicodeUTF8)
    @rbn_16b.text = Qt::Application.translate("CommandWizard", "16 bits", nil, Qt::Application::UnicodeUTF8)
    @lbl_latency.text = Qt::Application.translate("CommandWizard", "Latency (ns):", nil, Qt::Application::UnicodeUTF8)
    @lbl_totalSize.text = Qt::Application.translate("CommandWizard", "Total size:", nil, Qt::Application::UnicodeUTF8)
    @btn_dumpPara.text = Qt::Application.translate("CommandWizard", "Dump...", nil, Qt::Application::UnicodeUTF8)
    @btn_fullDumpPara.text = Qt::Application.translate("CommandWizard", "Full Dump...", nil, Qt::Application::UnicodeUTF8)
    @lbl_dumpPara.text = Qt::Application.translate("CommandWizard", "Dump:", nil, Qt::Application::UnicodeUTF8)
    @btn_save.text = Qt::Application.translate("CommandWizard", "Save", nil, Qt::Application::UnicodeUTF8)
    @rbn_m0.text = Qt::Application.translate("CommandWizard", "Mode 0", nil, Qt::Application::UnicodeUTF8)
    @rbn_m1.text = Qt::Application.translate("CommandWizard", "Mode 1", nil, Qt::Application::UnicodeUTF8)
    @rbn_m2.text = Qt::Application.translate("CommandWizard", "Mode 2", nil, Qt::Application::UnicodeUTF8)
    @rbn_m3.text = Qt::Application.translate("CommandWizard", "Mode 3", nil, Qt::Application::UnicodeUTF8)
    @lbl_mode.text = Qt::Application.translate("CommandWizard", "Mode:", nil, Qt::Application::UnicodeUTF8)
    @btn_saveSPI.text = Qt::Application.translate("CommandWizard", "Save", nil, Qt::Application::UnicodeUTF8)
    @lbl_frequencySPI.text = Qt::Application.translate("CommandWizard", "Frequency (Mhz) :", nil, Qt::Application::UnicodeUTF8)
    @cbx_frequencySPI.insertItems(0, [Qt::Application.translate("CommandWizard", "25.00", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "18.75", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "15.00", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "12.50", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "10.71", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "9.38", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "7.50", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "5.00", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "3.95", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "3.00", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "2.03", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "1.00", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "0.50", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "0.29", nil, Qt::Application::UnicodeUTF8)])
    @lie_cmdReadSPI.text = Qt::Application.translate("CommandWizard", "3", nil, Qt::Application::UnicodeUTF8)
    @lbl_startSPI.text = Qt::Application.translate("CommandWizard", "Start address:", nil, Qt::Application::UnicodeUTF8)
    @lbl_stopSPI.text = Qt::Application.translate("CommandWizard", "Stop address:", nil, Qt::Application::UnicodeUTF8)
    @lbl_totalSizeSPI.text = Qt::Application.translate("CommandWizard", "Total size (8 bits word):", nil, Qt::Application::UnicodeUTF8)
    @lbl_cmdReadSPI.text = Qt::Application.translate("CommandWizard", "SPI command read:", nil, Qt::Application::UnicodeUTF8)
    @btn_dumpSPI.text = Qt::Application.translate("CommandWizard", "Dump...", nil, Qt::Application::UnicodeUTF8)
    @btn_fullDumpSPI.text = Qt::Application.translate("CommandWizard", "Full Dump...", nil, Qt::Application::UnicodeUTF8)
    @lbl_dumpSPI.text = Qt::Application.translate("CommandWizard", "Dump:", nil, Qt::Application::UnicodeUTF8)
    @busParamTabs.setTabText(@busParamTabs.indexOf(@spi), Qt::Application.translate("CommandWizard", "SPI", nil, Qt::Application::UnicodeUTF8))
    @btn_cmdI2C.text = Qt::Application.translate("CommandWizard", "Add command", nil, Qt::Application::UnicodeUTF8)
    @btn_busScanI2C.text = Qt::Application.translate("CommandWizard", "Bus scan", nil, Qt::Application::UnicodeUTF8)
    if @tbl_scanResult.columnCount < 2
        @tbl_scanResult.columnCount = 2
    end

    __colItem2 = Qt::TableWidgetItem.new
    __colItem2.setText(Qt::Application.translate("CommandWizard", "Address", nil, Qt::Application::UnicodeUTF8))
    @tbl_scanResult.setHorizontalHeaderItem(0, __colItem2)

    __colItem3 = Qt::TableWidgetItem.new
    __colItem3.setText(Qt::Application.translate("CommandWizard", "R/W", nil, Qt::Application::UnicodeUTF8))
    @tbl_scanResult.setHorizontalHeaderItem(1, __colItem3)
    @lbl_scanResult.text = Qt::Application.translate("CommandWizard", "Bus scan", nil, Qt::Application::UnicodeUTF8)
    @rbn_RI2C.text = Qt::Application.translate("CommandWizard", "Read", nil, Qt::Application::UnicodeUTF8)
    @rbn_WI2C.text = Qt::Application.translate("CommandWizard", "Write", nil, Qt::Application::UnicodeUTF8)
    @lbl_baseAddrW.text = Qt::Application.translate("CommandWizard", "Base address (W):", nil, Qt::Application::UnicodeUTF8)
    @lbl_baseAddrR.text = Qt::Application.translate("CommandWizard", "Base address (R):", nil, Qt::Application::UnicodeUTF8)
    @lbl_sizeI2C.text = Qt::Application.translate("CommandWizard", "Payload size:", nil, Qt::Application::UnicodeUTF8)
    @btn_saveI2C.text = Qt::Application.translate("CommandWizard", "Save", nil, Qt::Application::UnicodeUTF8)
    @cbx_frequencyI2C.insertItems(0, [Qt::Application.translate("CommandWizard", "100", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "400", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("CommandWizard", "1000", nil, Qt::Application::UnicodeUTF8)])
    @lbl_frequencyI2C.text = Qt::Application.translate("CommandWizard", "Frequency (Khz):", nil, Qt::Application::UnicodeUTF8)
    @btn_dumpI2C.text = Qt::Application.translate("CommandWizard", "Dump...", nil, Qt::Application::UnicodeUTF8)
    @btn_fullDumpI2C.text = Qt::Application.translate("CommandWizard", "Full Dump...", nil, Qt::Application::UnicodeUTF8)
    @lbl_startAddressI2C.text = Qt::Application.translate("CommandWizard", "Start address:", nil, Qt::Application::UnicodeUTF8)
    @lbl_stopAddressI2C.text = Qt::Application.translate("CommandWizard", "Stop address:", nil, Qt::Application::UnicodeUTF8)
    @lbl_fullSizeI2C.text = Qt::Application.translate("CommandWizard", "Total size:", nil, Qt::Application::UnicodeUTF8)
    @busParamTabs.setTabText(@busParamTabs.indexOf(@i2c), Qt::Application.translate("CommandWizard", "I2C", nil, Qt::Application::UnicodeUTF8))
    end # retranslateUi

    def retranslate_ui(commandWizard)
        retranslateUi(commandWizard)
    end

end

module Ui
    class CommandWizard < Ui_CommandWizard
    end
end  # module Ui

