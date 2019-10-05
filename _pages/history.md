---
layout: default
title: History
description: A brief history of the SwashRL project, from conception to present day.
---

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

| Version Name         | Date/time Finalized  | Description |
|----------------------|----------------------|-------------|
| 0.map                | 2015-08-24 12:31 EST | First version of the current source code.  Displayed a test map.  Apart from the ability to quit the program, there was no user interaction. |
| 0.move               | 2015-08-24 14:10 EST | Movement implemented |
| 0.colission          | 2015-08-24 20:14 EST | Collision detection implemented.  The typo in the version name is accurate to the actual label I gave this version of the program. |
| 0.hazards            | 2015-08-24 21:29 EST | The first hazard is implemented: If the player steps in the water, they die. |
| 0.text-effects       | 2015-08-29 17:58 EST | "Text effects" (inverted colors for walls) implemented. |
| 0.monster-display    | 2015-08-30 14:44 EST | The first monster (a goobling) is implemented.  It is displayed on the map but does not interact with anything. |
| 0.monster-colission  | 2015-08-30 19:56 EST | The player now collides with monsters, producing the message "You bump into a *%s*.  It doesn't look too pleased." |
| 0.monster-fight      | 2015-09-02 10:23 EST | This was the first version of Slumbering Dragon to have Windows support; if the `WINDOWS` flag was set, the program would compile with pdcurses rather than ncurses.  Rudimentary combat is implemented: If the player runs in to the goobling, the player attacks and then the goobling attacks back. |
| 0.monster-move       | 2015-09-03 21:43 EST | Monster movement first implemented: Monsters will move randomly. |
| 0.monster-move-chase | 2015-09-04 12:13 EST | Monsters now move toward the player and kind of navigate around obstacles.  They can also attack without the player having to attack them first. |
| 0.monster-move-fly   | 2015-09-04 17:13 EST | First implementation of flying and swimming monsters. |

FORRNIF
-------

After version 0.monster-move-fly, later rebranded to version 0.0.10, I started
to take the project very seriously.  I changed the name to FORRNIF and started
typing up ambitious design documents involving a huge fantasy world with a
complex history.  Unfortunately 2016 was a very bad time for me and
development stalled for over a year.

| Version | Date/time Finalized  | Description |
|---------|----------------------|-------------|
| 0.0.11  | 2015-10-04 19:59 EST | First update primarily composed of bugfixes.  This was also the first update in which slain monsters were removed permanently from the map data.  Change-logging starts for the first time, with proper version numbers retroactively added to the Slumbering Dragon versions. |
| 0.0.12  | 2016-12-27 17:14 EST | Monsters collide with each other for the first time, instead of multiple monsters "stacking" on the same space. |
| 0.0.13  | 2017-01-17 15:13 EST | Random number generator, hit dice, and attack rolls implemented. |
| 0.0.14  | 2017-01-17 23:07 EST | A rudimentary status bar, displaying the player's hit points and attack dice, is implemented, and the map is shrunk slightly to make room for this and the message line.  This is also the first update in which messages are buffered and then displayed after every turn instead of in the middle of the turn, but the message buffer didn't start to work right until version 0.017. |

Spelunk!
--------

After the release of version 0.0.14 it became obvious that trying to turn
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

