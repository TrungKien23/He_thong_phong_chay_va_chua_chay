
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _nhiet=R4
	.DEF _nhiet_msb=R5
	.DEF _canhbao=R6
	.DEF _canhbao_msb=R7
	.DEF _baochay=R8
	.DEF _baochay_msb=R9
	.DEF _xulychay=R10
	.DEF _xulychay_msb=R11
	.DEF _baocoi=R12
	.DEF _baocoi_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x43,0x48,0x41,0x59,0x20,0x2D,0x20,0x58
	.DB  0x55,0x20,0x4C,0x59,0x3A,0x20,0x25,0x64
	.DB  0x20,0x20,0x0,0x42,0x41,0x4F,0x20,0x58
	.DB  0x55,0x20,0x4C,0x59,0x20,0x4C,0x41,0x49
	.DB  0x3A,0x20,0x25,0x64,0x20,0x20,0x0,0x41
	.DB  0x4E,0x20,0x54,0x4F,0x41,0x4E,0x20,0x20
	.DB  0x20,0x20,0x20,0x25,0x30,0x32,0x64,0x25
	.DB  0x63,0x43,0x0,0x4E,0x47,0x55,0x59,0x20
	.DB  0x48,0x49,0x45,0x4D,0x20,0x20,0x20,0x25
	.DB  0x30,0x32,0x64,0x25,0x63,0x43,0x0,0x43
	.DB  0x4F,0x20,0x43,0x48,0x41,0x59,0x20,0x20
	.DB  0x20,0x20,0x20,0x25,0x30,0x32,0x64,0x25
	.DB  0x63,0x43,0x0,0x48,0x45,0x20,0x54,0x48
	.DB  0x4F,0x4E,0x47,0x20,0x50,0x48,0x4F,0x4E
	.DB  0x47,0x20,0x0,0x43,0x48,0x41,0x59,0x20
	.DB  0x43,0x48,0x55,0x41,0x20,0x43,0x48,0x41
	.DB  0x59,0x20,0x0,0x50,0x48,0x4F,0x4E,0x47
	.DB  0x20,0x53,0x4F,0x20,0x30,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x50,0x48,0x4F,0x4E
	.DB  0x47,0x20,0x53,0x4F,0x20,0x30,0x32,0x20
	.DB  0x20,0x20,0x20,0x20,0x0
_0x2060003:
	.DB  0x80,0xC0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x10
	.DW  _0x76
	.DW  _0x0*2+99

	.DW  0x10
	.DW  _0x76+16
	.DW  _0x0*2+115

	.DW  0x11
	.DW  _0x76+32
	.DW  _0x0*2+131

	.DW  0x11
	.DW  _0x76+49
	.DW  _0x0*2+148

	.DW  0x11
	.DW  _0x76+66
	.DW  _0x0*2+131

	.DW  0x11
	.DW  _0x76+83
	.DW  _0x0*2+148

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 4/8/2023
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;#include <string.h>
;#include <math.h>
;#include <stdio.h>
;
;unsigned int nhiet; // nhiet do do duoc cho vi tri 1
;unsigned int canhbao = 0; // canh bao (=0 n�u khong co cam bien bao loi, = 1 n�u 1 trong 2 cam bien bao)
;unsigned int baochay = 0; // = 0 neu chua co chay, = 1 neu c� chay
;unsigned int xulychay = 0; // = 0 neu chay chua duoc xu ly, = 1 neu da duoc xu ly
;unsigned int baocoi = 0; // =0 neu chua xac nhan, = 1 neu da xac nhan
;unsigned int dangbaocoi = 0; // =0 neu chua bao coi, = 1 neu da bao coi
;
;unsigned int nhiet1; // nhiet do do duoc cho vi tri 1
;unsigned int canhbao1 = 0; // canh bao (=0 n�u khong co cam bien bao loi, = 1 n�u 1 trong 2 cam bien bao)
;unsigned int baochay1 = 0; // = 0 neu chua co chay, = 1 neu c� chay
;unsigned int xulychay1 = 0; // = 0 neu chay chua duoc xu ly, = 1 neu da duoc xu ly
;unsigned int baocoi1 = 0; // =0 neu chua xac nhan, = 1 neu da xac nhan
;unsigned int dangbaocoi1 = 0; // =0 neu chua bao coi, = 1 neu da bao coi
;
;unsigned int cht = 0; // chon hien thi dia diem chay
;unsigned int pn = 0; // khai bao bit nho co phim nhan, pn = 0 co phim nhan, pn = 1 tat ca cac phim deu nha
;unsigned char Mang[20];
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 003B {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 003C ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 003D // Delay needed for the stabilization of the ADC input voltage
; 0000 003E delay_us(10);
	__DELAY_USB 27
; 0000 003F // Start the AD conversion
; 0000 0040 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0041 // Wait for the AD conversion to complete
; 0000 0042 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0043 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0044 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20C0001
; 0000 0045 }
; .FEND
;
;void nhietdo()
; 0000 0048 {
_nhietdo:
; .FSTART _nhietdo
; 0000 0049     nhiet = 500 * (unsigned long)read_adc(0) / 1023;
	LDI  R26,LOW(0)
	CALL SUBOPT_0x0
	MOVW R4,R30
; 0000 004A     nhiet1 = 500 * (unsigned long)read_adc(1) / 1023;
	LDI  R26,LOW(1)
	CALL SUBOPT_0x0
	STS  _nhiet1,R30
	STS  _nhiet1+1,R31
; 0000 004B }
	RET
