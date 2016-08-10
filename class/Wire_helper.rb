#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../gui/gui_wire_helper'
require_relative '../HardsploitAPI/Core/HardsploitAPI'

class Wire_helper < Qt::Widget
  slots 'rotate_scene()'

  def initialize(chip)
    super()
    @wire_helper_gui = Ui_Wire_helper.new
    centerWindow(self)
    @wire_helper_gui.setupUi(self)
    @chip = chip
    HardsploitAPI.instance.setWiringLeds(value: 0x0000000000000000)
    @scene = Qt::GraphicsScene.new
    @wire_helper_gui.lbl_chip.setText("Your chip (#{chip.reference}):")
    Package.find_by(id: chip.package_id).shape.zero? ? draw_square : draw_rect
    @wire_helper_gui.gView.setScene(@scene)
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def closeEvent(event)
    HardsploitAPI.instance.setWiringLeds(value: 0xFF00FF00FF00FF00)
  rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
    ErrorMsg.new.hardsploit_not_found
  rescue HardsploitAPI::ERROR::USB_ERROR
    ErrorMsg.new.usb_error
  rescue Exception => msg
    ErrorMsg.new.unknown(msg)
  end

  def rotate_scene
    @wire_helper_gui.gView.rotate(90)
  end
end

def draw_square
  total_pin_nbr = Pin.where(chip_id: @chip.id).count
  pin_by_side = total_pin_nbr / 4
  cHeight = 14*(pin_by_side + 4)  # Chip's height (+4 because we add a space equal to one pin for each corner)
  @scene.addRect(Qt::RectF.new(0, 0, cHeight, cHeight))
  y = 32
  y2 = cHeight - 38
  x = 32
  x2 = cHeight - 38
  (1..total_pin_nbr).each do |i|
    # Face 1
    if i <= pin_by_side
      ySig = y
      yNum = y
      UniqPin.new(@scene, i, @chip.id, -70, ySig - 12, 0, yNum - 12, 0, y, -20, 6, false)
      y = y + 14 # Space between each pin
    elsif i > pin_by_side && i <= total_pin_nbr / 2
    # Face 2
      xSig2 = x
      xNum2 = x
      UniqPin.new(@scene, i, @chip.id, xSig2 - 12, cHeight + 55, xNum2 - 12, cHeight, x, cHeight, 6, 20, true)
      x = x + 14
    elsif i > total_pin_nbr / 2 && i <= (total_pin_nbr - (pin_by_side))
    # Face 3
      xSig = cHeight + 24
      ySig = y2
      yNum = y2

      if i < 10
        xNum = cHeight - 20
      elsif i >= 10 && i < 100
        xNum = cHeight - 25
      else
        xNum = cHeight - 35
      end
      UniqPin.new(@scene, i, @chip.id, xSig, ySig - 12, xNum, yNum - 12, cHeight, y2, 20, 6, false)
      y2 = y2 - 14
    else
    # Face 4
      xSig2 = x2
      xNum2 = x2

      if i < 10
        yNum2 = 20
      elsif i >= 10 && i < 100
        yNum2 = 30
      else
        yNum2 = 40
      end
      UniqPin.new(@scene, i, @chip.id, xSig2 - 12, -20, xNum2 - 12, yNum2, x2, 0, 6, -20, true)
      x2 = x2 - 14
    end
  end
end

def draw_rect
  total_pin_nbr = Pin.where(chip_id: @chip.id).count
  pin_by_side = total_pin_nbr / 2
  cHeight = 14 * (pin_by_side + 2) # +2 because we add a space equal to one pin for each corner
  @scene.addRect(Qt::RectF.new(0, 0, cHeight, cHeight))
  # Add the pins + text
  y = 18
  y2 = cHeight - 24
  (1..total_pin_nbr).each do |i|
    # Face 1
    if i <= total_pin_nbr / 2
      ySig = y
      yNum = y
      UniqPin.new(@scene, i, @chip.id, -70, ySig - 12, 0, yNum - 12, 0, y, -20, 6, false)
      y = y + 14
    # Face 2
    else
      xSig = cHeight + 24
      ySig = y2
      yNum = y2

      if i < 10
        xNum = cHeight - 20
      elsif i >= 10 && i < 100
        xNum = cHeight - 25
      else
        xNum = cHeight - 35
      end
      UniqPin.new(@scene, i, @chip.id, xSig, ySig - 12, xNum, yNum - 12, cHeight, y2, 20, 6, false)
      y2 = y2 - 14
    end
  end
