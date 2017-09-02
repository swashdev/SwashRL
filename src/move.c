/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "global.h"

#include <stdlib.h>

int getcommand( bool alt_hjkl )
{
  uint16 c = getch();
#if 0 /* debug stuff */
  mvprintw( 0, 0, "Mov: %c alt_hjkl: %u", c, alt_hjkl );
  getch();
#endif
  switch( c )
  {
    case 'y':
      if( alt_hjkl == TRUE )
      { return MOVE_HELP;
      }
    case '7':
    case KEY_HOME:
      return MOVE_NW;
      break;
    case 'k':
    case '8':
    case KEY_UP:
      return MOVE_NN;
      break;
    case 'u':
      if( alt_hjkl == TRUE )
      { return MOVE_NW;
      }
    case '9':
    case KEY_PPAGE: /* pgup */
      return MOVE_NE;
      break;
    case 'l':
    case '6':
    case KEY_RIGHT:
      return MOVE_EE;
      break;
    case 'n':
      if( alt_hjkl == TRUE )
      { return MOVE_SW;
      }
    case '3':
    case KEY_NPAGE: /* pgdn */
      return MOVE_SE;
      break;
    case 'j':
    case '2':
    case KEY_DOWN: /* numpad "down" */
      return MOVE_SS;
      break;
    case 'b':
      if( alt_hjkl == TRUE )
      { return MOVE_INVENTORY;
      }
    case '1':
    case KEY_END:
      return MOVE_SW;
      break;
    case 'h':
    case '4':
    case KEY_LEFT:
      return MOVE_WW;
      break;
    case MV_WT:
    case NP_WT:
      return MOVE_WAIT;
      break;

/* numpad controls (Windows-specific) */
#ifdef WINDOWS
    case KEY_A1:
      return MOVE_NW;
    case KEY_A2:
      return MOVE_NN;
    case KEY_A3:
      return MOVE_NE;
    case KEY_B1:
      return MOVE_WW;
    case KEY_B2:
      return MOVE_WAIT;
    case KEY_B3:
      return MOVE_EE;
    case KEY_C1:
      return MOVE_SW;
    case KEY_C2:
      return MOVE_SS;
    case KEY_C3:
      return MOVE_SE;
#endif /* WINDOWS */

    case 'i':
      if( alt_hjkl == TRUE )
      { return MOVE_NE;
      }
      return MOVE_INVENTORY;
      break;
    case 'm':
      if( alt_hjkl == TRUE )
      { return MOVE_SE;
      }
      return MOVE_HELP;
      break;

    case KEY_F12: /* F12 key */
      return MOVE_ALTKEYS;

    case KY_GET:
      return MOVE_GET;

    case KY_MESS:
      return MOVE_MESS_DISPLAY;
    case KY_CLEAR:
      return MOVE_MESS_CLEAR;

    case KY_QUIT:
      return MOVE_QUIT;

    case KY_VERSION:
      return MOVE_GETVERSION;

    default:
    case KY_HELP:
      return MOVE_HELP;
  }
}

void getdydx( short int dir, short int* dy, short int* dx )
{
  switch( dir )
  {
    case MOVE_NW:
      *dy = -1;
      *dx = -1;
      break;
    case MOVE_NN:
      *dy = -1;
      *dx =  0;
      break;
    case MOVE_NE:
      *dy = -1;
      *dx =  1;
      break;
    case MOVE_EE:
      *dy =  0;
      *dx =  1;
      break;
    case MOVE_SE:
      *dy =  1;
      *dx =  1;
      break;
    case MOVE_SS:
      *dy =  1;
      *dx =  0;
      break;
    case MOVE_SW:
      *dy =  1;
      *dx = -1;
      break;
    case MOVE_WW:
      *dy =  0;
      *dx = -1;
      break;

    default:
      *dy =  0;
      *dx =  0;
      break;
  }
}

void mattacku( monst* m, player* u )
{
  dieroll_t atk = rollbag( m->attack_roll );
  if( atk > 0 )
  {
    u->hp -= atk;
    /* TODO: Figure out message formatting--probably have to write your own
     * version of sprintf since the standard ones aren't working */
#if 0
    message( "It attacks you!" );
#else
    mvprintw( 0, 0, "The %s attacks you!", m->name );
    buffer_message();
#endif
  }
  else
  {
#if 0
    message( "It barely misses you!" );
#else
    mvprintw( 0, 0, "The %s barely misses you!", m->name );
    buffer_message();
#endif
  }
}

void uattackm( player* u, monst* m )
{
  int8 mod = u->attack_roll.modifier + u->inventory.items[INVENT_WEAPON].addm;
  int8 dice = u->attack_roll.dice + u->inventory.items[INVENT_WEAPON].addd;
  dieroll_t atk = roll_x( dice, mod,
                          u->attack_roll.floor, u->attack_roll.ceiling );

  if( atk > 0 )
  {
    m->hp -= atk;
#if 0
    message( "You attack it!" );
#else
    mvprintw( 0, 0, "You attack the %s!", m->name );
    buffer_message();
#endif
  }
  else
  {
#if 0
    message( "You barely miss it!" );
#else
    mvprintw( 0, 0, "You barely miss the %s!", m->name );
    buffer_message();
#endif
  }

  if( m->hp <= 0 )
  {
#if 0
    message( "It is slain!" );
#else
    mvprintw( 0, 0, "The %s is slain!", m->name );
    buffer_message();
#endif
  }
#if 0 /* debug stuff! */
  else
  {
    getch();
    clear_message_line();
    mvprintw( 0, 0, "The %s has %d hit points left.",
              m->name, m->hp );
  }
#endif
  move( u->y + RESERVED_LINES, u->x );
}

