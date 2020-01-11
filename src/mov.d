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
// TODO:  Allow the player to be represented by a `monst` to allow some of
// these functions to be deprecated

import global;

/++
 + Gets the change in x and y coordinates associated with the given direction
 + of travel
 +
 + This function takes a flag dir, representing a direction that a monster is
 + moving in, and alters dy and dx to represent what changes that movement
 + makes to the monster's x and y coordinates.
 +
 + dir is actually a movement flag defined in moves.d.
 +
 + Params:
 +   dir = A movement flag determining what `dir`ection is being used to
 +         calculate dy and dx
 +   dy  = A pointer to a `byte` representing the change in the monster's y
 +         coordinate, which will be changed to either -1, 0, or 1 depending
 +         on what `dir`ection the monster is moving in;  Note that -1 means
 +         "up" and 1 means "down" due to the way the coordinate system works
 +   dx  = A pointer to a `byte` representing the change in the monster's x
 +         coordinate, which will be changed to either -1, 0, or 1 depending
 +         on what `dir`ection the monster is moving in
 +/
void get_dydx( uint dir, byte* dy, byte* dx )
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

/++
 + Causes a monster to attack another monster
 +
 + This function alters the given `Monst` u to reflect changes, if any,
 + resulting from the given `Monst` m attacking u, and outputs messages to
 + show the user what is happening.
 +
 + <strong>This function can kill the player if m does enough damage to
 + u</strong>
 +
 + Date:  2018-09-01
 +
 + Params:
 +   m = A pointer to the `Monst`er which is attacking u
 +   u = A pointer to the `Monst`er which is being attacked by m
 +/
