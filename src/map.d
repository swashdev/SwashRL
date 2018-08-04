/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

// A `struct' used to store `room's for the map generation code
struct room
{
  uint x1, y1, x2, y2;
}

// Defines a struct ``map'' which stores map data, including map tiles and
// monsters and items on the map

struct map
{
  tile[MAP_X][MAP_Y]   t; // `t'iles
  monst[]              m; // 'm'onsters
  item[MAP_X][MAP_Y]   i; // 'i'tems

  room[9] r;

static if( USE_FOV )
{
  bool[MAP_X][MAP_Y] v; // 'v'isibility
}

  ubyte[2] player_start;

}

void add_mon( map* mp, monst mn )
{
  size_t mndex = mp.m.length;
  if( mndex < NUMTILES )
  {
    mp.m.length++;
    mp.m[mndex] = mn;
  }
}

void remove_mon( map* mp, ushort index )
{
  // To remove a monster in a map's mon array, move all monsters that are
  // past it in the array up, thus overwriting it.
  if( index < mp.m.length )
  {
    foreach( mn; index + 1 .. mp.m.length )
    { mp.m[mn - 1] = mp.m[mn];
    }
    mp.m.length--;
  }
}

// Carves a vertical corridor in `m' starting at (y1, x) and ending at (y2, x)
// Returns `true' if the operation was successful.
bool add_corridor_y( uint x, uint y1, int y2, map* m )
{
  // Check if the corridor will be within the bounds of the map.
  if( x < 1 || x > MAP_x )
  { return false;
  }
  if( y1 < 1 || y1 > MAP_y || y2 < 1 || y2 > MAP_y )
  { return false;
  }

  // if y2 < y1, swap the two.
  uint sta, end;
  if( y2 < y1 )
  {
    sta = y2;
    end = y1;
  }
  else
  {
    sta = y1;
    end = y2;
  }

  // Carve all locations along the line [y, index], where `index' is the most
  // recent spot carved.
  foreach( y; sta .. (end + 1) )
  {
    // Do not destroy water by carving
    if( m.t[y][x] != Terrain.water )
    { m.t[y][x] = Terrain.floor;
    }
  }

  return true;
} // bool add_corridor_x( uint, uint, uint, map* )

// Carves a horizontal corridor in `m' starting at (y, x1) and ending at
// (y, x2).
// Returns `true' if the operation was successful.
bool add_corridor_x( uint y, uint x1, uint x2, map* m )
{
  // Check if the corridor will be within the bounds of the map.
  if( y < 1 || y > MAP_y )
  { return false;
  }
  if( x1 < 1 || x1 > MAP_x || x2 < 1 || x2 > MAP_x )
  { return false;
  }

  // if x2 < x1, swap the two.
  uint sta, end;
  if( x2 < x1 )
  {
    sta = x2;
    end = x1;
  }
  else
  {
    sta = x1;
    end = x2;
  }

  // Carve all locations along the line [y, index], where `index' is the most
  // recent spot carved.
  foreach( x; sta .. (end + 1) )
  {
    // Do not destroy water by carving
    if( m.t[y][x] != Terrain.water )
    { m.t[y][x] = Terrain.floor;
    }
  }

  return true;
} // bool add_corridor_x( uint, uint, uint, map* )

// Carves a room into the given `map', with the top-rightmost point (that is,
// the top-rightmost floor, not the wall) being at the given coordinates.
// Returns `true' if the operation was successful.
bool add_room( uint y1, uint x1, uint y2, uint x2, map* m )
{
  // Check if the room will fit within the bounds of the map.
  if( x1 > MAP_x || x1 < 1 || x2 > MAP_x || x2 < 1 )
  { return false;
  }
  if( y1 > MAP_y || y1 < 1 || y2 > MAP_y || y2 < 1 )
  { return false;
  }

  // Carve out the room
  foreach( index_y; y1 .. (y2 + 1) )
  {
    foreach( index_x; x1 .. (x2 + 1) )
    {
      m.t[index_y][index_x] = Terrain.floor;
    }
  }

  return true;
} // bool add_room( uint, uint, uint, uint, map* )

