Getting Started
================

Downloading Xcode
----------------
[Download Xcode from the Mac App Store](http://itunes.apple.com/us/app/xcode/id448457090?mt=12).  When the download is finished, run the installer.

You need Xcode 7 with the latest iOS simulator installed.

Energy
---------------
We don't run off forks, as this is an OSS project

    git clone https://github.com:artsy/energy.git

Then run

    bundle install
    bundle exec pod install
    make setup

Finally open `Artsy Folio.xcworkspace` and hit Command-R to build and run in the simulator.

Running Tests
---------------
You need to be on an iPad Retina at iOS 8.3 in order to run the tests. Press cmd + u in Xcode.


Use your `.energy` file
-----------------------

Authentication is a lot easier when you don't type so much, create a file in your home directory called `.energy` and it takes a collection of `key:value` lines to have the username and password set for you in the `ARLoginViewController`.  You can use the `ARDeveloperOptions` class to react to the key value store. For example:


    username:orta@artsymail.com
    password:this_is_not_my_actual_password


Running on Device
---------------
You will need to have the developer signing certificates installed, to install them run `make certs`.

If you have a new device, open the Xcode organizer and then go to the device in the devices list and click use for Development and log in with the Artsy Apple Account and Xcode _should_ do everything you need to make it work.