; .FEND
;
;//========================================
;
;
;
;void kiemtra()
; 0000 0052 {
_kiemtra:
; .FSTART _kiemtra
; 0000 0053    nhietdo();
	RCALL _nhietdo
; 0000 0054    if(nhiet > 70)
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CP   R30,R4
	CPC  R31,R5
	BRSH _0x6
; 0000 0055    {
; 0000 0056       if(xulychay == 0) // khi chua duoc xu ly
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x7
; 0000 0057       {
; 0000 0058          PORTC.3 = 1;
	SBI  0x15,3
; 0000 0059          if(baocoi == 0)
	MOV  R0,R12
	OR   R0,R13
	BRNE _0xA
; 0000 005A          {
; 0000 005B             PORTD.0 = 1;
	SBI  0x12,0
; 0000 005C             dangbaocoi = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _dangbaocoi,R30
	STS  _dangbaocoi+1,R31
; 0000 005D          }
; 0000 005E       }
_0xA:
; 0000 005F       baochay = 1;
_0x7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 0060       canhbao = 1;
	MOVW R6,R30
; 0000 0061    }
; 0000 0062    else
	RJMP _0xD
_0x6:
; 0000 0063    {
; 0000 0064       if(xulychay == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xE
; 0000 0065       {
; 0000 0066          xulychay = 0;
	CLR  R10
	CLR  R11
; 0000 0067          baochay = 0;
	CLR  R8
	CLR  R9
; 0000 0068       }
; 0000 0069    }
_0xE:
_0xD:
; 0000 006A    //----------------------------------------
; 0000 006B    if(nhiet1 > 70)
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x47)
	LDI  R30,HIGH(0x47)
	CPC  R27,R30
	BRLO _0xF
; 0000 006C    {
; 0000 006D       if(xulychay1 == 0) // khi chua duoc xu ly
	LDS  R30,_xulychay1
	LDS  R31,_xulychay1+1
	SBIW R30,0
	BRNE _0x10
; 0000 006E       {
; 0000 006F          PORTC.2 = 1;
	SBI  0x15,2
; 0000 0070          if(baocoi1 == 0)
	LDS  R30,_baocoi1
	LDS  R31,_baocoi1+1
	SBIW R30,0
	BRNE _0x13
; 0000 0071          {
; 0000 0072             PORTD.0 = 1;
	SBI  0x12,0
; 0000 0073             dangbaocoi1 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _dangbaocoi1,R30
	STS  _dangbaocoi1+1,R31
; 0000 0074          }
; 0000 0075       }
_0x13:
; 0000 0076       baochay1 = 1;
_0x10:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _baochay1,R30
	STS  _baochay1+1,R31
; 0000 0077       canhbao1 = 1;
	STS  _canhbao1,R30
	STS  _canhbao1+1,R31
; 0000 0078    }
; 0000 0079    else
	RJMP _0x16
_0xF:
; 0000 007A    {
; 0000 007B       if(xulychay1 == 1)
	CALL SUBOPT_0x2
	SBIW R26,1
	BRNE _0x17
; 0000 007C       {
; 0000 007D          xulychay1 = 0;
	CALL SUBOPT_0x3
; 0000 007E          baochay1 = 0;
	LDI  R30,LOW(0)
	STS  _baochay1,R30
	STS  _baochay1+1,R30
; 0000 007F       }
; 0000 0080    }
_0x17:
_0x16:
; 0000 0081 }
	RET
