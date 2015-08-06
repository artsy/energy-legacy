Coding standards
===============

Make sure to follow Apple&rsquo;s [Coding Guidelines for Cocoa](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html#//apple_ref/doc/uid/10000146-SW1).

Some miscellaneous notes:

* We use the prefix "AR" for classes and constants.
* The pointer asterisk should go with the variable name in declarations,
* `make setup` will install [spacecommander](https://github.com/square/spacecommander) which will ensure that
  quarrells over syntax can be ignored.

*  All names except preprocessor definitions should be in ``camelCase``, with a ``LeadingCap`` for class names and constants.  Leave your ``underscore_names`` in the Ruby/CoffeeScript codebase.

* When creating new `@property`'s, use @sythesize property = _property so that you have an obviously private instance variable.

* Private methods don't need a declaration inside the .m file, this is mainly to reduce clutter. It's bad enough up there with all the #imports. This is a new one, so theory doesn't yet fully match practice, if you see some feel free to kill them.

* When creating a Class, or importing a library you need to ensure that it is added to both the Artsy Folio target and the KIFolio target to ensure that it's both in the app, and in the integration tests. This is made easier with the Podfile because it will add the library to the right targets for you. 

* Now that it's possible to use methods that don't come with an argument as properties use some refrain against using it everywhere, something that you could percieve as being a computed instance variable that gets return ( like say _artworks.count, or _artwork.title.length )  but something that is just a method call without a return value ( _downloadOperation.start ) is confusing.