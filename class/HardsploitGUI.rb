#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../HardsploitAPI/HardsploitAPI'
class HardsploitGUI < Qt::MainWindow
  VERSION = "1.0.16"
  slots 'openChipWizard()'
  slots 'verifAction()'
  slots 'activAction()'
  slots 'execAction()'
  slots 'feedChipArray()'
  slots 'updateUcFirmware()'
  slots 'getVersions()'
  slots 'getLogPath()'

  def initialize(api)
    super()
    @mf = Ui_ChipManagement.new
    @mf.setupUi(self)
    @api = api

    #Search icon
    @mf.lbl_loupe.setPixmap(Qt::Pixmap.new(File.expand_path(File.dirname(__FILE__)) + "/../images/search.png"))

    #Disable next & action button
    @mf.btn_next.enabled = false
    @mf.cbx_action.enabled = false

    inputRestrict(@mf.lie_search, 2)

    # Feed table
    feedChipArray

    # Feed manufacturer combobox
    begin
      manufacturer = Manufacturer.all
      manufacturer.each do |m|
        @mf.cbx_manufacturer.addItem(m.manufacturer_name)
      end
    rescue Exception => msg
        logger = Logger.new($logFilePath)
        logger.error msg
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Error while loading Manufacturer list from database").exec
    end

    # Feed type combobox
    begin
      cType = CType.all
      cType.each do |c|
        @mf.cbx_type.addItem(c.cType_name)
      end
    rescue Exception => msg
        logger = Logger.new($logFilePath)
        logger.error msg
        Qt::MessageBox.new(Qt::MessageBox::Critical, "Error", "Error while loading the type list from database").exec
    end

    # Chip table parameters
    @mf.tbl_chip.resizeColumnsToContents()
    @mf.tbl_chip.resizeRowsToContents()
    @mf.tbl_chip.horizontalHeader.stretchLastSection = true

    # Is Hardsploit connected ?
    checkConnection(api)

    if $usbConnected == false then
      @mf.cbx_action.removeItem(@mf.cbx_action.findText("Wiring"))
    end
  end

  # Feed chip array
  def feedChipArray
    ref = @mf.lie_search.text

    if @mf.cbx_manufacturer.currentIndex != 0
      manufacturer = Manufacturer.find_by(manufacturer_name: @mf.cbx_manufacturer.currentText).manufacturer_id
    else
      manufacturer = 0
    end

    if @mf.cbx_type.currentIndex != 0
      type = CType.find_by(cType_name: @mf.cbx_type.currentText).cType_id
    else
      type = 0
    end

    # Empty the array
    @mf.tbl_chip.clearContents

    # Get the elements depending on the filters
    if ref.empty?
      if manufacturer == 0
        if type == 0
          chip = Chip.all
        else
          chip = Chip.where("chip_type = ?", type)
        end
      else
        if type == 0
          chip = Chip.where("chip_manufacturer = ?", manufacturer)
        else
          chip = Chip.where("chip_manufacturer = ? AND chip_type = ?", manufacturer, type)
        end
      end
    else
      if manufacturer == 0
        if type == 0
          chip = Chip.where("chip_reference LIKE ?", "%#{ref}%")
        else
          chip = Chip.where("chip_type = ? AND chip_reference LIKE ?", type, "%#{ref}%")
        end
      else
        if type == 0
          chip = Chip.where("chip_reference LIKE ? AND chip_manufacturer = ?", "%#{ref}%", manufacturer)
        else
          chip = Chip.where("chip_manufacturer = ? AND chip_type = ? AND chip_reference LIKE ?", manufacturer, type, "%#{ref}%")
        end
      end
    end
    # Array formating
    @mf.tbl_chip.setColumnCount(3);
    @mf.tbl_chip.setRowCount(chip.count);

    # Insert elements
    chip.to_enum.with_index(0).each do |c, i|

      item = Qt::TableWidgetItem.new(c.chip_reference)
      item.setFlags(Qt::ItemIsSelectable|Qt::ItemIsEnabled)
      @mf.tbl_chip.setItem(i, 0, item);

      item2 = Qt::TableWidgetItem.new(CType.find(c.chip_type).cType_name)
      item2.setFlags(Qt::ItemIsEnabled)
      @mf.tbl_chip.setItem(i, 1, item2);

      item3 = Qt::TableWidgetItem.new(Manufacturer.find(c.chip_manufacturer).manufacturer_name)
      item3.setFlags(Qt::ItemIsEnabled)
      @mf.tbl_chip.setItem(i, 2, item3);
    end
    rescue Exception => msg
      logger = Logger.new($logFilePath)
      logger.error msg
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Critical error", "Error while filtering the results").exec
  end

  # Next button state
  def verifAction
    case @mf.cbx_action.currentIndex
    when 0
      @mf.btn_next.enabled = false
    when 1..5
      @mf.btn_next.enabled = true
    else
      @mf.btn_next.enabled = false
    end
  end

  # Execute action
  def execAction
    if @mf.tbl_chip.currentItem.nil?
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Missing chip", "Select a chip in the array first").exec
      return
    end
    # Get the chip information
    chip = Chip.find_by(chip_reference: @mf.tbl_chip.currentItem.text)

    case @mf.cbx_action.currentText
    # Wiring
    when "Wiring"
      openWireHelper(chip, @api)
    # Commands
    when "Commands"
      # Check if this chip have effective bus existing
      chipSig = chip.pin.pluck(:pin_signal)
      chipSig.delete(62)
      if !chipSig.empty?
        openCommandWizard(chip)
      else
        Qt::MessageBox.new(Qt::MessageBox::Warning, "No working bus", "This chip have no bus to work with").exec
      end
    # Template
    when "Use as template"
      action = "temp"
      openChipWizard(chip, action)
    # Edit
    when "Edit"
      action = "edit"
      openChipWizard(chip, action)
    # Delete
    when "Delete"
      msg = Qt::MessageBox.new
      msg.setWindowTitle("Delete this chip")
      msg.setText("By deleting this chip, all the commands linked to it will be deleted too. Continue ?")
      msg.setIcon(Qt::MessageBox::Question)
      msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
      msg.setDefaultButton(Qt::MessageBox::Cancel)
      if msg.exec == Qt::MessageBox::Ok
        chip.destroy
        feedChipArray
      end
    else
    end
  end

  # Combobox action state
  def activAction
    if @mf.tbl_chip.currentColumn == 0
      @mf.cbx_action.enabled = true
      if @mf.cbx_action.currentIndex != 0
        @mf.btn_next.enabled = true
      end
    else
      @mf.cbx_action.enabled = false
      @mf.btn_next.enabled = false
    end
  end

  def openChipWizard(chip = "none", action = "new")
    x = ChipWizard.new(self, chip, action)
    x.setWindowModality(Qt::ApplicationModal)
    x.show
  end

  def openWireHelper(chip, api)
    y = WireHelper.new(chip, api)
    y.setWindowModality(Qt::ApplicationModal)
    y.show
  end

  def openCommandWizard(chip)
    cmd = CommandWizard.new(@api, chip)
    cmd.setWindowModality(Qt::ApplicationModal)
    cmd.show
  end

  def updateUcFirmware
    system("dfu-util -D 0483:df11 -a 0 -s 0x08000000 -R --download #{File.expand_path(File.dirname(__FILE__))}'/../Firmware/uC/HARDSPLOIT_FIRMWARE_UC.bin'")
  end

  def getVersions
    if $usbConnected == true
      Qt::MessageBox.new(Qt::MessageBox::Information, "Hardsploit versions", "GUI VERSION : #{VERSION}\nAPI VERSION : #{HardsploitAPI::VERSION::API}\nBOARD : #{@api.getVersionNumber}").exec
    else
      Qt::MessageBox.new(Qt::MessageBox::Information, "Hardsploit versions", "GUI VERSION : #{VERSION}\nAPI VERSION : #{HardsploitAPI::VERSION::API}").exec
    end
  end

  def getLogPath
    Qt::MessageBox.new(Qt::MessageBox::Information, "Log path", "#{$logFilePath}").exec
  end

  def checkConnection(api)
    case api.connect
    when HardsploitAPI::USB_STATE::NOT_CONNECTED
      $usbConnected = false
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Hardsploit not found", "Hardsploit board unconnected, wiring and command execution disabled").exec
    when HardsploitAPI::USB_STATE::UNKNOWN_CONNECTED
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Hardsploit not found", "The device may be BUSY or a another device with the same IdVendor and IdProduct was found").exec
    when HardsploitAPI::USB_STATE::CONNECTED
      $usbConnected = true
      api.startFPGA
      Qt::MessageBox.new(Qt::MessageBox::Information, "Hardsploit found", "Hardsploit board detected\nGUI VERSION : #{VERSION}\nAPI VERSION : #{HardsploitAPI::VERSION::API}\nBOARD : #{api.getVersionNumber}").exec
    else
      Qt::MessageBox.new(Qt::MessageBox::Critical, "Hardsploit unknown state", "You are in the 'else' part of a 'case' that should normally never be triggered. Good luck.").exec
    end
  end
end
