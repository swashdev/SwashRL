/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

void getdydx( ubyte dir, byte* dy, byte* dx )
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
  uint atk = rollbag( m.attack_roll );
  if( atk > 0 )
  {
    u.hp -= atk;
    message( "The %s attacks you!", m.name );
  }
  else
  { message( "The %s barely misses you!", m.name );
  }
}

void uattackm( player* u, monst* m )
{
  int mod = u.attack_roll.modifier + u.inventory.items[INVENT_WEAPON].addm;
  int dice = u.attack_roll.dice + u.inventory.items[INVENT_WEAPON].addd;
  int atk = roll_x( dice, mod, u.attack_roll.floor, u.attack_roll.ceiling );

  if( atk > 0 )
  {
    m.hp -= atk;
    message( "You attack the %s!", m.name );
  }
  else
  { message( "You barely miss the %s!", m.name );
  }

  if( m.hp <= 0 )
  { message( "The %s is slain!", m.name );
  }
  move( u.y + RESERVED_LINES, u.x );
}

enum FLOOR_HERE = 0;
enum WALL_HERE  = 1;
enum WATER_HERE = 2;
enum MOVEMENT_IMPOSSIBLE = 3;

enum CAN_NOT_FLY = 0;
enum CAN_FLY     = 1;
enum IS_FLYING   = 2;

enum CAN_NOT_SWIM  = 0;
enum CAN_SWIM      = 1;
enum CAN_ONLY_SWIM = 2;

void mmove( monst* mn, map* m, byte idy, byte idx, player* u )
{
  uint dy = idy, dx = idx;

  ubyte terrain = 0, monster = 0;

  dx = dx + mn.x; dy = dy + mn.y;
  bool cardinal = dx == 0 || dy == 0;

  if( (cardinal && (m.t[dy][dx].block_cardinal_movement))
  || (!cardinal && (m.t[dy][dx].block_diagonal_movement)) )
  {
    terrain = WALL_HERE;
  }
  else
  {
    if( (m.t[dy][dx].hazard & HAZARD_WATER) && mn.swim == CAN_NOT_SWIM )
    {
      terrain = WATER_HERE;
    }
    else if( !(m.t[dy][dx].hazard & HAZARD_WATER)
             && mn.swim == CAN_ONLY_SWIM )
    {
      terrain = MOVEMENT_IMPOSSIBLE;
    }
  }

  if( terrain )
  {
    // Attempt to have the monster navigate around obstacles
    if( terrain == WATER_HERE && mn.fly == CAN_FLY )
    {
      mn.fly = IS_FLYING;
    }
    else if( terrain == WALL_HERE || mn.fly == CAN_NOT_FLY )
    {
      // TODO: Definitely need better colission checking here.  Maybe a
      // function should be written to determine if a monster can step in a
      // certain tile.
      if( !m.t[dy][mn.x].block_cardinal_movement )
      { dx = mn.x;
      }
      else if( !m.t[mn.y][dx].block_cardinal_movement )
      { dy = mn.y;
      }
    }
  }
  

  if( dx == u.x && dy == u.y )
  {
    mattacku( mn, u );
    monster = 1;
  }
  else
  {
    foreach( c; 0 .. m.m.length )
    {
      if( m.m[c].x == dx && m.m[c].y == dy )
      {
        monster = 1;
      }
    }
  }

  if( !monster )
  {
    mn.x = cast(byte)dx; mn.y = cast(byte)dy;
  }
}

void monstai( map* m, uint index, player* u )
{
  monst* mn = &m.m[index];
  int mnx = mn.x, mny = mn.y, ux = u.x, uy = u.y,
    dx = 0, dy = 0;
  if( mnx > ux )
    dx = -1;
  if( mnx < ux )
    dx =  1;
  if( mny > uy )
    dy = -1;
  if( mny < uy )
    dy =  1;
  mmove( mn, m, cast(byte)dy, cast(byte)dx, u );
}

ubyte umove( player* u, map* m, ubyte dir )
{
  if( dir == MOVE_GET )
  {
    if( upickup( u, m.i[u.y][u.x] ) )
    {
      m.i[u.y][u.x] = No_item;
      return 1;
    }
    return 0;
  }
  if( dir == MOVE_INVENTORY )
  { return cast(ubyte)uinventory( u );
  }
  byte dy, dx;
  getdydx( dir, &dy, &dx );
  bool cardinal = dy == 0 || dx == 0;

  ubyte terrain = 0, monster = 0;

  dx += u.x; dy += u.y;

  monst* mn;
  foreach( c; 0 .. m.m.length )
  {
    mn = &m.m[c];
    if( mn.x == dx && mn.y == dy && mn.hp > 0 )
    {
      uattackm( u, mn );
      monster = 1;
      break;
    }
  }

  if( (cardinal && (m.t[dy][dx].block_cardinal_movement))
  || (!cardinal && (m.t[dy][dx].block_diagonal_movement)) )
  {
    message( "Ouch!  You walk straight into a wall!" );
    // report "no movement" to the mainloop so we don't expend a turn
    return 0;
  }
  else
  {
    if( m.t[dy][dx].hazard & HAZARD_WATER )
    {
      u.hp = 0;
message( "You step into the water and are pulled down by your equipment..." );
    }
  }

  if( m.i[dy][dx].sym.ch != '\0' )
  { message( "You see here a %s", m.i[dy][dx].name );
  }

  if( monster || terrain )
  { dx = 0; dy = 0;
  }
  else
  {
    mvaddch( u.y + RESERVED_LINES, u.x, '.' );
    u.y = dy; u.x = dx;
  }

  return 1;
}

void map_move_all_monsters( map* m, player* u )
{
  if( m.m.length == 0 )
  { return;
  }

  foreach( mn; 0 .. m.m.length )
  {
    if( m.m[mn].hp > 0 )
    { monstai( m, cast(uint)mn, u );
    }
    else
    { remove_mon( m, cast(ushort)mn );
    }
  }
}
