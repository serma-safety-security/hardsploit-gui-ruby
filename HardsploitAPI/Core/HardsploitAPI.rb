require 'singleton'
require 'libusb'
require 'thread'
require_relative 'HardsploitAPI_CONSTANT'
require_relative 'HardsploitAPI_USB_COMMUNICATION'
require_relative 'HardsploitAPI_FIRMWARE'
require_relative 'HardsploitAPI_ERROR'
require_relative '../../Firmwares/FPGA/VersionFPGA'
require_relative '../../Firmwares/UC/VersionUC'
class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end

class HardsploitAPI
  include Singleton
  include USB_COMMAND
  include USB
  include VERSION
  include ERROR

  @@callbackData = nil
  @@callbackInfo = nil
  @@callbackProgress = nil
  @@callbackSpeedOfTransfert = nil
  @@id = 0
  @@crossWiringValue = Array.new

  def self.callbackData= fn
        @@callbackData = fn
  end
  def self.callbackInfo= fn
        @@callbackInfo = fn
  end
  def self.callbackProgress= fn
        @@callbackProgress = fn
  end
  def self.callbackSpeedOfTransfert= fn
        @@callbackSpeedOfTransfert = fn
  end

  def self.crossWiringValue
    return @@crossWiringValue
  end

  def self.id=id
    if (id < 0) then
      raise ERROR::HARDSPLOIT_NOT_FOUND
    else
      @@id = id
    end
  end

  def initialize
       if @@callbackData == nil or @@callbackInfo == nil or @@callbackProgress == nil or @@callbackSpeedOfTransfert == nil then
         raise "Error you need to specify callbackData callbackInfo callbackProgress callbackSpeedOfTransfert first"
       else
         #Default wiring
         for i in 0..63
         	@@crossWiringValue.push i
         end
         self.connect
         puts "Hardsploit is connected".green.bold
       end
  end

  # Set the leds of uC  returning nothing
	# * +led+:: USB_COMMAND::GREEN_LED  or USB_COMMAND::RED_LED
	# * +state+:: callback to return +data for dump function+
	def setStatutLed(led:,state:)
		packet_send = Array.new
		packet_send.push 0 #size set before send automatic
		packet_send.push 0	#size set before send automatic
		packet_send.push HardsploitAPI.lowByte(word:led)
		packet_send.push HardsploitAPI.highByte(word:led)
		packet_send.push (state ? 1 : 0)
		return sendPacket(packet_send)
	end


  # Set custom value to wiring led
  # * +value+:: 64 bits (8x8 Bytes) values to represent led (PortH PortG PortF PortE PortD PortC PortB PortA)
  def setWiringLeds(value:)
  #  parametters = HardsploitAPI.checkParametters(["value"],args)
  #  val = parametters[:value]

    packet = Array.new
    packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
    packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
    packet.push HardsploitAPI.lowByte(word:USB_COMMAND::FPGA_COMMAND)
    packet.push HardsploitAPI.highByte(word:USB_COMMAND::FPGA_COMMAND)

    packet.push 0x23 #Command SPI write wiring led

    packet.push  HardsploitAPI.reverseBit((value & 0x00000000000000FF) >> 0)
    packet.push  HardsploitAPI.reverseBit((value & 0x000000000000FF00) >> 8 )
    packet.push  HardsploitAPI.reverseBit((value & 0x0000000000FF0000) >> 16 )
    packet.push  HardsploitAPI.reverseBit((value & 0x00000000FF000000) >> 24 )
    packet.push  HardsploitAPI.reverseBit((value & 0x000000FF00000000) >> 32 )
    packet.push  HardsploitAPI.reverseBit((value & 0x0000FF0000000000) >> 40 )
    packet.push  HardsploitAPI.reverseBit((value & 0x00FF000000000000) >> 48 )
    packet.push  HardsploitAPI.reverseBit((value & 0xFF00000000000000) >> 56 )

    return  HardsploitAPI.instance.sendPacket(packet)
  end

  # Obtaint the version number of the board
  def getVersionNumber
    packet = Array.new
    packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
    packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
    packet.push HardsploitAPI.lowByte(word:USB_COMMAND::GET_VERSION_NUMBER)
    packet.push HardsploitAPI.highByte(word:USB_COMMAND::GET_VERSION_NUMBER)

    #remove header
    version_number = self.sendAndReceiveDATA(packet,1000).drop(4)
    if version_number.size < 20 then #if size more thant 20 char error when reading version number
        return version_number.pack('U*')
    else
      return "BAD VERSION NUMBER"
    end
  end

  def getAllVersions
    puts "API             : #{VERSION::API}".blue.bold
    puts "Board           : #{getVersionNumber}".blue.bold
    puts "FPGA            : #{VersionFPGA::VERSION_FPGA::FPGA}".blue.bold
    puts "Microcontroller : #{VersionUC::VERSION_UC::UC}".blue.bold
  end

  def self.reverseBit(byte)
    return byte.to_s(2).rjust(8, "0").reverse.to_i(2)
  end

  # Set cross wiring
  # * +value+:: 64*8 bits to represent wiring
  def setCrossWiring(value:)
    if not value.size == 64 then
      raise HardsploitAPI::ERROR::API_CROSS_WIRING
    end

    packet = Array.new
    packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
    packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
    packet.push HardsploitAPI.lowByte(word:USB_COMMAND::FPGA_COMMAND)
    packet.push HardsploitAPI.highByte(word:USB_COMMAND::FPGA_COMMAND)

    packet.push 0x75 #Cross wiring command
    packet.push *value
    @@crossWiringValue = value
    return self.sendPacket(packet)
  end

  def self.allPosibility(numberOfConnectedPinFromA0:,numberOfSignalsForBus:)
      if numberOfConnectedPinFromA0 < numberOfSignalsForBus then
        raise HardsploitAPI::ERROR::API_SCANNER_WRONG_PIN_NUMBER
      end
      a =	  Array.new
      for i in 0..numberOfConnectedPinFromA0-1
        a.push i
      end
     return a.permutation.to_a
  end

  def self.prepare_packet
		packet = []
		packet.push 0  #low byte of lenght of trame refresh automaticly before send by usb
		packet.push 0  #high byte of lenght of trame refresh automaticly before send by usb
		packet.push HardsploitAPI.lowByte(word:HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
		packet.push HardsploitAPI.highByte(word:HardsploitAPI::USB_COMMAND::FPGA_COMMAND)
		packet.push 0x50 #Command RAW COMMUNICATION TO FPGA FIFO
		return packet
	end

  #call back
  def consoleProgress(percent:,startTime:,endTime:)
    @@callbackProgress.call(percent:percent,startTime:startTime,endTime:endTime)
  end
  def consoleData(value)
    @@callbackData.call(value)
  end
  def consoleSpeed(value)
    @@callbackSpeedOfTransfert.call(value)
  end
  def consoleInfo(value)
    @@callbackInfo.call(value)
  end

end
