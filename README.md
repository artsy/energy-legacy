<img src="https://raw.githubusercontent.com/artsy/energy/master/docs/screenshots/artsy_logo.png" align="left">
<img src="https://raw.githubusercontent.com/artsy/energy/master/docs/screenshots/energy.png" align="right">


<a href="http://folio.artsy.net"><img src ="https://raw.githubusercontent.com/artsy/energy/master/docs/screenshots/folio_screenshots.jpg" width="100%"></a>

The iPhone and iPad app that brings all the Partners to the yard.

### Meta

* __State:__ production
* __Point People:__ [@orta](https://github.com/orta)
* __CI :__  [![Circle CI](https://circleci.com/gh/artsy/energy.svg?style=svg)](https://circleci.com/gh/artsy/energy)

This is a core [Artsy Mobile](https://github.com/artsy/mobile) OSS project, along with [Eigen](https://github.com/artsy/eigen), [Eidolon](https://github.com/artsy/eidolon), [Emission](https://github.com/artsy/emission) and [Emergence](https://github.com/artsy/emergence).

Don't know what Artsy is? [Check this](https://github.com/artsy/mobile/blob/master/what_is_artsy.md) overview, or read our objc.io on [team culture](https://www.objc.io/issues/22-scale/artsy/).

Want to know more about Eigen? Read the [mobile](http://artsy.github.io/blog/categories/mobile/) blog posts, or [energy's](http://artsy.github.io/blog/categories/energy/) specifically. There's some great overview videos that cover almost all of the code-base.

### Docs

Get setup [here](docs/getting_started.md). Further documentation can be found in the [documentation folder](docs#readme) and in [the OSS announcement](http://artsy.github.io/blog/2015/08/06/open-sourcing-energy/).

Folio specific [Trello board](https://trello.com/b/95qNlO03/partner-success-revenue-near-term-roadmap) - you can use "Filter Cards" to just show Folio.

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

- Instead of `make oss` in the above, run `make artsy` to set up [spacecommander](https://github.com/square/spacecommander).
- Run `bundle exec pod install`. More info [here](https://guides.cocoapods.org/using/a-gemfile.html), if you're curious.
- Run tests on an `iPad Air 2` running `11.2`.

### Troubleshooting

If you are seeing `bundle: command not found` when running the OSS Quick Start commands, you will need to install [bundler](http://bundler.io). You can do this by writing `sudo gem install bundler`.

### Thanks

Thanks to all [our contributors](/docs/THANKS.md).

## License

MIT License. See [LICENSE](LICENSE).