; .FEND
;
;void quetphim() // chuong trinh con quet nut nhan / quet phim nhan
; 0000 0084 {
_quetphim:
; .FSTART _quetphim
; 0000 0085    if (pn)
	LDS  R30,_pn
	LDS  R31,_pn+1
	SBIW R30,0
	BRNE PC+2
	RJMP _0x18
; 0000 0086    {
; 0000 0087       if (PINC.0 == 0)
	SBIC 0x13,0
	RJMP _0x19
; 0000 0088       {
; 0000 0089          pn = 0; // bao co nut duoc nhan
	LDI  R30,LOW(0)
	STS  _pn,R30
	STS  _pn+1,R30
; 0000 008A          if(dangbaocoi == 1)
	LDS  R26,_dangbaocoi
	LDS  R27,_dangbaocoi+1
	SBIW R26,1
	BRNE _0x1A
; 0000 008B          {
; 0000 008C             PORTD.0 = 0;
	CBI  0x12,0
; 0000 008D             baocoi = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 008E          }
; 0000 008F          if(baocoi == 1 && canhbao == 0)
_0x1A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x1E
	CLR  R0
	CP   R0,R6
	CPC  R0,R7
	BREQ _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
; 0000 0090          {
; 0000 0091             baocoi = 0;
	CALL SUBOPT_0x4
; 0000 0092             dangbaocoi = 0;
; 0000 0093          }
; 0000 0094 
; 0000 0095          if(dangbaocoi1 == 1)
_0x1D:
	LDS  R26,_dangbaocoi1
	LDS  R27,_dangbaocoi1+1
	SBIW R26,1
	BRNE _0x20
; 0000 0096          {
; 0000 0097             PORTD.0 = 0;
	CBI  0x12,0
; 0000 0098             baocoi1 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _baocoi1,R30
	STS  _baocoi1+1,R31
; 0000 0099          }
; 0000 009A          if(baocoi1 == 1 && canhbao1 == 0)
_0x20:
	LDS  R26,_baocoi1
	LDS  R27,_baocoi1+1
	SBIW R26,1
	BRNE _0x24
	CALL SUBOPT_0x5
	BREQ _0x25
_0x24:
	RJMP _0x23
_0x25:
; 0000 009B          {
; 0000 009C             baocoi1 = 0;
	CALL SUBOPT_0x6
; 0000 009D             dangbaocoi1 = 0;
; 0000 009E          }
; 0000 009F        }
_0x23:
; 0000 00A0 //----------------------------------------
; 0000 00A1       if (PINC.1 == 0)
_0x19:
	SBIC 0x13,1
	RJMP _0x26
; 0000 00A2       {
; 0000 00A3          pn = 0;
	LDI  R30,LOW(0)
	STS  _pn,R30
	STS  _pn+1,R30
; 0000 00A4          //if(canh_bao>0)
; 0000 00A5          {
; 0000 00A6 
; 0000 00A7             if(cht == 0)
	LDS  R30,_cht
	LDS  R31,_cht+1
	SBIW R30,0
	BRNE _0x27
; 0000 00A8             {
; 0000 00A9                baochay = 0;
	CLR  R8
	CLR  R9
; 0000 00AA                canhbao = 0;
	CLR  R6
	CLR  R7
; 0000 00AB                kiemtra();
	RCALL _kiemtra
; 0000 00AC                if(xulychay == 0)
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x28
; 0000 00AD                {
; 0000 00AE                   xulychay = 1; // bao da xu ly chay
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 00AF                   PORTC.3 = 0; // tat relay
	CBI  0x15,3
; 0000 00B0                   PORTD.0 = 0; // tat coi
	CBI  0x12,0
; 0000 00B1                   baocoi=0;
	CALL SUBOPT_0x4
; 0000 00B2                   dangbaocoi = 0;
; 0000 00B3                }
; 0000 00B4                else
	RJMP _0x2D
_0x28:
; 0000 00B5                {
; 0000 00B6                   xulychay = 0;
	CLR  R10
	CLR  R11
; 0000 00B7                }
_0x2D:
; 0000 00B8                if(baochay == 0) // khi van con bao chay
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x2E
; 0000 00B9                {
; 0000 00BA                   xulychay = 0; // bao da xu ly chay
	CLR  R10
	CLR  R11
; 0000 00BB                   PORTC.3 = 0; // tat relay
	CBI  0x15,3
; 0000 00BC                   PORTD.0 = 0; // tat coi
	CBI  0x12,0
; 0000 00BD                   baocoi = 0;
	CALL SUBOPT_0x4
; 0000 00BE                   dangbaocoi = 0;
; 0000 00BF                }
; 0000 00C0             }
_0x2E:
; 0000 00C1          }
_0x27:
; 0000 00C2          {
; 0000 00C3 
; 0000 00C4             if(cht==1)
	CALL SUBOPT_0x7
	SBIW R26,1
	BRNE _0x33
; 0000 00C5             {
; 0000 00C6                baochay1 = 0;
	LDI  R30,LOW(0)
	STS  _baochay1,R30
	STS  _baochay1+1,R30
; 0000 00C7                canhbao1 = 0;
	STS  _canhbao1,R30
	STS  _canhbao1+1,R30
; 0000 00C8                kiemtra();
	RCALL _kiemtra
; 0000 00C9                if(xulychay1 == 0)
	LDS  R30,_xulychay1
	LDS  R31,_xulychay1+1
	SBIW R30,0
	BRNE _0x34
; 0000 00CA                {
; 0000 00CB                   xulychay1 = 1; // bao da xu ly chay
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _xulychay1,R30
	STS  _xulychay1+1,R31
; 0000 00CC                   PORTC.2 = 0; // tat relay
	CBI  0x15,2
; 0000 00CD                   PORTD.0 = 0; // tat coi
	CBI  0x12,0
; 0000 00CE                   baocoi1 = 0;
	CALL SUBOPT_0x6
; 0000 00CF                   dangbaocoi1 = 0;
; 0000 00D0                }
; 0000 00D1                else
	RJMP _0x39
_0x34:
; 0000 00D2                {
; 0000 00D3                   xulychay1 = 0;
	CALL SUBOPT_0x3
; 0000 00D4                }
_0x39:
; 0000 00D5                if(baochay1 == 0) // khi van con bao chay
	LDS  R30,_baochay1
	LDS  R31,_baochay1+1
	SBIW R30,0
	BRNE _0x3A
; 0000 00D6                {
; 0000 00D7                   xulychay1 = 0; // bao da xu ly chay
	CALL SUBOPT_0x3
; 0000 00D8                   PORTC.2 = 0; // tat relay
	CBI  0x15,2
; 0000 00D9                   PORTD.0 = 0; // tat coi
	CBI  0x12,0
; 0000 00DA                   baocoi1 = 0;
	CALL SUBOPT_0x6
; 0000 00DB                   dangbaocoi1 = 0;
; 0000 00DC                }
; 0000 00DD             }
_0x3A:
; 0000 00DE          }
_0x33:
; 0000 00DF       }
; 0000 00E0 //----------------------------------------
; 0000 00E1    }
_0x26:
; 0000 00E2    else
	RJMP _0x3F
_0x18:
; 0000 00E3    {
; 0000 00E4       if((PINC.0 == 1)&&(PINC.1 == 1))
	SBIS 0x13,0
	RJMP _0x41
	SBIC 0x13,1
	RJMP _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 00E5       {
; 0000 00E6          pn = 1; // bao khong co nut nhan
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _pn,R30
	STS  _pn+1,R31
; 0000 00E7       }
; 0000 00E8    }
_0x40:
_0x3F:
; 0000 00E9 }
	RET
