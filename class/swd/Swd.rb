#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../HardsploitAPI/Modules/SWD/HardsploitAPI_SWD'

class Swd

  def initialize(chip, console)
    if HardsploitAPI.getNumberOfBoardAvailable > 0
      @console = console
      @chip = chip
    else
      Qt::MessageBox.new(
        Qt::MessageBox::Critical,
        "Error",
        "Hardsploit not plugged. Operation canceled"
      ).exec
    end
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
    return false
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
    return false
  rescue Exception => msg
    ErrorMsg.new.unknow(msg)
    return false
  end

  def do_swd_action(action, option = {})
    Firmware.new('SWD')
    api = HardsploitAPI_SWD.new(
      memory_start_address: @chip.swd_setting.memory_start_address,
      memory_size_address:  @chip.swd_setting.memory_size_address,
      cpu_id_address:       @chip.swd_setting.cpu_id_address,
      device_id_address:    @chip.swd_setting.device_id_address
    )
    return 0 if api.nil?
    case action
    when 'detect'
      return api.obtainCodes
    when 'export'
      $pgb = Progress_bar.new("SWD: #{action}...")
      $pgb.show
      api.dumpFlash(option)
    when 'import'
      $pgb = Progress_bar.new("SWD: #{action}...")
      $pgb.show
      api.writeFlash(option)
    when 'erase'
      api.eraseFlash
    end
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
    return false
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
    return false
  rescue HardsploitAPI::ERROR::SWD_ERROR
    ErrorMsg.new.swd_not_found
    return false
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
    return false
  end

  def detect
    code = do_swd_action('detect')
    unless code == false
      @console.print('New action: SWD Detect')
        Qt::MessageBox.new(
          Qt::MessageBox::Information,
          "SWD detection",
          "Detected:\n"+
            "DP.IDCODE:  #{code[:DebugPortId].to_s(16)}\n"+
            "AP.IDCODE:  #{code[:AccessPortId].to_s(16)}\n"+
            "CPU ID:     #{code[:CpuId].to_s(16)}\n"
        ).exec
    end
  end

  def export(filepath)
    unless do_swd_action('export', filepath) == false
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        "SWD Export Action",
        "Dump finished"
      ).exec
      $pgb.close
    end
  end

  def import(filepath)
    unless do_swd_action('import', filepath) == false
      Qt::MessageBox.new(
        Qt::MessageBox::Information,
        "SWD Import Action",
        "Import finished"
      ).exec
      $pgb.close
    end
  end

  def erase
    msg = Qt::MessageBox.new
    msg.setWindowTitle("Delete the data")
    msg.setText("You are going to delete all the data. Continue?")
    msg.setIcon(Qt::MessageBox::Information)
    msg.setStandardButtons(Qt::MessageBox::Cancel | Qt::MessageBox::Ok)
    msg.setDefaultButton(Qt::MessageBox::Cancel)
    if msg.exec == Qt::MessageBox::Ok
      unless do_swd_action('erase') == false
        Qt::MessageBox.new(
          Qt::MessageBox::Information,
          "SWD Erase Action",
          "Erase finished"
        ).exec
      end
    end
  end
end
