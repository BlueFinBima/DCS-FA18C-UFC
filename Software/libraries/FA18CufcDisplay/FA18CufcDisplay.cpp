/*
  FA18CufcDisplay.cpp - I2C F/A-18C UFC Character displays
  Revision 1.1
  Copyright (c) 2015 Neil Larmour.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/
#include "FA18CufcDisplay.h"

#if (ARDUINO >= 100)
#include <Arduino.h>
#else
#include <WProgram.h>
#endif

#include <Wire.h>
#include <inttypes.h>

// DDLR2416 4 character matrix display bit definitions
//
//high byte
#define DLG2416_¬BLANK  0b01111111
#define DLG2416_UNUSED  0b10111111
#define DLG2416_¬CLEAR  0b11011111
#define DLG2416_ADDR    0b00011111
// low byte
#define DLG2416_¬WRITE  0b01111111
#define DLG2416_DATA    0b01111111

FA18CufcDisplay::FA18CufcDisplay(uint8_t address)
{
    deviceaddress = address;
}

void FA18CufcDisplay::clear()
{
  Wire.beginTransmission(deviceaddress);
  // Clear display
  Wire.write(0b10000000);  // keep write off
  Wire.write(0b00000000);  // clear the display
  Wire.write(0b10000000);  // keep write off
  Wire.write(0b10100000);  // reset the clear and blank flags
  Wire.endTransmission();
  //return true;
}
void FA18CufcDisplay::blank(void)
{
  Wire.beginTransmission(deviceaddress);
  Wire.write(0b10000000);  // keep write off
  Wire.write(0b00100000);  // blank the display without clearing
  Wire.endTransmission();
  delay(10);
}
void FA18CufcDisplay::display(char *text)
{
	// write 7 characters to the main display which is complicated
	// by the fact that we use the rightmost 3 chars in display 6
	//	uint8_t j = 0;
	// Code to write the scratchpad when the leftmost character is masked 
	//for (j = 0; j<3; j++) {
	//	// first three chars are written individually
	//	DLG2416Display(6, j+1,&text[j]);
	//}
	//DLG2416Display(5, &text[j]); // write the complete display 5
	//
	//
	// write 8 characters to the main display
	uint8_t j = 0;
	for (uint8_t i = 6; i > 4; i--) {
		DLG2416Display(i, &text[j]);
		j += 4;
	}
}
void FA18CufcDisplay::display(uint8_t strNumber,char *text)
{
	// This format is used for the dual character strings at the beginning of the main display.
	//// This is complicated by them spanning display 7 and the first character of display 6.
	//if (text[1] == '-' && text[0] != 'A') {
	//	// if the first character is a dash, do a second one to mimic display
	//	DLG2416Display(7, strNumber * 2 + 1, &text[1]);
	//}
	//else {
	//	DLG2416Display(7, strNumber * 2 + 1, &text[0]);
	//}
	//if (strNumber == 0) {
	//	DLG2416Display(7, strNumber * 2 + 2, &text[1]);
	//}
	//else {
	//	DLG2416Display(6, 0, &text[1]);
	//}

	// =============================
	// This format is used for the dual character strings at the beginning of the main display.
	// 
	if (text[1] == '-' && text[0] != 'A') {
		// if the first character is a dash, do a send one to mimic display
		DLG2416Display(7, strNumber * 2, &text[1]);
	}
	else {
		DLG2416Display(7, strNumber * 2, &text[0]);
	}
	DLG2416Display(7, strNumber * 2 + 1, &text[1]);
}
void FA18CufcDisplay::oduDisplay(uint8_t ODUNumber,char *text)
{
	if (ODUNumber < 1 || ODUNumber >5) {}
	else {
		ODUNumber = 5 - ODUNumber;
		DLG2416Display(ODUNumber, text);
	}

}
void FA18CufcDisplay::DLG2416Display(uint8_t DLGNumber, char *text) {
	Wire.beginTransmission(deviceaddress);
	for (uint8_t i = 0; i < 4; i++) {
		if (text[i] == '\n' || text[i] == '\0') text[i] = ' ';
		Wire.write(text[i]); // set data with write low
		Wire.write(0xa0 + (DLGNumber << 2) + 3 - i); // turn off blank by setting ¬blank high and turn off clear
		Wire.write(0x80 | text[i]); // bring write high
		Wire.write(0xa0 + (DLGNumber << 2) + 3 - i); // turn off blank by setting ¬blank high and turn off clear
	}
	Wire.endTransmission();
}
void FA18CufcDisplay::DLG2416Display(uint8_t DLGNumber, uint8_t charNumber, char *text) {
	// this is used to write to specific character positions within a display
	Wire.beginTransmission(deviceaddress);
	//charNumber = 3 - charNumber;
	if (text[0] == '\n' || text[0] == '\0') text[0] = ' ';
	Wire.write(text[0]); // set data with write low
	Wire.write(0xa0 + (DLGNumber << 2) + 3 - charNumber); // turn off blank by setting ¬blank high and turn off clear
	Wire.write(0x80 | text[0]); // bring write high
	Wire.write(0xa0 + (DLGNumber << 2) + 3 - charNumber); // turn off blank by setting ¬blank high and turn off clear
	Wire.endTransmission();
}
