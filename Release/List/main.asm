
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 1.000000 MHz
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

	#pragma AVRPART ADMIN PART_NAME ATmega16A
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
	.DEF _PAUSE_TIME_AFTER_DISCARD_SECONDS=R4
	.DEF _PAUSE_TIME_AFTER_DISCARD_SECONDS_msb=R5
	.DEF __lcd_x=R7
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _trigger_alarm
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _exit_silent_mode
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

_KEYPAD_MATRIX:
	.DB  0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38
	.DB  0x39,0x2A,0x30,0x23

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0001

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x5,0x0

_0x0:
	.DB  0x31,0x3A,0x6F,0x6E,0x20,0x32,0x3A,0x6F
	.DB  0x66,0x66,0x0,0x33,0x3A,0x6C,0x6F,0x63
	.DB  0x6B,0x20,0x34,0x3A,0x75,0x6E,0x6C,0x6F
	.DB  0x63,0x6B,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0B
	.DW  _0x1B
	.DW  _0x0*2

	.DW  0x10
	.DW  _0x1B+11
	.DW  _0x0*2+11

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;#include <mega16a.h>
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
;#include <lcd.h>
;
;
;#asm
 .equ __lcd_port=0x15;
; 0000 0007 #endasm
;
;#include <delay.h>
;#define IS_ON_LED_OUT PORTD .6
;#define ALARM_OUT PORTD .5
;#define IS_SENSOR_PAUSED_LED PORTD .7
;#define KEYPAD_PIN PINB
;#define KEYPAD_PORT PORTB
;#define KEYPAD_ENABLE_PIN PINA .3
;#define REMOTE_PIN PINA
;int PAUSE_TIME_AFTER_DISCARD_SECONDS = 5;
;
;typedef enum
;{
;  rmt_no_action, // Do nothing, prevents default behaviour of enums.
;  rmt_turn_on,
;  rmt_turn_off,
;  rmt_discard_alarm,
;} eRemoteAction;
;
;bit is_on = 1;
;bit alarm_triggered = 0;  // If alarm is triggered, this will be 1 until alarm is discarded
;bit is_silent_mode = 0;   // A few seconds after alarm discard, the sensor input will be ignored.
;bit is_remote_locked = 0; // if remote is locked programmatically using keypad
;void temporarily_pause_sensor()
; 0000 0020 {

	.CSEG
_temporarily_pause_sensor:
; .FSTART _temporarily_pause_sensor
; 0000 0021   // with prescale set to 1024 and clk frequency = 1MHz, timer counts almost 1ms each clock.
; 0000 0022   int timer_bottom = (65 - PAUSE_TIME_AFTER_DISCARD_SECONDS) * 1000;
; 0000 0023   is_silent_mode = 1;
	ST   -Y,R17
	ST   -Y,R16
;	timer_bottom -> R16,R17
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	SUB  R30,R4
	SBC  R31,R5
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	MOVW R16,R30
	SET
	BLD  R2,2
; 0000 0024   TCNT1 = timer_bottom;
	__OUTWR 16,17,44
; 0000 0025   TCCR1B |= 0x05; // prescale set to 5 -> 1MHz / 1024 ~= 1ms
	IN   R30,0x2E
	ORI  R30,LOW(0x5)
	OUT  0x2E,R30
; 0000 0026 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void handle_remote_action(eRemoteAction rmt_action)
; 0000 0029 {
_handle_remote_action:
; .FSTART _handle_remote_action
; 0000 002A   if (rmt_action == rmt_no_action)
	ST   -Y,R26
;	rmt_action -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x3
; 0000 002B     return;
	JMP  _0x2020001
; 0000 002C 
; 0000 002D   if (rmt_action == rmt_turn_on)
_0x3:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x4
; 0000 002E   {
; 0000 002F     is_on = 1;
	SET
	BLD  R2,0
; 0000 0030   }
; 0000 0031   if (rmt_action == rmt_turn_off)
_0x4:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x5
; 0000 0032   {
; 0000 0033     is_on = 0;
	CLT
	BLD  R2,0
; 0000 0034     alarm_triggered = 0;
	BLD  R2,1
; 0000 0035   }
; 0000 0036   if (rmt_action == rmt_discard_alarm)
_0x5:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x6
; 0000 0037   {
; 0000 0038     alarm_triggered = 0;
	CLT
	BLD  R2,1
; 0000 0039     temporarily_pause_sensor();
	RCALL _temporarily_pause_sensor
; 0000 003A   }
; 0000 003B }
_0x6:
	JMP  _0x2020001
; .FEND
;
;
;const char KEYPAD_MATRIX[4][3] = {
;    {'1', '2', '3'}, {'4', '5', '6'}, {'7', '8', '9'}, {'*', '0', '#'}};
;
;typedef enum
;{
;  kp_no_action,
;  kp_turn_on,
;  kp_turn_off,
;  kp_lock_remote,
;  kp_unlock_remote,
;  kp_discard_alarm
;} eKeypadAction;
;
;char read_keypad()
; 0000 004C {
_read_keypad:
; .FSTART _read_keypad
; 0000 004D   char key = 0;
; 0000 004E 
; 0000 004F   while (1)
	ST   -Y,R17
;	key -> R17
	LDI  R17,0
_0x7:
; 0000 0050   {
; 0000 0051     int i, j;
; 0000 0052     if (KEYPAD_ENABLE_PIN == 0)
	SBIW R28,4
;	i -> Y+2
;	j -> Y+0
	SBIC 0x19,3
	RJMP _0xA
; 0000 0053     {
; 0000 0054       break;
	ADIW R28,4
	RJMP _0x9
; 0000 0055     }
; 0000 0056 
; 0000 0057     for (i = 0; i < 3; i++)
_0xA:
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
_0xC:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,3
	BRGE _0xD
; 0000 0058     {
; 0000 0059       // Set one column low at a time
; 0000 005A       KEYPAD_PORT |= 0x0F;
	IN   R30,0x18
	ORI  R30,LOW(0xF)
	OUT  0x18,R30
; 0000 005B       KEYPAD_PORT &= ~(1 << i);
	IN   R1,24
	LDD  R30,Y+2
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OUT  0x18,R30
; 0000 005C 
; 0000 005D       delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 005E 
; 0000 005F       // Check rows
; 0000 0060       for (j = 0; j < 4; j++)
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0xF:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRGE _0x10
; 0000 0061       {
; 0000 0062         if (!(KEYPAD_PIN & (1 << (j + 4))))
	CALL SUBOPT_0x0
	BRNE _0x11
; 0000 0063         {
; 0000 0064           // Key pressed
; 0000 0065           key = KEYPAD_MATRIX[j][i];
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(3)
	CALL __MULB1W2U
	SUBI R30,LOW(-_KEYPAD_MATRIX*2)
	SBCI R31,HIGH(-_KEYPAD_MATRIX*2)
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R17,Z
; 0000 0066           while (!(KEYPAD_PIN & (1 << (j + 4))))
_0x12:
	CALL SUBOPT_0x0
	BREQ _0x12
; 0000 0067             ; // Wait for key release
; 0000 0068           return key;
	MOV  R30,R17
	ADIW R28,4
	RJMP _0x2020002
; 0000 0069         }
; 0000 006A       }
_0x11:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0xF
_0x10:
; 0000 006B     }
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
	RJMP _0xC
_0xD:
; 0000 006C   }
	ADIW R28,4
	RJMP _0x7
_0x9:
; 0000 006D }
_0x2020002:
	LD   R17,Y+
	RET
; .FEND
;
;void handle_keypad_action(eKeypadAction action)
; 0000 0070 {
_handle_keypad_action:
; .FSTART _handle_keypad_action
; 0000 0071   if (action == kp_no_action)
	ST   -Y,R26
;	action -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x15
; 0000 0072     return;
	JMP  _0x2020001
; 0000 0073   if (action == kp_turn_on)
_0x15:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x16
; 0000 0074   {
; 0000 0075     is_on = 1;
	SET
	BLD  R2,0
; 0000 0076   }
; 0000 0077 
; 0000 0078   if (action == kp_turn_off)
_0x16:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x17
; 0000 0079   {
; 0000 007A     is_on = 0;
	CLT
	BLD  R2,0
; 0000 007B   }
; 0000 007C 
; 0000 007D   if (action == kp_lock_remote)
_0x17:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x18
; 0000 007E   {
; 0000 007F     is_remote_locked = 1;
	SET
	BLD  R2,3
; 0000 0080   }
; 0000 0081 
; 0000 0082   if (action == kp_unlock_remote)
_0x18:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x19
; 0000 0083   {
; 0000 0084     is_remote_locked = 0;
	CLT
	BLD  R2,3
; 0000 0085   }
; 0000 0086   if (action == kp_discard_alarm)
_0x19:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x1A
; 0000 0087   {
; 0000 0088     alarm_triggered = 0;
	CLT
	BLD  R2,1
; 0000 0089   }
; 0000 008A }
_0x1A:
	JMP  _0x2020001
; .FEND
;
;void lcd_render_guide()
; 0000 008D {
_lcd_render_guide:
; .FSTART _lcd_render_guide
; 0000 008E   lcd_clear();
	CALL _lcd_clear
; 0000 008F   lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0090   delay_ms(10);
	CALL SUBOPT_0x1
; 0000 0091   lcd_puts("1:on 2:off");
	__POINTW2MN _0x1B,0
	CALL _lcd_puts
; 0000 0092   delay_ms(15);
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
; 0000 0093   lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0094   delay_ms(15);
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
; 0000 0095   lcd_puts("3:lock 4:unlock");
	__POINTW2MN _0x1B,11
	CALL _lcd_puts
; 0000 0096 }
	RET
; .FEND

	.DSEG
_0x1B:
	.BYTE 0x1B
;
;interrupt[2] void trigger_alarm()
; 0000 0099 {

	.CSEG
_trigger_alarm:
; .FSTART _trigger_alarm
	ST   -Y,R30
	IN   R30,SREG
; 0000 009A   if (is_on == 1 && !is_silent_mode)
	SBRS R2,0
	RJMP _0x1D
	SBRS R2,2
	RJMP _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
; 0000 009B   {
; 0000 009C     alarm_triggered = 1;
	SET
	BLD  R2,1
; 0000 009D   } else {
_0x1C:
; 0000 009E   return;
; 0000 009F   }
; 0000 00A0 }
_0x3F:
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;interrupt[TIM1_OVF] void exit_silent_mode()
; 0000 00A3 {
_exit_silent_mode:
; .FSTART _exit_silent_mode
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A4   TCCR1B = 0x00; // turn off the timer
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 00A5   is_silent_mode = 0;
	CLT
	BLD  R2,2
; 0000 00A6   alarm_triggered = 0;
	BLD  R2,1
; 0000 00A7 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;
;void main()
; 0000 00AB {
_main:
; .FSTART _main
; 0000 00AC #asm("sei")    // Enable interrupt
	sei
; 0000 00AD   DDRA = 0x00; // Input
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00AE   DDRB = 0x0f; // Keypad Set columns as output and rows as input
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 00AF   PORTB = 0xf0;
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0000 00B0   DDRC = 0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00B1   PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00B2   DDRD = 0b11100000; // Output
	LDI  R30,LOW(224)
	OUT  0x11,R30
; 0000 00B3   PORTD = 0b01000000;
	LDI  R30,LOW(64)
	OUT  0x12,R30
; 0000 00B4   GICR = 0b01000000;  // Enabling interrupt 0
	OUT  0x3B,R30
; 0000 00B5   MCUCR = 0b00000011; // Rising Edge
	LDI  R30,LOW(3)
	OUT  0x35,R30
; 0000 00B6   GIFR = 0b0000000;
	LDI  R30,LOW(0)
	OUT  0x3A,R30
; 0000 00B7   IS_ON_LED_OUT = 1;
	SBI  0x12,6
; 0000 00B8   ALARM_OUT = 0;
	CBI  0x12,5
; 0000 00B9   TIMSK |= (1 << TOIE1); // Enable Timer1 Overflow
	IN   R30,0x39
	ORI  R30,4
	OUT  0x39,R30
; 0000 00BA 
; 0000 00BB   lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00BC   delay_ms(10);
	CALL SUBOPT_0x1
; 0000 00BD   lcd_render_guide();
	RCALL _lcd_render_guide
; 0000 00BE   delay_ms(10);
	CALL SUBOPT_0x1
; 0000 00BF   while (1)
_0x24:
; 0000 00C0   {
; 0000 00C1     eRemoteAction rmt_action = rmt_no_action;
; 0000 00C2     if (REMOTE_PIN .0 == 1)
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	rmt_action -> Y+0
	SBIS 0x19,0
	RJMP _0x27
; 0000 00C3     {
; 0000 00C4       rmt_action = rmt_turn_on;
	LDI  R30,LOW(1)
	ST   Y,R30
; 0000 00C5     }
; 0000 00C6 
; 0000 00C7     if (REMOTE_PIN .1 == 1)
_0x27:
	SBIS 0x19,1
	RJMP _0x28
; 0000 00C8     {
; 0000 00C9       rmt_action = rmt_turn_off;
	LDI  R30,LOW(2)
	ST   Y,R30
; 0000 00CA     }
; 0000 00CB 
; 0000 00CC     if (REMOTE_PIN .2 == 1)
_0x28:
	SBIS 0x19,2
	RJMP _0x29
; 0000 00CD     {
; 0000 00CE       rmt_action = rmt_discard_alarm;
	LDI  R30,LOW(3)
	ST   Y,R30
; 0000 00CF     }
; 0000 00D0 
; 0000 00D1     if (REMOTE_PIN .3 == 1)
_0x29:
	SBIS 0x19,3
	RJMP _0x2A
; 0000 00D2     {
; 0000 00D3       rmt_action = rmt_turn_on;
	LDI  R30,LOW(1)
	ST   Y,R30
; 0000 00D4     }
; 0000 00D5     if (is_remote_locked != 1)
_0x2A:
	SBRC R2,3
	RJMP _0x2B
; 0000 00D6     {
; 0000 00D7       handle_remote_action(rmt_action);
	LD   R26,Y
	RCALL _handle_remote_action
; 0000 00D8     }
; 0000 00D9 
; 0000 00DA     if (KEYPAD_ENABLE_PIN == 1)
_0x2B:
	SBIS 0x19,3
	RJMP _0x2C
; 0000 00DB     {
; 0000 00DC 
; 0000 00DD       eKeypadAction keypad_action = kp_no_action;
; 0000 00DE       char pressed_key;
; 0000 00DF       pressed_key = read_keypad();
	SBIW R28,2
	LDI  R30,LOW(0)
	STD  Y+1,R30
;	rmt_action -> Y+2
;	keypad_action -> Y+1
;	pressed_key -> Y+0
	RCALL _read_keypad
	ST   Y,R30
; 0000 00E0       if (pressed_key == '1')
	LD   R26,Y
	CPI  R26,LOW(0x31)
	BRNE _0x2D
; 0000 00E1       {
; 0000 00E2         keypad_action = kp_turn_on;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 00E3       }
; 0000 00E4       if (pressed_key == '2')
_0x2D:
	LD   R26,Y
	CPI  R26,LOW(0x32)
	BRNE _0x2E
; 0000 00E5       {
; 0000 00E6         keypad_action = kp_turn_off;
	LDI  R30,LOW(2)
	STD  Y+1,R30
; 0000 00E7       }
; 0000 00E8       if (pressed_key == '3')
_0x2E:
	LD   R26,Y
	CPI  R26,LOW(0x33)
	BRNE _0x2F
; 0000 00E9       {
; 0000 00EA         keypad_action = kp_lock_remote;
	LDI  R30,LOW(3)
	STD  Y+1,R30
; 0000 00EB       }
; 0000 00EC       if (pressed_key == '4')
_0x2F:
	LD   R26,Y
	CPI  R26,LOW(0x34)
	BRNE _0x30
; 0000 00ED       {
; 0000 00EE         keypad_action = kp_unlock_remote;
	LDI  R30,LOW(4)
	STD  Y+1,R30
; 0000 00EF       }
; 0000 00F0       if (pressed_key == '5')
_0x30:
	LD   R26,Y
	CPI  R26,LOW(0x35)
	BRNE _0x31
; 0000 00F1       {
; 0000 00F2         keypad_action = kp_discard_alarm;
	LDI  R30,LOW(5)
	STD  Y+1,R30
; 0000 00F3       }
; 0000 00F4       handle_keypad_action(keypad_action);
_0x31:
	LDD  R26,Y+1
	RCALL _handle_keypad_action
; 0000 00F5     }
	ADIW R28,2
; 0000 00F6     IS_ON_LED_OUT = is_on == 1 ? 1 : 0;
_0x2C:
	SBRS R2,0
	RJMP _0x32
	LDI  R30,LOW(1)
	RJMP _0x33
_0x32:
	LDI  R30,LOW(0)
_0x33:
	CPI  R30,0
	BRNE _0x35
	CBI  0x12,6
	RJMP _0x36
_0x35:
	SBI  0x12,6
_0x36:
; 0000 00F7     ALARM_OUT = alarm_triggered;
	SBRC R2,1
	RJMP _0x37
	CBI  0x12,5
	RJMP _0x38
_0x37:
	SBI  0x12,5
_0x38:
; 0000 00F8     IS_SENSOR_PAUSED_LED = is_silent_mode ? 1 : 0;
	SBRS R2,2
	RJMP _0x39
	LDI  R30,LOW(1)
	RJMP _0x3A
_0x39:
	LDI  R30,LOW(0)
_0x3A:
	CPI  R30,0
	BRNE _0x3C
	CBI  0x12,7
	RJMP _0x3D
_0x3C:
	SBI  0x12,7
_0x3D:
; 0000 00F9   }
	ADIW R28,1
	RJMP _0x24
; 0000 00FA }
_0x3E:
	RJMP _0x3E
; .FEND
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
; .FSTART __lcd_delay_G100
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2020001
; .FEND
__lcd_read_nibble_G100:
; .FSTART __lcd_read_nibble_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G100:
; .FSTART _lcd_read_byte0_G100
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R7,Y+1
	LDD  R6,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	MOV  R6,R30
	MOV  R7,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R7,R9
	BRLO _0x2000004
	__lcd_putchar1:
	INC  R6
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R6
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	INC  R7
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2020001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000005
_0x2000007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G100:
; .FSTART __long_delay_G100
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G100:
; .FSTART __lcd_init_write_G100
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2020001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R9,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL __long_delay_G100
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(40)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(133)
	RCALL SUBOPT_0x3
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x200000B:
	CALL __lcd_ready
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
	IN   R1,22
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,4
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	CALL __long_delay_G100
	LDI  R26,LOW(48)
	RJMP __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CALL __lcd_write_data
	JMP  __long_delay_G100


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

;END OF CODE MARKER
__END_OF_CODE:
