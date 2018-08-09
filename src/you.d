/*
 * Copyright 2016-2018 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License, excepting that
 * Derivative Works are not required to carry prominent notices in changed
 * files.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import global;

struct player
{
  symbol sym;
  ushort x, y;
  int hp;
  inven inventory;
  dicebag attack_roll;
}

player init_player( ubyte y, ubyte x )
{
  player u;
  if( x < 80 )
  { u.x = x;
  }
  else
  { u.x = 1;
  }
  if( y < 24 )
  { u.y = y;
  }
  else
  { u.y = 1;
  }
  u.sym = symdata( SMILEY, Color( CLR_WHITE, true ) );
  u.hp = roll( 3, 2 );

  foreach( count; 0 .. 40 )
  { u.inventory.items[count] = No_item;
  }
  u.inventory.quiver_count = 0;
  u.inventory.coins = 0;
  u.attack_roll = Dice( 2, 0, 0, 1000 );
  return u;
}
