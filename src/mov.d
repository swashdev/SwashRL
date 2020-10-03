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

// mov.d:  Functions related to player and monster movement

import global;
import std.random;
import std.range;

// SECTION 0: ////////////////////////////////////////////////////////////////
// Useful flags for monster movement                                        //
//////////////////////////////////////////////////////////////////////////////

// For functions which choose a direction
enum Direction
{
  northwest, // 0
  north,     // 1
  northeast, // 2
  west,      // 3
  east,      // 4
  southwest, // 5
  south,     // 6
  southeast, // 7
  invalid    // 8
}

// Colission detection:
enum Collision
{
  none,
  wall, water, monster,
  movement_impossible
}

// SECTION 1: ////////////////////////////////////////////////////////////////
// Translating Movement to Data                                             //
//////////////////////////////////////////////////////////////////////////////

// Takes a movement flag and gives the change in y and x coordinates which
// indicate the given direction, if any.
void get_dydx( Direction dir, byte* dy, byte* dx )
{
  switch( dir )
  {
    case Direction.northwest:
      *dy = -1;
      *dx = -1;
      break;
    case Direction.north:
      *dy = -1;
      *dx =  0;
      break;
    case Direction.northeast:
      *dy = -1;
      *dx =  1;
      break;
    case Direction.east:
      *dy =  0;
      *dx =  1;
      break;
    case Direction.southeast:
      *dy =  1;
      *dx =  1;
      break;
    case Direction.south:
      *dy =  1;
      *dx =  0;
      break;
    case Direction.southwest:
      *dy =  1;
      *dx = -1;
      break;
    case Direction.west:
      *dy =  0;
      *dx = -1;
      break;

    default:
      *dy =  0;
      *dx =  0;
      break;
  }
}

Direction get_direction( Move movement )
{
  switch( movement )
  {
    default:
      return Direction.invalid;
    case Move.northeast:
      return Direction.northeast;
    case Move.north:
      return Direction.north;
    case Move.northwest:
      return Direction.northwest;
    case Move.west:
      return Direction.west;
    case Move.east:
      return Direction.east;
    case Move.southeast:
      return Direction.southeast;
    case Move.south:
      return Direction.south;
    case Move.southwest:
      return Direction.southwest;
  }
}

// SECTION 2: ////////////////////////////////////////////////////////////////
// Collision Detection                                                      //
//////////////////////////////////////////////////////////////////////////////

// Checks whether the given Monst is able to move to a certain destination
// given its dx,dy coordinates.  This function also checks the player's
// position via the `u` parameter.
Collision check_collision( Map* m, Monst* mon, ubyte dest_x, byte dest_y,
                           bool cardinal, Player* u )
{

  byte start_x = mon.x;
  byte start_y = mon.y;

  // Check if there are any monsters on the destination tile; if so, the
  // monster will not be able to move and may be forced to attack.
  if( u.x == dest_x && u.y == dest_y )
  {
    return Collision.monster;
  }
  foreach( mn; 0 .. cast(uint)m.m.length )
  {
    if( m.m[mn].x == dest_x && m.m[mn].y == dest_y )
    {
      return Collision.monster;
    }
  }

  // Sessile monsters can never move, so if the above check did not result in
  // an attack then there is nothing more that it can do.
  if( mon.walk == Locomotion.sessile)  return Collision.movement_impossible;

  if( cardinal )
  {
    // If the monster's current position blocks cardinal movement, they are
    // stuck and must try to move diagonally.
    if( m.t[start_y][start_x].block_cardinal_movement )
    {
      return Collision.wall;
    }
    // If the monster's destination blocks cardinal movement, same story.
    if( m.t[dest_y][dest_x].block_cardinal_movement )
    {
      return Collision.wall;
    }
  }
  else
  {
    // If the monster's current position or destination block diagonal
    // movement, they must try to move cardinally.
    if( m.t[start_y][start_x].block_diagonal_movement )
    {
      return Collision.wall;
    }
    if( m.t[dest_y][dest_x].block_diagonal_movement )
    {
      return Collision.wall;
    }
  } // else from if( cardinal )

  // If the monster is not able to move over water, they must abort.
  if( m.t[dest_y][dest_x].hazard & HAZARD_WATER )
  {
    if( mon.walk == Locomotion.terrestrial )
    {
      return Collision.water;
    }
  }
  // If the monster is _only_ able to move over water, but this tile does not
  // have water, movement onto this space is impossible.
  else
  {
    if( mon.walk == Locomotion.aquatic )
    {
      return Collision.movement_impossible;
    }
  }

  return Collision.none;

} // Collision check_collision( Map*, Monst*, ubyte, ubyte, bool, Monst* )

