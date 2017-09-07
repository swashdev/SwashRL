/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

void display( ubyte y, ubyte x, symbol s, bool center )
{
  mvaddch( y, x, s.ch );

  static if( TEXT_EFFECTS )
  { mvchgat( y, x, 1, s.color, 0, NULL );
  }

  if( !center )
  { move( y, x + 1 );
  }
}

void display_player( player u )
{
  display( u.y + Y_OFFSET, u.x, u.sym, 1 );
}

void display_mon( monst m )
{
  display( m.y + Y_OFFSET, m.x, m.sym, 1 );
}

void display_map_mons( map to_display )
{
  uint c, d = to_display.m.length;
  monst mn;
  for( c = 0; c < d; c++ )
  {
    mn = to_display.m[c];
static if( USE_FOV )
{
    if( to_display.v[mn.y][mn.x] )
    { display_mon( mn );
    }
}
else
{
    display_mon( mn );
} /* static if( USE_FOV ) */
  }
}

void display_map( map to_display )
{
  char output; ubyte y, x;
  for( y = 0; y < MAP_Y; y++ )
    for( x = 0; x < 80; x++ )
    {
      symbol output = to_display.t[y][x].sym;

static if( USE_FOV )
{
      if( !to_display.v[y][x] )
      {
        output = SYM_SHADOW;
        goto dispoutput;
      }
} /* static if( USE_FOV ) */
      if( to_display.i[y][x].sym.ch != '\0' )
      { output = to_display.i[y][x].sym;
      }

dispoutput:
      display( y + 1, x, output, 0 );
    }
}

void display_map_all( map to_display )
{
  display_map( to_display );
  display_map_mons( to_display );
}

void display_map_and_player( map to_display, player u )
{
  display_map_all( to_display );
  display_player( u );
}

void clear_message_line()
{
  ubyte y;
  for( y = 0; y < MESSAGE_BUFFER_LINES; y++ )
  {
    ubyte x;
    for( x = 0; x < MAP_X; x++ )
    { display( y, x, symdata( ' ', A_NORMAL ), 0 );
    }
  }
}

void refresh_status_bar( player* u )
{
  int hp = u.hp;
  ubyte dice = u.attack_roll.dice + u.inventory.items[INVENT_WEAPON].addd;
  short mod = u.attack_roll.modifier + u.inventory.items[INVENT_WEAPON].addm;
  ubyte x;
  for( x = 0; x < MAP_X; x++ )
  { mvaddch( 1 + MAP_Y, x, ' ' );
  }
  mvprintw( 1 + MAP_Y, 0, "HP: %d    Attack: %ud %c %u",
            hp, dice, mod >= 0 ? '+' : '-', mod * ((-1) * mod < 0) );
}
