/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
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
enum MOVE_WIELD = 21;
enum MOVE_GET = 22;

// Message management
enum MOVE_MESS_DISPLAY = 30;
enum MOVE_MESS_CLEAR   = 31;

// Global "admin" keys:
enum MOVE_HELP = 0;
enum MOVE_QUIT = 10;
enum MOVE_GETVERSION = 11;
enum MOVE_ALTKEYS = 12;

// "Command not recognized" key:
enum MOVE_UNKNOWN = 255;
