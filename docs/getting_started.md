# Getting Started

## Downloading Xcode

[Download Xcode from the Mac App Store][xcode]. When the download is finished,
run the installer.

[xcode]: http://itunes.apple.com/us/app/xcode/id448457090?mt=12

You need Xcode 7 with the latest iOS simulator installed.

## Energy

We don't run off forks, as this is an OSS project

```
$ git clone https://github.com/artsy/energy.git
```

Then run

```
$ gem install bundler # you might already have it
$ bundle install
$ bundle exec pod install
```

If you are setting up as an employee, run this:

```
$ make artsy
```

And if you're setting up as an Open Source contributor, run this:

```
$ make oss
```

Finally open `Artsy Folio.xcworkspace` and hit Command-R to build and run in the
simulator.

## Running Tests

The tests require the iOS 8.3 iPad Retina simulator. Once you've picked that
combination, run the tests with `cmd + u`.

## Use your `.energy` file

Authentication is a lot easier when you don't type so much, create a file in
your home directory called `.energy` and it takes a collection of `key:value`
lines to have the username and password set for you in the
`ARLoginViewController`. You can use the `ARDeveloperOptions` class to react to
the key value store. For example:

```
username:orta@artsymail.com
password:this_is_not_my_actual_password
```

## Running on Device

You will need to have the developer signing certificates installed, to install
them run `make certs`.

If you have a new device, open the Xcode organizer and then go to the device in
the devices list and click use for Development and log in with the Artsy Apple
Account and Xcode _should_ do everything you need to make it work.
