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
    } // switch( dir )
} // void get_dydx( Direction, byte*, byte* )

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
    } // switch( movement )
} // Direction get_direction( Move )

// SECTION 2: ////////////////////////////////////////////////////////////////
// Collision Detection                                                      //
//////////////////////////////////////////////////////////////////////////////



// Checks whether the given Monst is able to move to a certain destination
// given its dx,dy coordinates.  This function also checks the player's
// position via the `u` parameter.
Collision check_collision( Map* map, Monst* mon, ubyte dest_x, byte dest_y,
                           bool cardinal, Player* plyr )
{
    byte start_x = mon.x;
    byte start_y = mon.y;

    // Check if there are any monsters on the destination tile; if so, the
    // monster will not be able to move and may be forced to attack.
    if( plyr.x == dest_x && plyr.y == dest_y )
    {
        return Collision.monster;
    }
    foreach( index; 0 .. cast(uint)map.mons.length )
    {
        if( map.mons[index].x == dest_x && map.mons[index].y == dest_y )
        {
            return Collision.monster;
        }
    }

    // Sessile monsters can never move, so if the above check did not result
    // in an attack then there is nothing more that it can do.
    if( mon.walk == Locomotion.sessile)
    {
        return Collision.movement_impossible;
    }

    if( cardinal )
    {
        // If the monster's current position blocks cardinal movement, they
        // are stuck and must try to move diagonally.
        if( map.tils[start_y][start_x].block_cardinal_movement )
        {
            return Collision.wall;
        }
        // If the monster's destination blocks cardinal movement, same story.
        if( map.tils[dest_y][dest_x].block_cardinal_movement )
        {
            return Collision.wall;
        }
    }
    else
    {
        // If the monster's current position or destination block diagonal
        // movement, they must try to move cardinally.
        if( map.tils[start_y][start_x].block_diagonal_movement )
        {
            return Collision.wall;
        }
        if( map.tils[dest_y][dest_x].block_diagonal_movement )
        {
            return Collision.wall;
        }
    }

    // If the monster is not able to move over water, they must abort.
    if( map.tils[dest_y][dest_x].hazard & HAZARD_WATER )
    {
        if( mon.walk == Locomotion.terrestrial )
        {
            return Collision.water;
        }
    }

    // If the monster is _only_ able to move over water, but this tile does
    // not have water, movement onto this space is impossible.
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
void mmove( Monst* mon, Map* map, byte idy, byte idx, Player* plyr )
{
    uint dy = idy, dx = idx;

    Collision obstacle;

    dx = dx + mon.x;
    dy = dy + mon.y;

    bool cardinal;

check_collision:
    obstacle = Collision.none;
    cardinal = dx == 0 || dy == 0;

    if( (cardinal && (map.tils[dy][dx].block_cardinal_movement))
        || (!cardinal && (map.tils[dy][dx].block_diagonal_movement)) )
    {
        obstacle = Collision.wall;
    }
    else
    {
        if( (map.tils[dy][dx].hazard & HAZARD_WATER)
            && mon.walk == Locomotion.terrestrial )
        {
            obstacle = Collision.water;
        }
        else if( !(map.tils[dy][dx].hazard & HAZARD_WATER)
                 && mon.walk == Locomotion.aquatic )
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
        if( !map.tils[dy][mon.x].block_cardinal_movement )
        {
            dx = mon.x;
            goto check_collision;
        }
        else if( !map.tils[mon.y][dx].block_cardinal_movement )
        {
            dy = mon.y;
            goto check_collision;
        }
    }
  

    if( dx == plyr.x && dy == plyr.y )
    {
        mattack( mon, plyr );
        obstacle = Collision.monster;
    }
    else
    {
        foreach( index; 0 .. map.mons.length )
        {
            if( map.mons[index].x == dx && map.mons[index].y == dy )
            {
                obstacle = Collision.monster;
            }
        }
    }

    if( obstacle == Collision.none )
    {
        mon.x = cast(byte)dx; mon.y = cast(byte)dy;
    }
} // void mmove( Monst*, Map*, byte, byte, Player* )

// SECTION 4: ////////////////////////////////////////////////////////////////
// Monster AI                                                               //
//////////////////////////////////////////////////////////////////////////////

// Tells the given monster to make their move.
void monst_ai( Map* map, uint index, Player* plyr )
{
    Monst* mon = &map.mons[index];
    ubyte mnx = mon.x, mny = mon.y, ux = plyr.x, uy = plyr.y;
    byte dx = 0, dy = 0;

    if( mnx > ux )
    {
        dx = -1;
    }
    if( mnx < ux )
    {
        dx =  1;
    }
    if( mny > uy )
    {
        dy = -1;
    }
    if( mny < uy )
    {
        dy =  1;
    }

    mmove( mon, map, dy, dx, plyr );
} // void monst_ai( Map*, uint, Player* )

// Sends an instruction to all of the monsters on the given map to make their
// move.
void map_move_all_monsters( Map* map, Player* plyr )
{
    if( map.mons.length == 0 )
    {
        return;
    }

    uint[] kill_mons;

    foreach( index; 0 .. cast(uint)map.mons.length )
    {
        if( map.mons[cast(size_t)index].hit_points > 0 )
        {
            monst_ai( map, index, plyr );
        }
        else
        {
            // mark the mon for removal:
            kill_mons = kill_mons ~ [index];
        }
    }

    // remove all of the dead mons:
    foreach( index; 0 .. cast(size_t)kill_mons.length )
    {
        remove_mon( map, kill_mons[index] );
    }
} // void map_move_all_monsters( Map*, Player* )

// SECTION 5: ////////////////////////////////////////////////////////////////
// Attacking                                                                //
//////////////////////////////////////////////////////////////////////////////

// Causes a monster to attack another monster.
void mattack( Monst* off, Monst* def )
{
    int dic = off.attack_roll.dice
              + off.inventory.items[INVENT_WEAPON].add_dice;
    int mod = off.attack_roll.modifier
              + off.inventory.items[INVENT_WEAPON].add_mod;
    int atk = roll_within( off.attack_roll.floor, off.attack_roll.ceiling,
                           dic, 6, mod );

    if( atk > 0 )
    {
        if( is_you( *def ) && Degreelessness )
        {
            message( "The puny %s's feeble attack does nothing!", off.name );
        }
        else if( is_you( *off ) && Infinite_weapon )
        {
            def.hit_points = 0;
            message( "The %s explodes from the force of your attack!",
                     def.name );

            static if( BLOOD )
            {
                // Spread viscera everywhere:
                import main : Current_map;
                int k = def.x, j = def.y;
                foreach( count; 0 .. 10 )
                {
                    byte dk, dj;
                    get_dydx( uniform!(Direction)( Lucky ), &dj, &dk );
                    Current_map.tils[j + dj][k + dk].hazard |= SPECIAL_BLOOD;
                }
            }
        } // else if( is_you( *off ) && Infinite_weapon )
        else
        {
            def.hit_points -= atk;
            message( "%s attack%s %s!", The_monst( *off ),
                    is_you( *def ) ? "" : "s", the_monst( *def ) );

            static if( BLOOD )
            {
                // The defender bleeds.
                import main : Current_map;
                int k = def.x, j = def.y;
                Current_map.tils[j][k].hazard |= SPECIAL_BLOOD;
                foreach( count; d() .. atk )
                {
                    byte dk, dj;
                    get_dydx( uniform!(Direction)( Lucky ), &dj, &dk );
                    Current_map.tils[j + dj][k + dk].hazard |= SPECIAL_BLOOD;
                }
            }

            if( def.hit_points <= 0 )
            {
                message( "%s %s slain!", The_monst( *def ),
                         is_you( *def ) ? "are" : "is" );
            }
        } // else from if( is_you( *off ) && Infinite_weapon )
    } // if( atk > 0 )
    else
    {
        message( "%s barely miss%s %s!", The_monst( *off ),
                is_you( *off ) ? "" : "es", the_monst( *def ) );
    }
} // void mattack( Monst*, Monst*)

// SECTION 6: ////////////////////////////////////////////////////////////////
// Player Movement                                                          //
//////////////////////////////////////////////////////////////////////////////

// Causes the player to make a move based on the given movement flag.
uint umove( Player* plyr, Map* map, Direction dir )
{
    byte dy, dx;
    get_dydx( dir, &dy, &dx );
    bool cardinal = dy == 0 || dx == 0;

    uint terrain = 0, monster = 0;

    dx += plyr.x; dy += plyr.y;

    Monst* mon;
    foreach( index; 0 .. map.mons.length )
    {
        mon = &map.mons[index];
        if( mon.x == dx && mon.y == dy && mon.hit_points > 0 )
        {
            mattack( plyr, mon );
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
        if( (cardinal && (map.tils[dy][dx].block_cardinal_movement))
            || (!cardinal && (map.tils[dy][dx].block_diagonal_movement)) )
        {
            message( "Ouch!  You walk straight into a wall!" );
            // report "no movement" to the mainloop so we don't expend a turn
            return 0;
        }
        else
        {
            if( map.tils[dy][dx].hazard & HAZARD_WATER )
            {
                plyr.hit_points = 0;
                message( "You step into the water and are pulled down by your equipment..." );
            }
        }
    }

    if( Item_here( map.itms[dy][dx] ) )
    {
        Item itm = map.itms[dy][dx];
        if( itm.count > 1 )
        {
            message( "You see here %d %ss.", itm.count, itm.name );
        }
        else
        {
            message( "You see here a %s.", itm.name );
        }
    }

    if( monster || terrain )
    {
        dx = 0; dy = 0;
    }
    else
    {
        plyr.y = dy;
        plyr.x = dx;
    }

    return 1;
} // uint umove( Player*, Map*, Direction )

// SECTION 6: ////////////////////////////////////////////////////////////////
// Miscellaneous Monster/Player Actions                                     //
//////////////////////////////////////////////////////////////////////////////

// Causes a monster to try to pick up a given item.
bool pickup( Monst* mon, Item itm )
{
    bool mon_picked_up = false;

    if( !Item_here( itm ) )
    {
        if( is_you( *mon ) )
        {
            message( "There is nothing here to pick up." );
            return false;
        }
    }

    // Items are picked up in the weapon-hand if the weapon-hand is
    // empty, AND the item is a weapon OR the off-hand is NOT empty
    if( !Item_here( mon.inventory.items[INVENT_WEAPON] )
        && (itm.type == Type.weapon
           || !Item_here( mon.inventory.items[INVENT_OFFHAND] ))
      )
    {

        mon.inventory.items[INVENT_WEAPON] = itm;

        if( is_you( *mon ) )
        {
            message( "You pick up a %s in your weapon-hand.", itm.name );
            return true;
        }
        else
        {
            mon_picked_up = true;
        }
    }
    // Items go in the off-hand if the off-hand is empty, AND the item is not
    // a weapon OR the weapon-hand is NOT empty
    else if( !Item_here( mon.inventory.items[INVENT_OFFHAND] ) )
    {
        mon.inventory.items[INVENT_OFFHAND] = itm;

        if( is_you( *mon ) )
        {
            message( "You pick up a %s in your off-hand.", itm.name );
            return true;
        }
        else
        {
            mon_picked_up = true;
        }
    }
    else if( is_you( *mon ) )
    {
        message( "You do not have a free grasp." );
    }

    if( mon_picked_up )
    {
        message( "The %s picks up a %s.", monst_name( *mon ), itm.name );
        return true;
    }

    return false;
} // bool pickup( Monst*, Item )

// Causes a monster to try to put down or "drop" an `Item` at the given index
// in its inventory.
Item m_drop_item( Monst* mon, int index )
{
    Item ret = No_item;

    // If the given index is invalid, return a placeholder item.  Note that 40
    // is the maximum number of slots in a monster's inventory (14 equipment
    // slots and 26 items in the bag)
    if( index < 0 || index >= 40 )
    {
        return No_item;
    }

    // Otherwise, we simply remove that item and return it:
    ret = mon.inventory.items[index];
    mon.inventory.items[index] = No_item;
  
    return ret;
}
