#===================================================
#  Hardsploit GUI - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../HardsploitAPI/HardsploitAPI'
require_relative '../gui/gui_wire_helper'

class Wire_helper < Qt::Widget
  slots 'rotate_scene()'

  def initialize(chip, api)
    super()
    @wire_helper_gui = Ui_Wire_helper.new
    centerWindow(self)
    @wire_helper_gui.setupUi(self)
    @chip = chip
    @api = api

    # Default led position
    api.setWiringLeds(0x0000000000000000)

    # Draw the chip
    scene = Qt::GraphicsScene.new
    @wire_helper_gui.lbl_chip.setText("Your chip (#{chip.chip_reference}):")

    # Get the pin total number
    # UniqPin parameters: (scene, pinNum, pinChip, xSig, ySig, xNum, yNum, xRect, yRect, wRect, hRect, rotation)
    total_pin_nbr = Pin.where(pin_chip: @chip.chip_id).count
    # If it's a square
    if Package.find_by(package_id: chip.chip_package).package_shape == 0
      pin_by_side = total_pin_nbr / 4
      cHeight = 14*(pin_by_side + 4)  # Chip's height (+4 because we add a space equal to one pin for each corner)
      scene.addRect(Qt::RectF.new(0, 0, cHeight, cHeight))
      y = 32
      y2 = cHeight - 38
      x = 32
      x2 = cHeight - 38
      (1..total_pin_nbr).each do |i|
        # Face 1
        if i <= pin_by_side
          ySig = y
          yNum = y
          UniqPin.new(scene, i, @chip.chip_id, -70, ySig - 12, 0, yNum - 12, 0, y, -20, 6, false, api)
          y = y + 14 # Space between each pin
        elsif i > pin_by_side && i <= total_pin_nbr / 2
        # Face 2
          xSig2 = x
          xNum2 = x
          UniqPin.new(scene, i, @chip.chip_id, xSig2 - 12, cHeight + 55, xNum2 - 12, cHeight, x, cHeight, 6, 20, true, api)
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
          UniqPin.new(scene, i, @chip.chip_id, xSig, ySig - 12, xNum, yNum - 12, cHeight, y2, 20, 6, false, api)
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
          UniqPin.new(scene, i, @chip.chip_id, xSig2 - 12, -20, xNum2 - 12, yNum2, x2, 0, 6, -20, true, api)
          x2 = x2 - 14
        end
      end
    # If it's a rectangle
    else
      pin_by_side = total_pin_nbr / 2
      cHeight = 14 * (pin_by_side + 2) # +2 because we add a space equal to one pin for each corner
      scene.addRect(Qt::RectF.new(0, 0, cHeight, cHeight))
      # Add the pins + text
      y = 18
      y2 = cHeight - 24
      (1..total_pin_nbr).each do |i|
        # Face 1
        if i <= total_pin_nbr / 2
          ySig = y
          yNum = y
          UniqPin.new(scene, i, @chip.chip_id, -70, ySig - 12, 0, yNum - 12, 0, y, -20, 6, false, api)
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
          UniqPin.new(scene, i, @chip.chip_id, xSig, ySig - 12, xNum, yNum - 12, cHeight, y2, 20, 6, false, api)
          y2 = y2 - 14
        end
      end
    end
    # Draw!
    @wire_helper_gui.gView.setScene(scene)
  rescue Exception => msg
    Qt::MessageBox.new(Qt::MessageBox::Critical, 'Critical error', 'Error occured while drawing the chip. Consult the logs for more details').exec
    logger = Logger.new($logFilePath)
    logger.error msg
  end

  def closeEvent(event)
    @api.setWiringLeds(0xFF00FF00FF00FF00)
  end

  def rotate_scene
    @wire_helper_gui.gView.rotate(90)
  end
end

#
# Custom Item - To trigger events on the graphics text items
#
class CustomItem < Qt::GraphicsTextItem

  def setPin(upin)
    @UPin = upin
  end

  def boundingRect
    rect = Qt::RectF.new
    rect.setHeight(20)
    rect.setWidth(65)
    rect.setTop(5)
    return rect
  end

  def mouseDoubleClickEvent(event)
    begin
      pin = self.instance_variable_get('@UPin')
      pin.setColor
      pin.instance_variable_get('@api').signalHelpingWiring(pin.instance_variable_get('@signalId'))
      pin.instance_variable_get('@signalTxt').clearFocus
      pin.instance_variable_get('@nbrTxt').clearFocus
    rescue
      pin.instance_variable_get('@api').setWiringLeds(0x0000000000000000)
      pin.instance_variable_get('@signalTxt').clearFocus
      pin.instance_variable_get('@nbrTxt').clearFocus
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Signal not found', 'This signal is not handled by the board').exec
    end
  end

  def mousePressEvent(event)
    begin
      pin = self.instance_variable_get('@UPin')
      pin.setColor
      pin.instance_variable_get('@api').signalHelpingWiring(pin.instance_variable_get('@signalId'))
      pin.instance_variable_get('@signalTxt').clearFocus
      pin.instance_variable_get('@nbrTxt').clearFocus
    rescue
      pin.instance_variable_get('@api').setWiringLeds(0x0000000000000000)
      pin.instance_variable_get('@signalTxt').clearFocus
      pin.instance_variable_get('@nbrTxt').clearFocus
      Qt::MessageBox.new(Qt::MessageBox::Critical, 'Signal not found', 'This signal is not handled by the board').exec
    end
  end
end

#
# UniqPin - Contain all data linked to one pin on the graphic
#
class UniqPin
  def initialize(scene, pinNum, pinChip, xSig, ySig, xNum, yNum, xRect, yRect, wRect, hRect, rotation, api)
    currentPin = Pin.where(pin_number: pinNum, pin_chip: pinChip).pluck(:pin_signal)[0]
    currentSignal = Signall.where(signal_id: currentPin).pluck(:signal_name)[0]
    # Set the signal id
    @signalId = currentSignal

    @api = api
    # Signal text
    @signalTxt = CustomItem.new(currentSignal)
    @signalTxt.cursor = Qt::Cursor.new(Qt::PointingHandCursor)
    @signalTxt.setPin(self)
    @signalTxt.setTextInteractionFlags(Qt::TextSelectableByMouse)
    @signalTxt.setX(xSig)
    @signalTxt.setY(ySig)
    if rotation
      @signalTxt.rotation = 270.00
    end
    scene.addItem(@signalTxt)

    # Number text
    @nbrTxt = CustomItem.new(pinNum.to_s)
    @nbrTxt.cursor = Qt::Cursor.new(Qt::PointingHandCursor)
    @nbrTxt.setPin(self)
    @nbrTxt.setTextInteractionFlags(Qt::TextSelectableByMouse)
    @nbrTxt.setX(xNum)
    @nbrTxt.setY(yNum)
    if rotation
      @nbrTxt.rotation = 270.00
    end
    scene.addItem(@nbrTxt)

    # Pin graphic
    @pinGraphItem = scene.addRect(xRect, yRect, wRect, hRect)
  end

  def setColor
    # Colors
    @on = Qt::Color.new(0, 0, 255)
    @off = Qt::Color.new(0, 0, 0)
    # Disable the pin if a pin is already enabled
    unless $pinEnabled.nil?
      $pinEnabled.unsetColor
    end
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
