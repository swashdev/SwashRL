SwashRL Guidelines for Contributors
===================================

Version 1.0.4.  Last updated 2020-09-18 17:05 CDT

---

Thank you for considering contributing to the SwashRL project.  In this file
you will find some brief guidelines for contributing to the project.  Don't
panic; this is a very small project, so for the most part we don't expect much
from contributors at this stage.

If you're reading this Markdown file in a text editor or other program that
doesn't display hyperlinks, links to files or web pages referenced in this
document can be found at the bottom.

## Table of Contents

* [Where to Get Started](#where-to-get-started)

* [Before Submitting](#before-submitting)

* [Compiling Your Changes](#compiling-your-changes)

* [Submitting Changes](#submitting-changes)

  * [Attribution](#attribution)

  * [Professionalism](#professionalism)

* [Style Guide](#style-guide)

## Where to Get Started

If you'd like to contribute, but you don't know where to get started, check
the [Readme] and the [docs folder].  In the docs folder you'll find a
[to-do list] which lists all of the things that we're currently working on in
order from highest priority to lowest priority, as well as a [list of known
bugs].

You should also check the [Issues page] on [our GitHub], where you will find
open Issues that you can take a stab at fixing yourself, and the
[Projects page], where you can find things that we're currently working on.

## Before Submitting

**Be aware of [the SwashRL license] before submitting anything that's been
licensed**.  If you're submitting anything that contains content you haven't
written yourself, triple-check that it hasn't been released under a license
that is incompatible with our license.  We take licenses for third-party
content very seriously and carefully consider including anything that might
conflict with our license.  **If you submit something to us, and we learn
later that you do not have permission to license it to us under the terms of
the SwashRL license, your contributions will be scrubbed from the project and
you will be permanently banned from ever contributing again.**

If anything that you submit is licensed, please be courteous and copy the
license into the [docs/license] directory with a filename like "project.txt"
and add a notice to [the third-party licenses file].  You should have one file
and one attribution notice for each license individually.

If you've written everything in your submission yourself, and you don't place
it under any particular license, we will take your submission as permission to
release your changes under [the SwashRL license] in exchange for attribution
(usually in the form of a comment line in the source code and a mention in
[thanks.txt]).  _If you don't want to be attributed for your changes in the
distributed source code or documentation, please let us know in your commit
message or Pull Request._

## Compiling Your Changes

You can find instructions for compiling SwashRL in the [Readme].

## Submitting Changes

The best way to contribute to the SwashRL project is to submit a
[Pull Request] on [our GitHub].  We have a Pull Request Template available
that you can use to let us know what you've changed and why, to make things
extra convenient.

If you don't know how to use git or have no experience with the GitHub
website, you can get started with [the guide on their website].

_Do not e-mail any of the contributors with your changes, as your e-mail will
be discarded._

When you commit your changes, be sure to enclose a detailed commit message so
that third-party users can see what you're doing.

### Attribution

As a professional courtesy, we ask that you acknowledge anyone else that
helped you with your changes, unless they asked to be anonymous.  As such, if
your git branch doesn't already attribute other contributors automatically, we
ask that your commit message do so.  If you don't know how to do this,
[GitHub offers a helpful guide].

### Professionalism

Some of the people who work on SwashRL are professionals or are seeking
employment in a professional field, so please try to keep your submissions,
including Pull Requests and commit messages, safe for work and politically
correct.  We do have a sense of humor, but keep in mind that our employers
might see what you submit, and any contributions that we accept will reflect
on us, and on you, as a result.

## Style Guide

SwashRL's code is written to be readable by the average user.  This means
ample use of whitespace and clear naming conventions.  In general, the style
guide should match [The D Style], but there are some notable exceptions:

* **White space**: Add a space after opening parenthesis `(` and before
  closing parenthesis `)` in function calls and conditional statements (`if`,
  `while`, &c).

* **Line width**: In general, code lines should _prefer_ to be no longer than
  78 characters, to make code and diff files readable on a standard 80x24
  terminal.  A _hard limit_ of 120 characters is imposed in accordance with
  [The D Style].

* **Block length**: The end of any code block exceeding 22 lines in length
  should have a comment on the same line as the end-bracket `}` which
  indicates which block it was a part of, to assist readability on standard
  80x24 terminals.

* **Naming conventions**: SwashRL always uses snake\_case.  A minimum variable
  name length of 3 is imposed to discourarge ambiguity in the code, with
  exceptions made for coordinate names such as `x`, `y`, `dx`, et cetera.  
  Capitalization rules are as follows:

  * Normal variables and functions, including member variables and functions,
    are named in\_all\_lowercase.

  * Global variables are named with the first letter Capitalized\_like\_this.

  * Constants are named IN\_ALL\_CAPS.

  * Classes and structs are named in initial caps Like\_This.

  * Enums should use Initial\_Caps like classes, while their members should
    use all_lowercase like normal variables; this is, in my opinion, the
    generally least confusing compromise between my code style and
    [The D Style].

* **Comment lines**: Three different conventions are used for comment lines:

  1. Most comment lines use a `//`double-slash format, so that users can
     accidentally delete a line without breaking anything.

  2. Comment blocks which are considered important, such as copyright notices,
     attribution notices, or otherwise important notices, use the more modern
     `/*`slash-asterisk format`*/` with an asterisk preceding each new line.

  3. In the case of section headers, a box or line is drawn using slashes to
     grab the user's attention.

[the SwashRL license]: ../LICENSE.txt
[the third-party licenses file]: ../3rdparty.txt
[Readme]: ../README.md
[docs folder]: ../docs
[to-do list]: ../docs/to-do.txt
[list of known bugs]: ../docs/bugs.txt
[docs/license]: ../docs/license
[thanks.txt]: ../thanks.txt
[our GitHub]: https://github.com/swashdev/SwashRL
[Issues page]: https://github.com/swashdev/SwashRL/issues
[Projects page]: https://github.com/swashdev/SwashRL/projects
[Pull Request]: https://github.com/swashdev/SwashRL/pulls
[the guide on their website]: https://guides.github.com/activities/hello-world/
[GitHub offers a helpful guide]: https://help.github.com/articles/creating-a-commit-with-multiple-authors/
[The D Style]: https://dlang.org/dstyle.html