; .FEND
;
;void taotre2(unsigned int t)
; 0000 00EC {
_taotre2:
; .FSTART _taotre2
; 0000 00ED    unsigned int i;
; 0000 00EE    unsigned int j;
; 0000 00EF    for(i = 0; i < t; i++)
	CALL SUBOPT_0x8
;	t -> Y+4
;	i -> R16,R17
;	j -> R18,R19
_0x44:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x45
; 0000 00F0    {
; 0000 00F1       for(j = 0; j < 40; j++)
	__GETWRN 18,19,0
_0x47:
	__CPWRN 18,19,40
	BRSH _0x48
; 0000 00F2       {
; 0000 00F3          delay_ms(10);
	CALL SUBOPT_0x9
; 0000 00F4          quetphim();
; 0000 00F5       }
	__ADDWRN 18,19,1
	RJMP _0x47
_0x48:
; 0000 00F6       nhietdo();
	RCALL _nhietdo
; 0000 00F7       kiemtra();
	RCALL _kiemtra
; 0000 00F8       if((canhbao == 0 && cht == 0)||(canhbao1 == 0 && cht == 1)) break;
	CLR  R0
	CP   R0,R6
	CPC  R0,R7
	BRNE _0x4A
	CALL SUBOPT_0x7
	SBIW R26,0
	BREQ _0x4C
_0x4A:
	CALL SUBOPT_0x5
	BRNE _0x4D
	CALL SUBOPT_0x7
	SBIW R26,1
	BREQ _0x4C
_0x4D:
	RJMP _0x49
_0x4C:
	RJMP _0x45
; 0000 00F9    }
_0x49:
	__ADDWRN 16,17,1
	RJMP _0x44
_0x45:
; 0000 00FA }
	RJMP _0x20C0004
