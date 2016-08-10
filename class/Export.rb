#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../gui/gui_export'
class Export < Qt::Widget
  slots 'export()'
  slots 'export_file()'

  def initialize(chip_list)
    super()
    @export_ui = Ui_Export.new
    centerWindow(self)
    @export_ui.setupUi(self)
    @chip_list = chip_list
    @export_ui.rbn_cmds.setEnabled(false) unless @chip_list.count == 1
  end

  def export_file
    @filepath = Qt::FileDialog.getSaveFileName(self, tr('Select a file'), '/')
  end

  def export
    unless @filepath.nil?
      @file = File.open("#{@filepath}.json", 'w')
      unless @file.nil?
        @file.write("{\n")
        @chip_list.each_with_index do |current_chip, index|
          @file.write("\t\"#{index}\": {\n")
          @chip = Chip.find_by(reference: current_chip.text)
          if @export_ui.rbn_both.isChecked
              export_chip
              export_commands
          elsif @export_ui.rbn_comp.isChecked
            export_chip
          else
            export_commands
          end
          if index.next < @chip_list.count
            @file.write("\t},\n")
          else
            @file.write("\t}\n")
          end
        end
        @file.write("}")
        @file.close
      end
      Qt::MessageBox.new(Qt::MessageBox::Information, 'Export status', 'Export finished').exec
    else
      Qt::MessageBox.new(Qt::MessageBox::Warning, 'File missing', 'Choose a file before exporting').exec
    end
  end

  def export_chip
    @file.write("\t\t\"chip\":{\n")
    write_commons
    write_settings
    write_pins
    if @export_ui.rbn_both.isChecked
      @file.write("\t\t},\n")
    else
      @file.write("\t\t}\n")
    end
  end

  def write_commons
    @file.write("\t\t\t\t\"package\": #{@chip.package.to_json},\n")
    @file.write("\t\t\t\t\"chip_type\": #{@chip.chip_type.to_json},\n")
    @file.write("\t\t\t\t\"manufacturer\": #{@chip.manufacturer.to_json},\n")
    @file.write("\t\t\t\t\"characteristics\": #{@chip.to_json},\n")
  end

  def write_settings
    @file.write("\t\t\t\t\"settings\":{\n")
    if @chip.parallel_setting.nil?
      @file.write("\t\t\t\t\t\t\"parralel\": {},\n")
    else
      @file.write("\t\t\t\t\t\t\"parralel\": #{@chip.parallel_setting.to_json},\n")
    end
    if @chip.spi_setting.nil?
      @file.write("\t\t\t\t\t\t\"spi\": {},\n")
    else
      @file.write("\t\t\t\t\t\t\"spi\":#{@chip.spi_setting.to_json},\n")
    end
    if @chip.i2c_setting.nil?
      @file.write("\t\t\t\t\t\t\"i2c\": {},\n")
    else
      @file.write("\t\t\t\t\t\t\"i2c\": #{@chip.i2c_setting.to_json},\n")
    end
    if @chip.swd_setting.nil?
      @file.write("\t\t\t\t\t\t\"swd\": {},\n")
    else
      @file.write("\t\t\t\t\t\t\"swd\": #{@chip.swd_setting.to_json},\n")
    end
    if @chip.uart_setting.nil?
      @file.write("\t\t\t\t\t\t\"uart\": {}\n")
    else
      @file.write("\t\t\t\t\t\t\"uart\": #{@chip.uart_setting.to_json}\n")
    end
    @file.write("\t\t\t\t},\n")
  end

  def write_pins
    @file.write("\t\t\t\t\"pins\":[\n")
    @chip.pins.each_with_index do |pin, index|
      if index + 1 < @chip.pins.count
        @file.write("\t\t\t\t\t\t#{pin.to_json},\n")
      else
        @file.write("\t\t\t\t\t\t#{pin.to_json}\n")
      end
    end
    @file.write("\t\t\t\t]\n")
  end

  def export_commands
    @file.write("\t\t\"commands\":{\n")
      @chip.commands.each_with_index do |cmd, index|
        @file.write("\t\t\t\t\"#{index}\":{\n")
        @file.write("\t\t\t\t\t\t\"characteristics\": #{cmd.to_json},\n")
        @file.write("\t\t\t\t\t\t\"bytes\":[\n")
        cmd.bytes.each_with_index do |bytes, index|
          if index + 1 < cmd.bytes.count
            @file.write("\t\t\t\t\t\t\t\t#{bytes.to_json},\n")
          else
            @file.write("\t\t\t\t\t\t\t\t#{bytes.to_json}\n")
          end
        end
        @file.write("\t\t\t\t\t\t]\n")
        if index.next < @chip.commands.count
          @file.write("\t\t\t\t},\n")
        else
          @file.write("\t\t\t\t}\n")
        end
      end
    @file.write("\t\t}\n")
  end
end
