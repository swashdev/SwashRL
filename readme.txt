Spelunk! version 0.022
Readme file, last updated 2017-12-05
Contact the maintainer: philip@swash.link

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

 -- Supported Systems -------------------------------------------------------

Spelunk! was originally written for Linux, and is confirmed to still work on
Linux and FreeBSD as of development version 0.022.

Windows support has been temporarily removed because we couldn't find a
Windows-compatible version of curses with a working D wrapper (hence the lack
of support for PDCurses) and alternative curses libraries tend to use software
licenses incompatible with the license I'm using.

I hope to eventually port it to more systems, but I'm limited in my ability to
officially support systems by their availability to me, which means my poor
family members who all decided to switch to Mac OS out of nowhere are just out
of luck for the time being unless they're exceptionally lucky and the code
JUST SO HAPPENS to work... which could happen, but it won't happen :-)

 -- Compiling ---------------------------------------------------------------

Starting with version 0.022, Spelunk! has been programmed in D.  This means
you'll need DmD to compile it (there are versions available for every major
platform including FreeBSD), but if you also get dub, the D package manager,
it will do a lot of your work for you including downloading dependencies.

You can make some changes to how Spelunk! is configured by editing the file
``src/config.d''.  This file has a lot of comment blocks which explain how
to configure Spelunk!  These configuration settings will be interpreted and,
if necessary, modified, in ``src/global.d''
NOTE: Some of the configuration options in ``src/config.d'' aren't functional
because of the lack of a PDCurses wrapper for D--because we don't have
PDCurses, the config functions which would normally import it don't work and
will be ignored.

To compile, navigate to the root folder (the same folder this readme file is
in) and type:

 dub build

 -- Change Logging ----------------------------------------------------------

For all of your change logging needs, see ``doc/changes.txt''.  For those
interested, there's also a more in-depth history of the project being recorded
in ``doc/history.txt''

 -- Style Guide -------------------------------------------------------------

With certain exceptions, most comments as of the transition from C to D use
"line comments" (//) so that you can accidentally snip a line off and it will
be fine.  Comment "blocks" (/* */) are used for more important messages like
the copyright notices and blocks used to organize and explain the source code.
Comment lines are also used at the end of long functions like `if' statements
to hopefully keep you from getting lost trying to keep track of where all the
curly brackets are.

Except where my text editors have sneakily used tab characters without my
permission, the source code is tabbed using spaces.  Two spaces, to be exact.
Not everyone likes this, but it's how I find the code to be most readable.
Try not to use tab characters in your code.  I've had issues with other people
editing the source code and through no fault of their own rendering it
unreadable because the tab characters push all of the code either off the
screen or into the line wrap limit.

Some functions like D's `static if' statement and `version' blocks are not
indented; this is a carryover from the C code and is used to make system
functions and version control statements stand out from the rest of the source
code so it's more obvious where the conditional code is.

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
