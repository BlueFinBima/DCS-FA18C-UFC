/*
  FA18CufcDisplay.h - I2C ATtiny85 used for Master Caution LED on the UFC of A-10C
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
#ifndef FA18CufcDisplay_h
#define FA18CufcDisplay_h

#include <inttypes.h>

class FA18CufcDisplay
{
private:
	void DLG2416Display(uint8_t, char[]);
	void DLG2416Display(uint8_t, uint8_t, char[]);
public:
    FA18CufcDisplay(uint8_t);
    void clear(void);
    void blank(void);
	void display(char[]);
	void display(uint8_t, char[]);
	void oduDisplay(uint8_t, char[]);
	uint8_t deviceaddress;
};

#endif