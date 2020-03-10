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

### Public Branches

What follows is a list of branches which currently exist in the repository and
a brief description of their function.  Branches are listed in order of
proximity to the `master` branch; however, note that
[`hotfix-*` and `release-*` branches](#Production-Branches) will be the
closest.

 * [`master`](https://github.com/swashdev/SwashRL/tree/master)  
   This is the central branch for the project and is meant to contain the most
   recent stable or "release" versions of the code and the most up-to-date
   documentation.  Only merge to `master` if code is stable and ready for
   release.  Tagged commits will always come from `master`.
   [`hotfix-*` branches](#Production-Branches) should branch from `master`.

 * [`stable`](https://github.com/swashdev/SwashRL/tree/stable)  
   This branch is used to hold stable versions of the code.  While it is not
   intended as a release branch, it is helpful to think of `stable` as a good
   place to put "nightly release" builds.  When you need to modify some code,
   merge `stable` into `dev` and work from there.
   [`release-*` branches](#Production-Branches) also branch from `stable`.

 * [`dev`](https://github.com/swashdev/SwashRL/tree/dev)  
   This is the branch used when modifying code files.  This branch should only
   be merged to `master` when the code is stable and has been tagged for a
   release.  When working on a new feature, create a
   [`feature-*` branch](#Production-Branches) off of `dev` and merge back when
   the feature is complete.

 * [`spring-cleaning`](https://github.com/swashdev/SwashRL/tree/spring-cleaning)  
   This is a special branch originally created towards the end of February
   2020 to facilitate a radical cleanup and restructuring of SwashRL's code
   base and make it compliant with an updated style guide.  It is essentially
   equivalent to a `feature-*` branch in scope, except that it is not working
   on any particular feature and is publically available for peer review.  Any
   time a "spring cleaning" project is done, it will be merged into `dev`.

### Production Branches

These are private branches used when working on individual copies of the
source code, except that some of them may be pushed to a public repo
temporarily in order to collaborate on preparation for an upcoming release or
if assistance is needed.  As above, the branches are listed according to how
close they are to the `master` branch.

 * `hotfix-*`
   These branches are used to quickly fix bugs in `master` release versions of
   SwashRL.  These branches should be very short-lived; larger bugfixes will
   have to happen in `dev`.  Name the branch according to what the version
   number will be after the hotfix is complete, e.g. `hotfix-0.31.1`.  Do not
   merge `hotfix-*` branches to `master` until they are ready for release.

 * `release-*`
   These are release branches, branches off of `stable` which are used to set
   the repository up for a release version of the software.  Merges to
   `master` should come from `release-*` branches.  Name the branch according
   to what the version number will be after the release is complete, e.g.
   `release-0.32.0`.

 * `feature-*`  
   Whenever you are working on adding a new feature, merge `dev` into a
   feature branch in a private repository.  The naming convention should give
   away what its intended feature is; for example, `feature-colors` was used
   for an overhaul of the color storage system in SwashRL's display code.  All
   of the work done in this branch should go toward working on that particular
   feature, not bug fixes in the existing source code.

### Special Branches

These branches are public, but are not related an a fundamental level to the
production of source code.

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
