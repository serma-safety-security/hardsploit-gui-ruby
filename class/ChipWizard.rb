#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

class ChipWizard < Qt::Widget
  slots 'select_package()'
  slots 'editChip()'
  slots 'addChip()'
  slots 'select_manufacturer()'
  slots 'select_type()'
  slots 'fill_pin_table()'
  slots 'filter_cbx()'
  slots 'delete_cbx_element()'
  slots 'check_txe_content()'

  def initialize(parent, chip, action)
    super()
    @cf = Ui_ChipWizard.new
    centerWindow(self)
    @cf.setupUi(self)
    @parent = parent
    @chip = chip

    inputRestrict(@cf.lie_packageName, 2)
    inputRestrict(@cf.lie_pinNumber, 0)
    inputRestrict(@cf.lie_manufacturerName, 2)
    inputRestrict(@cf.lie_typeOther, 2)
    inputRestrict(@cf.lie_ref, 2)

    # Combobox

    # Package
    package = Package.all
    package.each do |p|
      @cf.cbx_package.addItem(p.package_name)
    end

    # Manufacturer
    manufacturer = Manufacturer.all
    manufacturer.each do |p|
      @cf.cbx_manufacturer.addItem(p.manufacturer_name)
    end

    # Type
    c_type = CType.all
    c_type.each do |p|
      @cf.cbx_type.addItem(p.cType_name)
    end
		
		#Bus
		@bus_list = Bus.all

    if action != 'new'
      package_name = package.find_by(package_id: @chip.chip_package).package_name
      manufacturer_name = manufacturer.find_by(manufacturer_id: @chip.chip_manufacturer).manufacturer_name
      c_type_name = c_type.find_by(cType_id: @chip.chip_type).cType_name

      @cf.cbx_package.setCurrentIndex(@cf.cbx_package.findText(package_name))
      @cf.lie_packageName.setText(package_name)
      @cf.lie_packageName.setEnabled(false)
      @cf.cbx_manufacturer.setCurrentIndex(@cf.cbx_manufacturer.findText(manufacturer_name))
      @cf.lie_manufacturerName.setText(manufacturer_name)
      @cf.lie_manufacturerName.setEnabled(false)
      @cf.cbx_type.setCurrentIndex(@cf.cbx_type.findText(c_type_name))
      @cf.lie_typeOther.setText(c_type_name)
      @cf.lie_typeOther.setEnabled(false)
			
      @cf.rbn_rectangular.setEnabled(false)
      @cf.rbn_square.setEnabled(false)
      if @chip.chip_voltage == 1
        @cf.rbn_3v.setChecked(true)
      else
        @cf.rbn_5v.setChecked(true)
      end
      package_shape = Package.find_by(package_id: @chip.chip_package).package_shape
      if package_shape == 0
        @cf.rbn_square.setChecked(true)
      else
        @cf.rbn_rectangular.setChecked(true)
      end

      # Line Edit
      # Name
      if action == 'edit'
        @cf.lie_ref.setText(@chip.chip_reference)
      end
      # Load pin array
      fill_pin_table('edit')
      # Misc tab
      @cf.txe_info.setPlainText(@chip.chip_detail)
    end

    # Array struct
    @cf.tbl_pins.horizontalHeader.stretchLastSection = true
    @cf.tbl_pins.verticalHeader.setVisible(false)

    @cf.tabWidget.setCurrentIndex(0)
    # Button text
    if action == 'edit'
      @cf.btn_add.setText('Edit')
      Qt::Object.connect(@cf.btn_add, SIGNAL('clicked()'), self, SLOT('editChip()'))
    else
      @cf.btn_add.setText('Add')
      Qt::Object.connect(@cf.btn_add, SIGNAL('clicked()'), self, SLOT('addChip()'))
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured when opening the chip wizard interface. Consult the log for more details').exec
  end

  # Control the form values
  def control_form_val
    error = ''
    # Package
    if @cf.lie_packageName.text.empty?
      error = 'Package reference missing'
    # Pin number
    elsif @cf.lie_pinNumber.text.empty?
      error = 'Package pin number missing'
    elsif @cf.tbl_pins.rowCount != @cf.lie_pinNumber.text.to_i
      error = 'The pin number and the line count in the pin array does not match'
    # Reference
    elsif @cf.lie_ref.text.empty?
      error = 'Chip reference missing'
    # Manufacturer
    elsif @cf.lie_manufacturerName.text.empty?
      error = 'Chip manufacturer missing'
    # Type
    elsif @cf.lie_typeOther.text.empty?
      error = 'Chip type missing'
    end
    unless error.empty?
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Invalid form', error).exec
      return false
		else
			return true
    end
  end

  def check_txe_content
    reg = Qt::RegExp.new('^[a-zA-Z0-9_@-]+( [a-zA-Z0-9_@-]+)*$')
    reg_val = Qt::RegExpValidator.new(reg, self)
    if reg_val.validate(sender.toPlainText, sender.toPlainText.length) == 0
      sender.setPlainText(sender.toPlainText.chop)
      sender.moveCursor(Qt::TextCursor::End, Qt::TextCursor::MoveAnchor)
    end
  end

  def delete_cbx_element
    msg = Qt::MessageBox.new
    msg.setWindowTitle('Delete element')
    msg.setText('By deleting this element, all the chips and commands linked to him will be deleted too. Continue ?')
    msg.setIcon(Qt::MessageBox::Warning)
    msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
    msg.setDefaultButton(Qt::MessageBox::Cancel)
    if msg.exec == Qt::MessageBox::Ok
      case sender.objectName
      when 'btn_removePackage'
        if @cf.cbx_package.currentIndex == 0
          Qt::MessageBox.new(Qt::MessageBox::Warning, 'Warning', 'Please select a valid element to delete').exec
        else
          package = Package.find_by(package_name: @cf.cbx_package.currentText)
          chips = Chip.where(chip_package: package)
          chips.each do |chip|
            chip.cmd.destroy_all
          end
          chips.destroy_all
          package.destroy
          @cf.cbx_package.removeItem(@cf.cbx_package.currentIndex)
          @cf.cbx_package.setCurrentIndex(0)
        end
      when 'btn_removeManufacturer'
        if @cf.cbx_manufacturer.currentIndex == 0
          Qt::MessageBox.new(Qt::MessageBox::Warning, 'Warning', 'Please select a valid element to delete').exec
        else
          manufacturer = Manufacturer.find_by(manufacturer_name: @cf.cbx_manufacturer.currentText)
          chips = Chip.where(chip_manufacturer: manufacturer)
          chips.each do |chip|
            chip.cmd.destroy_all
          end
          chips.destroy_all
          manufacturer.destroy
          @cf.cbx_manufacturer.removeItem(@cf.cbx_manufacturer.currentIndex)
          @cf.cbx_manufacturer.setCurrentIndex(0)
        end
      when 'btn_removeType'
        if @cf.cbx_type.currentIndex == 0
          Qt::MessageBox.new(Qt::MessageBox::Warning, 'Warning', 'Please select a valid element to delete').exec
        else
          type = CType.find_by(cType_name: @cf.cbx_type.currentText)
          chips = Chip.where(chip_type: type)
          chips.each do |chip|
            chip.cmd.destroy_all
          end
          chips.destroy_all
          type.destroy
          @cf.cbx_type.removeItem(@cf.cbx_type.currentIndex)
          @cf.cbx_type.setCurrentIndex(0)
        end
      end
      @parent.feedChipArray
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while deleting the element. Consult the log for more details').exec
  end

  # Add chip in database
  def addChip
    unless control_form_val
      return
    end
    if Chip.exists?(chip_reference: @cf.lie_ref.text)
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Invalid form', 'This chip reference already exists').exec
      return
    end
    chip = Chip.new
    # Reference
    chip.chip_reference = @cf.lie_ref.text
    # Custom
    chip.chip_custom = 1
    # Manufacturer
    manu = Manufacturer.find_or_create_by(manufacturer_name: @cf.lie_manufacturerName.text)
    chip.chip_manufacturer = manu.manufacturer_id
    # Package
    if @cf.cbx_package.currentIndex != 0
      chip.chip_package = Package.find_by(package_name: @cf.cbx_package.currentText).package_id
    else
      if @cf.rbn_square.checked
        shape = 0
      else
        shape = 1
      end
      Package.create(
        package_name:       @cf.lie_packageName.text,
        package_pinNumber:  @cf.lie_pinNumber.text,
        package_shape:      shape
      )
      chip.chip_package = Package.ids.last
    end
    # Type
    ctype = CType.find_or_create_by(cType_name: @cf.lie_typeOther.text)
    chip.chip_type = ctype.cType_id
    # Voltage
    if @cf.rbn_3v.checked
      voltage = 1
    else
      voltage = 0
    end
    chip.chip_voltage = voltage

    # Divers
    chip.chip_detail = @cf.txe_info.plainText

    chip.save

    # Ajout des PINs
    for i in 0..(@cf.lie_pinNumber.text.to_i) - 1 do
      pin_num = @cf.tbl_pins.item(i, 0)
      pin_signal = @cf.tbl_pins.cellWidget(i, 2)
      pin_bus = @cf.tbl_pins.cellWidget(i, 1)
      if pin_bus.currentIndex == 0
        signal = 62
      else
        signal = Signall.find_by(signal_name: pin_signal.currentText).signal_id
      end
      Pin.create(
        pin_number: pin_num.text.to_i,
        pin_chip: chip.chip_id,
        pin_signal: signal
      )
    end
    # Reloading array
    @parent.feedChipArray
    close
  end

  # Edit the chip
  def editChip
    unless control_form_val
      return
    end
    # Reference
    if @chip.chip_reference != @cf.lie_ref.text
      @chip.update(chip_reference: @cf.lie_ref.text)
    end
    # Manufacturer
    manu = Manufacturer.find_or_create_by(manufacturer_name: @cf.lie_manufacturerName.text)
    if @chip.chip_manufacturer != manu.manufacturer_id
      @chip.update(chip_manufacturer: manu.manufacturer_id)
    end
    # Package
    if @cf.rbn_square.isChecked
      shape = 0
    else
      shape = 1
    end
    package = Package.find_or_create_by(
      package_name:       @cf.lie_packageName.text,
      package_pinNumber:  @cf.lie_pinNumber.text,
      package_shape:      shape
    )
    if @chip.chip_package != package.package_id
      @chip.update(chip_package: package.package_id)
    end
    # Type
    ctype = CType.find_or_create_by(cType_name: @cf.lie_typeOther.text)
    if @chip.chip_type != ctype.cType_id
      @chip.update(chip_type: ctype.cType_id)
    end
    # Voltage
    if @cf.rbn_3v.checked
      voltage = 1
    else
      voltage = 0
    end
    if @chip.chip_voltage != voltage
      @chip.update(chip_voltage: voltage)
    end
    # Divers
    if @chip.chip_detail != @cf.txe_info.plainText
      @chip.update(chip_detail: @cf.txe_info.plainText)
    end

    # Edit PINs (Destroy all then recreate)
    @chip.pin.destroy_all
    for i in 0..(@cf.lie_pinNumber.text.to_i) - 1 do
      pin_num = @cf.tbl_pins.item(i, 0)
      pin_signal = @cf.tbl_pins.cellWidget(i, 2)
      pin_bus = @cf.tbl_pins.cellWidget(i, 1)
      if pin_bus.currentIndex == 0
        signal = 62
      else
        signal = Signall.find_by(signal_name: pin_signal.currentText).signal_id
      end
      Pin.create(
        pin_number: pin_num.text.to_i,
        pin_chip: @chip.chip_id,
        pin_signal: signal
      )
    end
    # Reloading array
    @parent.feedChipArray
    close
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while editing the chip. Consult the log for more details').exec
  end

  # Package combobox
  def select_package
    if @cf.cbx_package.currentIndex != 0
      selectedPackage = Package.find_by package_name: @cf.cbx_package.currentText
      @cf.lie_packageName.setEnabled(false)
      @cf.lie_packageName.setText(selectedPackage.package_name)
      @cf.lie_pinNumber.setEnabled(false)
      @cf.lie_pinNumber.setText(selectedPackage.package_pinNumber.to_s)
      @cf.rbn_square.setEnabled(false)
      @cf.rbn_rectangular.setEnabled(false)
      if selectedPackage.package_shape == 0
        @cf.rbn_square.setChecked(true)
      else
        @cf.rbn_rectangular.setChecked(true)
      end
      fill_pin_table
    else
      @cf.lie_packageName.setEnabled(true)
      @cf.lie_packageName.clear
      @cf.lie_pinNumber.setEnabled(true)
      @cf.lie_pinNumber.clear
      @cf.rbn_square.setChecked(true)
      @cf.rbn_rectangular.setEnabled(true)
      @cf.rbn_square.setEnabled(true)
      @cf.tbl_pins.clear
      @cf.tbl_pins.setRowCount(0)
    end
  end

  # Manufacturer combobox
  def select_manufacturer
    if @cf.cbx_manufacturer.currentIndex != 0
      @cf.lie_manufacturerName.setEnabled(false)
      @cf.lie_manufacturerName.setText(@cf.cbx_manufacturer.currentText)
    else
      @cf.lie_manufacturerName.setEnabled(true)
      @cf.lie_manufacturerName.setText('')
    end
  end

  # Type combobox
  def select_type
    if @cf.cbx_type.currentIndex != 0
      @cf.lie_typeOther.setEnabled(false)
      @cf.lie_typeOther.setText(@cf.cbx_type.currentText)
    else
      @cf.lie_typeOther.setEnabled(true)
      @cf.lie_typeOther.setText('')
    end
  end

  def fill_pin_table(action = '')
    if @cf.lie_pinNumber.text.to_i <= 144 && @cf.lie_pinNumber.text.to_i > 4
      @cf.tbl_pins.setRowCount(@cf.lie_pinNumber.text.to_i)
      @cf.lie_pinNumber.text.to_i.times do |i|
        cbx_bus = Qt::ComboBox.new
        row = Qt::Variant.new(i)
        cbx_bus.setProperty('row', row)
        @cf.tbl_pins.setCellWidget(i, 1, cbx_bus)
				cbx_signal = Qt::ComboBox.new
        @cf.tbl_pins.setCellWidget(i, 2, cbx_signal)
        item =  Qt::TableWidgetItem.new
				item.setFlags(Qt::ItemIsEnabled)
        item.setData(0, Qt::Variant.new(i.next))
        @cf.tbl_pins.setItem(i, 0, item)
        cbx_bus.addItem('Bus...')
        @bus_list.each do |b|
          cbx_bus.addItem(b.bus_name)
        end
        if action == 'edit'
          pin = Pin.find_by(pin_number: i.next, pin_chip: @chip.chip_id)
          cbx_bus.setCurrentIndex(cbx_bus.findText(pin.signall.bus.pluck(:bus_name)[0]))
          signal_list = Use.where(bus_id: pin.signall.bus.pluck(:bus_id)[0]).pluck(:signal_id)
          signal_list.each do |s|
            cbx_signal.addItem(Signall.find_by(signal_id: s).signal_name)
          end
          cbx_signal.setCurrentIndex(cbx_signal.findText(pin.signall.signal_name))
        end
        Qt::Object.connect(cbx_bus, SIGNAL('currentIndexChanged(int)'), self, SLOT('filter_cbx()'))
      end
    else
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'Invalid pin number value', 'Pin number needs to be between 4 and 144').exec
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while adding pins to the table. Consult the log for more details').exec
  end

  # Filter signals by bus
  def filter_cbx
    bus_item_row = sender.property('row').to_i
    busItem = @cf.tbl_pins.cellWidget(bus_item_row, 1)
    associated_signal_item = @cf.tbl_pins.cellWidget(bus_item_row, 2)
    associated_signal_item.clear
    if busItem.currentText != 'Bus...'
      bus = Bus.find_by(bus_name: busItem.currentText).bus_id
      filtered_signal_list = Use.where(bus_id: bus)
      filtered_signal_list.each do |s|
        signalName = Signall.find_by(signal_id: s.signal_id).signal_name
        associated_signal_item.addItem(signalName)
      end
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while filtering the signals. Consult the log for more details').exec
  end
end