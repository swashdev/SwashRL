/*
 * libtcod 1.6.3
 * Copyright (c) 2008,2009,2010,2012,2013,2016,2017 Jice & Mingos & rmtew
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * The name of Jice or Mingos may not be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY JICE, MINGOS AND RMTEW ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL JICE, MINGOS OR RMTEW BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * This source code has been modified from its original Doryen library
 * implementation by Philip Pavlick to work in SwashRL.  The SwashRL license
 * follows.
 *
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

import global;

import std.math: sqrt;

static int[][] mult = [
  [1,0,0,-1,-1,0,0,1],
  [0,1,-1,0,0,-1,1,0],
  [0,1,1,0,0,-1,-1,0],
  [1,0,0,1,-1,0,0,-1]
];

/++
 + Recursively calculates field-of-vision in a sector of the given map
 +
 + This function is used by `TCOD_map_compute_fov_recursive_shadowcasting`
 + to do the number-crunching for the recursive shadowcasting algorithm.  Its
 + job is to calculate the field-of-vision in a sector and recursively
 + generate new sectors in order to cast shadows realistically.
 +
 + This function has been changed from its original version to work with
 + SwashRL.
 +
 + <b>Note</b>:  I haven't bothered listing the parameters for this function
 + because to be honest I don't fully understand everything that it does.
 + That's why I took someone else's implementation instead of coding one up
 + myself.
 +
 + Authors:
 +   Bjorn Bergstrom, Jice, Mingos, rmtew
 +
 + Origin:
 +   libtcod
 +
 + License:
 +   BSD 3-clause
 +
 + See_Also:
 +   <a href="http://www.roguebasin.com/index.php?title=FOV_using_recursive_shadowcasting">Roguebasin:  FOV using recursive shadowcasting</a>
 +/
void cast_light( Map* to_display, int cx, int cy, int row, float start,
                 float end, int radius, int r2, int xx, int xy, int yx,
                 int yy, int id, bool light_walls)
{
  float new_start=0.0f;
  if ( start < end )
  { return;
  }
  foreach (j; row .. radius+1)
  {
    int dx=-j-1;
    int dy=-j;
    bool blocked=false;
    while ( dx <= 0 )
    {
      int X,Y;
      dx++;
      X=cx+dx*xx+dy*xy;
      Y=cy+dx*yx+dy*yy;
      if (X < MAP_X && Y < MAP_Y)
      {
        float l_slope,r_slope;
        l_slope=(dx-0.5f)/(dy+0.5f);
        r_slope=(dx+0.5f)/(dy-0.5f);
        if( start < r_slope )
        { continue;
        }
        else if( end > l_slope )
        { break;
        }
        if ( dx*dx+dy*dy <= r2
             && (light_walls || !(to_display.t[Y][X].block_vision))
           )
        {
          to_display.v[Y][X] = true;
          to_display.t[Y][X].seen = true;
        }
        if ( blocked )
        {
          if (to_display.t[Y][X].block_vision)
          {
            new_start=r_slope;
            continue;
          }
          else
          {
            blocked=false;
            start=new_start;
          }
        }
        else
        {
          if ((to_display.t[Y][X].block_vision) && j < radius )
          {
            blocked=true;
            cast_light(to_display,cx,cy,j+1,start,l_slope,radius,r2,xx,xy,yx,
                       yy,id+1,light_walls);
            new_start=r_slope;
          }
        }
      }
    }
    if ( blocked )
    { break;
    }
  }
}

/++
 + Calculates field-of-vision using the Recursive Shadowcasting algorithm
 +
 + This function modifies the given map to update the visibility of each tile
 + using Bjorn Bergstrom's recursive shadowcasting algorithm.
 +
 + This function has been changed from its original version to work with
 + SwashRL.
 +
 + Authors:
 +   Bjorn Bergstrom, Jice, Mingos, rmtew
 +
 + Origin:
 +   libtcod
 +
 + License:
 +   BSD 3-clause
 +
 + See_Also:
 +   <a href="http://www.roguebasin.com/index.php?title=FOV_using_recursive_shadowcasting">Roguebasin:  FOV using recursive shadowcasting</a>
 +
 + Params:
 +   to_display  = A pointer to the map whose field-of-vision data is to be
 +                 modified
 +   player_x    = The starting x coordinate for the field-of-vision
 +                 calculation
 +   player_y    = The starting y coordinate for the field-of-vision
 +                 calculation
 +   max_radius  = The maximum radius to calculate field-of-vision for; `0`
 +                 means infinite
 +   light_walls = Whether or not to illuminate walls
 +/
void TCOD_map_compute_fov_recursive_shadowcasting(
    Map* to_display, int player_x, int player_y, int max_radius,
    bool light_walls)
{
  int r2;
  /* clean the map */
  foreach (c; 0 .. MAP_Y)
  { foreach (d; 0 .. MAP_X)
    { to_display.v[c][d] = false;
    }
  }
  if ( max_radius == 0 )
  {
    int max_radius_x=MAP_X-player_x;
    int max_radius_y=MAP_Y-player_y;
    max_radius_x=max_radius_x > player_x ? max_radius_x : player_x;
    max_radius_y=max_radius_y > player_y ? max_radius_y : player_y;
    max_radius = cast(int)(sqrt(cast(float)(max_radius_x*max_radius_x)
               +(max_radius_y*max_radius_y))) +1;
  }
  r2=max_radius*max_radius;
  /* recursive shadow casting */
  foreach (oct; 0 .. 8)
  {
    cast_light(to_display,player_x,player_y,1,1.0,0.0,max_radius,r2,
    mult[0][oct],mult[1][oct],mult[2][oct],mult[3][oct],0,light_walls);
  }
  to_display.v[player_y][player_x] = true;
}

/++
 + A shortcut for the recursive shadowcasting functions
 +
 + This function was added specifically for SwashRL to quickly do the call to
 + `TCOD_map_compute_fov_recursive_shadowcasting` that would most frequently
 + be required.
 +
 + This function takes in a pointer to a `map` and the coordinates of the
 + viewer and modifies the `map` data to update the viewer's field-of-view.
 +
 + Params:
 +   to_display = A pointer to the map whose field-of-vision is to be
 +                calculated and updated
 +   viewer_x   = The x coordinate of the start point for field-of-vision
 +                calculation
 +   viewer_y   = The y coordinate of the start point for field-of-vision
 +                calculation
 +/
void calc_visible( Map* to_display, uint viewer_x, uint viewer_y )
{
  TCOD_map_compute_fov_recursive_shadowcasting(
    to_display, viewer_x, viewer_y, 0, true );
}
