---
layout: default
title: History
description: A brief history of the SwashRL project, from conception to present day.
permalink: /history/
---

Table of Contents
-----------------

* [Prehistory]
* [Slumbering Dragon]
* [FORRNIF]
* [Spelunk!]
  * [The First Public git Repository]
  * [The Translation into D]
* [SwashRL]
  * [SDL Support]

[Jump to the current version](#0035)

[Back to top]: #table-of-contents

[Prehistory]: #prehistory
[Slumbering Dragon]: #slumbering-dragon
[FORRNIF]: #forrnif
[Spelunk!]: #spelunk
[SwashRL]: #swashrl

[The First Public git Repository]: #0019
[The Translation into D]: #0022
[SDL Support]: #0024

[0.map]: #0map
[0.0.0]: #0map
[0.move]: #0move
[0.0.1]: #0move
[0.colission]: #0colission
[0.0.2]: #0colission
[0.hazards]: #0hazards
[0.0.3]: #0hazards
[0.text-effects]: #0text-effects
[0.0.4]: #0text-effects
[0.monster-display]: #0monster-display
[0.0.5]: #0monster-display
[0.monster-colission]: #0monster-colission
[0.0.6]: #0monster-colission
[0.monster-fight]: #0monster-fight
[0.0.7]: #0monster-fight
[0.monster-move]: #0monster-move
[0.0.8]: #0monster-move
[0.monster-move-chase]: #0monster-move-chase
[0.0.9]: #0monster-move-chase
[0.monster-move-fly]: #0monster-move-fly
[0.0.10]: #0monster-move-fly
[0.0.11]: #0011
[0.0.12]: #0012
[0.0.13]: #0013
[0.0.14]: #0014
[0.0.15]: #0015
[0.0.16]: #0016
[0.017]: #0017
[0.018]: #0018
[0.019]: #0019
[0.020]: #0020
[0.020-1]: #0020-1
[0.021]: #0021
[0.022]: #0022
[0.023]: #0023
[0.024]: #0024
[0.025]: #0025
[0.026]: #0026
[0.027]: #0027
[0.028]: #0028
[0.029]: #0029
[0.029-1]: #0029-1
[0.030]: #0030
[0.030-1]: #0030-1
[0.031]: #0031
[0.031 Christmas Update]: #0031-christmas-update
[0.031-christmas-update]: #0031-christmas-update
[0.032]: #0032
[0.033]: #0033
[0.034]: #0034
[0.035]: #0035

Prehistory
----------

SwashRL is actually the modern reimagining of a game I started writing in
C# way back in 2005, while I was still in high school.  At that time it was
simply named Crawl, and served as my homage to '90s text adventure games and
early dungeon crawlers.  At the time I didn't even know that Roguelikes were a
thing, but it ended up being very similar to rudimentary Roguelikes.  I came
back to this project many times, porting it first to C++ and then Python.
After a while writing a Roguelike became the de facto way I learned new
programming languages.

Despite the name, Crawl had nothing to do with Linley's Dungeon Crawl or its
derivative Stone Soup, which is the reason I ended up changing the name.  In
fact in its original form it hardly resembled a Roguelike at all.  The game
generated a dungeon by randomly generating two walls stretching from left to
right.  The player (`P`) was required to proceed from left to right down
twenty levels, fighting monsters (`O`) with randomly-generated names and
collecting treasure (`X`) which included weapons and armor.  The dungeon also
had stalactites (`V`) and test tubes (`U`) which acted as "obstacles."

It's safe to say that Crawl was not a very well-designed game, but it remained
close to my heart as one of my first really ambitious programming projects.

Slumbering Dragon
-----------------

In 2015, I was experimenting with Linux virtual machines and messing around
with various utilities when I decided to try writing a simple game to see if I
could work out how to get curses working in C.  I called this game Slumbering
Dragon, or simply SD.  Because I wasn't planning on releasing it, I didn't
bother with proper version numbers (or checking to see if the name was already
taken), which is why in historical versions of the code you instead see a 0
followed by a short one- or two-word phrase describing what that version had
introduced.

### 0.map

2015-08-24 12:31 EST

First version of the current source code.  Displayed a test map.
Apart from the ability to quit the program, there was no user interaction.
The test map has changed over time as new game features has been implemented,
but its general layout has remained largely the same.

[Back to top]

### 0.move

2015-08-24 14:10 EST

Movement implemented: The player character is able to move around with the
traditional HJKLYUBN movement keys.  Due to a lack of collision detection, it
is possible to move outside the boundaries of the map and cause the game to
crash due to an array index exception.

[Back to top]

### 0.colission

2015-08-24 20:14 EST

Collision detection implemented: Walking into a wall produces the message
"Ouch!  You walk straight into a wall!".  The typo in the version name is
accurate to the actual label I gave this version of the program.

[Back to top]

### 0.hazards

2015-08-24 21:29 EST

The first hazard is implemented: If the player steps in the water, they die.

[Back to top]

### 0.text-effects

2015-08-29 17:58 EST

"Text effects" (inverted colors for walls) implemented.  I'm not certain, but
I believe this is also the update where I started using the "dim" effect to
draw the player character in a darker color after they die, which still exists
in the curses interface at time of writing.

[Back to top]

### 0.monster-display

2015-08-30 14:44 EST

The first monster (a goobling) is implemented.  It is displayed on the map but
does not interact with anything.

[Back to top]

### 0.monster-colission

2015-08-30 19:56 EST

The player now collides with monsters, producing the message "You bump into a
*%s*.  It doesn't look too pleased."

[Back to top]

### 0.monster-fight

2015-09-02 10:23 EST

Rudimentary combat is implemented:  If the player runs in to the goobling, the
player attacks and then the goobling attacks back.  The goobling has no AI and
therefore can not initiate combat; all interactions originate from the player
at this stage.

This was the first version of Slumbering Dragon to have Windows support; if
the `WINDOWS` flag was set, the program would compile with pdcurses rather
than ncurses.  

[Back to top]

### 0.monster-move

2015-09-03 21:43 EST

Monster movement first implemented:  Monsters will move in a random direction
every turn.

[Back to top]

### 0.monster-move-chase

2015-09-04 12:13 EST

Monsters now move toward the player and kind of navigate around obstacles.
They can also attack without the player having to attack them first.

[Back to top]

### 0.monster-move-fly

2015-09-04 17:13 EST

Rudimentary first implementation of monsters which can fly over and swim
through obstacles.

There was an attrocious bug in this version which caused the movement
functions to attempt to gather tile data from monsters on the map, which meant
that despite being finalized this version couldn't even compile.

[Back to top]

FORRNIF
-------

After version [0.monster-move-fly], later rebranded to version 0.0.10, I
started to take the project very seriously.  I changed the name to FORRNIF and
started typing up ambitious design documents involving a huge fantasy world
with a complex history.  Unfortunately 2016 was a very bad time for me and
development stalled for over a year.

### 0.0.11

2015-10-04 19:59 EST

This is the first update primarily composed of bugfixes.  This was also the
first update in which slain monsters were removed permanently from the map
data.  This was also the first update in which monster AI was handled by the
map, allowing every monster on a particular map to take their turn in sequence
more easily.

Change-logging starts for the first time, with proper version numbers
retroactively added to the Slumbering Dragon versions.

[Back to top]

### 0.0.12

2016-12-27 17:14 EST

Monsters collide with each other for the first time, instead of multiple
monsters "stacking" on the same space.

[Back to top]

### 0.0.13

2017-01-17 15:13 EST

Random number generator, hit dice, and attack rolls implemented.  This update
established the practice of using a random number generator to simulate actual
die rolls rather than using arbitrary ranges like most Roguelikes do, still in
effect at time of writing.

[Back to top]

### 0.0.14

2017-01-17 23:07 EST

A rudimentary status bar, displaying the player's hit points and attack dice,
is implemented, and the map is shrunk slightly to make room for this and the
message line.

This is also the first update in which messages are buffered and then
displayed after every turn instead of in the middle of the turn, but due to
issues with the C standard's implementation of string formatting the message
buffer didn't start to work right until version [0.017] and proper message
formatting wouldn't be successfully implemented until version [0.022].

[Back to top]

Spelunk!
--------

After the release of version [0.0.14] it became obvious that trying to turn
Slumbering Dragon into a huge fantasy epic was just going to overwhelm me, so
instead I decided to vastly simplify the project and turn it into a more
casual game.  Rather than a sprawling RPG, Spelunk! was to be a more generic
dungeon crawler with a major focus on survivalism and navigation.  I even
wrote up plans for the player character's height to be a major factor in
gameplay, with taller characters requiring less rope in order to climb down
chasms to proceed through the game.

Spelunk! also boasted a less-than-traditional bestiary (not that any of it was
ever implemented) with more monsters taken from American folklore than Tolkein
novels and European traditions.  Some of my favorite monsters from this era of
the game included the [Hidebehind](https://en.wikipedia.org/wiki/Hidebehind)
and [Agropelter](https://en.wikipedia.org/wiki/Agropelter), and there were
even plans to include an evil scientist and a hunchbacked assistant, to
explain the presence of test tubes in the dungeon.  The overall theme was to
make this feel like a more American game than most fantasy Roguelikes.

### 0.0.15

2017-01-20 20:41 EST

Minor code rewrites to make the code compliant with C89 (at the time I wanted
the game to be so universally compatible that it could be compiled on DOS).
This is also the first version which enforced system compatibility, in the
sense that the Windows version would refuse to compile with ncurses because
ncurses is POSIX-exclusive.

[Back to top]

### 0.0.16

2017-01-20 23:04 EST

After much futzing around I believed I had solved the problem of messages not
buffering properly.  Unfortunately I was wrong and the only thing I managed to
do with this update was break text effects.

[Back to top]

### 0.017

2017-01-22 18:02 EST

Message buffer finally works correctly.  Text effects fixed.  Minor optional
graphical effects added.

Certain commands, such as the "wait," "help," and "see version number"
commands, no longer consume a turn.  The ability to read the stored message
history by pressing 'P' is also implemented.

An experimental feature was implemented in this update which caused monsters
to blink if the `USE_BLINK` flag was defined.  I actually rather liked the
concept behind this, and wanted to use this feature to highlight which
monsters were hostile, but at some point in development it was quietly dropped
and never spoken of again.

Note the new version numbering system; this made it easier to change and
output the version number in C.  From here on out, the code was numbered as
Release.Revision until version [0.028], which added the git commit
ID as a "Patch number."

The "history" file is started, with the intention of providing a more in-depth
look at the development process behind Spelunk!

[Back to top]

### 0.018

2017-01-29 22:28 EST

The first rudimentary implementation of items appeared in this update.

The message buffer was sorta-kinda fixed to allow string formatting, although
the method used involved a kludge in which the message was output to the
screen and then read in and erased using curses.

Color pairs defined, although color itself is not yet a focus of the project.
Some of the code is edited slightly so that color can not be enabled if text
effects are not.  For some reason, all of the color pairs defined in this
update were lost upon storage and were never recovered, so colors were not
again implemented until version [0.025].

[Back to top]

### 0.019

2017-02-22 22:04 EST

Key handling procedures are updated, with a new Dvorak-oriented control scheme
available with press of the F12 key.

At this point in development, the random number generator code was greatly
simplified and optimized to mostly use six-sided dice.  This is because around
this point in development I had a pretty good idea of how I wanted Spelunk!'s
major game mechanics to work.

The code is imported into a
[git repository](https://github.com/swashdev/SwashRL), with more loose version
control being done.

[Back to top]

### 0.020

2017-03-05 17:48 EST

Initial attempts at field-of-vision handling code using a
[recursive shadowcasting algorithm](http://www.roguebasin.com/index.php?title=FOV_using_recursive_shadowcasting).
Despite this version being finalized, my implementation of the algorithm was
incomplete, and as such it failed to cast shadows properly.

This is the first version of the project to use code contributed by another
user (the macro which detects Windows rather than requiring the user to define
a flag in the source code, provided by Elronnd).

Map tiles are re-implemented as bitmasks to make it easier to define new ones.

Despite quite a lot of huffing and puffing on my part, this was the version of
the source code in which I, begrudgingly, agreed that running into a wall
should not count as a turn.

[Back to top]

### 0.020-1

2017-03-05 21:55 EST

The first "in-between" version number.  The
[libtcod](http://roguecentral.org/doryen/libtcod/) implementation of Bjorn
Bergstrom's reverse shadowcasting algorithm is implemented, replacing my
pathetic attempt from version [0.020], making this the first version of the
game to use third-party licensed source code.

[Back to top]

### 0.021

2017-09-02 02:36 EST

Improvements to the operating system detecting code, courtesy of Elronnd.

Attempts are started and then swiftly abandoned to revamp the string handling
code.

Tiles are now defined as structs rather than bitmasks, in order to make them
more functional, and map symbols are also now structs so that they can be
defined modularly (and in the hopes that a sym struct can store an image
sprite for a future graphical version of the game).

Additionally, work on the inventory system begins.

[The git repository was reset](https://github.com/swashdev/SwashRL/blob/ce6d653ee3f0e8a083aceca6aa1374f30da3b55d/gitreset.txt)
at this point in anticipation of major overhauls to the code for version
[0.022].

[Back to top]

### 0.022

2017-12-05 21:45 EST

The code is fully translated into D, unlocking additional functionality for
the source code.  Unfortunately this breaks PDCurses and thus renders Windows
support impossible.  As a result, I am now only able to develop and test the
game on a Linux virtual machine, as at this point I had not yet fully switched
over to Linux.

By making use of the new D code, a large amount of the configuration settings
are now automated, meaning that a user compiling from source no longer has to
edit source code files to get the game working.

Message formatting now finally works properly, resolving one of the
longest-standing bugs in the source code at the time.

Additionally, the source code now uses the `dub` package manager to handle
dependencies.

[Back to top]

### 0.023

2017-12-05 22:30 EST

[Download](https://github.com/swashdev/SwashRL/releases/tag/v0.023)

An update to [0.022] which actually compiles this time.

SwashRL
-------

On July 9th, I had a major panic attack that left me crippled by depression
and anxiety for weeks.  It was (and still is) the worst panic attack I'd ever
had in my life.  As I came down, though, I realized that I had not been
pursuing my passions properly.  As a result, I decided to renew my game
projects, which included this game.  I changed the name to SwashRL, to finally
silence those who kept getting the game confused with Spelunky, and
re-licensed it under the Apache License 2.0 and then eventually the BSD
3-clause license to make it easier for people to create derivative software.
I decided to pursue my programming not just as a hobby, but as a passion, so
that I could focus on exercising my skills hopefully for the betterment of
myself and humanity.

### 0.024

2018-08-05 02:23 EST

[Download](https://github.com/swashdev/SwashRL/releases/tag/v0.024)

First version with SDL support.  The program can be compiled with or without
SDL, ncurses, or PDCurses depending on what configuration is requested of dub.
As a result, Windows support is renewed.  However, PDCurses support is still
broken.

A number of idiosyncratic changes to the code base are made, such as using a
hashmap to store key mappings and storing the input and output code in a class
so they can be swapped out depending on whether SDL or curses is being used.

The message buffer is now a linked list, simplifying the code required to
generate it and allowing for a larger number of buffered messages.

This is also the first version of the program to accept command-line arguments
and to implement a rudimentary (read: caveman-like) level generator.

"Community Documentation," such as a Guideline for Contributors and
GitHub-specific Issue and Pull Request templates, are added.

[Back to top]

### 0.025

2018-08-10 03:29 EST

This is the first version to include color support, using standard curses
colors and imitating those colors in the SDL terminal interface.

Map memory is implemented, but buggy on certain user interfaces.

The message buffer and status bar now use a bold font on the SDL terminal
interface so they look better on the default smaller tile size.  Configuration
options added to allow the builder to define their own fonts and font size.

By this point, the game would generate a random level when launched, so the
`--test-map` command line option was added to debug builds to allow access to
the test map.

[Back to top]

### 0.026

2018-08-19 04:53 EST

First version that allows saving and loading of the map.

This is also the update which introduced the "really quit?" prompt, to prevent
accidentally quitting the game.  On the other hand, the SDL interface now has
a feature which causes the program to quit immediately without prompting if
the "close window" button is pressed, as an emergency shutdown feature
implemented just in case the game gets stuck in an infinite loop when waiting
for a keypress.

[Back to top]

### 0.027

2018-08-19 07:19 EST

First version to implement mold, a feature that was originally implemented in
the Python version of Crawl back in 2012.  Blood is also implemented for the
first time.  These don't really have any effect of gameplay as yet, and are
essentially small changes made to make the environment look more alive and
dynamic.

[Back to top]

### 0.028

[Download](https://github.com/swashdev/SwashRL/releases/tag/v0.028)

2018-11-27 19:58 EST

Largely a bugfix version.

Made it easier to change the name of the program for source modders.

Added some cheat modes which are activated as command-line arguments.

Some changes to the source code to be more consistent and cause fewer problems.

Slight changes to the wording of the special exception to the Apache License
2.0.

PDCurses support is resumed following implementation of
[unleashy](https://github.com/unleashy)'s
[pdcurses-d](https://github.com/unleashy/pdcurses-d) wrapper.

This is the first version of the program which uses the git commit number as a
"patch number," bringing the version numbering system slightly closer to the
typical Major.Minor.Patch version number system that many software projects
use, but also allowing us to easily identify which specific commit caused a
bug if an error is reported.

[Back to top]

### 0.029

2019-01-28 17:54 CST **(This version is no longer available)**

Numerous idiosyncratic changes to the inventory code, including giving the
user more clear instructions on how to interact with the equipment screen.

The equipment screen and inventory screen are now separated into two separate
functions with different keypresses, allowing the user to more quickly check
the contents of their bag or equipment slots.  This also drastically reduces
the amount of spaghetti code in the program.

[Back to top]

### 0.029-1

2019-01-29 13:10 CST

[Download](https://github.com/swashdev/SwashRL/releases/tag/v0.029-1)

A minor release correcting small errors in the documentation from version
[0.029] and moving some of the code around in `iomain.d` for consistency.

[Back to top]

### 0.030

2019-09-01 16:38 CST **(This version is no longer available)**

A new map generator was written, allowing better generation of traditional
"Rogue-like" maps, and setup begins for further code revisions to make it
easier to genericize the map generation functions later on.

The code is re-licensed under the BSD 3-clause license, the most permissive
license I can release it under while still being compatible with the
third-party code included with SwashRL.

[Back to top]

### 0.030-1

[Download](https://github.com/swashdev/SwashRL/releases/tag/v0.030-1)

2019-09-01 16:53 CST

A minor "in-between" release correcting an error made while copying and
pasting the license notice into the repository and the source code files
within:  When I copied and pasted the BSD 3-clause license I neglected to
check if any alterations had been made to the warranty and liability
disclaimer.  As it happens there were, so this revision fixes that.

[Back to top]

### 0.031

2019-12-21 19:52 CST

A minor release correcting a bug in the map generator introduced in
revision [0.030].  Originally the rooms in the maps were supposed to be
connected in random order, but I forgot to randomize the indexes of the rooms
before connecting them, so they would always be connected in the same order
that they were generated.  This update fixes that.

Revision 0.031 came after yet another substantial delay between releases and
ultimately was finalized just so that more work could get done.

[Back to top]

### 0.031 Christmas Update

2019-12-21 23:02 CST

This was a special release made to protest a decision by the Microsoft VSCode
team to remove an icon of a Santa hat from VSCode Insider because of a
ridiculous complaint they had received claiming that the very concept of
Christmas is inherently anti-Semitic and that Santa hats are "equivalent to a
swastika."

This update added greetings which the player would receive on certain
holidays, namely New Year's, Christmas, Halloween, and Hanamatsuri, referred to
in-game as Hanami.  Additionally, the player receives a "festive hat" if they start the game during the month of December.

As a side-effect, this release also fixed an error where items would be
allowed in inappropriate item slots.

This is the first official release of the game, besides the "in-between"
versions [0.020-1], [0.029-1], and [0.030-1], which did not increment the
version number; instead, this is simply an official update to version [0.031],
referred to in the repository as `v0.031-christmas-update`

[Back to top]

### 0.032

2020-09-11 17:28 CDT

[Download](https://github.com/swashdev/SwashRL/releases/tag/v0.032)

Following yet another substantial delay, Revision 0.032 represents significant
changes to the way that SwashRL handles colors in order to make them
substantially easier to store but also much more compatible between the curses
and SDL terminal interfaces.  Several issues with the way that the SDL
interface interprets color codes were fixed by using this method, and even
save files are notably smaller as a result.

Because of these changes, this is also the first version of the game which is
not compatible with earlier save files since the ability to save the dungeon
level was introduced in revision [0.026].

As an experimental extra feature, a configuration option was added which
allowed the user to compile a copy of SwashRL that uses the
[OpenDyslexic](https://opendyslexic.org/) Mono font rather than the standard
DejaVu Sans Mono font.  This should hopefully make it easier for people with
dyslexia to distinguish characters on the screen.

As a bonus, the player character is now displayed in a unique orange color as
an homage to the oldest game that I have ever published,
[Orange Guy's Quest](https://github.com/swashdev/orange-guys-quest).  This is
only true on the SDL terminal interface, however, because it doesn't come out
looking quite right on the curses interface.

Finally, on a sadder note, my boyfriend passed away between the release of
the [0.031 Christmas Update] and this revision.  Not only has he been a major
inspiration for me personally, but he also inspired me to keep on going with
my game dev projects, including SwashRL, and has even contributed some useful
ideas regarding the game's plot and gameplay.  In response, SwashRL has been
dedicated to his memory.

> To Seb (1994-2020)  For ten years, he taught me a lot about life, growing
> up, the universe, and people.  He suffered from a number of unfortunate
> health conditions, including mental health problems, but survived and
> persevered in spite of them, teaching me how to be strong myself and take
> care of myself even while trying to help others.  His contributions to my
> life and the value of his companionship can not be overstated.
> 
> Rest in peace, my dear friend and fellow weirdo.  As promised, I will do
> the very best I can to live in a way that you would have been proud of,
> not for pity but for its own sake.  You will be remembered, if only in
> this small way.

Take care of yourselves, friends.  Hopefully the next update will be out
before someone else dies :-p

[Back to top]

### 0.033

2021-01-27 18:26 CST

[Download](https://github.com/swashdev/SwashRL/releases/tag/v0.033)

Version 0.033's original goal was to implement the ability to drop an item
that the player is holding.  This was surprisingly difficult to do, and
resulted indirectly in a massive list of changes to the source code,
even compared to [0.032], making this quite possibly the most significant
update to the game since [the translation into D](0.022).

In addition to the player now being able to drop items, some items can now
stack in the player's inventory, and stacks will be indicated on the inventory
and equipment screens.

Items dropped on the ground will "bounce" off of items and stacks below them
until they find an empty square they can land on.  This may result in items
being lost forever if, for example, they land on a water tile.

The list of bug fixes in this version of the game is also quite extensive,
and includes the player picking up items in the appropriate hand, not drowning
if they attack a monster which happens to be on a water tile, and not causing
a range error by killing a monster.  Monster movement has also been greatly
improved, making it no longer possible for a terrestrial monster to exploit
poor collision detection to walk across water diagonally.

The [style guide was also updated](https://github.com/swashdev/SwashRL/blob/2d6d2781533955a040e1abe76f356c8eba2fcabf/docs/CONTRIBUTING.md#style-guide)
for version 0.033, following feedback from a certain French honey badger I
know who had a number of complaints about my use of whitespace, naming
conventions, the ham-fisted way that the code was transferred from C to D, and
the way I smelled.

So long was the delay between versions that I was
[seriously considering](https://github.com/swashdev/SwashRL/commit/01c4d5315baa703300ac4706c72f8cb191e466a5)
changing the version number to 0.∞ and treating the game as an "infinite
alpha" project that would never be completed.  However, inspired by my
passion for game development and simply having more fun with discrete version
numbers leading up to an eventual release, I decided to keep to the course
with SwashRL, because it may have been downgraded to a hobby in the face of
other projects but it's still tons of fun to work on.

[Back to top]

### 0.034

2021-01-28 22:30 CST

[Download](https://github.com/swashdev/SwashRL/releases/tag/v0.034)

This is a minor release largely to correct some mistakes I made while
documenting version [0.033], namely correcting the year in the license notice
and having deleted the wrong screenshot in the readme file.

This version does represent the official deprecation of the OpenDyslexic Mono
font and the settings used to activate it, however.  It was a good idea, but
in the end it just didn't work very well.  Hopefully in a future version I'll
be able to find a better way to implement it.

[Back to top]

### 0.035

2021-04-13 17:59 CDT

[Discission & Downloads](https://github.com/swashdev/SwashRL/releases/tag/v0.035)

Version 0.035 features a number of small fixes and additions but primarily
focuses on refining the inventory system.

Monsters, including the player, now have two character attributes, Strength
and Endurance, which are randomly generated when the monster is spawned (the
player gets 3d6 in both).  Items now also have variables which allow them to
impart modifiers on these attributes.  These features haven't been fully
implemented yet.

The number of equipment slots available to the player has been simplified down
to this list:
- Weapon-hand
- Off-hand
- Helmet
- Armor
- Shield
- Boots
- Left ring
- Right ring
- Necklace
- Clothes

A monster's equipment list is no longer stored in the same array as their open
inventory.  Instead, the equipment list is an associative array that's ordered
by the equipment slots from the above list.  The inventory is a dynamic array
(different monsters may now have different numbers of inventory slots) and the
wallet is a non-dynamic array (containing stacks of coins in 5 denominations).

Monster inventories will now be saved when the level is saved, and loaded when
the level is loaded.  This also goes for their wallet and equipment.

The color palette for the SDL terminal interface has been changed to a
variation on the Tango color palette, so the colors are less garish and stand
out more against the black background.  Several colors have been adjusted or
removed.

![An image showing the differences in color palettes between versions 0.034 and 0.035](images/v0.035-color-comparison.png)

SwashRL now incorporates a default font,
[bd-font from Bad Diode](https://git.badd10de.dev/bd-font/about/),
which is used if it doesn't find a valid TTF font file.

![An image showing version 0.035 in its default bd-font](images/v0.035-bd-font.png)

The player can now specify a random seed for the map generator, and the map
generation functions now use a separate random number generator from the rest
of the game to allow players to share level gens they think are particularly
interesting.

Other minor fixes include preventing the player from getting a free festive
hat if they are already wearing a hat (thus keeping the festive hat from
overwriting any armor they might be wearing) and fixing sessile monsters so
that they can no longer move.

[Back to top]
