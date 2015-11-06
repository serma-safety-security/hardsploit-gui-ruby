#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../HardsploitAPI/HardsploitAPI'
class CommandWizard < Qt::Widget
  slots 'openCmdForm()'
  slots 'verifCmdAction()'
  slots 'activCmdAction()'
  slots 'execCmdAction()'
  slots 'feedCmdArray()'
  slots 'changeCmdBus()'
  slots 'dumpParallel()'
  slots 'dumpSPI()'
  slots 'dumpI2C()'
  slots 'saveParallelParam()'
  slots 'saveSpiParam()'
  slots 'saveI2CParam()'
  slots 'busScanI2C()'
  slots 'createCmdI2C()'
  slots 'fileChoice()'

  def initialize(api, chip)
    super()
    @cw = Ui_CommandWizard.new
    centerWindow(self)
    @cw.setupUi(self) 
    @chip = chip
    @api = api

    #Search icon
    @cw.lbl_loupe.setPixmap(Qt::Pixmap.new("images/search.png"))

    #Disable next & action button
    @cw.btn_next.setEnabled(false)
    @cw.cbx_action.setEnabled(false)

    # BUS combobox
    chipSignalId = chip.pin.pluck(:pin_signal)
    chipSignalId.delete(62) # NA
    chipBusId = Array.new
    chipSignalId.each do |s|
      chipBusId.push(Use.find_by(signal_id: s).bus_id)
    end
    chipBusId.uniq.each do |b|
      @cw.cbx_bus.addItem(Bus.find_by(bus_id: b).bus_name)
    end
    @cw.lbl_chip.setText(chip.chip_reference)

    inputRestrict(@cw.lie_search, 2)
    inputRestrict(@cw.lie_start, 0)
    inputRestrict(@cw.lie_stop, 0)
    inputRestrict(@cw.lie_startSPI, 0)
    inputRestrict(@cw.lie_stopSPI, 0)
    inputRestrict(@cw.lie_startI2C, 0)
    inputRestrict(@cw.lie_stopI2C, 0)
    inputRestrict(@cw.lie_totalSize, 0)
    inputRestrict(@cw.lie_totalSizeSPI, 0)
    inputRestrict(@cw.lie_totalSizeI2C, 0)
    inputRestrict(@cw.lie_latency, 0)
    inputRestrict(@cw.lie_cmdReadSPI, 0)
		inputRestrict(@cw.lie_sizeI2C, 0)
    inputRestrict(@cw.lie_addrR, 2)
    inputRestrict(@cw.lie_addrW, 2)
    changeCmdBus
    feedCmdArray

    # Chip array parameters
    @cw.tbl_cmd.resizeColumnsToContents
    @cw.tbl_cmd.resizeRowsToContents
    @cw.tbl_cmd.horizontalHeader.stretchLastSection = true

    rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error while loading the command editor GUI").exec
  end

  # Feed command array
  def feedCmdArray
    # Empty the array
    @cw.tbl_cmd.clearContents

    # Get the elements depending on the filters
    if @cw.lie_search.text.empty?
        cmd = @chip.cmd.where(cmd_bus: Bus.find_by(bus_name: @cw.cbx_bus.currentText).bus_id)
    else
        cmd = @chip.cmd.where(cmd_bus: Bus.find_by(bus_name: @cw.cbx_bus.currentText).bus_id)
        cmd = cmd.where("cmd_name LIKE ?", "%#{@cw.lie_search.text}%")
    end

    # Array formating
    @cw.tbl_cmd.setColumnCount(2);
    @cw.tbl_cmd.setRowCount(cmd.count);

    # Insert elements
    cmd.to_enum.with_index(0).each do |c, i|
      it1 = Qt::TableWidgetItem.new(c.cmd_name)
      it1.setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled)
      it2 =  Qt::TableWidgetItem.new(c.cmd_desc)
      it2.setFlags(Qt::ItemIsEnabled)
      @cw.tbl_cmd.setItem(i, 0, it1);
      @cw.tbl_cmd.setItem(i, 1, it2);
    end
    rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error while loading the command array").exec
  end

  def uploadFPGAFirmware(firm, api)
    sleepTime = 2 # time to wait to be sure FPGA is ready 1s is enought but 2 secondes for security
    if $currentFirmware != firm
      case firm
      # PARALLEL
      when 0
        p "Upload Firmware  check : #{api.uploadFirmware(File.expand_path(File.dirname(__FILE__)) +  "/../Firmware/FPGA/PARALLEL/NO_MUX_PARALLEL_MEMORY/HARDSPLOIT_FIRMWARE_FPGA_NO_MUX_PARALLEL_MEMORY.rpd", false)}\n"
      # SPI
      when 1
        p "Upload Firmware  check : #{api.uploadFirmware(File.expand_path(File.dirname(__FILE__)) +  "/../Firmware/FPGA/SPI/SPI_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_SPI_INTERACT.rpd", false)}\n"
      # I2C
      when 2
        p "Upload Firmware  check : #{api.uploadFirmware(File.expand_path(File.dirname(__FILE__)) +  "/../Firmware/FPGA/I2C/I2C_INTERACT/HARDSPLOIT_FIRMWARE_FPGA_I2C_INTERACT.rpd", false)}\n"
      else
      end
      sleep(sleepTime)
      $currentFirmware = firm
    end
  end
  
  def changeCmdBus
    if $usbConnected == false then
      @cw.cbx_action.removeItem(@cw.cbx_action.findText("Execute"))
      @cw.btn_fullDumpI2C.setEnabled(false)
      @cw.btn_fullDumpSPI.setEnabled(false)
      @cw.btn_fullDumpPara.setEnabled(false)
      @cw.btn_dumpPara.setEnabled(false)
      @cw.btn_dumpI2C.setEnabled(false)
      @cw.btn_dumpSPI.setEnabled(false)
    end
    @busId = Bus.find_by(bus_name: @cw.cbx_bus.currentText).bus_id
    if @cw.cbx_bus.currentText == "PARALLEL"
      @chipParallel = Parallel.find_by(parallel_chip: @chip.chip_id)
      @cw.gbx_parallelMem.show
      @cw.tbl_cmd.hide
      @cw.busParamTabs.setEnabled(false)
      @cw.btn_create.setEnabled(false)
      @cw.lie_search.setEnabled(false)
      @cw.cbx_action.setEnabled(false)
      if !@chipParallel.nil?
        @cw.lie_totalSize.setText(@chipParallel.parallel_totalSize.to_s)
        @cw.lie_latency.setText(@chipParallel.parallel_readLatency.to_s)
        if @chipParallel.parallel_wordSize == 1
          @cw.rbn_16b.setChecked(true)
        else
          @cw.rbn_8b.setChecked(true)
        end
      end
    elsif @cw.cbx_bus.currentText == "SPI"
      @cw.busParamTabs.setTabEnabled(0, true)
      @cw.busParamTabs.setTabEnabled(1, false)
      @cw.busParamTabs.setCurrentIndex(0)
      @chipSPI = Spi.find_by(spi_chip: @chip.chip_id)
      if !@chipSPI.nil?
        if @chipSPI.spi_mode == 0
          @cw.rbn_m0.setChecked(true)
        elsif @chipSPI.spi_mode == 1
          @cw.rbn_m1.setChecked(true)
        elsif @chipSPI.spi_mode == 2
          @cw.rbn_m2.setChecked(true)
        else
          @cw.rbn_m3.setChecked(true)
        end
        @cw.cbx_frequencySPI.setCurrentIndex(@cw.cbx_frequencySPI.findText(@chipSPI.spi_frequency))
        @cw.lie_cmdReadSPI.setText(@chipSPI.spi_commandRead.to_s)
        @cw.lie_totalSizeSPI.setText(@chipSPI.spi_totalSize.to_s)
      end
      @cw.gbx_parallelMem.hide
      @cw.tbl_cmd.show
      @cw.busParamTabs.setEnabled(true)
      @cw.btn_create.setEnabled(true)
      @cw.lie_search.setEnabled(true)
      @cw.cbx_action.setEnabled(true)
      @cw.cbx_action.removeItem(@cw.cbx_action.findText("Concatenate"))
      feedCmdArray
    elsif @cw.cbx_bus.currentText == "I2C"
      @cw.tbl_scanResult.resizeColumnsToContents
      @cw.tbl_scanResult.resizeRowsToContents
      @cw.tbl_scanResult.horizontalHeader.stretchLastSection = true
      @cw.busParamTabs.setTabEnabled(0, false)
      @cw.busParamTabs.setTabEnabled(1, true)
      @cw.busParamTabs.setCurrentIndex(1)
      @cw.gbx_parallelMem.hide
      @cw.tbl_cmd.show
      @cw.busParamTabs.setEnabled(true)
      @cw.btn_create.hide
      @cw.lie_search.setEnabled(true)
      @cw.cbx_action.setEnabled(true)
      feedCmdArray
      @chipI2C = I2C.find_by(i2c_chip: @chip.chip_id)
      if !@chipI2C.nil?
        @cw.lie_addrR.setText(@chipI2C.i2c_read)
        @cw.lie_addrW.setText(@chipI2C.i2c_write)
        @cw.lie_totalSizeI2C.setText(@chipI2C.i2c_totalSize.to_s)
        @cw.cbx_frequencyI2C.setCurrentIndex(@cw.cbx_frequencyI2C.findText(@chipI2C.i2c_frequency))
      end
    else
      Qt::MessageBox.new(Qt::MessageBox::Warning, "Bus error", "No working buses for this component or pins set to NA").exec
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured when loading the bus combobox. Consult the log for more details").exec
  end
  
  def saveParallelParam
    if @cw.rbn_8b.checked?
      wordSize = 0
    else
      wordSize = 1
    end

    if !@chipParallel.nil?
      if @chipParallel.parallel_readLatency != @cw.lie_latency.text
        if @cw.lie_latency.text.empty? || @cw.lie_latency.text.to_i > 1600
          @cw.lie_latency.setText("0") 
        end
        @chipParallel.update(parallel_readLatency: @cw.lie_latency.text)
      end
      
      if @chipParallel.parallel_totalSize != @cw.lie_totalSize.text
        if @cw.lie_totalSize.text.empty?
          @cw.lie_totalSize.setText("0")
        end
        @chipParallel.update(parallel_totalSize: @cw.lie_totalSize.text)
      end

      if @chipParallel.parallel_wordSize != wordSize
        @chipParallel.update(parallel_wordSize: wordSize)
      end
    else
      @chipParallel = Parallel.create(
        parallel_totalSize: @cw.lie_totalSize.text.to_i,
        parallel_totalSizeUnit: "o",
        parallel_wordSize: wordSize,
        parallel_readLatency: @cw.lie_latency.text.to_i,
        parallel_chip: @chip.chip_id
      )
    end
    if sender.objectName == "btn_save"
      Qt::MessageBox.new(Qt::MessageBox::Information, "Parameters saved", "Successfuly saved the parameters").exec
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured when saving the parallel parameters. Consult the log for more details").exec
  end
  
  def getSpiMode
    if @cw.rbn_m0.checked?
      return 0
    elsif @cw.rbn_m1.checked?
      return 1
    elsif @cw.rbn_m2.checked?
      return 2
    elsif @cw.rbn_m3.checked?
      return 3
    else
      return false
    end
  end
  
  def saveSpiParam
    mode = getSpiMode
    
    if @cw.lie_cmdReadSPI.text.empty? || @cw.lie_totalSizeSPI.text.empty?
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Invalid form", "Total size and SPI command read fields must be renseigned").exec
      return      
    end
    
    if @chipSPI.nil?
      @chipSPI = Spi.create(
        spi_mode: mode,
        spi_frequency: @cw.cbx_frequencySPI.currentText,
        spi_commandRead: @cw.lie_cmdReadSPI.text,
        spi_totalSize: @cw.lie_totalSizeSPI.text,
        spi_chip: @chip.chip_id
      )
    else
      if @chipSPI.spi_mode != mode
        @chipSPI.update(spi_mode: mode)
      end
      if @chipSPI.spi_frequency != @cw.cbx_frequencySPI.currentText
        @chipSPI.update(spi_frequency: @cw.cbx_frequencySPI.currentText)
      end
      if @chipSPI.spi_commandRead != @cw.lie_cmdReadSPI.text
        if @cw.lie_cmdReadSPI.text.empty?
          @cw.lie_cmdReadSPI.setText("3")
        end
        @chipSPI.update(spi_commandRead: @cw.lie_cmdReadSPI.text)
      end
      if @chipSPI.spi_totalSize != @cw.lie_totalSizeSPI.text
        @chipSPI.update(spi_totalSize: @cw.lie_totalSizeSPI.text)
      end
    end
    
    if sender.objectName == "btn_saveSPI"
      Qt::MessageBox.new(Qt::MessageBox::Information, "Succes", "SPI mode saved successfully").exec
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured when saving the SPI parameters. Consult the log for more details").exec 
  end
  
  def saveI2CParam
    if @cw.lie_addrR.text.empty? || @cw.lie_addrW.text.empty?
      Qt::MessageBox.new(Qt::MessageBox::Warning, "Field empty", "Please fill both read and write base addresses").exec
      return false
    elsif @cw.lie_totalSizeI2C.text.empty? || @cw.lie_totalSizeI2C.text <= "4294967296"
      Qt::MessageBox.new(Qt::MessageBox::Warning, "Wrong size", "Total size must be renseigned and inferior to 4go").exec
      return false
    end
    if @chipI2C.nil?
      I2C.create(
        i2c_read: @cw.lie_addrR.text,
        i2c_write: @cw.lie_addrW.text,
        i2c_totalSize: @cw.lie_totalSizeI2C.text,
        i2c_frequency: @cw.cbx_frequencyI2C.currentText,
        i2c_chip: @chip.chip_id
      )
    else
      if @cw.lie_addrW.text != @chipI2C.i2c_write
        @chipI2C.update(i2c_write: @cw.lie_addrW.text)
      end
      if @cw.lie_addrR.text != @chipI2C.i2c_read
        @chipI2C.update(i2c_read: @cw.lie_addrR.text)
      end
      if @cw.lie_totalSizeI2C.text != @chipI2C.i2c_totalSize
        if @cw.lie_totalSizeI2C.text.empty?
          @cw.lie_totalSizeI2C.setText("0")
        end
        @chipI2C.update(i2c_totalSize: @cw.lie_totalSizeI2C.text)
      end
      if @cw.cbx_frequencyI2C.currentText != @chipI2C.i2c_frequency
        @chipI2C.update(i2c_frequency: @cw.cbx_frequencyI2C.currentText)
      end
    end
    if sender.objectName == "btn_saveI2C"
      Qt::MessageBox.new(Qt::MessageBox::Information, "Succes", "I2C parameters saved successfully").exec
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured when saving the I2C address. Consult the log for more details").exec  
  end
  
  def busScanI2C
    @cw.tbl_scanResult.setRowCount(0)
    uploadFPGAFirmware(2, @api)
    scan_result = @api.i2c_Scan(0)
    p scan_result
    p " "
    p "Size : #{scan_result.size}"
    if scan_result.include?(1)
      scan_result.each_with_index do |v, i|
        if v == 1
          @cw.tbl_scanResult.insertRow(@cw.tbl_scanResult.rowCount)
          @cw.tbl_scanResult.setItem(@cw.tbl_scanResult.rowCount-1, 0, Qt::TableWidgetItem.new(i.to_s(16).upcase))
          if i%2 == 0
            @cw.tbl_scanResult.setItem(@cw.tbl_scanResult.rowCount-1, 1, Qt::TableWidgetItem.new("Write"))
          else
            @cw.tbl_scanResult.setItem(@cw.tbl_scanResult.rowCount-1, 1, Qt::TableWidgetItem.new("Read"))
          end
        end
      end
      @cw.tbl_scanResult.resizeColumnsToContents
      @cw.tbl_scanResult.resizeRowsToContents
      @cw.tbl_scanResult.horizontalHeader.stretchLastSection = true
      Qt::MessageBox.new(Qt::MessageBox::Information, "Bus Scan", "Bus scan ended correctly: #{@cw.tbl_scanResult.rowCount} address(es) found").exec
    else
      Qt::MessageBox.new(Qt::MessageBox::Information, "Bus addresses", "No valid addresses have been returned by the scan").exec
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured when scanning I2C. Consult the log for more details").exec  
  end
  
  def createCmdI2C
    if !@cw.rbn_RI2C.checked && !@cw.rbn_WI2C.checked
      Qt::MessageBox.new(Qt::MessageBox::Warning, "Missing parameter", "You must choose the Write or Read option").exec
      return
    end
    if @cw.rbn_RI2C.checked
      if @cw.lie_addrR.text.empty? || @cw.lie_sizeI2C.text.empty?
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Missing parameters", "You must fill the 'Base address (R)' and size fields").exec
        return      
      end
    else
      if @cw.lie_addrW.text.empty? || @cw.lie_sizeI2C.text.empty?
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Missing parameter", "You must fill the 'Base address (W)' and size fields").exec
        return      
      end     
    end
    if @cw.rbn_RI2C.checked
      mode = "r"
      addr = @cw.lie_addrR.text
    else
      mode = "w"
      addr = @cw.lie_addrW.text
    end
    cmdBase = CommandBase.new(0, nil, @chip.chip_id, @busId, self, @api, :mode => mode, :size => @cw.lie_sizeI2C.text, :addr => addr)
    cmdBase.setWindowModality(Qt::ApplicationModal)
    cmdBase.show
  end
  
  # Next button state
  def verifCmdAction
    case @cw.cbx_action.currentIndex
    when 0
      @cw.btn_next.setEnabled(false)
    when 1..5
      @cw.btn_next.setEnabled(true)
    else
      @cw.btn_next.setEnabled(false)
    end
  end

  # Execute action
  def execCmdAction
    if @cw.tbl_cmd.currentItem.nil?
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Missing command", "Select a command in the array first").exec
      return
    end
    case @cw.cbx_action.currentText
    when "Execute"
      if @cw.cbx_bus.currentText == "SPI"
        # Create command table
        byteList = Byte.where(byte_cmd: Cmd.find_by(cmd_name: @cw.tbl_cmd.currentItem.text))

        # Array sent
        array_sent = Array.new
        byteList.each do |bl|
          if bl.byte_iteration != 0
            for i in 1..bl.byte_iteration.to_i do
              array_sent.push(bl.byte_value.to_i(16))
            end
          else
            array_sent.push(bl.byte_value.to_i(16))
          end
        end

        # Mode
        mode = getSpiMode
        if !getSpiMode
          Qt::MessageBox.new(Qt::MessageBox::Critical, "Mode", "Please select a mode before executing the command").exec
          return
        end

        # Speed
        speed = {
          "25.00" => 3,
          "18.75" => 4,
          "15.00" => 5,
          "12.50" => 6,
          "10.71" => 7,
          "9.38" => 8,
          "7.50" => 10,
          "5.00" => 15,
          "3.95" => 19,
          "3.00" => 25,
          "2.03" => 37,
          "1.00" => 75,
          "0.50" => 150,
          "0.29" => 255
        }

        # Upload SPI firmware
        uploadFPGAFirmware(1, @api)
        # Launch SPI command
        result = check_SendAndReceivedData(@api.spi_Interact(mode, speed[@cw.cbx_frequencySPI.currentText], array_sent))
        exportManager = ExportManager.new("spi", result, array_sent)
        exportManager.setWindowModality(Qt::ApplicationModal)
        exportManager.show
      end
      if @cw.cbx_bus.currentText == "I2C"
        # Create command table
        byteList = Byte.where(byte_cmd: Cmd.find_by(cmd_name: @cw.tbl_cmd.currentItem.text))

        # Array sent
        array_sent = Array.new
        byteList.each do |bl|
          if bl.byte_iteration != 0
            for i in 1..bl.byte_iteration.to_i do
              array_sent.push(bl.byte_value.to_i(16))
            end
          else
            array_sent.push(bl.byte_value.to_i(16))
          end
        end
        # Upload I2C firmware
        uploadFPGAFirmware(2, @api)
        result = check_SendAndReceivedData(@api.i2c_Interact(@cw.cbx_frequencyI2C.currentIndex, array_sent))
        exportManager = ExportManager.new("i2c", result)
        exportManager.setWindowModality(Qt::ApplicationModal)
        exportManager.show
      end
    # Use as template
    when "Use as template"
      openCmdForm(:option_1 => "temp")
    # Edit
    when "Edit"
      openCmdForm(:option_1 => "edit")
    #Concatenate
    when "Concatenate"
      begin
        if @cw.tbl_cmd.selectedItems.count != 2
          Qt::MessageBox.new(Qt::MessageBox::Critical, "Wrong selection", "Select two commands in the table to concatenate them").exec
        else
          bytesCmd1 = Byte.where(byte_cmd: Cmd.find_by(cmd_name: @cw.tbl_cmd.selectedItems[0].text).cmd_id)
          bytesCmd2 = Byte.where(byte_cmd: Cmd.find_by(cmd_name: @cw.tbl_cmd.selectedItems[1].text).cmd_id)
          # Cmd size verification
          checkSize = Array.new
          bytesCmd1.each do |b1|
            checkSize.push(b1.byte_value)
          end
          bytesCmd2.each do |b2|
            checkSize.push(b2.byte_value)
          end
          count = 0
          i = 0
          while i <= (checkSize.size) - 1 do
            lowByte = checkSize[i]
            highByte = checkSize[i + 1]
            commandType = checkSize[i + 2]
            count = count + (@api.BytesToInt(lowByte.to_i(16), highByte.to_i(16)))
            if commandType.to_i(16) % 2 == 0 #WRITE
              i = (i + ((@api.BytesToInt(lowByte.to_i(16), highByte.to_i(16))) + 3))
            else #READ
              i = (i + 3)
            end
          end
          if count > 2000
            Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Command too big: unable to concatenate").exec
            return false
          end
          # Save cmd
          cmd = Cmd.new
          cmd.cmd_name = "New concatenation"
          cmd.cmd_desc = "Concatenation of #{@cw.tbl_cmd.selectedItems[0].text} and #{@cw.tbl_cmd.selectedItems[1].text} commands"
          cmd.cmd_bus = Bus.find_by(bus_name: @cw.cbx_bus.currentText).bus_id
          cmd.cmd_chip = @chip.chip_id
          cmd.save
          
          # Save first command
          bytesCmd1.each do |b1|
            byte = Byte.new
            byte.byte_index = b1.byte_index
            byte.byte_value = b1.byte_value
            checkSize.push(b1.byte_value)
            byte.byte_description = b1.byte_description
            byte.byte_iteration = b1.byte_iteration
            byte.byte_cmd = Cmd.ids.last
            byte.byte_type = 1
            byte.save
          end
          bytesCmd2.each do |b2|
            byte2 = Byte.new
            byte2.byte_index = Byte.last.byte_index + 1
            byte2.byte_value = b2.byte_value
            checkSize.push(b2.byte_value)
            byte2.byte_description = b2.byte_description
            byte2.byte_iteration = b2.byte_iteration
            byte2.byte_cmd = Cmd.ids.last
            byte2.byte_type = 1
            byte2.save
          end
          feedCmdArray
        end
      rescue Exception => msg
        logger = Logger.new($logFilePath)
        logger.error msg
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured when concatenating the command. Consult the log for more details").exec
      end
    #Delete
    when "Delete"
      begin
      msg = Qt::MessageBox.new
      msg.setWindowTitle("Delete command")
      msg.setText("Confirm the delete command action ?")
      msg.setIcon(Qt::MessageBox::Question)
      msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
      msg.setDefaultButton(Qt::MessageBox::Cancel)
      if msg.exec == Qt::MessageBox::Ok
        @chip.cmd.find_by(cmd_name: @cw.tbl_cmd.currentItem.text).destroy
        feedCmdArray
        feedCmdArray
      end
      rescue Exception => msg
        logger = Logger.new($logFilePath)
        logger.error msg
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured when deleting the command. Consult the log for more details").exec
      end
    else
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Wrong option", "Please choose a correct command and action to continue").exec
    end
    rescue Exception => msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while executing the action. Consult the logs for more details").exec
      logger = Logger.new($logFilePath)
      logger.error msg
  end

  # Combobox action state
  def activCmdAction
    if @cw.tbl_cmd.currentColumn == 0
      @cw.cbx_action.setEnabled(true)
    else
      @cw.cbx_action.setEnabled(false)
      @cw.btn_next.setEnabled(false)
    end
  end

  def openCmdForm(options={})
    if options[:option_1].nil?
      cmdBase = CommandBase.new(0, nil, @chip.chip_id, @busId, self, @api)
    else
      if options[:option_1] == "temp"
        cmdBase = CommandBase.new(1, @cw.tbl_cmd.currentItem.text, @chip.chip_id, @busId, self, @api)
      else
        cmdBase = CommandBase.new(2, @cw.tbl_cmd.currentItem.text, @chip.chip_id, @busId, self, @api)
      end
    end
    cmdBase.setWindowModality(Qt::ApplicationModal)
    cmdBase.show
  end

  def dumpParallel
    saveParallelParam
    if @cw.lie_latency.text.empty?
      Qt::MessageBox.new(Qt::MessageBox::Warning, "Empty field", "Latency field missing").exec
      return
    end
    
    # Dump size
    if sender.objectName == "btn_fullDumpPara"
      if @cw.lie_totalSize.text.empty? || @cw.lie_totalSize.text == "0"
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Empty field", "Total size field must be renseigned and different to 0").exec
        return
      end
      stop = @cw.lie_totalSize.text.to_i - 1
      @cw.lie_start.setText("0")
    else
      if @cw.lie_start.text.empty? || @cw.lie_stop.text.empty?
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Empty field", "Start and stop address must be renseigned").exec
        return
      end
      if @cw.lie_start.text.to_i > @cw.lie_stop.text.to_i
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Wrong value", "Start address must be inforior to the stop address").exec       
        return
      end
      if @cw.lie_start.text.to_i > (@chipParallel.parallel_totalSize - 1) || @cw.lie_stop.text.to_i > (@chipParallel.parallel_totalSize - 1)
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Wrong value", "Start and stop address must be inforior to the chip total size").exec
        return
      end
      stop = @cw.lie_stop.text.to_i
    end
    
    # Select result file
    pathfile = Qt::FileDialog.getSaveFileName(self, tr("Select a file"), "/", tr("Bin file (*.bin)"))
    if !pathfile.nil?
      $file = File.open("#{pathfile}", 'w')
    else
      return
    end
 
    # Upload parallel firmware
    uploadFPGAFirmware(0, @api)
    time = Time.new
    if @chipParallel.parallel_wordSize == 0
      check_SendAndReceivedData(@api.read_Memory_WithoutMultiplexing(@cw.lie_start.text.to_i, stop, true, @cw.lie_latency.text.to_i))
    else
      check_SendAndReceivedData(@api.read_Memory_WithoutMultiplexing(@cw.lie_start.text.to_i, stop, false, @cw.lie_latency.text.to_i))
    end
    
    #Close the file
    if !$file.nil?
      $file.close
    end
    time = Time.new - time

    fileSize = File.size("#{pathfile}")
    # 8 bits test
    if @chipParallel.parallel_wordSize == 0
      if (stop - @cw.lie_start.text.to_i + 1) == fileSize
        Qt::MessageBox.new(Qt::MessageBox::Information, "Information", "Dump finished at #{((fileSize/time)).round(2)}Bytes/s (#{(fileSize)} Bytes in  #{time.round(4)} s)").exec
      else
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Dump error: Size does not match").exec
      end
    else
      if (stop - @cw.lie_start.text.to_i + 1) == (fileSize/2)
        Qt::MessageBox.new(Qt::MessageBox::Information, "Information", "Dump finished at #{((fileSize/time)).round(2)}Bytes/s (#{(fileSize)} Bytes in  #{time.round(4)} s)").exec
      else
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Dump error: File size and dump size does not match").exec
      end   
    end
  
    p "DUMP #{((fileSize/time)).round(2)}Bytes/s (#{(fileSize)}Bytes in  #{time.round(4)} s)"

    rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while dumping the memory. Consult the logs for more details").exec
  end
  
  def dumpSPI
    saveSpiParam
    # Speed
    speed = {
      "25.00" => 3,
      "18.75" => 4,
      "15.00" => 5,
      "12.50" => 6,
      "10.71" => 7,
      "9.38" => 8,
      "7.50" => 10,
      "5.00" => 15,
      "3.95" => 19,
      "3.00" => 25,
      "2.03" => 37,
      "1.00" => 75,
      "0.50" => 150,
      "0.29" => 255
    }
    if @chipSPI.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, "No parameters found", "Please save the parameters before dumping").exec
      return
    end

    if sender.objectName == "btn_fullDumpSPI"
      if @cw.lie_totalSizeSPI.text.empty? || @cw.lie_totalSizeSPI.text == "0"
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Empty field", "Full size field must be renseigned and different to 0").exec
        return
      end
      stop = @chipSPI.spi_totalSize - 1
      @cw.lie_startSPI.setText((0).to_s)
    else
      if @cw.lie_startSPI.text.empty? || @cw.lie_stopSPI.text.empty?
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Empty field", "Start and stop address must be renseigned").exec
        return
      end
      if @cw.lie_startSPI.text.to_i > @cw.lie_stopSPI.text.to_i
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Wrong value", "Start address must be inforior to the stop address").exec
        return
      end
      if @cw.lie_startSPI.text.to_i > (@chipSPI.spi_totalSize - 1) || @cw.lie_stopSPI.text.to_i > (@chipSPI.spi_totalSize - 1)
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Wrong value", "Start and stop address must be inforior to the chip total size").exec
        return
      end
      stop = @cw.lie_stopSPI.text.to_i
    end
    
    # Select result file
    pathfile = Qt::FileDialog.getSaveFileName(self, tr("Select a file"), "/", tr("Bin file (*.bin)"))
    if !pathfile.nil?
      $file = File.open("#{pathfile}", 'w')
    else
      return
    end
    
    # Upload SPI firmware
    uploadFPGAFirmware(1, @api)
    time = Time.new
    @api.spi_Generic_Dump(@chipSPI.spi_mode, speed[@chipSPI.spi_frequency], @cw.lie_cmdReadSPI.text.to_i, @cw.lie_startSPI.text.to_i, stop, @chipSPI.spi_totalSize.to_i)
    
    #Close the file
    if !$file.nil?
      $file.close
    end
    time = Time.new - time

    if sender.objectName == "btn_fullDumpSPI"
      toCompare = @cw.lie_totalSizeSPI.text.to_i
    else
      toCompare = ((stop - @cw.lie_startSPI.text.to_i)+1)
    end
    fileSize = File.size("#{pathfile}")
    # Result test
    if toCompare == fileSize
      Qt::MessageBox.new(Qt::MessageBox::Information, "Information", "Dump finished at #{((fileSize/time)).round(2)}Bytes/s (#{(fileSize)} Bytes in  #{time.round(4)} s)").exec
    else
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Dump error: Size does not match").exec
    end 
  
    p "DUMP #{((fileSize/time)).round(2)}Bytes/s (#{(fileSize)}Bytes in  #{time.round(4)} s)"

    rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while dumping the memory. Consult the logs for more details").exec    
  end

  def dumpI2C
    saveI2CParam

    if @chipI2C.nil?
      Qt::MessageBox.new(Qt::MessageBox::Warning, "No parameters found", "Please save the parameters before dumping").exec
      return
    end

    if sender.objectName == "btn_fullDumpI2C"
      if @cw.lie_totalSizeI2C.text.empty? || @cw.lie_totalSizeI2C.text == "0"
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Empty field", "Full size field must be renseigned and different to 0").exec
        return
      end
      stop = @chipI2C.i2c_totalSize - 1
      @cw.lie_startI2C.setText((0).to_s)
    else
      if @cw.lie_startI2C.text.empty? || @cw.lie_stopI2C.text.empty?
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Empty field", "Start and stop address must be renseigned").exec
        return
      end
      if @cw.lie_startI2C.text.to_i > (@chipI2C.i2c_totalSize - 1) || @cw.lie_stopI2C.text.to_i > (@chipI2C.i2c_totalSize - 1)
        Qt::MessageBox.new(Qt::MessageBox::Warning, "Wrong value", "Start and stop address must be inforior to the chip total size").exec
        return
      end
      stop = @cw.lie_stopI2C.text.to_i
    end
    
    # Select result file
    pathfile = Qt::FileDialog.getSaveFileName(self, tr("Select a file"), "/", tr("Bin file (*.bin)"))
    if !pathfile.nil?
      $file = File.open("#{pathfile}", 'w')
    else
      return
    end
    
    # Upload I2C firmware
    uploadFPGAFirmware(2, @api)
    time = Time.new
    begin
      @api.i2c_Generic_Dump(@cw.cbx_frequencyI2C.currentIndex, @cw.lie_addrW.text.to_i(16), @cw.lie_startI2C.text.to_i, stop, @chipI2C.i2c_totalSize.to_i)
    rescue
      Qt::MessageBox.new(Qt::MessageBox::Warning, "I2C dump error", "The dump returned one or several NACK, the result may be incorrect").exec
    end
    
    #Close the file
    if !$file.nil?
      $file.close
    end
    time = Time.new - time

    if sender.text == "Full Dump..."
      toCompare = @cw.lie_totalSizeI2C.text.to_i
    else
      toCompare = ((stop - @cw.lie_startI2C.text.to_i)+1)
    end
    fileSize = File.size("#{pathfile}")
    # Result test
    if toCompare == fileSize
      Qt::MessageBox.new(Qt::MessageBox::Information, "Information", "Dump finished at #{((fileSize/time)).round(2)}Bytes/s (#{(fileSize)} Bytes in  #{time.round(4)} s)").exec
    else
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Dump error: Size does not match").exec
    end 
  
    p "DUMP #{((fileSize/time)).round(2)}Bytes/s (#{(fileSize)}Bytes in  #{time.round(4)} s)" 
    rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error occured while dumping the I2C memory. Consult the logs for more details").exec      
  end

  def check_SendAndReceivedData(value)
    case value
      when HardsploitAPI::USB_STATE::PACKET_IS_TOO_LARGE
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "PACKET_IS_TOO_LARGE max: #{HardsploitAPI::USB::USB_TRAME_SIZE}").exec
      when HardsploitAPI::USB_STATE::ERROR_SEND
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "ERROR_SEND").exec
      when HardsploitAPI::USB_STATE::BUSY
        Qt::MessageBox.new(Qt::MessageBox::Warning, "BUSY", "Device busy").exec
      else
        return value
    end   
  end 
end