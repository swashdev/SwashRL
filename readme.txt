Spelunk! version 0.021

Spelunk! is a Roguelike game currently in the early development phases.  The
actual "game" part is not yet functional, as it's still in need of a few
important pieces.

As the software is still under development and has not seen an official
release, it currently has NO DOCUMENTATION, save for that mentioned in this
file.

Spelunk! currently has git respositories hosted at the following locations:
  https://github.com/Crawldragon/spelunk

 -- License Agreement -------------------------------------------------------

Spelunk! is released as careware.  You can find the license agreement in
``license.txt''.  However, as it currently exists, it is dependent on some
software libraries and code that are released under different licenses.
See ``3rdparty.txt'' for more information.

You are of course free to use Spelunk!, and I wouldn't have given you the
source code if I didn't want you to mess with it, but be sure to abide by the
terms of the license agreement if you're going to be distributing it.  This is
my child and I will defend it from you if I have to.

 -- Compiling ---------------------------------------------------------------

One of the major design goals for Spelunk! was that it would be easy to
compile.  It can be compiled using a single gcc command, which follows:

If you are compiling with ncurses, use this:
  gcc -o binary/spelunk.exe -I include src/*.c -lncurses -lm

If you are compling with PDCurses, use this:
  gcc -o binary/spelunk.exe -I include src/*.c -lpdcurses -lm

You will need at least one of pdcurses or ncurses, neither of which is
included with this distribution.

You *should* also be able to compile this using a different compiler.  clang
in particular should work, as it is designed to have the same functionality as
gcc.

You can make some changes to how Spelunk! is configured by editing the file
``include/config.h''.  This file has a lot of comment blocks which explain how
to configure Spelunk!  These configuration settings will be interpreted and,
if necessary, modified, in ``include/global.h''

 -- Supported Systems -------------------------------------------------------

Spelunk! was originally written for Linux, and is confirmed to still work on
Windows and FreeBSD as of development version 0.021.  I also have a tester who
has successfully compiled and run version 0.021 under Arch Linux.

I hope to eventually port it to more systems, but I'm limited in my ability to
officially support systems by their availability to me, which means my poor
family members who all decided to switch to Mac OS out of nowhere are just out
of luck for the time being unless they're exceptionally lucky and the code
JUST SO HAPPENS to work... which could happen, but it won't happen :-)

 -- Change Logging ----------------------------------------------------------

For all of your change logging needs, see ``doc/changes.txt''.  For those
interested, there's also a more in-depth history of the project being recorded
in ``doc/history.txt''

 -- Notes about the Source --------------------------------------------------

The source code is designed to be as compatible as possible, which means in
theory if I've done everything right you should be able to port Spelunk! to
just about any system, albeit not always easily (and remember to follow the
license agreement before you go putting this on the iPhone app store).

I've designed the code so that it will be hopefully as readable as possible.
There are some failings in that department (like the random number generation
utilities, for example) but in general it should be pretty clear what every
function does.  `display' displays a character at coordinates (x, y).
`new_monst' returns a struct of type monster.  You get the picture.

The code is designed to be fully compliant with the ANSI C standard
colloquially known as C89, but it's a little flexible here in that it can also
be compiled with the C99 standard and it will use some conveniences from that
standard instead, like explicitly-sized integer variables.  Although there is
code in ``include/global.h'' which defines macros meant to detect other C
standards (C95, C11, &c) these are not currently used; however, I can confirm
that as of version 0.0.15 the code will compile successfully in C89, C99, and
C11.  I couldn't get gcc to compile using the C95 standard; I don't know why,
and I can't find any documentation explaining this.  Anyway, version 0.0.15 is
already old, and I haven't even finished version 0.018 as of this writing, so
expect that to have changed without me noticing.

Spelunk! uses some `goto' statements in a couple of places.  If you don't like
it, you can deal with it.

 -- Style Guide -------------------------------------------------------------

Spelunk! source code is written using no line comments, only comment blocks
(i.e., `/* */' instead of `//') in order to be compliant with the C89
standard.  You should do the same.

For readability and maximum portability, I've used macros to define explicit
integer sizes (`int8', `int16', &c) as well as booleans (`cbool') and strings
(`cstr') in order to make everything concise and clear.  There are some files
that I haven't needed to edit for a while that don't always use these explicit
variable types, but hopefully before you actually see this I'll have gone
through the whole source code and weeded those out as well.

Except where my text editors have sneakily used tab characters without my
permission, the source code is tabbed using spaces.  Two spaces, to be exact.
Not everyone likes this, but it's how I find the code to be most readable.
I also use two spaces in-between sentences, becuase this makes things that
little bit more readable on crappy terminals like Windows cmd.

Except in the ``notes'' folder, which you shouldn't have received, all folders
and file names are limited to eight characters plus three for the file type
(xxxxxxxx.yyy) in order to make things compatible with old operating systems
like DOS.

I don't ever format an `if' statement like this:

  if( thing )
    one_function;
  else
    other_function;

That formatting is terrible.  Instead I use this:

  if( thing )
  { one_function;
  }
  else
  { other_function;
  }

It takes up more space but makes things less ambiguous, which I approve of.

Finally, there's the name itself.  Spelunk! was always meant to have an
exclamation mark in the title.  It just doesn't work otherwise.  Because of
this, it makes sentences a little weird.  Because I always use two spaces
after every sentence, it's never ambiguous whether Spelunk!'s title is at the
end of a sentence.  However, if it does end a sentence, the sentence will
always end with an exclamation mark unless it's a question.  Just try to be
consistent if you're doing any writing about Spelunk! with this paragraph and
the following examples:

  Spelunk! is a fun game to play.
  I like to play Spelunk!
  Spelunk!'s title makes for some confusing grammar.
  Do you want to play Spelunk!?

(I swear to God if an interrobang existed in the standard ASCII character set
I would have been sorely tempted to use that instead just to confuse you even
more)

 -- Have Fun! ---------------------------------------------------------------

Spelunk! is the reinvigoration of a game project I've been fiddling with and
rebooting ever since I was in high school, so do try not to take it too
seriously and have fun with it.  Do take the license agreement seriously,
though, because seriously this is my baby and I will cut you if you try to
screw me for my code.

 -- In the Future -----------------------------------------------------------

Spelunk! is far from completed, and will be gaining new features (including,
eventually, color support and SDL support) even after its official release.
I'm also going to be accepting criticism of the source code and, if you'd
like, submissions from you and other users to make future versions better,
faster, and more portable.

I intend to continue maintaining Spelunk!, partly because I like it when old
open-source projects are still maintained, and also because I'm planning on
using it as a base for other game projects.  The game that Spelunk! is now is
the first step in a very large project that I'm working on, but that will be
under a different name.  Suffice it to say, you ain't seen nothing yet,
assuming I don't get hit by a bus any time soon.

 -- Contacting the Author ---------------------------------------------------

The official contact address for Spelunk! is
philip-atsign-swash-fullstop-link, accurate as of 2017-09-02.  I'm not
expecting this to change any time soon, but I will update this readme if it
does.  There is currently no mailing address for Spelunk!'s development team.
