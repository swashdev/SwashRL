/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "global.h"

# define Y_OFFSET RESERVED_LINES

void display( uint8 y, uint8 x, symbol s, bool center )
{
  mvaddch( y, x, s.ch );
#ifdef TEXT_EFFECTS
  mvchgat( y, x, 1, s.color, 0, NULL );
#endif /* def TEXT_EFFECTS */
  if( !center )
    move( y, x + 1 );
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
  unsigned short int c, d = to_display.m_siz;
  monst mn;
  for( c = 0; c < d; c++ )
  {
    mn = to_display.m[c];
#ifdef USE_FOV
    if( to_display.v[mn.y][mn.x] )
    { display_mon( mn );
    }
#else
    display_mon( mn );
#endif /* def USE_FOV */
  }
}

void display_map( map to_display )
{
  char output; int y, x;
  for( y = 0; y < MAP_Y; y++ )
    for( x = 0; x < 80; x++ )
    {
      symbol output = to_display.t[y][x].sym;

#ifdef USE_FOV
      if( !to_display.v[y][x] )
      { output = SYM_SHADOW;
      }
      else
#endif /* def USE_FOV */
      if( to_display.i[y][x].sym.ch != '\0' )
      { output = to_display.i[y][x].sym;
      }

dispoutput:
      display( y + Y_OFFSET, x, output, 0 );
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
  uint8 y;
  for( y = 0; y < MESSAGE_BUFFER_LINES; y++ )
  {
    uint8 x;
    for( x = 0; x < MAP_X; x++ )
    { display( y, x, symdata( ' ', A_NORMAL ), 0 );
    }
  }
}

void refresh_status_bar( player* u )
{
  int32 hp = u->hp;
  uint8 dice = u->attack_roll.dice + u->inventory.items[INVENT_WEAPON].addd;
  int16 mod = u->attack_roll.modifier + u->inventory.items[INVENT_WEAPON].addm;
  uint8 x;
  for( x = 0; x < MAP_X; x++ )
  { mvaddch( MESSAGE_BUFFER_LINES + MAP_Y, x, ' ' );
  }
  mvprintw( MESSAGE_BUFFER_LINES + MAP_Y, 0, "HP: %d    Attack: %ud %c %u",
            hp, dice, mod >= 0 ? '+' : '-', mod * ((-1) * mod < 0) );
}

#if 0

void display( map to_display, player u, bool skip_message_line )
{
  /* Leave the message line blank unless instructed to do otherwise */
  if( !skip_message_line )
    putch( '\n' );
  else
    printf( "  Press ENTER to continue\n" );

  /* Now we display the map */
  uint8 y, x;
  for( y = 0; y < MAP_Y; y++ )
  {
    for( x = 0; x < MAP_X; x++ )
    {
      /* first check if the player should go in this spot */
      if( x == u.x && y == u.y )
      { putch( '@' );
      }
      /* next check for monsters */
      else
      {
        bool monhere = FALSE;
        uint16 mindex;
        monst m;
        for( mindex = 0; mindex < to_display.m_siz; mindex++ )
        {
          m = to_display.m[mindex];
          if( x = m.x && y = m.y )
          {
            putch( m.sym );
            monhere = TRUE;
            break;
          }
        }

        /* now output tile data */
        if( !monhere )
        {
          tile t = to_display.t[y][x];
          if( t & WALL ) putch( '#' );
          else if( t & WATER ) putch( '{' );
          else putch( '.' );
        }
      }
    }
  }

  /* Next do the status line */
  int32 hp = u.hp;
  uint8 dice = u->attack_roll.dice;
  int16 mod = u->attack_roll.modifier;
  printf( "HP: %d    %ud %c %u dice",
          hp, dice, mod < 0 ? '-' : '+', mod * ((-1) * (mod < 0))
        );
}

#endif /* ANY_CURSES */