// Carves a given `room' into the given `map'.
// Returns `true' if the operation was successful.
bool add_room( room r, map* m )
{
  return add_room( r.y1, r.x1, r.y2, r.x2, m );
} // bool add_room( room, map* )

// Generates a new map randomly
map generate_new_map()
{
  import std.random;

debug
{
  // DEBUG OUTPUT
  import std.stdio : writefln;
}

  // We're going to use a classic Roguelike room generation system:  Split the
  // map into nine sectors, generate a room in each one, and then connect them
  // with corridors.

  // These integers will tell us what the room boundaries for each sector are.
  // Note that some of them overlap; this is intentional.
  uint s1x1 = 1,  s1x2 = 26, s1y1 = 1,  s1y2 = 7;
  uint s2x1 = 26, s2x2 = 52, s2y1 = 1,  s2y2 = 7;
  uint s3x1 = 52, s3x2 = 78, s3y1 = 1,  s3y2 = 7;
  uint s4x1 = 1,  s4x2 = 26, s4y1 = 7,  s4y2 = 13;
  uint s5x1 = 26, s5x2 = 52, s5y1 = 7,  s5y2 = 13;
  uint s6x1 = 52, s6x2 = 78, s6y1 = 7,  s6y2 = 13;
  uint s7x1 = 1,  s7x2 = 26, s7y1 = 13, s7y2 = 20;
  uint s8x1 = 26, s8x2 = 52, s8y1 = 13, s8y2 = 20;
  uint s9x1 = 52, s9x2 = 78, s9y1 = 13, s9y2 = 20;

  // An array that stores generated rooms:
  room[9] r;

  // An empty map:
  map m = empty_map();

  foreach( c; 0 .. 9 )
  {
    uint x1, x2, y1, y2;

    final switch( c )
    {
      case 0:
        x1 = s1x1; x2 = s1x2; y1 = s1y1; y2 = s1y2;
        break;
      case 1:
        x1 = s2x1; x2 = s2x2; y1 = s2y1; y2 = s2y2;
        break;
      case 2:
        x1 = s3x1; x2 = s3x2; y1 = s3y1; y2 = s3y2;
        break;
      case 3:
        x1 = s4x1; x2 = s4x2; y1 = s4y1; y2 = s4y2;
        break;
      case 4:
        x1 = s5x1; x2 = s5x2; y1 = s5y1; y2 = s5y2;
        break;
      case 5:
        x1 = s6x1; x2 = s6x2; y1 = s6y1; y2 = s6y2;
        break;
      case 6:
        x1 = s7x1; x2 = s7x2; y1 = s7y1; y2 = s7y2;
        break;
      case 7:
        x1 = s8x1; x2 = s8x2; y1 = s8y1; y2 = s8y2;
        break;
      case 8:
        x1 = s9x1; x2 = s9x2; y1 = s9y1; y2 = s9y2;
        break;
    } // switch( c )

room_gen:

    room t;
    t.x1 = uniform( x1, x2 - 2, Lucky );
    t.x2 = uniform( t.x1 + 2, x2, Lucky );
    t.y1 = uniform( y1, y2 - 2, Lucky );
    t.y2 = uniform( t.y1 + 2, y2, Lucky );

    // This if statement is just a failsafe.  It shouldn't be necessary, but
    // I like to idiot-proof myself.
    if( !add_room( t, &m ) )
    { goto room_gen;
    }

    r[c] = t;
        
  } // foreach( c; 0 .. 9 )

  // Shuffle the rooms so that we can generate corridors randomly rather than
  // in a predictable line while still ensuring that all of the rooms are
  // connected.
  room[9] rr = r.dup.randomShuffle( Lucky );

  // Randomly get coordinates from each room and connect them
  foreach( c; 0 .. 8 )
  {
debug
{
    writefln( "c is %d, c + 1 is %d", c, c + 1 );
}

    room r1 = rr[c];
    room r2 = rr[c + 1];

debug
{
    writefln( "r1 is rr[%d]\nr2 is rr[%d]", c, c + 1 );
    writefln( "r1.x1 is %d, r1.x2 is %d", r1.x1, r1.x2 );
    writefln( "r1.y1 is %d, r1.y2 is %d", r1.y1, r1.y2 );
    writefln( "r2.x1 is %d, r2.x1 is %d", r2.x1, r2.x2 );
    writefln( "r2.y1 is %d, r2.y2 is %d", r2.y1, r2.y2 );
}

    uint x1 = uniform( r1.x1, r1.x2 + 1, Lucky );

debug
    writefln( "Generated value for x1: %d", x1 );

    uint x2 = uniform( r2.x1, r2.x2 + 1, Lucky );

debug
    writefln( "Generated value for x2: %d", x2 );

    uint y1 = uniform( r1.y1, r1.y2 + 1, Lucky );

debug
    writefln( "Generated value for y1: %d", y1 );

    uint y2 = uniform( r2.y1, r2.y2 + 1, Lucky );

debug
    writefln( "Generated value for y2: %d", y2 );

    // Randomly decide whether to carve horizontally or vertically first.
    if( flip() )
    {
      add_corridor_x( y1, x1, x2, &m );
      add_corridor_y( x2, y1, y2, &m );
    }
    else
    {
      add_corridor_y( x1, y1, y2, &m );
      add_corridor_x( y2, x1, x2, &m );
    }
  } // foreach( c; 0 .. 7 )

version( none )
{
  // Now we'll do the same thing with a random sample of 1d6 of the rooms, so
  // that some rooms have multiple corridors leading to or from them.
  room[] rr2 = r.dup.partialShuffle( d(), Lucky );

  // Randomly get coordinates from each room and connect them
  foreach( c; 0 .. rr2.length - 1 )
  {
    room r1 = rr2[c];
    room r2 = rr2[c + 1];

    uint x1 = uniform( r1.x1, r1.x2 + 1, Lucky );
    uint x2 = uniform( r2.x1, r2.x2 + 1, Lucky );
    uint y1 = uniform( r1.y1, r1.y2 + 1, Lucky );
    uint y2 = uniform( r2.y1, r2.y2 + 1, Lucky );

    // Randomly decide whether to carve horizontally or vertically first.
    if( flip() )
    {
      add_corridor_x( y1, x1, x2, &m );
      add_corridor_y( x2, y1, y2, &m );
    }
    else
    {
      add_corridor_y( x1, y1, y2, &m );
      add_corridor_x( y2, x1, x2, &m );
    }
  } // foreach( c; 0 .. rr2.length - 1 )
} // version( none )

  // Finally, get random coordinates from a random room and put the player
  // there:

  uint srindex = uniform( 0, 9, Lucky );

debug
  writefln( "sr is r[%d]", srindex );

  room sr = r[ uniform( 0, 9, Lucky ) ];

debug
{
  writefln( "sr.x1 is %d, sr.x2 is %d", sr.x1, sr.x2 );
  writefln( "range for player x is [%d, %d]", sr.x1 + 1, sr.x2 - 1 );
  writefln( "sr.y1 is %d, sr.y2 is %d", sr.y1, sr.y2 );
  writefln( "range for player y is [%d, %d]", sr.y1 + 1, sr.y2 - 1 );
}

  ubyte px = cast(ubyte)uniform( sr.x1 + 1, sr.x2, Lucky );
  ubyte py = cast(ubyte)uniform( sr.y1 + 1, sr.y2, Lucky );

debug
{
  writefln( "Generated player x is %d", px );
  writefln( "Generated player y is %d", py );
}

  m.player_start = [py, px];

  // Pass the generated rooms to the map for record-keeping
  m.r = r;

  return m;
} // map generate_new_map()

