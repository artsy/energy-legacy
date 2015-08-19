Getting Started
================

Downloading Xcode
----------------
[Download Xcode from the Mac App Store](http://itunes.apple.com/us/app/xcode/id448457090?mt=12).  When the download is finished, run the installer.

You need Xcode 6.3 with the iOS 7.1 simulator installed.

Forking Energy
---------------
Fork [Energy](https://github.com/artsy/energy) to your Github account.  Make a local clone.

    git clone git@github.com:[YOUR GITHUB NAME HERE]/energy.git

Add a remote called "upstream" so that you can pull in upstream changes.

	git remote add upstream git@github.com:artsy/energy.git

Then run 

    bundle install
    bundle exec pod install
    make setup

Finally open `Art.sy Folio.xcworkspace` and hit Command-R to build and run in the simulator.

Running Tests
---------------
You need to be on an iPad Retina at iOS 7.1 in order to run the tests. Press cmd + u in Xcode.


Use your `.energy` file
-----------------------

Authentication is a lot easier when you don't type so much, create a file in your home directory called `.energy` and it takes a collection of `key:value` lines to have the username and password set for you in the `ARLoginViewController`.  You can use the `ARDeveloperOptions` class to react to the key value store. For example:


    username:orta@artsymail.com
    password:this_is_not_my_actual_password


Running on Device
---------------
You will need to have the developer signing certificates installed, you can find them in the Certs folder of the project root. The instructions for this can be found in the artsy/potential repo.

If you have a new device, open the Xcode organizer and then go to the device in the devices list and click use for Development and log in with the Artsy Apple Account and Xcode _should_ do everything you need.