void mattack( Monst* m, Monst* u )
{
  int dic = m.attack_roll.dice + m.inventory.items[INVENT_WEAPON].addd;
  int mod = m.attack_roll.modifier  + m.inventory.items[INVENT_WEAPON].addm;
  int atk = roll_x( dic, mod, m.attack_roll.floor, m.attack_roll.ceiling );

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
        get_dydx( cast(ubyte)td10(), &dj, &dk );
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
        get_dydx( cast(ubyte)td10(), &dj, &dk );
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

/++
 + Moves a given monster on the given map
 +
 + This function attempts to move mn in the direction given by idy and idx
 + based on what's going on in the given `Map` m and where the given `Monst`
 + u is.
 +
 + Specifically, this function attempts to alter `mn`'s x and y coordinates by
 + idx and idy, but might change them to a different value if there is a Tile
 + in m blocking their way.  If u is in their path, mn will attack u instead
 + of moving.
 +
 + idy and idx can be calculated by the `get_dydx` function.
 +
 + <strong>This function can kill the player if mn attacks u</strong>
 +
 + See_Also:
 +   <a href="#mattack">mattack</a>,
 +   <a href="#monst_ai">monst_ai</a>
 +
 + Params:
 +   mn  = A pointer to the `Monst` which is being moved
 +   m   = A pointer to the `Map` that mn is currently in
 +   idy = The initial dy which `mn.y` will try to be altered by if the
 +         terrain and the player allow
 +   idx = The initial dx which `mn.x` will try to be altered by if the
 +         terrain and the player allow
 +   u   = A pointer to the `Player` character
 +/
void mmove( Monst* mn, Map* m, byte idy, byte idx, Player* u )
{
  uint dy = idy, dx = idx;

  uint terrain = 0, monster = 0;

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
    mattack( mn, u );
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

/++
 + Tells the given monster to make their move
 +
 + This function is called when it is a particular monster's turn to make a
 + move.  Based on the position of the given `Player` u, the monster will
 + attempt to move toward u on the map.
 +
 + Which monster is being activated is determined by the index of the monster
 + in the given `Map` `m`'s monster array (`m.m`).
 +
 + <strong>This function can kill the player if `m.m[index]` attacks
 + u</strong>
 +
 + See_Also:
 +   <a href="#mmove">mmove</a>
 +
 + Params:
 +   m     = A pointer to the `Map` that the monster is stored in
 +   index = The index of the monster in `m.m`
 +   u     = A pointer to the `Player` character
 +/
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

/++
 + Causes the player to move
 +
 + This function takes in the `Player` character u, the current `Map` m, and
 + the `dir`ection that the player wants to move in, and computes the result.
 +
 + If there is terrain in the `dir`ection that u wants to go, this function
 + governs how u is affected by that.
 + <strong>This function might kill the player depending on what terrain they
 + bump into</strong>.
 +
 + If there is a monster in the `dir`ection that u wants to go, this function
 + will cause u to attack it.
 +
 + dir is a movement flag from moves.d.  If dir is not a direction that can
 + be passed into `get_dydx`, this function will sometimes handle what the
 + player character does instead of moving, but this use of the function is
 + not recommended because this function is best used for cases where the
 + player is <em>actually</em> trying to move.
 +
 + See_Also:
 +   <a href="#mattack">mattack</a>
 +
 + Params:
 +   u   = A pointer to the `Player` character
 +   m   = A pointer to the `Map` that u is currently navigating
 +   dir = The `dir`ection that u wants to go in
 +
 + Returns:
 +   A `ubyte` representing the number of turns expended by the player while
 +   moving (usually 1 or 0)
 +/
uint umove( Player* u, Map* m, uint dir )
{
  if( dir == MOVE_GET )
  {
    if( pickup( u, m.i[u.y][u.x] ) )
    {
      m.i[u.y][u.x] = No_item;
      return 1;
    }
    return 0;
  }

  if( dir == MOVE_DROP )
  {
    Item it = put_down( u );
  }

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

/++
 + Causes a monster to try to pick up a given item
 +
 + This function takes the `Monst` mn and a given `Item` i and tries to get mn
 + to pick up i.
 +
 + i is an `Item` which should be obtained from the `i` array of the `Map`
 + that the monster is currently occupying.
 +
 + This function will automatically check both of the monster's hands to make
 + sure that mn has a free grasp to pick an item up.
 +
 + The only difference between monsters and the player, as far as this
 + function is concerned, is that the player will get certain messages that
 + monsters will not.
 +
 + Params:
 +   mn = A pointer to the monster that is attempting to pick up an item
 +   i  = An `Item` that u is trying to pick up
 +
 + Returns:
 +   `true` if u successfully picked up i; `false` otherwise
 +/
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
          (i.type & ITEM_WEAPON
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

/++
 + Causes a monster to try to put down or "drop" an `Item` at the given
 + `index`.
 +
 + If `index` is negative, this function will return an empty item, unless
 + `mn` is the player, in which case it will display the equipment screen in
 + order for the player to select an item to drop.
 +
 + This function will remove the `Item` at `index` from the monster's
 + inventory, if it is a valid item, and return that `Item` so that it can be
 + dropped into the game world.
 +
 + Returns:
 +   An `Item` which has been removed from `mn`'s inventory, or `No_item`.
 +/
Item put_down( Monst* mn, int index = -1 )
{
  Item ret = No_item;

  // The easiest case is if `index` is too large to be in the array:
  if( index >= mn.inventory.items.length )  return No_item;

  // If `index` is positive, we simply remove that item and return it:
  if( index >= 0 )
  {
    ret = mn.inventory.items[index];
    mn.inventory.items[index] = No_item;
    return ret;
  }

  // If `index` is negative, we first check to see if the monster is the
  // player.  If it is not, return no item.
  if( !is_you( mn ) )  return No_item;

  // If it *is* the player, we must display the equipment screen so that the
  // player may select an item to be dropped:
  int i = index;

  message( "Sorry, this function doesn't do anything yet." );
  
  return ret;
}

/++
 + Moves all monsters on the given `Map`
 +
 + This function cycles through all of the monsters in `m`'s monster array
 + (`m.m`) and calls `monst_ai` on all of them.  The function takes in the
 + `player` character so that the monsters know where he or she is in order
 + to make a decision.
 +
 + If any monsters have been killed by the player, this function will remove
 + them from `m.m`.
 +
 + <strong>This function can kill the player if any of the monsters in `m.m`
 + attack u</strong>
 +
 + See_Also:
 +   <a href="#monst_ai">monst_ai</a>,
 +   <a href="#mmove">mmove</a>
 +
 + Params:
 +   m = A pointer to the `Map` whose monsters we want to move
 +   u = A pointer to the `Player` character
 +/
void map_move_all_monsters( Map* m, Player* u )
{
  if( m.m.length == 0 )
  { return;
  }

  foreach( mn; 0 .. cast(uint)m.m.length )
  {
    if( m.m[mn].hp > 0 )
    { monst_ai( m, mn, u );
    }
    else
    { remove_mon( m, mn );
    }
  }
}