#define FLOOR_HERE 0
#define WALL_HERE  1
#define WATER_HERE 2
#define MOVEMENT_IMPOSSIBLE 3

#define CAN_NOT_FLY 0
#define CAN_FLY     1
#define IS_FLYING   2

#define CAN_NOT_SWIM  0
#define CAN_SWIM      1
#define CAN_ONLY_SWIM 2

void mmove( monst* mn, map* m, short int idy, short int idx, player* u )
{
  short int dy = idy, dx = idx;

  unsigned short int pause = 0;
  unsigned short int terrain = 0, monster = 0;

  dx = dx + mn->x; dy = dy + mn->y;
  bool cardinal = dx == 0 || dy == 0;

  if( (cardinal && (m->t[dy][dx].block_cardinal_movement))
  || (!cardinal && (m->t[dy][dx].block_diagonal_movement)) )
  {
    terrain = WALL_HERE;
  }
  else
  {
    if( (m->t[dy][dx].hazard & HAZARD_WATER) && mn->swim == CAN_NOT_SWIM )
    {
      terrain = WATER_HERE;
    }
    else if( !(m->t[dy][dx].hazard & HAZARD_WATER)
             && mn->swim == CAN_ONLY_SWIM )
    {
      terrain = MOVEMENT_IMPOSSIBLE;
    }
  }

  if( terrain )
  {
    /* Attempt to have the monster navigate around obstacles */
    if( terrain == WATER_HERE && mn->fly == CAN_FLY )
    {
      mn->fly = IS_FLYING;
    }
    else if( terrain == WALL_HERE || mn->fly == CAN_NOT_FLY )
    {
      /* TODO: Definitely need better colission checking here.  Maybe a
       * function should be written to determine if a monster can step in a
       * certain tile. */
      if( !m->t[dy][mn->x].block_cardinal_movement )
      {
        dx = mn->x;
      }
      else if( !m->t[mn->y][dx].block_cardinal_movement )
      {
        dy = mn->y;
      }
    }
  }
  

  if( dx == u->x && dy == u->y )
  {
    mattacku( mn, u );
    monster = 1;
  }
  else
  {
    int c, d = m->m_siz;
    for( c = 0; c < d; c++ )
    {
      if( m->m[c].x == dx && m->m[c].y == dy )
      {
        monster = 1;
      }
    }
  }

  if( !monster )
  {
    mn->x = dx; mn->y = dy;
  }
}

#undef CAN_NOT_SWIM
#undef CAN_SWIM
#undef CAN_ONLY_SWIM

#undef CAN_NOT_FLY
#undef CAN_FLY
#undef IS_FLYING

#undef FLOOR_HERE
#undef WALL_HERE
#undef WATER_HERE
#undef MOVEMENT_IMPOSSIBLE

void monstai( map* m, unsigned int index, player* u )
{
  monst* mn = &m->m[index];
  int mnx = mn->x, mny = mn->y, ux = u->x, uy = u->y,
    dx = 0, dy = 0;
  if( mnx > ux )
    dx = -1;
  if( mnx < ux )
    dx =  1;
  if( mny > uy )
    dy = -1;
  if( mny < uy )
    dy =  1;
  mmove( mn, m, dy, dx, u );
}

uint8 umove( player* u, map* m, unsigned short int dir )
{
  if( dir == MOVE_GET )
  {
    if( upickup( u, m->i[u->y][u->x] ) )
    {
      m->i[u->y][u->x] = No_item;
      return 1;
    }
    return 0;
  }
  if( dir == MOVE_INVENTORY )
  { return uinventory( u );
  }
  short int dy, dx;
  getdydx( dir, &dy, &dx );
  bool cardinal = dy == 0 || dx == 0;

  unsigned short int terrain = 0, monster = 0;

  dx = dx + u->x; dy = dy + u->y;

  int c, d = m->m_siz;
  monst* mn;
  for( c = 0; c < d; c++ )
  {
    mn = &m->m[c];
    if( mn->x == dx && mn->y == dy && mn->hp > 0 )
    {
      uattackm( u, mn );
      monster = 1;
      break;
    }
  }

  if( (cardinal && (m->t[dy][dx].block_cardinal_movement))
  || (!cardinal && (m->t[dy][dx].block_diagonal_movement)) )
  {
    message( "Ouch!  You walk straight into a wall!" );
    /* report "no movement" to the mainloop so we don't expend a turn */
    return 0;
  }
  else
  {
    if( m->t[dy][dx].hazard & HAZARD_WATER )
    {
      u->hp = 0;
message( "You step into the water and are pulled down by your equipment..." );
    }
  }

  if( m->i[dy][dx].sym.ch != '\0' )
  {
#if 0
    message( "You see here an old sword." );
#else
    mvprintw( 0, 0, "You see here a %s", m->i[dy][dx].name );
    buffer_message();
#endif
  }

  if( monster || terrain )
  {
    dx = 0; dy = 0;
  }
  else
  {
    mvaddch( u->y + RESERVED_LINES, u->x, '.' );
    u->y = dy; u->x = dx;
  }

  return 1;
}

void map_move_all_monsters( map* m, player* u )
{
  if( m->m_siz == 0 )
    return;

  int mn, mndex;
  for( mn = 0, mndex = m->m_siz; mn < mndex; mn++ )
  {
    if( m->m[mn].hp > 0 )
    {
      monstai( m, mn, u );
    }
    else
    {
      remove_mon( m, mn );
    }
  }
}
