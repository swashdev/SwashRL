Spelunk! version 0.023
Readme file, last updated 2018-07-24 04:48 EST
Contact the maintainer: <philip@swash.link>

---

Spelunk! is a Roguelike game currently in the early development phases.  The
actual "game" part is not yet functional, as it's still in need of a few
important pieces.

As the software is still under development and has not seen an official
release, it currently has NO DOCUMENTATION, save for that mentioned in this
file.

Spelunk! currently has git respositories hosted at the following locations:
  <https://github.com/swashdev/Spelunk>

## License Agreement

Spelunk! is released as careware.  You can find the license agreement in
<license.txt>.  However, as it currently exists, it is dependent on some
software libraries and code that are released under different licenses.
See <3rdparty.txt> for more information.

You are of course free to use Spelunk!, and I wouldn't have given you the
source code if I didn't want you to mess with it, but be sure to abide by the
terms of the license agreement if you're going to be distributing it.  This is
my child and I will defend it from you if I have to.

## Supported Systems

Spelunk! was originally written for Linux, and is confirmed to still work on
Linux and FreeBSD as of development version 0.022.

Windows support has been temporarily removed because we couldn't find a
Windows-compatible version of curses with a working D wrapper (hence the lack
of support for PDCurses) and alternative curses libraries tend to use software
licenses incompatible with the license I'm using.

I hope to eventually port it to more systems, but I'm limited in my ability to
officially support systems by their availability to me.  If you'd like to
become a volunteer maintainer for Spelunk! on your system, [contact me on
GitHub](https://github.com/swashdev) and we can work something out.

## Compiling

Starting with version 0.022, Spelunk! has been programmed in D.  This means
you'll need DmD to compile it (there are versions available for every major
platform including FreeBSD), but if you also get dub, the D package manager,
it will do a lot of your work for you including downloading dependencies.

You can make some changes to how Spelunk! is configured by editing the file
<src/config.d>.  This file has a lot of comment blocks which explain how
to configure Spelunk!  These configuration settings will be interpreted and,
if necessary, modified, in <src/global.d>

To compile, navigate to the root folder (the same folder this readme file is
in) and type:

> ``dub build``

You'll need to be connected to the Internet so that dub can download the
packages that it needs.

By default, Spelunk! will compile with SDL.  However, you can also compile
with ncurses by using dub's ``--config`` flag, and even compile with _only_
ncurses, by using one of the following commands:

> ``dub build --config ncurses
> ``dub build --config ncurses-nosdl

In theory, you could use PDCurses instead, but this isn't being actively
supported because frankly noone on the development team can get it to work.
If you can, we'd love to hear how you did it.  To compile with PDCurses,
use one of the following commands:

> ``dub build --config pdcurses``
> ``dub build --config pdcurses-nosdl``

## Change Logs

For all of your change logging needs, see <docs/changes.txt>.  For those
interested, there's also a more in-depth history of the project being recorded
in <docs/history.txt>

## Contributing

If you're thinking of making a contribution to the Spelunk! project, first of
all thank you very much!  We now have
[contribution guidelines](docs/CONTRIBUTING.MD) to help you get started.

The best way to contribute to Spelunk! is via
[our GitHub page](https://github.com/swashdev/Spelunk), where you can follow
the conversation and see where we need help.

## Have fun!

Spelunk! is the reinvigoration of a game project I've been fiddling with and
rebooting ever since I was in high school, so do try not to take it too
seriously and have fun with it.  Do take the license agreement seriously,
though, because we do.