// SECTION 3: ////////////////////////////////////////////////////////////////
// Monster Movement                                                         //
//////////////////////////////////////////////////////////////////////////////

// Moves a given monster on the given map.
void mmove( Monst* mn, Map* m, byte idy, byte idx, Player* u )
{
  uint dy = idy, dx = idx;

  Collision obstacle;

  dx = dx + mn.x; dy = dy + mn.y;
  bool cardinal;

check_collision:
  obstacle = Collision.none;
  cardinal = dx == 0 || dy == 0;

  if( (cardinal && (m.t[dy][dx].block_cardinal_movement))
  || (!cardinal && (m.t[dy][dx].block_diagonal_movement)) )
  {
    obstacle = Collision.wall;
  }
  else
  {
    if( (m.t[dy][dx].hazard & HAZARD_WATER)
        && mn.walk == Locomotion.terrestrial )
    {
      obstacle = Collision.water;
    }
    else if( !(m.t[dy][dx].hazard & HAZARD_WATER)
             && mn.walk == Locomotion.aquatic )
    {
      obstacle = Collision.movement_impossible;
    }
  }

  // Attempt to have the monster navigate around obstacles
  if( obstacle == Collision.wall )
  {
    // TODO: Definitely need better colission checking here.  Maybe a
    // function should be written to determine if a monster can step in a
    // certain tile.
    if( !m.t[dy][mn.x].block_cardinal_movement )
    {
      dx = mn.x;
      goto check_collision;
    }
    else if( !m.t[mn.y][dx].block_cardinal_movement )
    {
      dy = mn.y;
      goto check_collision;
    }
  }
  

  if( dx == u.x && dy == u.y )
  {
    mattack( mn, u );
    obstacle = Collision.monster;
  }
  else
  {
    foreach( c; 0 .. m.m.length )
    {
      if( m.m[c].x == dx && m.m[c].y == dy )
      {
        obstacle = Collision.monster;
      }
    }
  }

  if( obstacle == Collision.none )
  {
    mn.x = cast(byte)dx; mn.y = cast(byte)dy;
  }
}

// SECTION 4: ////////////////////////////////////////////////////////////////
// Monster AI                                                               //
//////////////////////////////////////////////////////////////////////////////

