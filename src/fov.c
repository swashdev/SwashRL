/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "global.h"

#ifdef USE_FOV

void calc_visible( map* to_display, uint8 viewer_x, uint8 viewer_y )
{
# ifdef TCOD_FOV_H
/* if we have the tcod field-of-view header, this function acts as a shortcut
 * to it */
  TCOD_map_compute_fov_recursive_shadowcasting(
    to_display, viewer_x, viewer_y, 0, TRUE );
}
# else /* ifndef TCOD_FOV_H */
  /* first clear the visibility array */
  uint8 x, y;
  for( y = 0; y < MAP_Y; y++ )
  { for( x = 0; x < MAP_X; x++ )
    { to_display->v[y][x] = TRUE;
    }
  }

  int8 oct;
  for( oct = 0; oct <= 7; oct++ )
  {
    calc_octant( to_display, viewer_x, viewer_y, oct, TRUE );
  }
}

void scan_row( map* to_display, uint8 y, uint8 start_x, uint8 fin_x,
               int8 octant, bool visible )
{
  uint8 x = start_x;
  bool skip_walls = FALSE;
  while( within_minmax( x, 0, MAP_x ) )
  {
    if( !visible )
    { to_display->v[y][x] = FALSE;
    }
    else
    {
      if( to_display->t[y][x] & BLOCK_VISION )
      {
        /* if a wall is found, calculate an octant extending from here to
         * fill with shadow */
        calc_octant( to_display, x, y, octant, FALSE );
      }
    }

    if( start_x > fin_x )
    {
      if( x > fin_x )
      { x--;
      }
      else
      { break;
      }
    }
    else if( start_x < fin_x )
    {
      if( x < fin_x )
      { x++;
      }
      else
      { break;
      }
    }
    else /* if start_x == fin_x */
    { break;
    }
  }
}

void scan_col( map* to_display, uint8 x, uint8 start_y, uint8 fin_y,
               int8 octant, bool visible )
{
  uint8 y = start_y;
  bool skip_walls = FALSE;
  while( within_minmax( y, 0, MAP_y ) )
  {
    if( !visible )
    { to_display->v[y][x] = FALSE;
    }
    else
    {
      if( to_display->t[y][x] & BLOCK_VISION )
      {
        /* if a wall is found, calculate an octant extending from here to
         * fill with shadow */
        calc_octant( to_display, x, y, octant, FALSE );
        skip_walls = TRUE;
      }
    }

    if( start_y > fin_y )
    {
      if( y > fin_y )
      { y--;
      }
      else
      { break;
      }
    }
    else if( start_y < fin_y )
    {
      if( y < fin_y )
      { y++;
      }
      else
      { break;
      }
    }
    else /* if start_y == fin_y */
    { break;
    }
  }
}

void calc_octant( map* to_display, uint8 viewer_x, uint8 viewer_y,
                  int8 octant, bool visible )
{
  int8 x, y;
  switch( octant )
  {
    case 0:
      x = viewer_x + 1;
      y = viewer_y - 1;
      while( y >= 0 )
      {
        scan_row( to_display, y, x, viewer_x, octant, visible );
        y--;
        if( x < MAP_x ) x++;
      }
      break;
    case 1:
      x = viewer_x + 1;
      y = viewer_y - 1;
      while( x <= MAP_x )
      {
        scan_col( to_display, x, y, viewer_y, octant, visible );
        if( y > 0     ) y--;
        x++;
      }
      break;
    case 2:
      x = viewer_x + 1;
      y = viewer_y + 1;
      while( x <= MAP_x )
      {
        scan_col( to_display, x, y, viewer_y, octant, visible );
        if( y < MAP_y ) y++;
        x++;
      }
      break;
    case 3:
      x = viewer_x + 1;
      y = viewer_y + 1;
      while( y <= MAP_y )
      {
        scan_row( to_display, y, x, viewer_x, octant, visible );
        y++;
        if( x < MAP_x ) x++;
      }
      break;
    case 4:
      x = viewer_x - 1;
      y = viewer_y + 1;
      while( y <= MAP_y )
      {
        scan_row( to_display, y, x, viewer_x, octant, visible );
        if( x > 0     ) x--;
        y++;
      }
      break;
    case 5:
      x = viewer_x - 1;
      y = viewer_y + 1;
      while( x >= 0 )
      {
        scan_col( to_display, x, y, viewer_y, octant, visible );
        x--;
        if( y < MAP_y ) y++;
      }
      break;
    case 6:
      x = viewer_x - 1;
      y = viewer_y - 1;
      while( x >= 0 )
      {
        scan_col( to_display, x, y, viewer_y, octant, visible );
        x--;
        if( y > 0     ) y--;
      }
      break;
    case 7:
      x = viewer_x - 1;
      y = viewer_y - 1;
      while( y >= 0 )
      {
        scan_row( to_display, y, x, viewer_x, octant, visible );
        if( x > 0     ) x--;
        y--;
      }
      break;
  }
}

# endif /* def TCOD_FOV_H */

#endif /* def USE_FOV */

/* octants used for Bergstrom's recursive shadowcasting algorithm:
 * (Bergstrom originally used one-counted numbering for their examples, with 1
 * being in the upper-left, but I've zero-counted them and started with 0 in
 * the upper-right to make calculations slightly easier)
 *            Shared
 *            edge by
 * Shared     7 & 0      Shared
 * edge by\      |      /edge by
 * 6 & 7   \     |     / 0 & 1
 *          \7777|0000/
 *          6\777|000/1
 *          66\77|00/11
 *          666\7|0/111
 * Shared   6666\|/1111  Shared
 * edge by-------@-------edge by
 * 5 & 6    5555/|\2222  1 & 2
 *          555/4|3\222
 *          55/44|33\22
 *          5/444|333\2
 *          /4444|3333\
 * Shared  /     |     \ Shared
 * edge by/      |      \edge by
 * 4 & 5      Shared     2 & 3
 *            edge by 
 *            3 & 4
 */
