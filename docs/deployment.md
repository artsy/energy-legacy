Deployment
================

Follows Eigen's [documentation](https://github.com/artsy/eigen/blob/main/docs/deploy_to_beta.md) - it's
more likely to be up-to-date and they should more-or-less be the same.

### Upon Successful Submission

1. Return to iTunes Connect and click ‘Submit for Review’. Then answer the subsequent questions as follows:
  * Have you added or made changes to encryption features since your last submission of this app?: NO
  * Does your app contain, display, or access third-party content?: YES
  * Do you have all necessary rights to that content […]?: YES
  * Does this app use the Advertising Identifier (IDFA)?: NO
2. HockeyApp will automatically see your new archive. Push Archived build to HockeyApp as a live build.
3. Make a git tag for the version with `git tag x.y.z`. Push the tags to `artsy/energy` with `git push --tags`.

### Prepare for the Next Release

1. Run `make next`. This runs `pod install` and prompts for the next version number.
2. Empty the upcoming section of the changelog.yml.
3. Add and commit the changed files, typically with `-m "Preparing for development, version X.Y.Z."`.