// Generates a new, empty `map'
map empty_map()
{
  map m;
  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      m.i[y][x] = No_item;
      m.t[y][x] = Terrain.wall;
    }
  }

  m.player_start = [ 0, 0 ];

  return m;
}

version( testmap )
{

map test_map()
{
  map nu;

  nu.player_start = [ 1, 1 ];

  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      nu.i[y][x] = No_item;
      if( y == 0 || y == MAP_y || x == 0 || x == MAP_x )
      {
        nu.t[y][x] = Terrain.wall;
      }
      else
      {
        if( (y < 13 && y > 9) && ((x > 19 && x < 24) || (x < 61 && x > 56)) )
        { nu.t[y][x] = Terrain.wall;
        }
        else
        {
          if( (y < 13 && y > 9) && (x > 30 && x < 50) )
          { nu.t[y][x] = Terrain.water;
          }
          else
          { nu.t[y][x] = Terrain.floor;
          }
        } /* else from if( (y < 13 && y > 9) ... */
      } /* else from if( y == 0 || y == MAP_y ... */
    } /* foreach( x; 0 .. MAP_X ) */
  } /* foreach( y; 0 .. MAP_Y ) */

  // test monsters

  monst goobling = new_monst_at( 'g', "goobling", 0, 0, 2, 2, 0, 10, 2, 0, 2,
                                 1000, 60, 20 );

  add_mon( &nu, goobling );