; .FEND
;//========================================
;void taotre(unsigned int t)
; 0000 00FD {
_taotre:
; .FSTART _taotre
; 0000 00FE    unsigned int i;
; 0000 00FF    unsigned int j;
; 0000 0100    for(i = 0; i < t; i++)
	CALL SUBOPT_0x8
;	t -> Y+4
;	i -> R16,R17
;	j -> R18,R19
_0x51:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x52
; 0000 0101    {
; 0000 0102       for(j = 0; j < 50; j++)
	__GETWRN 18,19,0
_0x54:
	__CPWRN 18,19,50
	BRSH _0x55
; 0000 0103       {
; 0000 0104          delay_ms(10);
	CALL SUBOPT_0x9
; 0000 0105          quetphim();
; 0000 0106       }
	__ADDWRN 18,19,1
	RJMP _0x54
_0x55:
; 0000 0107       nhietdo();
	RCALL _nhietdo
; 0000 0108       kiemtra();
	RCALL _kiemtra
; 0000 0109       if(canhbao == 1||canhbao1 == 1) break;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BREQ _0x57
	LDS  R26,_canhbao1
	LDS  R27,_canhbao1+1
	SBIW R26,1
	BRNE _0x56
_0x57:
	RJMP _0x52
; 0000 010A    }
_0x56:
	__ADDWRN 16,17,1
	RJMP _0x51
_0x52:
; 0000 010B }
_0x20C0004:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;//========================================
;
;void hienthichay()
; 0000 010F {
_hienthichay:
; .FSTART _hienthichay
; 0000 0110    unsigned int xl;
; 0000 0111    if((xulychay == 0 && cht == 0)||(xulychay1 == 0 && cht == 1))
	ST   -Y,R17
	ST   -Y,R16
;	xl -> R16,R17
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRNE _0x5A
	CALL SUBOPT_0x7
	SBIW R26,0
	BREQ _0x5C
_0x5A:
	CALL SUBOPT_0x2
	SBIW R26,0
	BRNE _0x5D
	CALL SUBOPT_0x7
	SBIW R26,1
	BREQ _0x5C
_0x5D:
	RJMP _0x59
_0x5C:
; 0000 0112    {
; 0000 0113       for(xl = 6; xl > 0; xl--)
	__GETWRN 16,17,6
_0x61:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRSH _0x62
; 0000 0114       {
; 0000 0115          sprintf(Mang,"CHAY - XU LY: %d  ",xl);
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,0
	CALL SUBOPT_0xB
; 0000 0116          lcd_gotoxy(0,1); // dua con tro LCD ve dong 1 cot 1;
; 0000 0117          lcd_puts(Mang);
; 0000 0118          taotre2(2);
; 0000 0119       }
	__SUBWRN 16,17,1
	RJMP _0x61
_0x62:
; 0000 011A    }
; 0000 011B    if((xulychay == 1 && cht == 0)||(xulychay1 == 1 && cht == 1))
_0x59:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x64
	CALL SUBOPT_0x7
	SBIW R26,0
	BREQ _0x66
_0x64:
	CALL SUBOPT_0x2
	SBIW R26,1
	BRNE _0x67
	CALL SUBOPT_0x7
	SBIW R26,1
	BREQ _0x66
_0x67:
	RJMP _0x63
_0x66:
; 0000 011C    {
; 0000 011D       for(xl = 6; xl > 0; xl--)
	__GETWRN 16,17,6
_0x6B:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRSH _0x6C
; 0000 011E       {
; 0000 011F          sprintf(Mang,"BAO XU LY LAI: %d  ",xl);
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,19
	CALL SUBOPT_0xB
; 0000 0120          lcd_gotoxy(0,1); // dua con tro LCD ve dong 1 cot 1;
; 0000 0121          lcd_puts(Mang);
; 0000 0122          taotre2(2);
; 0000 0123       }
	__SUBWRN 16,17,1
	RJMP _0x6B
_0x6C:
; 0000 0124    }
; 0000 0125 }
_0x63:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;//========================================
;void htnhiet(unsigned int n)
; 0000 0128 {
_htnhiet:
; .FSTART _htnhiet
; 0000 0129    if(n < 50)
	ST   -Y,R27
	ST   -Y,R26
;	n -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,50
	BRSH _0x6D
; 0000 012A    {
; 0000 012B       sprintf(Mang,"AN TOAN     %02d%cC", n, 0xdf);
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,39
	CALL SUBOPT_0xC
; 0000 012C       lcd_gotoxy(0,1); // dua con tro LCD ve dong 1 cot 1;
; 0000 012D       lcd_puts(Mang);
; 0000 012E    }
; 0000 012F    else
	RJMP _0x6E
_0x6D:
; 0000 0130    if(n < 70)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x46)
	LDI  R30,HIGH(0x46)
	CPC  R27,R30
	BRSH _0x6F
