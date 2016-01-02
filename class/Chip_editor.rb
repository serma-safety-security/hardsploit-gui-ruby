#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../gui/gui_chip_editor'
class Chip_editor < Qt::Widget
  slots 'select_package()'
  slots 'edit_chip()'
  slots 'add_chip()'
  slots 'select_manufacturer()'
  slots 'select_type()'
  slots 'fill_pin_table()'
  slots 'filter_cbx()'
  slots 'delete_cbx_element()'

  def initialize(parent, chip, action)
    super()
    @gui_chip_editor = Ui_Chip_editor.new
    centerWindow(self)
    @gui_chip_editor.setupUi(self)
    @parent = parent
    @chip = chip

    inputRestrict(@gui_chip_editor.lie_pack_name, 2)
    inputRestrict(@gui_chip_editor.lie_pack_pin, 0)
    inputRestrict(@gui_chip_editor.lie_manu_name, 2)
    inputRestrict(@gui_chip_editor.lie_type_name, 2)
    inputRestrict(@gui_chip_editor.lie_reference, 2)
    inputRestrict(@gui_chip_editor.lie_description, 2)

    # Combobox
    # Package
    package = Package.all
    package.each do |p|
      @gui_chip_editor.cbx_package.addItem(p.package_name)
    end
    # Manufacturer
    manufacturer = Manufacturer.all
    manufacturer.each do |p|
      @gui_chip_editor.cbx_manufacturer.addItem(p.manufacturer_name)
    end
    # Type
    c_type = CType.all
    c_type.each do |p|
      @gui_chip_editor.cbx_type.addItem(p.cType_name)
    end

		#Bus
		@bus_list = Bus.all

    if action != 'new'
      package_name = package.find_by(package_id: @chip.chip_package).package_name
      manufacturer_name = manufacturer.find_by(manufacturer_id: @chip.chip_manufacturer).manufacturer_name
      c_type_name = c_type.find_by(cType_id: @chip.chip_type).cType_name

      @gui_chip_editor.cbx_package.setCurrentIndex(@gui_chip_editor.cbx_package.findText(package_name))
      @gui_chip_editor.lie_pack_name.setText(package_name)
      @gui_chip_editor.lie_pack_name.setEnabled(false)
      @gui_chip_editor.cbx_manufacturer.setCurrentIndex(@gui_chip_editor.cbx_manufacturer.findText(manufacturer_name))
      @gui_chip_editor.lie_manu_name.setText(manufacturer_name)
      @gui_chip_editor.lie_manu_name.setEnabled(false)
      @gui_chip_editor.cbx_type.setCurrentIndex(@gui_chip_editor.cbx_type.findText(c_type_name))
      @gui_chip_editor.lie_type_name.setText(c_type_name)
      @gui_chip_editor.lie_type_name.setEnabled(false)
      @gui_chip_editor.rbn_rectangular.setEnabled(false)
      @gui_chip_editor.rbn_square.setEnabled(false)
      if @chip.chip_voltage.zero?
        @gui_chip_editor.rbn_5v.setChecked(true)
      else
        @gui_chip_editor.rbn_3v.setChecked(true)
      end
      package_shape = Package.find_by(package_id: @chip.chip_package).package_shape
      if package_shape.zero?
        @gui_chip_editor.rbn_square.setChecked(true)
      else
        @gui_chip_editor.rbn_rectangular.setChecked(true)
      end

      # Line Edit
      # Name
      if action == 'edit'
        @gui_chip_editor.lie_reference.setText(@chip.chip_reference)
      end
      # Load pin array
      fill_pin_table('edit')
      # Misc tab
      @gui_chip_editor.lie_description.setText(@chip.chip_detail)
    end

    # Array struct
    @gui_chip_editor.tbl_pins.horizontalHeader.stretchLastSection = true
    @gui_chip_editor.tbl_pins.verticalHeader.setVisible(false)

    # Button text
    if action == 'edit'
      @gui_chip_editor.btn_add.setText('Edit')
      Qt::Object.connect(@gui_chip_editor.btn_add, SIGNAL('clicked()'), self, SLOT('edit_chip()'))
    else
      @gui_chip_editor.btn_add.setText('Add')
      Qt::Object.connect(@gui_chip_editor.btn_add, SIGNAL('clicked()'), self, SLOT('add_chip()'))
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
    if @gui_chip_editor.lie_pack_name.text.empty?
      error = 'Package reference missing'
    # Pin number
    elsif @gui_chip_editor.lie_pack_pin.text.empty?
      error = 'Package pin number missing'
    elsif @gui_chip_editor.tbl_pins.rowCount != @gui_chip_editor.lie_pack_pin.text.to_i
      error = 'The pin number and the line count in the pin array does not match'
    # Reference
    elsif @gui_chip_editor.lie_reference.text.empty?
      error = 'Chip reference missing'
    # Manufacturer
    elsif @gui_chip_editor.lie_manu_name.text.empty?
      error = 'Chip manufacturer missing'
    # Type
    elsif @gui_chip_editor.lie_type_name.text.empty?
      error = 'Chip type missing'
    end
    unless error.empty?
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Invalid form', error).exec
      return false
		else
			return true
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
        if @gui_chip_editor.cbx_package.currentIndex == 0
          Qt::MessageBox.new(Qt::MessageBox::Warning, 'Warning', 'Please select a valid element to delete').exec
        else
          package = Package.find_by(package_name: @gui_chip_editor.cbx_package.currentText)
          chips = Chip.where(chip_package: package)
          chips.each do |chip|
            chip.cmd.destroy_all
          end
          chips.destroy_all
          package.destroy
          @gui_chip_editor.cbx_package.removeItem(@gui_chip_editor.cbx_package.currentIndex)
          @gui_chip_editor.cbx_package.setCurrentIndex(0)
        end
      when 'btn_removeManufacturer'
        if @gui_chip_editor.cbx_manufacturer.currentIndex == 0
          Qt::MessageBox.new(Qt::MessageBox::Warning, 'Warning', 'Please select a valid element to delete').exec
        else
          manufacturer = Manufacturer.find_by(manufacturer_name: @gui_chip_editor.cbx_manufacturer.currentText)
          chips = Chip.where(chip_manufacturer: manufacturer)
          chips.each do |chip|
            chip.cmd.destroy_all
          end
          chips.destroy_all
          manufacturer.destroy
          @gui_chip_editor.cbx_manufacturer.removeItem(@gui_chip_editor.cbx_manufacturer.currentIndex)
          @gui_chip_editor.cbx_manufacturer.setCurrentIndex(0)
        end
      when 'btn_removeType'
        if @gui_chip_editor.cbx_type.currentIndex == 0
          Qt::MessageBox.new(Qt::MessageBox::Warning, 'Warning', 'Please select a valid element to delete').exec
        else
          type = CType.find_by(cType_name: @gui_chip_editor.cbx_type.currentText)
          chips = Chip.where(chip_type: type)
          chips.each do |chip|
            chip.cmd.destroy_all
          end
          chips.destroy_all
          type.destroy
          @gui_chip_editor.cbx_type.removeItem(@gui_chip_editor.cbx_type.currentIndex)
          @gui_chip_editor.cbx_type.setCurrentIndex(0)
        end
      end
      @parent.feed_chip_array
    end
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while deleting the element. Consult the log for more details').exec
  end

  # Add chip in database
  def add_chip
    unless control_form_val
      return
    end
    if Chip.exists?(chip_reference: @gui_chip_editor.lie_reference.text)
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Invalid form', 'This chip reference already exists').exec
      return
    end
    chip = Chip.new
    # Reference
    chip.chip_reference = @gui_chip_editor.lie_reference.text
    # Custom
    chip.chip_custom = 1
    # Manufacturer
    manu = Manufacturer.find_or_create_by(manufacturer_name: @gui_chip_editor.lie_manu_name.text)
    chip.chip_manufacturer = manu.manufacturer_id
    # Package
    if @gui_chip_editor.cbx_package.currentIndex != 0
      chip.chip_package = Package.find_by(package_name: @gui_chip_editor.cbx_package.currentText).package_id
    else
      if @gui_chip_editor.rbn_square.checked
        shape = 0
      else
        shape = 1
      end
      Package.create(
        package_name:       @gui_chip_editor.lie_pack_name.text,
        package_pinNumber:  @gui_chip_editor.lie_pack_pin.text,
        package_shape:      shape
      )
      chip.chip_package = Package.ids.last
    end
    # Type
    ctype = CType.find_or_create_by(cType_name: @gui_chip_editor.lie_type_name.text)
    chip.chip_type = ctype.cType_id
    # Voltage
    if @gui_chip_editor.rbn_3v.checked
      voltage = 1
    else
      voltage = 0
    end
    chip.chip_voltage = voltage
    # Divers
    chip.chip_detail = @gui_chip_editor.lie_description.text
    chip.save
    # Ajout des PINs
    for i in 0..(@gui_chip_editor.lie_pack_pin.text.to_i) - 1 do
      pin_num = @gui_chip_editor.tbl_pins.item(i, 0)
      pin_signal = @gui_chip_editor.tbl_pins.cellWidget(i, 2)
      pin_bus = @gui_chip_editor.tbl_pins.cellWidget(i, 1)
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
    @parent.feed_chip_array
    close
  end

  # Edit the chip
  def edit_chip
    unless control_form_val
      return 0
    end
    # Reference
    if @chip.chip_reference != @gui_chip_editor.lie_reference.text
      @chip.update(chip_reference: @gui_chip_editor.lie_reference.text)
    end
    # Manufacturer
    manu = Manufacturer.find_or_create_by(manufacturer_name: @gui_chip_editor.lie_manu_name.text)
    if @chip.chip_manufacturer != manu.manufacturer_id
      @chip.update(chip_manufacturer: manu.manufacturer_id)
    end
    # Package
    if @gui_chip_editor.rbn_square.isChecked
      shape = 0
    else
      shape = 1
    end
    package = Package.find_or_create_by(
      package_name:       @gui_chip_editor.lie_pack_name.text,
      package_pinNumber:  @gui_chip_editor.lie_pack_pin.text,
      package_shape:      shape
    )
    if @chip.chip_package != package.package_id
      @chip.update(chip_package: package.package_id)
    end
    # Type
    ctype = CType.find_or_create_by(cType_name: @gui_chip_editor.lie_type_name.text)
    if @chip.chip_type != ctype.cType_id
      @chip.update(chip_type: ctype.cType_id)
    end
    # Voltage
    if @gui_chip_editor.rbn_3v.checked
      voltage = 1
    else
      voltage = 0
    end
    if @chip.chip_voltage != voltage
      @chip.update(chip_voltage: voltage)
    end
    # Divers
    if @chip.chip_detail != @gui_chip_editor.lie_description.text
      @chip.update(chip_detail: @gui_chip_editor.lie_description.text)
    end

    # Edit PINs (Destroy all then recreate)
    @chip.pin.destroy_all
    for i in 0..(@gui_chip_editor.lie_pack_pin.text.to_i) - 1 do
      pin_num = @gui_chip_editor.tbl_pins.item(i, 0)
      pin_signal = @gui_chip_editor.tbl_pins.cellWidget(i, 2)
      pin_bus = @gui_chip_editor.tbl_pins.cellWidget(i, 1)
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
    @parent.feed_chip_array
    close
  rescue Exception => msg
    logger = Logger.new($logFilePath)
    logger.error msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while editing the chip. Consult the log for more details').exec
  end

  # Package combobox
  def select_package
    if @gui_chip_editor.cbx_package.currentIndex != 0
      selectedPackage = Package.find_by package_name: @gui_chip_editor.cbx_package.currentText
      @gui_chip_editor.lie_pack_name.setEnabled(false)
      @gui_chip_editor.lie_pack_name.setText(selectedPackage.package_name)
      @gui_chip_editor.lie_pack_pin.setEnabled(false)
      @gui_chip_editor.lie_pack_pin.setText(selectedPackage.package_pinNumber.to_s)
      @gui_chip_editor.rbn_square.setEnabled(false)
      @gui_chip_editor.rbn_rectangular.setEnabled(false)
      if selectedPackage.package_shape == 0
        @gui_chip_editor.rbn_square.setChecked(true)
      else
        @gui_chip_editor.rbn_rectangular.setChecked(true)
      end
      fill_pin_table
    else
      @gui_chip_editor.lie_pack_name.setEnabled(true)
      @gui_chip_editor.lie_pack_name.clear
      @gui_chip_editor.lie_pack_pin.setEnabled(true)
      @gui_chip_editor.lie_pack_pin.clear
      @gui_chip_editor.rbn_square.setChecked(true)
      @gui_chip_editor.rbn_rectangular.setEnabled(true)
      @gui_chip_editor.rbn_square.setEnabled(true)
      @gui_chip_editor.tbl_pins.clear
      @gui_chip_editor.tbl_pins.setRowCount(0)
    end
  end

  # Manufacturer combobox
  def select_manufacturer
    if @gui_chip_editor.cbx_manufacturer.currentIndex != 0
      @gui_chip_editor.lie_manu_name.setEnabled(false)
      @gui_chip_editor.lie_manu_name.setText(@gui_chip_editor.cbx_manufacturer.currentText)
    else
      @gui_chip_editor.lie_manu_name.setEnabled(true)
      @gui_chip_editor.lie_manu_name.setText('')
    end
  end

  # Type combobox
  def select_type
    if @gui_chip_editor.cbx_type.currentIndex != 0
      @gui_chip_editor.lie_type_name.setEnabled(false)
      @gui_chip_editor.lie_type_name.setText(@gui_chip_editor.cbx_type.currentText)
    else
      @gui_chip_editor.lie_type_name.setEnabled(true)
      @gui_chip_editor.lie_type_name.setText('')
    end
  end

  def fill_pin_table(action = '')
    if @gui_chip_editor.lie_pack_pin.text.to_i <= 144 && @gui_chip_editor.lie_pack_pin.text.to_i > 4
      @gui_chip_editor.tbl_pins.setRowCount(@gui_chip_editor.lie_pack_pin.text.to_i)
      @gui_chip_editor.lie_pack_pin.text.to_i.times do |i|
        cbx_bus = Qt::ComboBox.new
        row = Qt::Variant.new(i)
        cbx_bus.setProperty('row', row)
        @gui_chip_editor.tbl_pins.setCellWidget(i, 1, cbx_bus)
				cbx_signal = Qt::ComboBox.new
        @gui_chip_editor.tbl_pins.setCellWidget(i, 2, cbx_signal)
        item =  Qt::TableWidgetItem.new
				item.setFlags(Qt::ItemIsEnabled)
        item.setData(0, Qt::Variant.new(i.next))
        @gui_chip_editor.tbl_pins.setItem(i, 0, item)
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
    busItem = @gui_chip_editor.tbl_pins.cellWidget(bus_item_row, 1)
    associated_signal_item = @gui_chip_editor.tbl_pins.cellWidget(bus_item_row, 2)
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