static if( false ) /* never */
{
  goobling.x = 50;
  add_mon( &nu, goobling );
  goobling.y = 10;
  add_mon( &nu, goobling );
}

  // test items

  // a test item "old sword" which grants a +2 bonus to the player's
  // attack roll
  item old_sword = { sym:symdata( '(', A_NORMAL ),
                     name:"old sword",
                     type:ITEM_WEAPON, equip:EQUIP_NO_ARMOR,
                     addd:0, addm:2 };
  nu.i[10][5] = old_sword;

// I'm too lazy to do all of this crap right now (TODO)
static if( false ) /* never */
{
  item ring = { .sym = symdata( '=', A_NORMAL ),
                .name = "tungsten ring",
                .type = ITEM_JEWELERY, .equip = EQUIP_JEWELERY_RING,
                .addd = 0, .addm = 0 };
  nu.i[10][2] = ring;
  nu.i[10][1] = ring;
  item helmet = { .sym = symdata( ']', A_NORMAL ),
                  .name = "hat",
                  .type = ITEM_ARMOR, .equip = EQUIP_HELMET,
                  .addd = 0, .addm = 0 };
  nu.i[10][3] = helmet;
  item scarf = { .sym = symdata( ']', A_NORMAL ),
                 .name = "fluffy scarf",
                 .type = ITEM_ARMOR, .equip = EQUIP_JEWELERY_NECK,
                 .addd = 0, .addm = 0 };
  nu.i[11][3] = scarf;
  item tunic = { .sym = symdata( ']', A_NORMAL ),
                 .name = "tunic",
                 .type = ITEM_ARMOR, .equip = EQUIP_CUIRASS,
                 .addd = 0, .addm = 0 };
  nu.i[12][3] = tunic;
  item gloves = { .sym = symdata( ']', A_NORMAL ),
                  .name = "pair of leather gloves",
                  .type = ITEM_ARMOR, .equip = EQUIP_BRACERS,
                  .addd = 0, .addm = 1 };
  nu.i[13][3] = gloves;
  item pants = { .sym = symdata( ']', A_NORMAL ),
                 .name = "pair of trousers",
                 .type = ITEM_ARMOR, .equip = EQUIP_GREAVES,
                 .addd = 0, .addm = 0 };
  nu.i[14][3] = pants;
  item kilt = { .sym = symdata( ']', A_NORMAL ),
                .name = "plaid kilt",
                .type = ITEM_ARMOR, .equip = EQUIP_KILT,
                .addd = 0, .addm = 0 };
  nu.i[15][3] = kilt;
  item boots = { .sym = symdata( ']', A_NORMAL ),
                 .name = "pair of shoes",
                 .type = ITEM_ARMOR, .equip = EQUIP_FEET,
                 .addd = 0, .addm = 0 };
  nu.i[16][3] = boots;
  item tailsheath = { .sym = symdata( ']', A_NORMAL ),
                      .name = "leather tailsheath",
                      .type = ITEM_ARMOR, .equip = EQUIP_TAIL,
                      .addd = 0, .addm = 1 };
  nu.i[17][3] = tailsheath;
} /* static if( false ) */
  
  return nu;
}

}
