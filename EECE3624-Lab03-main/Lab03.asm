/**************************************************************************
 *     File: Lab03.asm
 * Lab Name: Lab 03
 *   Author: Julia Camille McCamey
 *  Created: 09/07/2026
 *
 * This program simulates reading sensor data and doing operations on them.
 * It uses memory locations for sensors and result writes.
 * We hope to learn more about branching in assembly.
 *************************************************************************/

/************************************************************************
 * NOTE!  To populate the sensor data to memory, follow these steps!
 * 1) Set breakpoint on 1st instruction RJMP
 * 2) Set the stimulus file
 *    - Debug->Set Stimufile.  Select Lab03.stim
 *    - This only needs to be done ONCE (will save in project file)
 *    - Should be in your Project file from the Repo, but do once to be sure.
 * 3) Execute stimulus file
 *    - Debug->Execute Stimufile
 *    - This needs to be run EVERY TIME you restart a debug session.  :-(
 * 4) single step code
 * 5) Check that data IRAM at 0x0100 has changed "61 97"
 * 
 * Sensor1 Located at 0x0100 (preset to 0x61)
 * Sensor2 Located at 0x0101 (preset to 0x97)
 * 
 * NOTE:  For testing, you can modify these after loading them
 * to make sure all of your branches work properly
 ***********************************************************************/

; //Naming sensors and threshold
.equ THRESHOLD = 0x90 ; Create a constant
.def Sensor1 = R20 ; Define a nickname for R20 (unsigned)
.def Sensor2 = R21 ; Define a nickname for R21 (signed)

; //Reset
.org 0x0000 ; next instruction will be written to address 0x0000
            ; (the location of the reset vector)
RJMP main	; set reset vector to point to the main code entry point

; //Pointers initialization
main:       ; jump here on reset

	; initialize the stack (RAMEND = 0x10FF by default for the ATmega128A)
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	LDI R16, low(RAMEND)
	OUT SPL, R16

    ;----------------------------------

; //Loading sensor values (box 1)
LDI YH, HIGH(0x0100)
LDI YL, LOW(0x0100)
LD Sensor1, Y+
LD Sensor2, Y

; //Sensor1 >= THRESHOLD y=0x46 at 0x0110, n=0x50 at 0x0110
LDI YH, HIGH(0x0100)
LDI YL, LOW(0x0100)	
LDI R22, THRESHOLD
CP Sensor1, R22
BRSH Sensor1Y               ; branch yes

; //Branches Sensor1
Sensor1N: LDI R23, 0x50
		  ST Y+, R23        ; Y points to 0x0111
		  RJMP Sensor1Store ; skip branch yes
Sensor1Y: LDI R23, 0x46
		  ST Y+, R23        ; Y points to 0x0111

; //Store Sensor1 in 0x0111
Sensor1Store: ST Y+, Sensor1

; //Sensor2 < THRESHOLD y==>i at 0x0112 n==>s at 0x0112
LDI R22, THRESHOLD
CP Sensor2, R22
BRLT Sensor2Y               ; branch yes

; //Branches Sensor2
Sensor2N: LDI R23, 's'
		  ST Y+, R23        ; Y points to 0x0113
		  RJMP Sensor12Compare
Sensor2Y: LDI R23, 'i'
		  ST Y+, R23        ; Y points to 0x0113

; //Sensor1 != Sensor2
Sensor12Compare: CP Sensor1, Sensor2
				 BRNE NotEqual

; //Branches compare
Equal: LDI R23, 0x08
	   ST Y, R23
	   RJMP Done
NotEqual: LDI R23, 0x15
		  ST Y, R23

Done:
nop

