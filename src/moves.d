/*
 * Copyright (c) 2015-2020 Philip Pavlick.  See '3rdparty.txt' for other
 * licenses.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of the SwashRL project nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

// moves.d: defines a number of indexes representing in-game commands.

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
enum MOVE_GET  = 22;
enum MOVE_DROP = 23;

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
