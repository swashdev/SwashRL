SwashRL Guidelines for Contributors
===================================

Last updated 2018-08-05 02:07 EST

---

Thank you for considering contributing to the SwashRL project.  In this file
you will find some brief guidelines for contributing to the project.  Don't
panic; this is a very small project, so for the most part we don't expect much
from contributors at this stage.

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
the [Readme](../README.MD) and [the docs folder](../docs).  In the docs
folder you'll find [a to-do list](../docs/to-do.txt)
which lists all of the things that we're currently working on in order from
highest priority to lowest priority.

You should also check the
[Issues page](https://github.com/swashdev/SwashRL/issues) on
[our GitHub](https://github.com/swashdev/SwashRL), where you will find open
Issues that you can take a stab at fixing yourself.

## Before Submitting

**Be aware of [the license for the SwashRL project](../LICENSE)
before submitting anything that's been licensed**.  If you're submitting
anything that contains content you haven't written yourself, triple-check that
it hasn't been released under a license that is incompatible with our license.
We take licenses for third-party content very seriously and carefully consider
including anything that might conflict with our license.  **If you submit
something to us, and we learn later that you do not have permission to license
it to us under the terms of the SwashRL license, your contributions will be
scrubbed from the project and you will be permanently banned from ever
contributing again.**

If anything that you submit is licensed, please be courteous and copy the
license into the [docs/license](../docs/license) directory with a filename
like "project.txt" and add a notice to the [third-party licenses
file](../NOTICE).  You should have one file and one attribution notice for
each license individually.

If you've written everything in your submission yourself, and you don't place
it under any particular license, we will take your submission as permission to
release your changes under the SwashRL license in exchange for attribution
(usually in the form of a comment line in the source code and a mention in
thanks.txt).  _If you don't want to be attributed for your changes in the
distributed source code or documentation, please let us know in your commit
message or Pull Request._

## Compiling Your Changes

You can find instructions for compiling SwashRL
[in the Readme](../README.MD#Compiling)

## Submitting Changes

The best way to contribute to the SwashRL project is to submit a Pull Request
on our [GitHub page](https://github.com/swashdev/SwashRL/).  We have a Pull
Request Template available that you can use to let us know what you've
changed and why, to make things extra convenient.

If you don't know how to use git or have no experience with the GitHub
website, you can get started with
[the guide on their
website](https://guides.github.com/activities/hello-world/).

_Do not e-mail any of the contributors with your changes, as your e-mail will
be discarded._

When you commit your changes, be sure to enclose a detailed commit message so
that third-party users can see what you're doing.

### Attribution

As a professional courtesy, we ask that you acknowledge anyone else that
helped you with your changes, unless they asked to be anonymous.  As such, if
your git branch doesn't already attribute other contributors automatically, we
ask that your commit message do so.  If you don't know how to do this,
[GitHub offers a helpful guide](https://help.github.com/articles/creating-a-commit-with-multiple-authors/)

### Professionalism

Some of the people who work on SwashRL are professionals or are seeking
employment in a professional field, so please try to keep your submissions,
including Pull Requests and commit messages, safe for work and politically
correct.  We do have a sense of humor, but keep in mind that our employers
might see what you submit, and any contributions that we accept will reflect
on us, and on you, as a result.

## Style Guide

SwashRL's code is written to be readable by the average user.  Because
SwashRL is written in D, a relatively new language, this is particularly
important.  As such, we have a few perhaps unconventional rules about the
aesthetics of the source code that you should keep in mind while writing your
changes:

* The code is indented using two spaces, not tab characters, with function
parameters padded with a space on either side to make relevant parenthesis
more visible.

* Where possible, the length of each line of code is limited to 78 characters,
to keep it and diff files related to it readable on your average command
line terminal.  There are some exceptions to this rule, because not every
line of code can easily be broken up into 78-character lines, but in general
we work hard to ensure that this is the case.

* Conditional statements, such as `static if` or `version` statements, are
_not_ indented, but their contents are.  This convention is a holdover from
when the source code was written in C, and is done to make these conditional
programming blocks more visible.

* Class and object names are always Capitalized\_Like\_This, global variables
always have the first letter of their name Capitalized\_like\_this, constants
and enums are always named IN\_ALL\_CAPS, and words in all variable, function,
class, enum, &c names are always separated\_by\_underscores.

* Two different conventions are used for comment lines:

  1. Most comment lines use a ``//``double-slash format, so that users can
accidentally delete a line without breaking anything.

  2. Comment blocks which are considered important, such as copyright notices,
attribution notices, or otherwise important notices, use the more modern
``/*``slash-asterisk format``*/`` with an asterisk preceding each new line.

  3. In the case of section headers, a box is drawn around the comment using
asterisks or slashes to grab the user's attention.

* In comment lines or blocks, references to variables, functions, or types are
wrapped in quotes \`that look like this', with one backtic at the beginning
and one single-quote at the end.  References to files, such as a source file
or the license document, are surrounded in quotes \`\`that look like this'',
with two of each.  This is to disambiguate references to the names of
variables, functions, or files that might have a similar name to a common
word.

* Curly brackets ``{}`` should always be placed on their own line, like this:  
``if( this )``  
``{``  
``  that();``  
``  the( other );``  
``}``  
The exception to this rule is code blocks which contain only one line.  In a
lot of conventions, curly brackets aren't used at all, but in our case we
choose a less ambiguous compromise:  
``if( this )``  
``{ that();``  
``}``

* The end of a long ``if`` block, function, or other programming block that
ends with a curly bracket ``}`` should include a ``//`` comment that lets the
user know which block that curly bracket marks the end of.  This will also
make it easier for you to keep track of your own code.

As a rule of thumb, just try to make your code look like our code for the sake
of consistency and you'll be fine.
