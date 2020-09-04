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

// color.d: Defines classes used by SwashRL to store color values for both the
// curses and SDL terminal interfaces.

import global;

// SECTION 1: ////////////////////////////////////////////////////////////////
// Colors                                                                   //
//////////////////////////////////////////////////////////////////////////////

// A class used to store color data
class Color
{

static if( CURSES_ENABLED )
{
  private short curses_color = 7;

  public short get_curses_color()
  { return curses_color;
  }

  public void set_curses_color( short curses_color_code = 7 )
  { curses_color = curses_color_code;
  }

} /* static if( CURSES_ENABLED ) */

static if( SDL_ENABLED )
{
  private SDL_Color sdl_color = SDL_Color( 162, 162, 162, 255 );

  public SDL_Color get_sdl_color()
  { return sdl_color;
  }

  public void set_sdl_color( ubyte sdl_red = 162, ubyte sdl_green = 162,
                             ubyte sdl_blue = 162, ubyte sdl_opacity = 255 )
  { sdl_color = SDL_Color( sdl_red, sdl_green, sdl_blue, sdl_opacity );
  }

  public void set_sdl_color( SDL_Color sdl_color_object )
  { sdl_color = sdl_color_object;
  }

} /* static if( SDL_ENABLED ) */


  // Initialize a `Color` object by specifying the curses color code and the
  // RGB values for an SDL color.  As an additional option, the opacity value
  // has also been included, but should only be used sparingly.
  this( short curses_color_code, ubyte sdl_red, ubyte sdl_blue,
        ubyte sdl_green, ubyte sdl_opacity = 255 )
  {

static if( CURSES_ENABLED )
{
    curses_color = curses_color_code;
}

static if( SDL_ENABLED )
{
    sdl_color = SDL_Color( sdl_red, sdl_blue, sdl_green, sdl_opacity );
}
    
  } /* this( short, int, int, int, bool?, int? ) */

}

// SECTION 2: ////////////////////////////////////////////////////////////////
// Color Pairs                                                              //
//////////////////////////////////////////////////////////////////////////////

class Color_Pair
{

  private Color foreground, background;

  // Because of the way curses works, "bright" color values must be specified
  // here, in the color pair, because the bright colors are created by
  // applying the "bold" attribute to an existing color pair.  This does not
  // apply to SDL.
  private bool bold = false, inverted = false;

  public bool get_bright()
  { return bold;
  }

  public void set_bright( bool bright )
  { bold = bright;
  }

  public bool get_inverted()
  { return inverted;
  }

  public void set_inverted( bool reversed )
  { inverted = reversed;
  }

  // Because curses refers to color pairs by an index, we need to store what
  // the most recent index was, as well as the index of the current color
  // pair.  Note that if `last_color_pair` is 0, that means that no color
  // pairs were defined, because curses uses 0 as sort of a default color
  // pair.

  private static short last_color_pair = 0;
  private short curses_color_pair = 0;

  public short get_last_color_pair()
  { return last_color_pair;
  }

  public short get_color_pair()
  { return curses_color_pair;
  }

  public static bool color_pairs_defined()
  {
static if( CURSES_ENABLED )
{
    return (last_color_pair > 0);
}
else
{
    return false;
}
  } /* public static bool color_pairs_defined() */

  public Color get_foreground()
  { return foreground;
  }

  public void set_foreground( Color new_foreground_color )
  { foreground = new_foreground_color;
  }

  public Color get_background()
  { return background;
  }

  public void set_background( Color new_background_color )
  { background = new_background_color;
  }

