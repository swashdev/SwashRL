/*
 * Copyright 2016-2018 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License, excepting that
 * Derivative Works are not required to carry prominent notices in changed
 * files.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/* swash-tentative status: WAITING for `fdun.d' */

// fexcept.d: Exceptions for file I/O and functions for generating them

import global;

import std.format;
import std.exception : basicExceptionCtors;

/++
 + An exception for invalid save file access
 +
 + See_Also: save_error
 +/
class SaveFileException : Exception
{
  mixin basicExceptionCtors;
}

/++
 + An exception for invalid dungeon level file access
 +
 + See_Also: level_file_error
 +/
class DungeonFileException : Exception
{
  mixin basicExceptionCtors;
}

/++
 + Throws a SaveFileException
 +
 + This function throws a SaveFileException with the given `error` message.
 +
 + The message thrown will always be: "Unable to access save file (1): (2)",
 + where (1) is `save_file` and (2) is `error`
 +
 + Throws:
 +     SaveFileException
 +
 + Params:
 +     save_file = The path to the file that caused the error
 +     error = The message to be appended to the thrown `SaveFileException`
 +/
void save_error( T... )( string file, T args )
{
  throw new SaveFileException( format( "Unable to access save file %s: %s",
                                       file, format( args ) ) );
}

/++
 + Throws a DungeonFileException
 +
 + This function throws a DungeonFileException with the given `error` message.
 +
 + The message thrown will always be: "Unable to access dungeon level file
 + (1): (2)", where (1) is `dungeon_file` and (2) is `error`
 +
 + Throws:
 +     DungeonFileException
 +
 + Params:
 +     dungeon_file = The path to the file that caused the error
 +     error = The message to be appended to the thrown `SaveFileException`
 +/
void level_file_error( T... )( string dungeon_file, T args )
{
  throw new DungeonFileException(
    format( "Unable to read dungeon level file %s: %s",
    dungeon_file, format( args ) ) );
}