; 0000 0131    {
; 0000 0132       sprintf(Mang,"NGUY HIEM   %02d%cC", n, 0xdf);
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,59
	CALL SUBOPT_0xC
; 0000 0133       lcd_gotoxy(0,1); // dua con tro LCD ve dong 1 cot 1;
; 0000 0134       lcd_puts(Mang);
; 0000 0135       PORTD.0 = 1; // bat coi
	SBI  0x12,0
; 0000 0136       taotre(1);
	CALL SUBOPT_0xD
; 0000 0137       taotre(1);
	CALL SUBOPT_0xD
; 0000 0138       taotre(1);
	CALL SUBOPT_0xD
; 0000 0139       PORTD.0 = 0; // tat coi
	CBI  0x12,0
; 0000 013A    }
; 0000 013B    else
	RJMP _0x74
_0x6F:
; 0000 013C    if(n >= 70)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x46)
	LDI  R30,HIGH(0x46)
	CPC  R27,R30
	BRLO _0x75
; 0000 013D    {
; 0000 013E       sprintf(Mang,"CO CHAY     %02d%cC", n, 0xdf);
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,79
	CALL SUBOPT_0xC
; 0000 013F       lcd_gotoxy(0,1); // dua con tro LCD ve dong 1 cot 1;
; 0000 0140       lcd_puts(Mang);
; 0000 0141       taotre(1);
	CALL SUBOPT_0xD
; 0000 0142       taotre(1);
	CALL SUBOPT_0xD
; 0000 0143       taotre(1);
	CALL SUBOPT_0xD
; 0000 0144       taotre(1);
	CALL SUBOPT_0xD
; 0000 0145    }
; 0000 0146 }
_0x75:
_0x74:
_0x6E:
	JMP  _0x20C0002
