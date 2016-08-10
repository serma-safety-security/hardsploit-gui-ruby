#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require 'json'
require_relative '../gui/gui_import'
class Import < Qt::Widget
  slots 'import()'
  slots 'import_file()'

  def initialize(cm, chip = 'none')
    super()
    @import_ui = Ui_Import.new
    centerWindow(self)
    @import_ui.setupUi(self)
    @chip = chip
    @cm = cm
    @import_ui.lbl_import.setText("Import:")
  end

  def import_file
    @filepath = Qt::FileDialog.getOpenFileName(
      self,
      tr('Select a file'),
      '/',
      tr('JSON file (*.json)')
    )
  end

  def import
    unless @filepath.nil?
      @file = File.read("#{@filepath}")
      data_hash = JSON.parse(@file)
      data_hash.each_with_index do |element, index|
        @data_chip = element[1]['chip']
        @data_commands =  element[1]['commands']
        if @import_ui.rbn_both.isChecked
            import_chip
            import_commands
        elsif @import_ui.rbn_comp.isChecked
            import_chip
        else
            import_commands
        end
      end
      @cm.feed_chip_array
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        'Import status',
        'Import complete'
      ).exec
      self.close
    else
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'File missing',
        'Choose a file before importing'
      ).exec
    end
  end

  def import_package
    package = Package.new
    package.from_json(@data_chip['package'].to_json)
    if Package.exists?(name: package.name)
      return Package.find_by(name: package.name).id
    else
      Package.last.nil? ? package.id = 1 : package.id = Package.last.id.next
      package.save
      return package.id
    end
  end

  def import_type
    chip_type = ChipType.new
    chip_type.from_json(@data_chip['chip_type'].to_json)
    if ChipType.exists?(name: chip_type.name)
      return ChipType.find_by(name: chip_type.name).id
    else
      ChipType.last.nil? ? chip_type.id = 1 : chip_type.id = ChipType.last.id.next
      chip_type.save
      return chip_type.id
    end
  end

  def import_manufacturer
    manufacturer = Manufacturer.new
    manufacturer.from_json(@data_chip['manufacturer'].to_json)
    if Manufacturer.exists?(name: manufacturer.name)
      return Manufacturer.find_by(name: manufacturer.name).id
    else
      Manufacturer.last.nil? ? manufacturer.id = 1 : manufacturer.id = Manufacturer.last.id.next
      manufacturer.save
      return manufacturer.id
    end
  end

  def import_chip
    @chip = Chip.new
    @chip.from_json(@data_chip['characteristics'].to_json)
    if Chip.exists?(reference: @chip.reference)
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Import aborted',
        'This component already exists'
      ).exec
      return 0
    else
      Chip.last.nil? ? @chip.id = 1 : @chip.id = Chip.last.id.next
      @chip.package_id = import_package
      @chip.chip_type_id = import_type
      @chip.manufacturer_id = import_manufacturer
      @chip.save
      import_parallel_settings unless @data_chip['settings']['parallel'].nil?
      import_spi_settings unless @data_chip['settings']['spi'].empty?
      import_i2c_settings unless @data_chip['settings']['i2c'].empty?
      import_swd_settings unless @data_chip['settings']['swd'].empty?
      import_uart_settings unless @data_chip['settings']['uart'].empty?
      import_pins
    end
  end

  def import_pins
    @data_chip['pins'].each do |data_pin|
      pin = Pin.new
      pin.from_json(data_pin.to_json)
      pin.chip_id = @chip.id
      Pin.last.nil? ? pin.id = 1 : pin.id = Pin.last.id.next
      pin.save
    end
  end

  def import_parallel_settings
    parallel_settings = ParallelSetting.new
    parallel_settings.from_json(@data_chip['settings']['parallel'].to_json)
    parallel_settings.chip_id = @chip.id
    ParallelSetting.last.nil? ? parallel_settings.id = 1 : parallel_settings.id = ParallelSetting.last.id.next
    parallel_settings.save
  end

  def import_spi_settings
    spi_settings = SpiSetting.new
    spi_settings.from_json(@data_chip['settings']['spi'].to_json)
    spi_settings.chip_id = @chip.id
    SpiSetting.last.nil? ? spi_settings.id = 1 : spi_settings.id = SpiSetting.last.id.next
    spi_settings.save
  end

  def import_i2c_settings
    i2c_settings = I2cSetting.new
    i2c_settings.from_json(@data_chip['settings']['i2c'].to_json)
    i2c_settings.chip_id = @chip.id
    I2cSetting.last.nil? ? i2c_settings.id = 1 : i2c_settings.id = I2cSetting.last.id.next
    i2c_settings.save
  end

  def import_swd_settings
    swd_settings = SwdSetting.new
    swd_settings.from_json(@data_chip['settings']['swd'].to_json)
    swd_settings.chip_id = @chip.id
    SwdSetting.last.nil? ? swd_settings.id = 1 : swd_settings.id = SwdSetting.last.id.next
    swd_settings.save
  end

  def import_uart_settings
    uart_settings = UartSetting.new
    uart_settings.from_json(@data_chip['settings']['uart'].to_json)
    uart_settings.chip_id = @chip.id
    UartSetting.last.nil? ? uart_settings.id = 1 : uart_settings.id = UartSetting.last.id.next
    uart_settings.save
  end

  def import_commands
    return 0 if @data_commands.empty?
    @data_commands.each do |cmd_element|
      cmd = Command.new
      cmd.from_json(cmd_element[1]['characteristics'].to_json)
      Command.last.nil? ? cmd.id = 1 : cmd.id = Command.last.id.next
      cmd.chip_id = @chip.id
      cmd.save
      cmd_element[1]['bytes'].each do |byte_element|
        byte = Byte.new
        byte.from_json(byte_element.to_json)
        Byte.last.nil? ? byte.id = 1 : byte.id = Byte.last.id.next
        byte.command_id = cmd.id
        byte.save
      end
    end
  end
end
