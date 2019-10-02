SwashRL
=======

Branch Directory
----------------

This readme file is used to explain the branch structure for the SwashRL git
repository.  The SwashRL project currently has public repositories at the
following locations:

 * [GitHub](https://github.com/swashdev/SwashRL)  
   Because GitHub is the central hub for the SwashRL project, all links in
   the branch descriptions will link to GitHub pages.

 * [repo.or.cz](https://repo.or.cz/SwashRL.git)

What follows is a list of branches which currently exist in the repository and
a brief description of their function:

 * [`master`](https://github.com/swashdev/SwashRL/tree/master)  
   This is the central branch for the project and is meant to contain the most
   recent stable or "release" versions of the code and the most up-to-date
   documentation.  Commits which modify the source code should not push
   directly to `master` excepting commits which modify the autodoc comments in
   the source code files.

 * [`dev`](https://github.com/swashdev/SwashRL/tree/dev)  
   This is the branch used when modifying code files.  This branch should only
   be merged to `master` when the code is stable and ready for a release.  Do
   not modify the documentation in this branch; instead merge to `master` and
   modify the documentation there.

 * [`gh-pages`](https://github.com/swashdev/SwashRL/tree/gh-pages)  
   This is an orphan branch which is used to host SwashRL's GitHub Pages site.
   Obviously, you shouldn't be pushing any code files here.  If you are not
   on GitHub, you might not see this branch, because it's only relevant to
   GitHub Pages.

 * [`branch-readme`](https://github.com/swashdev/SwashRL/tree/branch-readme)  
   This is an orphan branch which is used to hold this readme file.  This
   branch should only ever be updated in order to update this readme file.
   **No code should be pushed to this branch as it may cause a licensing issue
   due to the lack of license notices in this branch**.
