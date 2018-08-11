SwashRL
=======

Readme file, last updated 2018-08-11 03:26 EST  
Contact the maintainer: <philip@swash.link>

---

SwashRL is a Roguelike game currently in the early development phases.  The
actual "game" part is not yet functional, as it's still in need of a few
important pieces.

As the software is still under development and has not seen an official
release, it currently has NO DOCUMENTATION, save for that mentioned in this
file.

SwashRL currently has git respositories hosted at the following locations:

* <https://github.com/swashdev/SwashRL>

## License Agreement

SwashRL is released under the Apache License 2.0, excepting that Derivative
Works are not required to carry prominent notices in changed files as
required by the normal Apache License 2.0 in Section 4b.  The license can be
found [here](LICENSE).

SwashRL uses some third-party resources to function.  For details, see the
[NOTICE file](NOTICE) and the third-party licenses referenced therein.

## Supported Systems

SwashRL was originally written for Linux, and is confirmed to still work on
Windows and Linux as of development version 0.025.

I hope to eventually port it to more systems, but I'm limited in my ability to
officially support systems by their availability to me.  If you'd like to
become a volunteer maintainer for SwashRL on your system, [contact me on
GitHub](https://github.com/swashdev) and we can work something out.

## Known Bugs

To submit a bug fix or report a possible solution, leave an Issue or a Pull
Request on [our GitHub page](https://github.com/swashdev/SwashRL).

* The PDCurses interface does not yet work due to all versions of PDCurses
  which we have been able to compile or otherwise acquire not working with
  DMD.

* The curses interface does not display remembered map tiles which fall
  outside the player's line-of-sight.

### Not Bugs

* The map generator function doesn't always separate rooms properly and carves
  corridors which can alter the shape of rooms rather than simply creating a
  doorway.  This is not a bug because the current map generator functions are
  only temporary fixes.

## Compiling

Starting with version 0.022, SwashRL has been programmed in D.  This means
you'll need DmD to compile it (there are versions available for every major
platform including FreeBSD), but if you also get dub, the D package manager,
it will do a lot of your work for you including downloading dependencies.

You can make some changes to how SwashRL is configured by editing the file
[config.d](src/config.d)  This file has a lot of comment blocks which explain
how to configure SwashRL  These configuration settings will be interpreted
in [global.d](src/global.d)

To compile, navigate to the root folder (the same folder this readme file is
in) and type:

> `dub build`

You'll need to be connected to the Internet so that dub can download the
packages that it needs.

By default, SwashRL will compile with SDL.  However, you can also compile
with ncurses by using dub's `--config` flag, and even compile with _only_
ncurses, by using one of the following commands:

> `dub build --config ncurses`  
> `dub build --config ncurses-nosdl`  

In theory, you could use PDCurses instead, but this isn't being actively
supported because frankly noone on the development team can get it to work.
If you can, we'd love to hear how you did it.  To compile with PDCurses,
use one of the following commands:

> `dub build --config pdcurses`  
> `dub build --config pdcurses-nosdl`  

## Change Logs

For all of your change logging needs, see [changes.txt](docs/changes.txt).
For those interested, there's also a more in-depth history of the project
being recorded in [history.txt](docs/history.txt)

## Contributing

If you're thinking of making a contribution to the SwashRL project, first of
all thank you very much!  We now have
[contribution guidelines](docs/CONTRIBUTING.MD) to help you get started.

The best way to contribute to SwashRL is via
[our GitHub page](https://github.com/swashdev/Spelunk), where you can follow
the conversation and see where we need help.

## Have fun!

SwashRL is the reinvigoration of a game project I've been fiddling with and
rebooting ever since I was in high school, so do try not to take it too
seriously and have fun with it.  Do take the license agreement seriously,
though, because we do.

## Careware

If you like the SwashRL project and would like to support me, you are
encouraged but not required to help me in a personal quest of mine by making a
donation to a nonprofit organization.  ForeGen is a medical resarch project
that is helping to study and put into practice regenerative medicine beginning
with the regeneration of amputated foreskins.  This approach to regenerative
medicine is not only a simple way to begin putting this research into
practice; it will also help men who had their genitals cut against their will
as children regain their genital integrity and help them cope with their lost
bodily autonomy by putting them back in control over their own bodies.  With
time this research can do a lot of good in the immediate sense, but can also
be expanded into bigger and better uses of this blossoming technology.

If you need further information on why this is important, I suggest visiting
the Doctors Opposing Circumcision website, where you will find a plethora of
information about why circumcision and other forms of genital cutting are
harmful, as well as resources on how to deal with the trauma that often comes
as a result of the procedure.  I encourage you to donate to them as well, as
they are doing good work.

Links to these organizations can be found below, and DOC also includes a page
where you can find similar nonprofit organizations in countries nearer to you.

NOTE:  I (Philip Pavlick) DO NOT REPRESENT, NOR AM I AFFILIATED WITH EITHER OF
THESE ORGANIZATIONS, AND I AM NOT RECEIVING ANY SPONSORSHIP FROM THEM.  THE
VIEWS EXPRESSED IN THIS LETTER ARE MY OWN AND DO NOT REFLECT THOSE OF ANY
OTHER CONTRIBUTOR TO THE SOFTWARE, NOR THOSE OF THESE ORGANIZATIONS NAMED IN
THIS LETTER.

* <http://www.foregen.org/>
* <https://www.doctorsopposingcircumcision.org/>
