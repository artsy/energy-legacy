Deployment
================

## Betas

We deploy betas to Hockey App via [fastlane](http://fastlane.tools). You will need to have set the ENV vars:

* `HOCKEY_API_TOKEN`  - accessible via HockeyApp's website. 
* `SLACK_URL` - accessible via the Slack admin.

To start the build run `bundle exec fastlane beta`. All details for our deployment can be found in the `Fastfile` in the `fastlane` directory.

## App Store

### TODOs for anyone before deploying

1. Check out energy Artsy master.
2. Remove dev only entries from `docs/CHANGELOG.yml`.
3. Update `CHANGELOG.yml with the release number.
4. Add and commit the changed files, typically with `-m "Preparing for the next release, version X.Y.Z."`.

IMPORTANT: We use the "Artsy Inc Account" not "ARTSY INC" - which is our enterprise account. For setting up these, consult [artsy/potential](https://github.com/artsy/potential/blob/master/mobile/mobile.md)

### Prepare in iTunes Connect

1. You need to have copy for the next release, for minor releases this is just a list of notable changes.
2. Log in to [iTunes Connect](https://itunesconnect.apple.com) as it@artsymail.com ( team _Art.sy Inc_ ).
3. Manage Your Apps > Which-ever app > Add new version.

### Release to AppStore

1. Install HockeyApp from http://hockeyapp.net/apps and run it.
2. In Xcode, change the target device to _iOS Device_.
3. In Xcode, hold alt (`⌥`) and go to the menu, hit _Product_ and then _Archive..._.
4. Check that the Build Configuration is set to _Store_.
5. Hit _Archive_.
6. Hit _Distribute_, it will run validations and submit.

### Upon Successful Submission

1. Return to iTunes Connect and click ‘Submit for Review’. Then answer the subequent questions as follows:
  * Have you added or made changes to encryption features since your last submission of this app?: NO
  * Does your app contain, display, or access third-party content?: YES
  * Do you have all necessary rights to that content […]?: YES
  * Does this app use the Advertising Identifier (IDFA)?: NO
2. HockeyApp will automatically see your new archive. Push Archived build to HockeyApp as a live build.
3. Make a git tag for the version with `git tag x.y.z`. Push the tags to `artsy/energy` with `git push --tags`.

### Prepare for the Next Release

1. Run `make next`. This runs `pod install` and prompts for the next version number.
2. Add a new section to CHANGELOG called _Next_.
3. Add and commit the changed files, typically with `-m "Preparing for development, version X.Y.Z."`.
