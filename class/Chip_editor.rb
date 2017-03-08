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
    @view = Ui_Chip_editor.new
    centerWindow(self)
    @view.setupUi(self)
    @parent = parent
    @chip = chip
    @action = action

    inputRestrict(@view.lie_pack_name,   2)
    inputRestrict(@view.lie_pack_pin,    0)
    inputRestrict(@view.lie_manu_name,   2)
    inputRestrict(@view.lie_type_name,   2)
    inputRestrict(@view.lie_reference,   2)
    inputRestrict(@view.lie_description, 2)

    # Combobox
    Package.all.each do |p|
      @view.cbx_package.addItem(p.name)
    end
    Manufacturer.all.each do |m|
      @view.cbx_manufacturer.addItem(m.name)
    end
    ChipType.all.each do |c|
      @view.cbx_type.addItem(c.name)
    end

    unless action == 'new'
      package_name      = chip.package.name
      manufacturer_name = chip.manufacturer.name
      chip_type_name    = chip.chip_type.name
      @view.cbx_package.setCurrentIndex(@view.cbx_package.findText(package_name))
      @view.lie_pack_name.setText(package_name)
      @view.lie_pack_name.setEnabled(false)
      @view.cbx_manufacturer.setCurrentIndex(@view.cbx_manufacturer.findText(manufacturer_name))
      @view.lie_manu_name.setText(manufacturer_name)
      @view.lie_manu_name.setEnabled(false)
      @view.cbx_type.setCurrentIndex(@view.cbx_type.findText(chip_type_name))
      @view.lie_type_name.setText(chip_type_name)
      @view.lie_type_name.setEnabled(false)
      @view.rbn_rectangular.setEnabled(false)
      @view.rbn_square.setEnabled(false)
      chip.voltage.zero? ? @view.rbn_5v.setChecked(true) : @view.rbn_3v.setChecked(true)
      chip.package.shape.zero? ? @view.rbn_square.setChecked(true) : @view.rbn_rectangular.setChecked(true)
      @view.lie_reference.setText(@chip.reference) if action == 'edit'
      fill_pin_table('edit')
      @view.lie_description.setText(@chip.description)
    end

    # Array struct
    @view.tbl_pins.horizontalHeader.stretchLastSection = true
    @view.tbl_pins.verticalHeader.setVisible(false)

    # Button text
    if action == 'edit'
      @view.btn_add.setText('Edit')
      Qt::Object.connect(@view.btn_add, SIGNAL('clicked()'), self, SLOT('edit_chip()'))
    else
      @view.btn_add.setText('Add')
      Qt::Object.connect(@view.btn_add, SIGNAL('clicked()'), self, SLOT('add_chip()'))
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def closeEvent(event)
    unless @chip == 'none' || Chip.exists?(@chip.id)
      @parent.instance_variable_get('@view').tw_chip.clear
    end
  end

  def prepare_rq
    # Manufacturer
    @manufacturer = Manufacturer.find_or_create_by(name: @view.lie_manu_name.text)
    return false if check_for_errors(@manufacturer)
    # Package
    @view.rbn_square.checked ? @shape = 0 : @shape = 1
    @package = Package.find_or_create_by(
      name:       @view.lie_pack_name.text,
      pin_number: @view.lie_pack_pin.text,
      shape:      @shape
    )
    return false if check_for_errors(@package)
    # Type
    @chip_type = ChipType.find_or_create_by(name: @view.lie_type_name.text)
    return false if check_for_errors(@chip_type)
    # Voltage
    @view.rbn_3v.checked? ? @voltage = 1 : @voltage = 0
    return true
  end

  def add_chip
    if prepare_rq
      @chip = Chip.create(
        reference:       @view.lie_reference.text,
        description:     @view.lie_description.text,
        voltage:         @voltage,
        manufacturer_id: @manufacturer.id,
        package_id:      @package.id,
        chip_type_id:    @chip_type.id
      )
      unless check_for_errors(@chip)
        add_pins
      end
    end
  end

  def edit_chip
    if prepare_rq
      @chip.update(
        reference:       @view.lie_reference.text,
        description:     @view.lie_description.text,
        voltage:         @voltage,
        manufacturer_id: @manufacturer.id,
        package_id:      @package.id,
        chip_type_id:    @chip_type.id
      )
      unless check_for_errors(@chip)
        @chip.pins.reload.destroy_all
        add_pins
      end
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def add_pins
    for i in 0..(@view.lie_pack_pin.text.to_i) - 1 do
      pin_num = @view.tbl_pins.item(i, 0)
      pin_signal = @view.tbl_pins.cellWidget(i, 2)
      pin_bus = @view.tbl_pins.cellWidget(i, 1)
      if pin_bus.currentIndex == 0
        signal = 1
      else
        signal = Signall.find_by(name: pin_signal.currentText).id
      end
      pin = Pin.create(
        number: pin_num.text.to_i,
        chip_id: @chip.id,
        signal_id: signal
      )
      check_for_errors(pin)
    end
    @parent.feed_chip_array
    close
  end

  # Package combobox
  def select_package
    unless @view.cbx_package.currentIndex.zero?
      selected_package = Package.find_by(name: @view.cbx_package.currentText)
      @view.lie_pack_name.setEnabled(false)
      @view.lie_pack_name.setText(selected_package.name)
      @view.lie_pack_pin.setEnabled(false)
      @view.lie_pack_pin.setText(selected_package.pin_number.to_s)
      @view.rbn_square.setEnabled(false)
      @view.rbn_rectangular.setEnabled(false)
      if selected_package.shape.zero?
        @view.rbn_square.setChecked(true)
      else
        @view.rbn_rectangular.setChecked(true)
      end
      fill_pin_table
    else
      @view.lie_pack_name.setEnabled(true)
      @view.lie_pack_name.clear
      @view.lie_pack_pin.setEnabled(true)
      @view.lie_pack_pin.clear
      @view.rbn_square.setChecked(true)
      @view.rbn_rectangular.setEnabled(true)
      @view.rbn_square.setEnabled(true)
      @view.tbl_pins.clear
      @view.tbl_pins.setRowCount(0)
    end
  end

  # Manufacturer combobox
  def select_manufacturer
    unless @view.cbx_manufacturer.currentIndex.zero?
      @view.lie_manu_name.setEnabled(false)
      @view.lie_manu_name.setText(@view.cbx_manufacturer.currentText)
    else
      @view.lie_manu_name.setEnabled(true)
      @view.lie_manu_name.setText('')
    end
  end

  # Type combobox
  def select_type
    unless @view.cbx_type.currentIndex.zero?
      @view.lie_type_name.setEnabled(false)
      @view.lie_type_name.setText(@view.cbx_type.currentText)
    else
      @view.lie_type_name.setEnabled(true)
      @view.lie_type_name.setText('')
    end
  end

  def fill_pin_table(action = '')
    if @view.lie_pack_pin.text.to_i <= 144 && @view.lie_pack_pin.text.to_i >= 4
      @view.tbl_pins.setRowCount(@view.lie_pack_pin.text.to_i)
      full_bus_list = Bus.all
      @view.lie_pack_pin.text.to_i.times do |i|
        cbx_bus = Qt::ComboBox.new
        row = Qt::Variant.new(i)
        cbx_bus.setProperty('row', row)
        @view.tbl_pins.setCellWidget(i, 1, cbx_bus)
				cbx_signal = Qt::ComboBox.new
        @view.tbl_pins.setCellWidget(i, 2, cbx_signal)
        item =  Qt::TableWidgetItem.new
				item.setFlags(Qt::ItemIsEnabled)
        item.setData(0, Qt::Variant.new(i.next))
        @view.tbl_pins.setItem(i, 0, item)
        cbx_bus.addItem('Bus...')
        full_bus_list.each do |b|
          cbx_bus.addItem(b.name)
        end
        if action == 'edit'
          pin = Pin.find_by(number: i.next, chip_id: @chip.id)
          unless pin.signal_id == 1
            current_bus = pin.signall.buses
            cbx_bus.setCurrentIndex(cbx_bus.findText(current_bus[0].name))
            current_signals = current_bus[0].signalls
            current_signals.each do |s|
              cbx_signal.addItem(s.name)
            end
            cbx_signal.setCurrentIndex(cbx_signal.findText(pin.signall.name))
          end
        end
        Qt::Object.connect(cbx_bus, SIGNAL('currentIndexChanged(int)'), self, SLOT('filter_cbx()'))
      end
    else
      ErrorMsg.new.invalid_pin_nbr
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def delete_cbx_element
    msg = Qt::MessageBox.new
    msg.setWindowTitle('Delete element')
    msg.setText('Chips and commands associated with it will be deleted too.')
    msg.setIcon(Qt::MessageBox::Warning)
    msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
    msg.setDefaultButton(Qt::MessageBox::Cancel)
    if msg.exec == Qt::MessageBox::Ok
      case sender.objectName
      when 'btn_delete_package'
        return false if @view.cbx_package.currentIndex == 0
        Package.find_by(name: @view.cbx_package.currentText).destroy
        @view.cbx_package.removeItem(@view.cbx_package.currentIndex)
        @view.cbx_package.setCurrentIndex(0)
      when 'btn_delete_manufacturer'
        return false if @view.cbx_manufacturer.currentIndex == 0
        Manufacturer.find_by(name: @view.cbx_manufacturer.currentText).destroy
        @view.cbx_manufacturer.removeItem(@view.cbx_manufacturer.currentIndex)
        @view.cbx_manufacturer.setCurrentIndex(0)
      when 'btn_delete_type'
        return false if @view.cbx_type.currentIndex == 0
        ChipType.find_by(name: @view.cbx_type.currentText).destroy
        @view.cbx_type.removeItem(@view.cbx_type.currentIndex)
        @view.cbx_type.setCurrentIndex(0)
      end
      @parent.feed_chip_array
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  # Filter signals by bus
  def filter_cbx
    bus_item_row = sender.property('row').to_i
    busItem = @view.tbl_pins.cellWidget(bus_item_row, 1)
    associated_signal_item = @view.tbl_pins.cellWidget(bus_item_row, 2)
    associated_signal_item.clear
    if busItem.currentText != 'Bus...'
      bus = Bus.find_by(name: busItem.currentText).id
      filtered_signal_list = Use.where(bus_id: bus)
      filtered_signal_list.each do |s|
        signal_name = Signall.find_by(id: s.signal_id).name
        associated_signal_item.addItem(signal_name)
      end
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end
end
