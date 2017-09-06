/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

static if( USE_FOV )
{

  // calculate field of vision from the point (viewer_x, viewer_y)
  // this function calls calc_octant for each of the eight octants
  void calc_visible( map* to_display, uint8 viewer_x, uint8 viewer_y );

  // only use this if we HAVEN'T included the libtcod FOV header
  static if( !USE_TCOD_FOV )
  {

    // calculate the field of vision for a particular octant centered on
    // (viewer_x, viewer_y); for a detailed description of these octants, see
    // Bjorn Bergstrom's recursive shadowcasting algorithm at
// http://www.roguebasin.com/index.php?title=FOV_using_recursive_shadowcasting
    // the "visible" flag determines whether the tiles in this octant will be
    // flagged as visible by this function.  If TRUE, all tiles will be set to
    // visible by default unless they specifically block vision.  Otherwise,
    // all tiles in this octant will be set to FALSE (in order to cast shadows
    // for the recursive call)
    // this function calculates what lines need to be scanned for visibility
    // and then calls scan_row or scan_col appropriately
    void calc_octant( map* to_display, uint8 viewer_x, uint8 viewer_y,
                      int8 octant, bool visible );

    // scan a row/column for visibility (this is where the actual work happens)
    void scan_row( map* to_display, uint8 y, uint8 start_x, uint8 fin_x,
                   int8 octant, bool visible );
    void scan_col( map* to_display, uint8 x, uint8 start_y, uint8 fin_y,
                   int8 octant, bool visible );

  } /* if( !USE_TCOD_FOV ) */

} /* if( USE_FOV ) */