| Version | Date/time Finalized  | Description |
|---------|----------------------|-------------|
| 0.0.15  | 2017-01-20 20:41 EST | Minor code rewrites to make the code compliant with C89 (at the time I wanted the game to be so universally compatible that it could be compiled on DOS).  This is also the first version which enforced system compatibility, in the sense that the Windows version would refuse to compile with ncurses because ncurses is POSIX-exclusive. |
| 0.0.16  | 2017-01-20 23:04 EST | After much futzing around I believed I had solved the problem of messages not buffering properly.  Unfortunately I was wrong and the only thing I managed to do with this update was break text effects. |
| 0.017   | 2017-01-22 18:02 EST | Message buffer finally works correctly.  Text effects fixed.  Minor optional graphical effects added.  The "history" file is started.  New commands added with the ability for some commands to not use a turn (particularly wait, help, and version).  The ability to read the stored message history by pressing 'P' is also implemented.  Note the new version numbering system; this made it easier to change and output the version number in C.  From here on out, the code was numbered as Release.Revision until version 0.028, which added the git commit number as a "Patch" number. |
| 0.018   | 2017-01-29 22:28 EST | Color pairs defined, although color itself is not yet a focus of the project.  Some of the code is edited slightly so that color can not be enabled if text effects are not.  For some reason, all of the color pairs defined in this update were lost upon storage and were never recovered, so colors were not again defined until version 0.025. |
| 0.019   | 2017-02-22 22:04 EST | Key handling procedures updated, new Dvorak-oriented control scheme available with press of the F12 key.  The code is imported into a [git repository](https://github.com/swashdev/SwashRL), with more loose version control being done. |
| 0.020   | 2017-03-05 17:48 EST | Initial attempts at field-of-vision handling code using a [recursive shadowcasting algorithm](http://www.roguebasin.com/index.php?title=FOV_using_recursive_shadowcasting).  First version of the project to use code contributed by another user (the macro which detects Windows rather than requiring the user to define a flag, provided by Elronnd).  Map tiles are now bitmasks.
| 0.020-1 | 2017-03-05 21:55 EST | The first "in-between" version number.  The [libtcod](http://roguecentral.org/doryen/libtcod/) implementation of Bjorn Bergstrom's reverse shadowcasting algorithm is implemented into the code, making this the first version of the game to use third-party licensed source code. |
| 0.021   | 2017-09-02 02:36 EST | Improvements to the operating system detecting code, courtesy of Elronnd.  Attempts are started and then swiftly abandoned to revamp the string handling code.  Tiles are now defined as structs rather than bitmasks, in order to make them more functional, and map symbols are also now structs so that they can be defined modularly (and in the hopes that a sym struct can store an image sprite for a future graphical version of the game).  Additionally, work on the inventory system begins.  [The git repository was reset](https://github.com/swashdev/SwashRL/blob/ce6d653ee3f0e8a083aceca6aa1374f30da3b55d/gitreset.txt) at this point in anticipation of major overhauls to the code for version 0.022. |
| 0.022   | 2017-12-05 21:45 EST | The code is fully translated into D, unlocking additional functionality for the source code.  Unfortunately this breaks PDCurses and thus renders Windows support impossible.  By making use of the new D code, a large amount of the configuration settings are now automated and message formatting now works properly again.  Additionally, the source code now uses the dub package manager to handle dependencies. |
| 0.023   | 2017-12-05 22:30 EST | An update to 0.022 which actually compiles this time. |

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

| Version | Date/time Finalized  | Description |
|---------|----------------------|-------------|
| 0.024   | 2018-08-05 02:23 EST | First version with SDL support.  The program can be compiled with or without SDL, ncurses, or PDCurses depending on what configuration is requested of dub.  As a result, Windows support is renewed.  However, PDCurses support is still broken.  A number of idiosyncratic changes to the code base are made, such as using a hashmap to store key mappings and storing the input and output code in a class so they can be swapped out depending on whether SDL or curses is being used.  The message buffer is now a linked list, simplifying the code required to generate it and allowing for a larger number of buffered messages.  This is also the first version of the program to accept command-line arguments and to implement a rudimentary (read: caveman-like) level generator.  "Community Documentation," such as a Guideline for Contributors and GitHub-specific Issue and Pull Request templates, are added. |
| 0.025   | 2018-08-10 03:29 EST | First version with color support.  Map memory implemented, but buggy on certain user interfaces.  The message buffer and status bar now use a bold font on the SDL terminal interface so they look better on the default smaller tile size.  Configuration options added to allow the builder to define their own fonts and font size.  The test map can now be accessed using the --test-map command-line option, but only on debug builds. |
| 0.026   | 2018-08-19 04:53 EST | First version that allows saving and loading of the map. |
| 0.027   | 2018-08-19 07:19 EST | First version to implement mold, a feature that was originally implemented in the Python version of Crawl back in 2012.  Blood is also implemented for the first time. |
| 0.028   | 2018-11-27 19:58 EST | Largely a bugfix version.  This is the first version of the program which uses the git commit number as a "patch number," bringing the version numbering system slightly closer to the typical Major.Minor.Patch version number system that many software projects use, but also allowing us to easily identify which specific commit caused a bug if an error is reported.  Made it easier to change the name of the program for source modders.  Added some cheat modes which are activated as command-line arguments.  Some changes to the source code to be more consistent and cause fewer problems.  Slight changes to the wording of the special exception to the Apache License 2.0. |
| 0.029   | 2019-01-28 17:54 CST | Numerous idiosyncratic changes to the inventory code, including giving the user more clear instructions on how to interact with the equipment screen.  The equipment and inventory screens are now clearly separated and cooperate nicely with each other without nearly so much spaghetti code. |
| 0.029-1 | 2019-01-29 13:10 CST | A minor release correcting small errors in the documentation from version 0.029 and moving some of the code around in `iomain.d` for consistency. |
| ~~0.030~~   | 2019-09-01 16:38 CST | A new map generator was written, allowing better generation of traditional "Rogue-like" maps, and setup begins for further code revisions to make it easier to genericize the map generation functions later on.  The code is re-licensed under the BSD 3-clause license. |
| **0.030-1** | 2019-09-01 16:53 CST | A minor release correcting an error made while copying and pasting the license notice into the repository and the source code files within; when I copied and pasted the BSD 3-clause license I neglected to check if any alterations had been made to the warranty and liability disclaimer.  As it happens there were, so this revision fixes that. |
