<img src="https://raw.githubusercontent.com/artsy/energy/master/docs/screenshots/artsy_logo.png" align="left" hspace="30px" vspace="30px">
<img src="https://raw.githubusercontent.com/artsy/energy/master/docs/screenshots/energy.png" align="right" hspace="30px" vspace="30px">


<a href="http://folio.artsy.net"><img src ="https://raw.githubusercontent.com/artsy/energy/master/docs/screenshots/folio_screenshots.jpg"></a>

The iPhone and iPad app that brings all the Partners to the yard.

[![Coverage Status](https://coveralls.io/repos/artsy/energy/badge.svg?branch=master&service=github)](https://coveralls.io/github/artsy/energy?branch=master)


### Docs

Get setup [here](docs/getting_started.md). Further documentation can be found in the [documentation folder](docs#readme).

### OSS Quick Start

Want to get the app running as an OSS project? Run this in your shell:

```sh
git clone https://github.com/artsy/energy.git
cd energy
make oss
open "Artsy Folio.xcworkspace"
```

You will have a running version of the Artsy app by hitting `Build > Run`.

### Work at Artsy?

Instead of `make oss` in the above, run `make artsy` to set up [spacecommander](https://github.com/square/spacecommander).

### Troubleshooting

If you are seeing `bundle: command not found` when running the OSS Quick Start commands, you will need to install [bundler](http://bundler.io). You can do this by writing `sudo gem install bundler`.

### Thanks

**Copyright**: 2012-2015, Artsy. Thanks to all [our contributors](/docs/THANKS.md).
