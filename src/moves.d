/*
 * Copyright 2016-2019 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SwashRL is distributed with a special exception to the normal Apache
 * License 2.0.  See LICENSE for details.
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
