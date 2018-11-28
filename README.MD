SwashRL
=======

Readme file, last updated 2018-08-30 01:48 EST  
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

* <https://github.com/swashdev/swash-tentative>

If you're reading this Markdown file in a text editor or other program that
doesn't display hyperlinks, links to files or web pages referenced in this
document can be found at the bottom.

## Table of Contents

* [License Agreement](#license-agreement)

* [Supported Systems](#supported-systems)

* [Known Bugs](#known-bugs)

  * [Not Bugs](#not-bugs)

* [Compiling](#compiling)

  * [Compiling for Derivatives](#compiling-for-derivatives)

* [Change Logs](#change-logs)

* [Contributing](#contributing)

* [Careware](#careware)

## License Agreement

SwashRL is released under [the Apache License 2.0], excepting that Derivative
Works are not required to carry prominent notices in changed files as
required by the normal Apache License 2.0 in Section 4b.

SwashRL uses some third-party resources to function.  For details, see
[the NOTICE file] and the third-party licenses referenced therein.

## Supported Systems

SwashRL was originally written for Linux, and is confirmed to still work on
Windows and Linux as of development version 0.025.

I hope to eventually port it to more systems, but I'm limited in my ability to
officially support systems by their availability to me.  If you'd like to
become a volunteer maintainer for SwashRL on your system, [contact me] and we
can work something out.

## Known Bugs

To submit a bug fix or report a possible solution, leave an Issue or a Pull
Request on [our GitHub page].

* The PDCurses interface does not yet work on Windows due to an unknown error.

* The curses interface does not display remembered map tiles which fall
  outside the player's line-of-sight.

### Not Bugs

* The map generator function doesn't always separate rooms properly and carves
  corridors which can alter the shape of rooms rather than simply creating a
  doorway.  This is not a bug because the current map generator functions are
  only temporary fixes.

## Compiling

Starting with version 0.022, SwashRL has been programmed in D.  This means
you'll need [DmD] or some other D compiler, but if you also get [dub], the D
package manager, it will do a lot of your work for you including downloading
dependencies.

You can make some changes to how SwashRL is configured by editing the file
[config.d].  This file has a lot of comment blocks which explain how to
configure SwashRL.  These configuration settings will be interpreted in
[global.d].

To compile, navigate to the root folder (the same folder this readme file is
in) and type:

> `dub build`

You'll need to be connected to the Internet the first time you compile so that
dub can download the packages that it needs.

By default, SwashRL will compile with SDL.  However, you can also compile
with ncurses by using dub's `--config` flag, and even compile with _only_
ncurses, by using one of the following commands:

> `dub build --config ncurses`  
> `dub build --config ncurses-nosdl`  

You can also compile with PDCurses, which is compatible with Windows, using
one of the following commands:

> `dub build --config pdcurses`  
> `dub build --config pdcurses-nosdl`

If you're compiling from a git repository, your compiled SwashRL will include
the current commit ID when asked for its version number.  If you are _not_
compiling from a git repository, you'll have to edit [config.d] and set the
`INCLUDE_COMMIT` flag to `false`, otherwise it will not compile.

If you're not sure whether or not your source code is in a git repository,
check and see if there's a `.git` directory in this folder.  If there isn't,
you can get the up-to-date source repository from
[our GitHub page].

For more information about git, check out [the git website].

### Compiling for Derivatives

There are a few things to note if you want to use the SwashRL source code to
make your own game.  First of all, [the Apache License 2.0] is very
permissive, and unlike the GNU GPL and other copyleft licenses you absolutely
can commercially exploit SwashRL without having to release your source code.
This is not an oversight; I have intentionally licensed SwashRL to allow you
to do this.  However, you _must_ retain all copyright notices, attribution
notices, etcetera.

Secondly, you'll have to change the name of the program.  I've made this very
easy to do.  It only requires two steps:

1. Edit the file [dub.json] so that the "name" field has been changed to the
   name of your executable file (i.e., instead of saying `"name": "swashrl",`
   it will say `"name": "yourname",`; do not include the `.exe`)

   1. You should also modify the "authors" and "copyright" fields to reflect
      your copyright information, and the "license" field if you choose to
      relicense it.  For more information about the dub.json file, see
      [the Dlang JSON file documentation].

2. Edit the file [global.d] so that the "NAME" enum will be the
   name of your program (i.e. instead of saying `enum NAME = "SwashRL";` it
   will say `enum NAME = "Your Game's Name";`)

## Change Logs

For all of your change logging needs, see [changes.txt].  For those
interested, there's also a more in-depth history of the project being recorded
in [history.txt].

## Contributing

If you're thinking of making a contribution to the SwashRL project, first of
all thank you very much!  We now have [contribution guidelines] to help you
get started.

The best way to contribute to SwashRL is via [our GitHub page], where you can
follow the conversation and see where we need help.

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

[our GitHub page]: https://github.com/swashdev/SwashRL
[the Apache license 2.0]: LICENSE
[the NOTICE file]: NOTICE
[an issue]: https://github.com/swashdev/SwashRL/issues/2
[contact me]: mailto:philip@swash.link
[contribution guidelines]: docs/CONTRIBUTING.MD
[config.d]: src/config.d
[global.d]: src/global.d
[dub.json]: dub.json
[changes.txt]: docs/changes.txt
[history.txt]: docs/history.txt
[DmD]: https://dlang.org/download.html
[dub]: https://code.dlang.org/download
[the git website]: https://git-scm.com/
[the Dlang JSON file documentation]: https://code.dlang.org/package-format?lang=json