; .FEND
;//========================================
;
;void main(void)
; 0000 014A {
_main:
; .FSTART _main
; 0000 014B // Declare your local variables here
; 0000 014C 
; 0000 014D // Input/Output Ports initialization
; 0000 014E // Port A initialization
; 0000 014F // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0150 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0151 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0152 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0153 
; 0000 0154 // Port B initialization
; 0000 0155 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0156 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0157 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0158 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0159 
; 0000 015A // Port C initialization
; 0000 015B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 015C DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(12)
	OUT  0x14,R30
; 0000 015D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 015E PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(3)
	OUT  0x15,R30
; 0000 015F 
; 0000 0160 // Port D initialization
; 0000 0161 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0162 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(1)
	OUT  0x11,R30
; 0000 0163 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0164 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0165 
; 0000 0166 // Timer/Counter 0 initialization
; 0000 0167 // Clock source: System Clock
; 0000 0168 // Clock value: Timer 0 Stopped
; 0000 0169 // Mode: Normal top=0xFF
; 0000 016A // OC0 output: Disconnected
; 0000 016B TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 016C TCNT0=0x00;
	OUT  0x32,R30
; 0000 016D OCR0=0x00;
	OUT  0x3C,R30
; 0000 016E 
; 0000 016F // Timer/Counter 1 initialization
; 0000 0170 // Clock source: System Clock
; 0000 0171 // Clock value: Timer1 Stopped
; 0000 0172 // Mode: Normal top=0xFFFF
; 0000 0173 // OC1A output: Disconnected
; 0000 0174 // OC1B output: Disconnected
; 0000 0175 // Noise Canceler: Off
; 0000 0176 // Input Capture on Falling Edge
; 0000 0177 // Timer1 Overflow Interrupt: Off
; 0000 0178 // Input Capture Interrupt: Off
; 0000 0179 // Compare A Match Interrupt: Off
; 0000 017A // Compare B Match Interrupt: Off
; 0000 017B TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 017C TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 017D TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 017E TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 017F ICR1H=0x00;
	OUT  0x27,R30
; 0000 0180 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0181 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0182 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0183 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0184 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0185 
; 0000 0186 // Timer/Counter 2 initialization
; 0000 0187 // Clock source: System Clock
; 0000 0188 // Clock value: Timer2 Stopped
; 0000 0189 // Mode: Normal top=0xFF
; 0000 018A // OC2 output: Disconnected
; 0000 018B ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 018C TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 018D TCNT2=0x00;
	OUT  0x24,R30
; 0000 018E OCR2=0x00;
	OUT  0x23,R30
; 0000 018F 
; 0000 0190 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0191 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0192 
; 0000 0193 // External Interrupt(s) initialization
; 0000 0194 // INT0: Off
; 0000 0195 // INT1: Off
; 0000 0196 // INT2: Off
; 0000 0197 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0198 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0199 
; 0000 019A // USART initialization
; 0000 019B // USART disabled
; 0000 019C UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 019D 
; 0000 019E // Analog Comparator initialization
; 0000 019F // Analog Comparator: Off
; 0000 01A0 // The Analog Comparator's positive input is
; 0000 01A1 // connected to the AIN0 pin
; 0000 01A2 // The Analog Comparator's negative input is
; 0000 01A3 // connected to the AIN1 pin
; 0000 01A4 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01A5 
; 0000 01A6 // ADC initialization
; 0000 01A7 // ADC Clock frequency: 1000.000 kHz
; 0000 01A8 // ADC Voltage Reference: AREF pin
; 0000 01A9 // ADC Auto Trigger Source: Free Running
; 0000 01AA ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 01AB ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(163)
	OUT  0x6,R30
; 0000 01AC SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01AD 
; 0000 01AE // SPI initialization
; 0000 01AF // SPI disabled
; 0000 01B0 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 01B1 
; 0000 01B2 // TWI initialization
; 0000 01B3 // TWI disabled
; 0000 01B4 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 01B5 
; 0000 01B6 // Alphanumeric LCD initialization
; 0000 01B7 // Connections are specified in the
; 0000 01B8 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 01B9 // RS - PORTD Bit 7
; 0000 01BA // RD - PORTD Bit 6
; 0000 01BB // EN - PORTD Bit 5
; 0000 01BC // D4 - PORTD Bit 4
; 0000 01BD // D5 - PORTD Bit 3
; 0000 01BE // D6 - PORTD Bit 2
; 0000 01BF // D7 - PORTD Bit 1
; 0000 01C0 // Characters/line: 16
; 0000 01C1 
; 0000 01C2 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 01C3     lcd_clear();
	CALL _lcd_clear
; 0000 01C4     lcd_gotoxy(0,0); // dua con tro LCD ve dong 1 cot 1;
	CALL SUBOPT_0xE
; 0000 01C5     lcd_puts("HE THONG PHONG ");
	__POINTW2MN _0x76,0
	CALL _lcd_puts
; 0000 01C6     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 01C7     lcd_puts("CHAY CHUA CHAY ");
	__POINTW2MN _0x76,16
	CALL _lcd_puts
; 0000 01C8     delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 01C9 
; 0000 01CA while (1)
_0x77:
; 0000 01CB       {
; 0000 01CC       nhietdo();
	RCALL _nhietdo
; 0000 01CD       if(canhbao == 0 && canhbao1 == 0)
	CLR  R0
	CP   R0,R6
	CPC  R0,R7
	BRNE _0x7B
	CALL SUBOPT_0x5
	BREQ _0x7C
_0x7B:
	RJMP _0x7A
_0x7C:
; 0000 01CE       {
; 0000 01CF          lcd_gotoxy(0,0); // dua con tro LCD ve dong 1 cot 1;
	CALL SUBOPT_0xE
; 0000 01D0          lcd_puts("PHONG SO 01     ");
	__POINTW2MN _0x76,32
	CALL _lcd_puts
; 0000 01D1          htnhiet(nhiet);
	CALL SUBOPT_0xF
; 0000 01D2          taotre(6);
; 0000 01D3          lcd_gotoxy(0,0); // dua con tro LCD ve dong 1 cot 1;
	CALL SUBOPT_0xE
; 0000 01D4          lcd_puts("PHONG SO 02     ");
	__POINTW2MN _0x76,49
	CALL _lcd_puts
; 0000 01D5          htnhiet(nhiet1);
	CALL SUBOPT_0x10
; 0000 01D6          taotre(6);
; 0000 01D7       }
; 0000 01D8       if(canhbao == 1 || canhbao1 == 1)
_0x7A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BREQ _0x7E
	LDS  R26,_canhbao1
	LDS  R27,_canhbao1+1
	SBIW R26,1
	BRNE _0x7D
_0x7E:
; 0000 01D9       {
; 0000 01DA          cht = 0;
	LDI  R30,LOW(0)
	STS  _cht,R30
	STS  _cht+1,R30
; 0000 01DB          lcd_gotoxy(0,0); // dua con tro LCD ve dong 1 cot 1;
	CALL SUBOPT_0xE
; 0000 01DC          lcd_puts("PHONG SO 01     ");
	__POINTW2MN _0x76,66
	CALL _lcd_puts
; 0000 01DD          if(baochay)
	MOV  R0,R8
	OR   R0,R9
	BREQ _0x80
; 0000 01DE             hienthichay();
	RCALL _hienthichay
; 0000 01DF          else
	RJMP _0x81
_0x80:
; 0000 01E0          {
; 0000 01E1             htnhiet(nhiet);
	CALL SUBOPT_0xF
; 0000 01E2             taotre(6);
; 0000 01E3          }
_0x81:
; 0000 01E4          cht = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cht,R30
	STS  _cht+1,R31
; 0000 01E5          lcd_gotoxy(0,0); // dua con tro LCD ve dong 1 cot 1;
	CALL SUBOPT_0xE
; 0000 01E6          lcd_puts("PHONG SO 02     ");
	__POINTW2MN _0x76,83
	CALL _lcd_puts
; 0000 01E7          if(baochay1)
	LDS  R30,_baochay1
	LDS  R31,_baochay1+1
	SBIW R30,0
	BREQ _0x82
; 0000 01E8             hienthichay();
	RCALL _hienthichay
; 0000 01E9          else
	RJMP _0x83
_0x82:
; 0000 01EA          {
; 0000 01EB             htnhiet(nhiet1);
	CALL SUBOPT_0x10
; 0000 01EC             taotre(6);
; 0000 01ED          }
_0x83:
; 0000 01EE 
; 0000 01EF 
; 0000 01F0       }
; 0000 01F1 
; 0000 01F2       }
_0x7D:
	RJMP _0x77
; 0000 01F3 }
_0x84:
	RJMP _0x84
