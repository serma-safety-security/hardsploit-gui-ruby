#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../gui/gui_generic_import'
require_relative '../../HardsploitAPI/Modules/SPI/HardsploitAPI_SPI'

class Spi_import < Qt::Widget
  slots 'import()'
  slots 'select_import_file()'

  def initialize(chip)
    super()
    @view = Ui_Generic_import.new
    centerWindow(self)
    @view.setupUi(self)
    @view.lbl_chip.setText(chip.reference)
    inputRestrict(@view.lie_start, 0)
    @chip = chip
    @speeds = {
      '25.00' => 3,
      '18.75' => 4,
      '15.00' => 5,
      '12.50' => 6,
      '10.71' => 7,
      '9.38' => 8,
      '7.50' => 10,
      '5.00' => 15,
      '3.95' => 19,
      '3.00' => 25,
      '2.03' => 37,
      '1.00' => 75,
      '0.50' => 150,
      '0.29' => 255
    }
  end

  def select_import_file
    @filepath = Qt::FileDialog.getOpenFileName(self, tr('Select a file'), '/', tr('*.*'))
    unless @filepath.nil?
      @view.btn_import.setEnabled(true)
      @view.lbl_selected_file.setText("#{@filepath.split("/").last}")
    end
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def import
    return 0 if control_import_settings.zero?
    spi = HardsploitAPI_SPI.new(
      speed: @speeds[@chip.spi_setting.frequency],
      mode:  @chip.spi_setting.mode
    )
    Firmware.new('SPI')
    $pgb = Progress_bar.new("SPI: Importing...")
    $pgb.show
    @chip.spi_setting.is_flash.zero? ? flash = false : flash = true
    spi.spi_Generic_Import(
      startAddress:          @view.lie_start.text.to_i,
      pageSize:              @chip.spi_setting.page_size,
      memorySize:            @chip.spi_setting.total_size,
      dataFile:              @filepath,
      writeSpiCommand:       @chip.spi_setting.command_write,
      writePageLatency:      @chip.spi_setting.write_page_latency / 1000.0,
      enableWriteSpiCommand: @chip.spi_setting.command_write_enable,
      clearSpiCommand:       @chip.spi_setting.command_erase,
      clearChipTime:         @chip.spi_setting.erase_time,
      isFLASH:               flash
    )
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def control_import_settings
    if @chip.spi_setting.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing SPI settings',
        'No settings saved for this chip'
      ).exec
      return 0
    end
    if @chip.spi_setting.total_size.nil? || @chip.spi_setting.page_size.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing SPI settings',
        'Total size or page size missing'
    ).exec
      return 0
    end
    if @chip.spi_setting.command_read.nil? || @chip.spi_setting.frequency.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing SPI settings',
        'Read command or frequency missing'
      ).exec
      return 0
    end
    if @chip.spi_setting.command_write.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing SPI settings',
        'Write command missing'
      ).exec
      return 0
    end
    if @chip.spi_setting.write_page_latency.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing SPI setting',
        'SPI write page latency missing'
      ).exec
      return 0
    end
    if @chip.spi_setting.is_flash.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing SPI setting',
        'SPI flash nature missing'
      ).exec
      return 0
    else
      if @chip.spi_setting.is_flash == 1
        if @chip.spi_setting.erase_time.nil? || @chip.spi_setting.command_erase.nil?
          Qt::MessageBox.new(
            Qt::MessageBox::Warning,
            'Missing SPI setting',
            'SPI erase time or command missing'
          ).exec
          return 0
        end
      end
    end
    if @chip.spi_setting.mode.nil?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing SPI setting',
        'Mode missing'
      ).exec
      return 0
    end
    if @view.lie_start.text.empty?
      Qt::MessageBox.new(
        Qt::MessageBox::Warning,
        'Missing start address',
        'Please fill the Start address field'
      ).exec
      return 0
    end
    return 1
  end
end