end


#
# Custom Item - To trigger events on the graphics text items
#
class CustomItem < Qt::GraphicsTextItem

  def setPin(upin, api_value)
    @UPin = upin
    @api_value = api_value
  end

  def boundingRect
    rect = Qt::RectF.new
    rect.setHeight(20)
    rect.setWidth(65)
    rect.setTop(5)
    return rect
  end

  def mousePressEvent(event)
      pin = self.instance_variable_get('@UPin')
      pin.setColor
      pin.instance_variable_get('@signalTxt').clearFocus
      pin.instance_variable_get('@nbrTxt').clearFocus
      return false if @api_value == 'NA'
      pin_group = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
      hardsploit_pin_number = pin_group.index(@api_value.pin[0]) * 8 + @api_value.pin[1].to_i
      HardsploitAPI.instance.setWiringLeds(value: 2**hardsploit_pin_number)
    rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
      ErrorMsg.new.hardsploit_not_found
    rescue HardsploitAPI::ERROR::USB_ERROR
      ErrorMsg.new.usb_error
    rescue Exception => msg
      HardsploitAPI.instance.setWiringLeds(value: 0x0000000000000000)
      pin.instance_variable_get('@signalTxt').clearFocus
      pin.instance_variable_get('@nbrTxt').clearFocus
    end

    def mouseDoubleClickEvent(event)
      pin = self.instance_variable_get('@UPin')
      pin.instance_variable_get('@signalTxt').clearFocus
      pin.instance_variable_get('@nbrTxt').clearFocus
    end
end

#
# UniqPin - Contain all data linked to one pin on the graphic
#
class UniqPin
  def initialize(scene, pinNum, pinChip, xSig, ySig, xNum, yNum, xRect, yRect, wRect, hRect, rotation)
    signal_name = Pin.find_by(number: pinNum, chip_id: pinChip).signall
    @signalTxt = CustomItem.new(signal_name.name)
    @signalTxt.cursor = Qt::Cursor.new(Qt::PointingHandCursor)
    @signalTxt.setPin(self, signal_name)
    @signalTxt.setTextInteractionFlags(Qt::TextSelectableByMouse)
    @signalTxt.setX(xSig)
    @signalTxt.setY(ySig)
    @signalTxt.rotation = 270.00 if rotation
    scene.addItem(@signalTxt)

    @nbrTxt = CustomItem.new(pinNum.to_s)
    @nbrTxt.cursor = Qt::Cursor.new(Qt::PointingHandCursor)
    @nbrTxt.setPin(self, pinNum.to_s)
    @nbrTxt.setTextInteractionFlags(Qt::TextSelectableByMouse)
    @nbrTxt.setX(xNum)
    @nbrTxt.setY(yNum)
    @nbrTxt.rotation = 270.00 if rotation
    scene.addItem(@nbrTxt)
    @pinGraphItem = scene.addRect(xRect, yRect, wRect, hRect)
  end

  def setColor
    # Colors
    @on = Qt::Color.new(0, 0, 255)
    @off = Qt::Color.new(0, 0, 0)
    # Disable the pin if another pin is already enabled
    $pinEnabled.unsetColor unless $pinEnabled.nil?
    # Light the new pin
    @nbrTxt.setDefaultTextColor(@on)
    @signalTxt.setDefaultTextColor(@on)
    @bold = Qt::Font.new
    @bold.setBold(true)
    @signalTxt.setFont(@bold)
    $pinEnabled = self
  end

  def unsetColor
    @nbrTxt.setDefaultTextColor(@off)
    @signalTxt.setDefaultTextColor(@off)
    @bold.setBold(false)
    @signalTxt.setFont(@bold)
  end

end
