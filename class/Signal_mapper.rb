#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../gui/gui_signal_mapper'
class Signal_mapper < Qt::Widget
  slots 'check_mapping_value(QTableWidgetItem*)'
  slots 'update_map_table(QString)'
  slots 'save_signal_mapping()'

  def initialize
    super()
    @view = Ui_Signal_mapper.new
    centerWindow(self)
    @view.setupUi(self)
    init_bus_list
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def init_bus_list
    Bus.all.each do |b|
      @view.cbx_bus.addItem(b.name) unless b.name == "NA"
    end
  end

  def check_mapping_value(item)
    if item.column == 1
      item.setText(item.text.upcase)
      reg = Qt::RegExp.new("^[A-H]{1}[0-7]${1}")
      reg_val = Qt::RegExpValidator.new(reg, self)
      if reg_val.validate(item.text, item.text.length) == Qt::Validator::Invalid || item.text.nil?
        item.setText('')
        Qt::MessageBox.new(
          Qt::MessageBox::Warning,
          'Wrong data',
          'Only values from A0 to H7 are accepted in this cell'
        ).exec
      end
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def update_map_table(bus_name)
    unless bus_name == 'Bus...'
      @view.map_table.clearContents
      @view.map_table.setRowCount(0)
      Bus.find_by(name: bus_name).signalls.each do |s|
        @view.map_table.insertRow(@view.map_table.rowCount)
        signal_cell = Qt::TableWidgetItem.new(s.name)
        signal_cell.setFlags(Qt::ItemIsEnabled)
        @view.map_table.setItem(@view.map_table.rowCount - 1, 0, signal_cell)
        pin_cell = Qt::TableWidgetItem.new(s.pin)
        @view.map_table.setItem(@view.map_table.rowCount - 1, 1, pin_cell)
      end
      resize_to_content
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def save_signal_mapping
    return 0 unless are_values_ok?
    @view.map_table.rowCount.times do |i|
      current_signal = Signall.find_by(name: @view.map_table.item(i, 0).text)
      if current_signal.name != @view.map_table.item(i, 1).text
        current_signal.update(pin: @view.map_table.item(i, 1).text)
      end
    end
    Qt::MessageBox.new(
      Qt::MessageBox::Information,
      'Save mapping',
      'Pin mapping saved successfuly'
    ).exec
    close
  end

  def are_values_ok?
    pins = []
    @view.map_table.rowCount.times do |i|
      pins.push(@view.map_table.item(i, 1).text)
    end
    return true if check_empty(pins) && check_duplicate(pins)
  end

  def check_empty(pins)
    return true unless pins.include?('')
    @view.map_table.setCurrentItem(@view.map_table.item(pins.index(''), 1))
		Qt::MessageBox.new(
      Qt::MessageBox::Warning,
      'Empty pin',
      'Empty pin value detected'
    ).exec
    return false
  end

  def check_duplicate(pins)
    duplicate = pins.inject(Hash.new(0)) {|ha, e| ha[e] += 1 ; ha}.delete_if {|k, v| v == 1}.keys
    unless duplicate.empty?
      @view.map_table.setCurrentItem(@view.map_table.item(pins.index(duplicate[0]), 1))
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Wrong value',
        "Duplicate values detected: #{duplicate[0]}"
      ).exec
      return false
    end
    return true
  end

  def resize_to_content
    @view.map_table.resizeColumnsToContents
    @view.map_table.resizeRowsToContents
    @view.map_table.horizontalHeader.stretchLastSection = true
  end
end
