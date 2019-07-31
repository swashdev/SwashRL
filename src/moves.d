/*
 * Copyright 2015-2019 Philip Pavlick
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

// Defines a number of indexes representing in-game commands.

// Standard movement
enum MOVE_NW = 7;
enum MOVE_NN = 8;
enum MOVE_NE = 9;
enum MOVE_WW = 4;
enum MOVE_EE = 6;
enum MOVE_SW = 1;
enum MOVE_SS = 2;
enum MOVE_SE = 3;
enum MOVE_WAIT = 5;

// Inventory management
enum MOVE_INVENTORY = 20;
enum MOVE_EQUIPMENT = 21;
enum MOVE_GET = 22;

// Message management
enum MOVE_MESS_DISPLAY = 30;
enum MOVE_MESS_CLEAR   = 31;

// Game management keys:
enum MOVE_SAVE = 40;

// Global "admin" keys:
enum MOVE_HELP = 0;
enum MOVE_QUIT = 10;
enum MOVE_GETVERSION = 11;
enum MOVE_ALTKEYS = 12;

// "Command not recognized" key:
enum MOVE_UNKNOWN = 255;