; .FEND

	.DSEG
_0x76:
	.BYTE 0x64

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x11
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0x11
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	CALL SUBOPT_0x12
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x13
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	CALL SUBOPT_0x11
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	CALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x13
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x13
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x16
	SBIW R30,0
	BRNE _0x2040072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0003
_0x2040072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x16
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
; .FSTART __lcd_write_nibble_G103
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2060004
	SBI  0x12,4
	RJMP _0x2060005
_0x2060004:
	CBI  0x12,4
_0x2060005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2060006
	SBI  0x12,3
	RJMP _0x2060007
_0x2060006:
	CBI  0x12,3
_0x2060007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2060008
	SBI  0x12,2
	RJMP _0x2060009
_0x2060008:
	CBI  0x12,2
_0x2060009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x206000A
	SBI  0x12,1
	RJMP _0x206000B
_0x206000A:
	CBI  0x12,1
_0x206000B:
	__DELAY_USB 13
	SBI  0x12,5
	__DELAY_USB 13
	CBI  0x12,5
	__DELAY_USB 13
	RJMP _0x20C0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 133
	RJMP _0x20C0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x17
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x17
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060010
_0x2060011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2060013
	RJMP _0x20C0001
_0x2060013:
_0x2060010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x12,7
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,7
	RJMP _0x20C0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060014
_0x2060016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x11,4
	SBI  0x11,3
	SBI  0x11,2
	SBI  0x11,1
	SBI  0x11,5
	SBI  0x11,7
	SBI  0x11,6
	CBI  0x12,5
	CBI  0x12,7
	CBI  0x12,6
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_dangbaocoi:
	.BYTE 0x2
_nhiet1:
	.BYTE 0x2
_canhbao1:
	.BYTE 0x2
_baochay1:
	.BYTE 0x2
_xulychay1:
	.BYTE 0x2
_baocoi1:
	.BYTE 0x2
_dangbaocoi1:
	.BYTE 0x2
_cht:
	.BYTE 0x2
_pn:
	.BYTE 0x2
_Mang:
	.BYTE 0x14
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	CALL _read_adc
	CLR  R22
	CLR  R23
	__GETD2N 0x1F4
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3FF
	CALL __DIVD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDS  R26,_nhiet1
	LDS  R27,_nhiet1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R26,_xulychay1
	LDS  R27,_xulychay1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  _xulychay1,R30
	STS  _xulychay1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	CLR  R12
	CLR  R13
	LDI  R30,LOW(0)
	STS  _dangbaocoi,R30
	STS  _dangbaocoi+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDS  R26,_canhbao1
	LDS  R27,_canhbao1+1
	SBIW R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _baocoi1,R30
	STS  _baocoi1+1,R30
	STS  _dangbaocoi1,R30
	STS  _dangbaocoi1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDS  R26,_cht
	LDS  R27,_cht+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	JMP  _quetphim

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(_Mang)
	LDI  R31,HIGH(_Mang)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R26,LOW(_Mang)
	LDI  R27,HIGH(_Mang)
	CALL _lcd_puts
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _taotre2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0xDF
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R26,LOW(_Mang)
	LDI  R27,HIGH(_Mang)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _taotre

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	MOVW R26,R4
	CALL _htnhiet
	LDI  R26,LOW(6)
	LDI  R27,0
	JMP  _taotre

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0x1
	CALL _htnhiet
	LDI  R26,LOW(6)
	LDI  R27,0
	JMP  _taotre

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G103
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