// Tells the given monster to make their move.
void monst_ai( Map* m, uint index, Player* u )
{
  Monst* mn = &m.m[index];
  ubyte mnx = mn.x, mny = mn.y, ux = u.x, uy = u.y;
  byte dx = 0, dy = 0;
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

// Sends an instruction to all of the monsters on the given map to make their
// move.
void map_move_all_monsters( Map* m, Player* u )
{
  if( m.m.length == 0 )
  { return;
  }

  uint[] kill_mons;

  foreach( mn; 0 .. cast(uint)m.m.length )
  {
    if( m.m[cast(size_t)mn].hp > 0 )
    { monst_ai( m, mn, u );
    }
    else
    {
      // mark the mon for removal:
      kill_mons = kill_mons ~ [mn];
    }
  }

  // remove all of the dead mons:
  foreach( mn; 0 .. cast(size_t)kill_mons.length )
  { remove_mon( m, kill_mons[mn] );
  }
}

// SECTION 5: ////////////////////////////////////////////////////////////////
// Attacking                                                                //
//////////////////////////////////////////////////////////////////////////////

// Causes a monster to attack another monster.
void mattack( Monst* m, Monst* u )
{
  int dic = m.attack_roll.dice + m.inventory.items[INVENT_WEAPON].add_dice;
  int mod = m.attack_roll.modifier + m.inventory.items[INVENT_WEAPON].add_mod;
  int atk = roll_within( m.attack_roll.floor, m.attack_roll.ceiling,
                         dic, 6, mod );

  if( atk > 0 )
  {
    if( is_you( *u ) && Degreelessness )
    {
      message( "The puny %s's feeble attack does nothing!", m.name );
    }
    else if( is_you( *m ) && Infinite_weapon )
    {
      u.hp = 0;
      message( "The %s explodes from the force of your attack!", u.name );

static if( BLOOD )
{
      // Spread viscera everywhere:
      import main : Current_map;
      int k = u.x, j = u.y;
      foreach( c; 0 .. 10 )
      {
        byte dk, dj;
        get_dydx( uniform!(Direction)( Lucky ), &dj, &dk );
        Current_map.t[j + dj][k + dk].hazard |= SPECIAL_BLOOD;
      }
}

    } // else if( is_you( m ) && Infinite_weapon )
    else
    {
      u.hp -= atk;
      message( "%s attack%s %s!", The_monst( *m ),
               is_you( *m ) ? "" : "s", the_monst( *u ) );
static if( BLOOD )
{
      import main : Current_map;
      int k = u.x, j = u.y;
      // The player bleeds...
      Current_map.t[j][k].hazard |= SPECIAL_BLOOD;
      foreach( c; d() .. atk )
      {
        byte dk, dj;
        get_dydx( uniform!(Direction)( Lucky ), &dj, &dk );
        Current_map.t[j + dj][k + dk].hazard |= SPECIAL_BLOOD;
      }
}

      if( u.hp <= 0 )  message( "%s %s slain!", The_monst( *u ),
                                is_you( *u ) ? "are" : "is" );
    } // else from if( is_you( m ) && Infinite_weapon )
  } // if( atk > 0 )
  else
  { message( "%s barely miss%s %s!", The_monst( *m ),
             is_you( *m ) ? "" : "es", the_monst( *u ) );
  }
}

// SECTION 6: ////////////////////////////////////////////////////////////////
// Player Movement                                                          //
//////////////////////////////////////////////////////////////////////////////

// Causes the player to make a move based on the given movement flag.
uint umove( Player* u, Map* m, Direction dir )
{

  byte dy, dx;
  get_dydx( dir, &dy, &dx );
  bool cardinal = dy == 0 || dx == 0;

  uint terrain = 0, monster = 0;

  dx += u.x; dy += u.y;

  Monst* mn;
  foreach( c; 0 .. m.m.length )
  {
    mn = &m.m[c];
    if( mn.x == dx && mn.y == dy && mn.hp > 0 )
    {
      mattack( u, mn );
      monster = 1;
      break;
    }
  }

  if( Noclip )
  {
    if( dx <= 0 || dx >= MAP_X || dy <= 0 || dy >= MAP_Y )
    {
      message( "Woah there!  You ain't Orpheus!  Get back in the game!"
             );
      return 0;
    }
  }
  else
  {
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
  } // else from if( Noclip )

  if( m.i[dy][dx].sym.ch != '\0' )
  { message( "You see here a %s", m.i[dy][dx].name );
  }

  if( monster || terrain )
  { dx = 0; dy = 0;
  }
  else
  {
    u.y = dy; u.x = dx;
  }

  return 1;
}

// SECTION 6: ////////////////////////////////////////////////////////////////
// Miscellaneous Monster/Player Actions                                     //
//////////////////////////////////////////////////////////////////////////////

// Causes a monster to try to pick up a given item.
bool pickup( Monst* mn, Item i )
{
  bool mon_picked_up = false;

  if( i.sym.ch == '\0' )
  {
    if( is_you( *mn ) )  message( "There is nothing here to pick up." );
    return false;
  }

  // Items are picked up in the weapon-hand if the weapon-hand is empty, AND
  // the item is a weapon OR the off-hand is NOT empty
  if( mn.inventory.items[INVENT_WEAPON].sym.ch == '\0' &&
          (i.type == Type.weapon
        || mn.inventory.items[INVENT_OFFHAND].sym.ch != '\0')
    )
  {

    mn.inventory.items[INVENT_WEAPON] = i;

    if( is_you( *mn ) )
    {
      message( "You pick up a %s in your weapon-hand.", i.name );
      return true;
    }
    else
    { mon_picked_up = true;
    }
  }
  // Items go in the off-hand if the off-hand is empty, AND the item is not a
  // weapon OR the weapon-hand is NOT empty
  else if( mn.inventory.items[INVENT_OFFHAND].sym.ch == '\0' )
  {
    mn.inventory.items[INVENT_OFFHAND] = i;

    if( is_you( *mn ) )
    {
      message( "You pick up a %s in your off-hand.", i.name );
      return true;
    }
    else
    { mon_picked_up = true;
    }
  }
  else if( is_you( *mn ) )
  { message( "You do not have a free grasp." );
  }

  if( mon_picked_up )
  {
    message( "The %s picks up a %s.", monst_name( *mn ), i.name );
    return true;
  }

  return false;
}

// Causes a monster to try to put down or "drop" an `Item` at the given index
// in its inventory.
Item m_drop_item( Monst* mn, int index )
{
  Item ret = No_item;

  // If the given index is invalid, return a placeholder item.  Note that 40
  // is the maximum number of slots in a monster's inventory (14 equipment
  // slots and 26 items in the bag)
  if( index < 0 || index >= 40 )  return No_item;

  // Otherwise, we simply remove that item and return it:
  ret = mn.inventory.items[index];
  mn.inventory.items[index] = No_item;
  return ret;
}
