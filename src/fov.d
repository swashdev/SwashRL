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
 */

/* This source code has been modified from its original Doryen library
 * implementation to work in Spelunk! - Philip Pavlick
 */

import global;

static if( USE_FOV )
{

import std.math: sqrt;

static int[][] mult = [
  [1,0,0,-1,-1,0,0,1],
  [0,1,-1,0,0,-1,1,0],
  [0,1,1,0,0,-1,-1,0],
  [1,0,0,1,-1,0,0,-1]
];

void cast_light( map* to_display, int cx, int cy, int row, float start,
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

void TCOD_map_compute_fov_recursive_shadowcasting(
    map* to_display, int player_x, int player_y, int max_radius,
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

/* This function, added for Spelunk!, is a shortcut for the recursive
 * shadowcasting function we'll be calling most frequently. - Philip Pavlick
 */
void calc_visible( map* to_display, ushort viewer_x, ushort viewer_y )
{
  TCOD_map_compute_fov_recursive_shadowcasting(
    to_display, viewer_x, viewer_y, 0, true );
}

} // static if( USE_FOV )