  // Initialize a `Color_Pair` using an existing `Color` (or two if we want to
  // specify a background other than black).
  // If `existing_curses_color_pair` is <= 1, define a new color pair.
  // Otherwise, use an existing one.
  this( Color foreground_color,
        Color background_color = new Color( 0, 0, 0, 0 ),
        short existing_curses_color_pair = 0,
	bool is_bright = false, bool is_reversed = false )
  {
    foreground = foreground_color;
    background = background_color;

    if( existing_curses_color_pair > 0
        && existing_curses_color_pair <= last_color_pair )
    {
      curses_color_pair = existing_curses_color_pair;
    }
    else
    {
      // Initialize a curses color pair and then store the resulting index in
      // `curses_color_pair`.
      last_color_pair++;
      curses_color_pair = last_color_pair;

static if( CURSES_ENABLED )
{

      init_pair( curses_color_pair, foreground.get_curses_color(),
                 background.get_curses_color() );

} /* static if( CURSES_ENABLED ) */

    } /* else from if( existing_curses_color_pair > 0 ) */

    set_bright( is_bright );
    set_inverted( is_reversed );

  } /* this( Color, Color?, short?, bool?, bool? ) */

  // Initialize a `Color_Pair` using an existing `Color`.  This constructor
  // will always use the default black background color.
  // If `existing_curses_color_pair` is <= 1, define a new color pair.
  // Otherwise, use an existing one.
  // `is_bright` & `is_reversed` set if the color pair will be boldened or
  // inverted, respectively.  Default for both is `false`
  this( Color foreground_color,
        short existing_curses_color_pair = 0,
	bool is_bright = false, bool is_reversed = false )
  {
    this( foreground_color, new Color( 0, 0, 0, 0 ),
          existing_curses_color_pair, is_bright, is_reversed );
  } /* this( Color, short?, bool?, bool? ) */

  // Initialize a `Color_Pair` using an existing `Color`.
  // All other options, such as background color and text effects, will remain
  // at their defaults.
  this( Color foreground_color )
  {
    this( foreground_color, new Color( 0, 0, 0, 0 ), 0, false, false );
  } /* this( Color ) */

  // Initialize a new color pair by "brightening" the existing color pair.
  // By default, the SDL color codes will double unless new color codes are
  // input as parameters.
  public Color_Pair brighten()
  {

static if( !SDL_ENABLED )
{

    Color_Pair new_pair = this;

    new_pair.set_bright( true );

    return new_pair;

}
else
{
    // Attempt to intelligently double the color values.
    ubyte sdl_red, sdl_green, sdl_blue;

    Color new_foreground_color = foreground;
    SDL_Color new_foreground = foreground.get_sdl_color();

    sdl_red   = cast(ubyte)(new_foreground.r * 2);
    sdl_green = cast(ubyte)(new_foreground.g * 2);
    sdl_blue  = cast(ubyte)(new_foreground.b * 2);

    // Correct for integer overloads.
    if( sdl_red < new_foreground.r )
    { sdl_red = 255;
    }
    if( sdl_green < new_foreground.g )
    { sdl_green = 255;
    }
    if( sdl_blue < new_foreground.b )
    { sdl_blue = 255;
    }

    // Now we can brighten the foreground color.

    return brighten( sdl_red, sdl_green, sdl_blue );

} /* else from static if( !SDL_ENABLED ) */

  } /* public Color_Pair brighten() */

  public Color_Pair brighten( ubyte sdl_red, ubyte sdl_green,
                              ubyte sdl_blue, ubyte sdl_opacity = 255 )
  {

    Color_Pair new_pair = this;

    new_pair.set_bright( true );

static if( SDL_ENABLED )
{
    Color new_foreground_color = foreground;

    SDL_Color new_foreground = SDL_Color( sdl_red, sdl_green, sdl_blue,
                                          sdl_opacity );

    new_foreground_color.set_sdl_color( new_foreground );

    new_pair.set_foreground( new_foreground_color );
} /* static if( SDL_ENABLED ) */

    return new_pair;

  } /* public Color_Pair brighten( int, int, int, int? ) */

  // Initialize a new color pair by inverting the existing color pair.
  public Color_Pair invert()
  {
    Color_Pair new_pair = this;

    Color new_foreground = new_pair.get_background();
    Color new_background = new_pair.get_foreground();

    new_pair.set_foreground( new_foreground );
    new_pair.set_background( new_background );

    new_pair.set_inverted( true );

    return new_pair;
  } /* public Color_Pair invert() */

} /* class Color_Pair */
