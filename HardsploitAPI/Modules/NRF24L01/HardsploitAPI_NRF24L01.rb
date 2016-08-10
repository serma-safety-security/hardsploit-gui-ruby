#!/usr/bin/ruby
#===================================================
#  Hardsploit API - By Opale Security
#  www.opale-security.com || www.hardsploit.io
#  License: GNU General Public License v3
#  License URI: http://www.gnu.org/licenses/gpl.txt
#===================================================

require_relative '../../Core/HardsploitAPI'
require_relative '../../Modules/SPI/HardsploitAPI_SPI'
class HardsploitAPI_NRF24L01
public
		# Instruction Mnemonics
		R_REGISTER 	  	 = 0x00
		W_REGISTER       = 0x20
		REGISTER_MASK    = 0x1F
		ACTIVATE         = 0x50
		R_RX_PL_WID      = 0x60
		R_RX_PAYLOAD     = 0x61
		W_TX_PAYLOAD     = 0xA0
		W_ACK_PAYLOAD    = 0xA8
		FLUSH_TX         = 0xE1
		FLUSH_RX         = 0xE2
		REUSE_TX_PL      = 0xE3
		NOP              = 0xFF

		#Register map
    NRF24L01_00_CONFIG      = 0x00
    NRF24L01_01_EN_AA       = 0x01
    NRF24L01_02_EN_RXADDR   = 0x02
    NRF24L01_03_SETUP_AW    = 0x03
    NRF24L01_04_SETUP_RETR  = 0x04
    NRF24L01_05_RF_CH       = 0x05
    NRF24L01_06_RF_SETUP    = 0x06
    NRF24L01_07_STATUS      = 0x07
    NRF24L01_08_OBSERVE_TX  = 0x08
    NRF24L01_09_CD          = 0x09
    NRF24L01_0A_RX_ADDR_P0  = 0x0A
    NRF24L01_0B_RX_ADDR_P1  = 0x0B
    NRF24L01_0C_RX_ADDR_P2  = 0x0C
    NRF24L01_0D_RX_ADDR_P3  = 0x0D
    NRF24L01_0E_RX_ADDR_P4  = 0x0E
    NRF24L01_0F_RX_ADDR_P5  = 0x0F
    NRF24L01_10_TX_ADDR     = 0x10
    NRF24L01_11_RX_PW_P0    = 0x11
    NRF24L01_12_RX_PW_P1    = 0x12
    NRF24L01_13_RX_PW_P2    = 0x13
    NRF24L01_14_RX_PW_P3    = 0x14
    NRF24L01_15_RX_PW_P4    = 0x15
    NRF24L01_16_RX_PW_P5    = 0x16
    NRF24L01_17_FIFO_STATUS = 0x17
    NRF24L01_1C_DYNPD       = 0x1C
		NRF24L01_1D_FEATURE     = 0x1D

		# Bit mnemonics
    NRF24L01_00_MASK_RX_DR  = 6
    NRF24L01_00_MASK_TX_DS  = 5
    NRF24L01_00_MASK_MAX_RT = 4
    NRF24L01_00_EN_CRC      = 3
    NRF24L01_00_CRCO        = 2
    NRF24L01_00_PWR_UP      = 1
    NRF24L01_00_PRIM_RX     = 0
    NRF24L01_07_RX_DR       = 6
    NRF24L01_07_TX_DS       = 5
    NRF24L01_07_MAX_RT      = 4

		# Bitrates
    NRF24L01_BR_1M				  = 0
    NRF24L01_BR_2M 					= 1
    NRF24L01_BR_250K			  = 2
    NRF24L01_BR_RSVD 				= 3

		TXRX_OFF								= 0
		TX_EN 									= 1
		RX_EN 									= 2

	def BV(x)
	 return (1 << x)
	end

	def sendAndReceiveSPI(packet)
		begin
			return @spi.spi_Interact(payload:packet)
		rescue HardsploitAPI::ERROR::HARDSPLOIT_NOT_FOUND
			puts "Hardsploit not found"
	  rescue HardsploitAPI::ERROR::USB_ERROR
			puts "USB ERROR"
		end
	end

	def initialize()
		#Speed Range 1-255  SPI clock =  150Mhz / (2*speed) tested from 3 to 255 (25Mhz to about 0.3Khz)
		@spi = HardsploitAPI_SPI.new(speed:8,mode:0) # 150/(2*8) = 9.3Mhz
		@rf_setup = 0x0F
		@tout	=0
	end

	def initDrone(channel:,address:)
		config = BV(NRF24L01_00_EN_CRC) | BV(NRF24L01_00_CRCO) | BV(NRF24L01_00_PRIM_RX)
		NRF24L01_WriteReg(NRF24L01_00_CONFIG, config);
		NRF24L01_WriteReg(NRF24L01_01_EN_AA, 0x0f);      # Auto Acknoledgement
		NRF24L01_Activate(0x73);                         #Allow write feature reg
		NRF24L01_WriteReg( NRF24L01_1D_FEATURE,0x06); #enableDynamicPayloads
		NRF24L01_WriteReg( NRF24L01_1C_DYNPD,0x3f);   #enableDynamicPayloads
    NRF24L01_WriteReg(NRF24L01_02_EN_RXADDR, 0x01);  # Enable data pipe 0
		NRF24L01_WriteReg(NRF24L01_03_SETUP_AW, 0x03);   # 5-byte RX/TX address
  		#NRF24L01_WriteReg(NRF24L01_04_SETUP_RETR, 0xFF); # 4ms retransmit t/o, 15 tries
		NRF24L01_WriteReg(NRF24L01_05_RF_CH, channel);      # Channel  - bind
		setBitrate(NRF24L01_BR_250K)
		setPower(3) #Max power
		NRF24L01_WriteReg(NRF24L01_07_STATUS, 0x70); 	# Clear data ready, data
		NRF24L01_WriteReg(NRF24L01_11_RX_PW_P0, 16);
		NRF24L01_WriteReg(NRF24L01_17_FIFO_STATUS, 0x00);
		NRF24L01_WriteRegisterMulti(NRF24L01_0A_RX_ADDR_P0,address);
		NRF24L01_WriteRegisterMulti(NRF24L01_10_TX_ADDR, address);

		initialize();

		config |= BV(NRF24L01_00_PWR_UP);
	  NRF24L01_WriteReg(NRF24L01_00_CONFIG, config);

		valid_packets = missed_packets = bad_packets = 0;

		NRF24L01_SetTxRxMode(TXRX_OFF);
		NRF24L01_SetTxRxMode(RX_EN);
		# puts "EN_AA"
		# p NRF24L01_ReadReg(NRF24L01_01_EN_AA)
		# puts "EN_RXADDR"
		# p NRF24L01_ReadReg(NRF24L01_02_EN_RXADDR)
		# puts "SETUP_AW"
		# p NRF24L01_ReadReg(NRF24L01_03_SETUP_AW)
		# puts "RF_CH"
		# p NRF24L01_ReadReg(NRF24L01_05_RF_CH)
		# puts "RX_PW_P0"
		# p NRF24L01_ReadRegisterMulti(NRF24L01_0A_RX_ADDR_P0,5)
		# puts "TX_PW_P0"
		# p NRF24L01_ReadRegisterMulti(NRF24L01_10_TX_ADDR,5)
		# puts "RX_ADDR_P0"
		# p NRF24L01_ReadReg(NRF24L01_0A_RX_ADDR_P0)
		# puts "TX_ADDR"
		# p NRF24L01_ReadReg(NRF24L01_10_TX_ADDR)
		# puts "config"
		# p config
	end

	def NRF24L01_WriteReg(reg, data)
		result = sendAndReceiveSPI([ (W_REGISTER | (REGISTER_MASK & reg)),data ])
		return result[1]
	end

	def NRF24L01_WriteRegisterMulti(reg, payload)
		tmppayload = Array.new
		tmppayload.push (W_REGISTER | (REGISTER_MASK & reg))
		tmppayload.push *payload
		result = sendAndReceiveSPI(tmppayload)
		return result[0]
	end

	def NRF24L01_WritePayload(payload)
		tmpWpayload = Array.new
		tmpWpayload.push (W_TX_PAYLOAD)
		tmpWpayload.push *payload
		result = sendAndReceiveSPI(tmpWpayload)
		return result[0]
	end

	def NRF24L01_ReadReg(reg)
		result = sendAndReceiveSPI([R_REGISTER | (REGISTER_MASK & reg) ,0xFF ])
		return result[1]
	end

	def readPayloadSize
		result = sendAndReceiveSPI([R_RX_PL_WID ,0xFF ])
		return result[1]
	end

	def NRF24L01_ReadRegisterMulti(reg,length)
		tab = Array.new
		tab.push (R_REGISTER | (REGISTER_MASK & reg))
		tab.push *Array.new(length, 0xFF)
		return sendAndReceiveSPI(tab).drop(1) #remove the first byte
	end

	def readPayload(length)
		tab = Array.new
		tab.push R_RX_PAYLOAD
		tab.push *Array.new(length, 0xFF)
		return sendAndReceiveSPI(tab).drop(1) #remove the first byte
	end

	def readAvailableData
			return readPayload(readPayloadSize)
	end

	def Strobe(state)
		result = sendAndReceiveSPI([state])
		return result[0];
	end

	def NRF24L01_FlushTx()
		return Strobe(FLUSH_TX);
	end

	def NRF24L01_FlushRx()
		return Strobe(FLUSH_RX);
	end

	def NRF24L01_Activate(code)
		result = sendAndReceiveSPI([ACTIVATE ,code])
		return result[0];
	end

	def dataAvailable()
		result = sendAndReceiveSPI([R_REGISTER ,HardsploitAPI_NRF24L01::NRF24L01_07_STATUS])
		if ((result[0] & BV(HardsploitAPI_NRF24L01::NRF24L01_07_RX_DR))>>6)==1
			return true
		else
			return false
		end
	end

	def changeChannel(channel:)
		NRF24L01_WriteReg(NRF24L01_05_RF_CH, channel)
	end

	def setBitrate(bitrate)
		 #Note that bitrate 250kbps (and bit RF_DR_LOW) is valid only
		 #for nRF24L01+. There is no way to programmatically tell it from
		 #older version, nRF24L01, but the older is practically phased out
		 #by Nordic, so we assume that we deal with with modern version.

		# Bit 0 goes to RF_DR_HIGH, bit 1 - to RF_DR_LOW
		@rf_setup = (@rf_setup & 0xD7) | ((bitrate & 0x02) << 4) | ((bitrate & 0x01) << 3);
		return NRF24L01_WriteReg(NRF24L01_06_RF_SETUP, @rf_setup);
	end

	# Power setting is 0..3 for nRF24L01
	def setPower(nrf_power)
		if (nrf_power < 0) or (nrf_power > 3) then
			raise "NRF setPower, wrong must be between 0 and 3"
		end
		@rf_setup = (@rf_setup & 0xF9) | ((nrf_power & 0x03) << 1)
		return NRF24L01_WriteReg(NRF24L01_06_RF_SETUP, @rf_setup)
	end

	def CE_lo
		@spi.pulse = 0
	end

	def CE_hi
		@spi.pulse = 1
	end

	def NRF24L01_SetTxRxMode(mode)
		if(mode == TX_EN) then
			CE_lo()
			#sleep(0.5)
			NRF24L01_WriteReg(NRF24L01_07_STATUS, (1 << NRF24L01_07_RX_DR) | (1 << NRF24L01_07_TX_DS) 	| (1 << NRF24L01_07_MAX_RT))   #reset the flag(s)
			NRF24L01_WriteReg(NRF24L01_00_CONFIG, (1 << NRF24L01_00_EN_CRC)| (1 << NRF24L01_00_CRCO) | (1 << NRF24L01_00_PWR_UP))  #switch to TX mode
			#sleep(0.5)
			CE_hi()
		elsif (mode == RX_EN) then
			CE_lo()
		#	sleep(0.5)
			NRF24L01_WriteReg(NRF24L01_07_STATUS, 0x70)        # reset the flag(s)
			NRF24L01_WriteReg(NRF24L01_00_CONFIG, 0x0F)        # switch to RX mode
			NRF24L01_WriteReg(NRF24L01_07_STATUS, (1 << NRF24L01_07_RX_DR) | (1 << NRF24L01_07_TX_DS) | (1 << NRF24L01_07_MAX_RT)) #reset the flag(s)
			NRF24L01_WriteReg(NRF24L01_00_CONFIG, (1 << NRF24L01_00_EN_CRC)| (1 << NRF24L01_00_CRCO) 	| (1 << NRF24L01_00_PWR_UP) | (1 << NRF24L01_00_PRIM_RX)) #switch to RX mode
		#	sleep(0.5)
			CE_hi()
		else
			NRF24L01_WriteReg(NRF24L01_00_CONFIG, (1 << NRF24L01_00_EN_CRC)) #PowerDown
			CE_lo()
		end
	end

	def reset()
		NRF24L01_SetTxRxMode(TXRX_OFF)
	 	NRF24L01_FlushTx()
	 	NRF24L01_FlushRx()
		return true
	end

	def Read()
		tabdataread = Array.new
		if dataAvailable()
			NRF24L01_WriteReg(0x07,BV(HardsploitAPI_NRF24L01::NRF24L01_07_RX_DR))
			tabdataread.push *readPayload(16)
    	return tabdataread
		else
			return tabdataread
		end
	end

	def Send(dataSend)
		NRF24L01_SetTxRxMode(TXRX_OFF)
		NRF24L01_FlushTx()
		NRF24L01_WritePayload(dataSend)
		NRF24L01_SetTxRxMode(TX_EN)
  	sleep(0.1)
		NRF24L01_SetTxRxMode(TXRX_OFF)
		NRF24L01_FlushTx()
		NRF24L01_FlushRx()
		NRF24L01_SetTxRxMode(RX_EN);
	end
end
