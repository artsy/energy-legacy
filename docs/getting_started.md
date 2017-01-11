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

Set an environment variable of `ARTSY_STAFF_MEMBER` to `true`.

Finally open `Artsy Folio.xcworkspace` and hit Command-R to build and run in the
simulator.

## Running Tests

The tests require the iOS 8.4 iPad Retina simulator. Once you've picked that
combination, run the tests with `cmd + u`.

## Use your `.energy` file

Authentication is a lot easier when you don't type so much, try this:

```
echo 'user@example.com:shhh' > ~/.energy
```

Run the app again and you'll see those values set in the text fields for email
and password. Then, check out `ARLoginViewController` to see what magic this is!

## Running on Device

You will need to have the developer signing certificates installed, to install
them run `make certs`.

If you have a new device, open the Xcode organizer and then go to the device in
the devices list and click use for Development and log in with the Artsy Apple
Account and Xcode _should_ do everything you need to make it work.
