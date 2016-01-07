Coding standards
===============

Make sure to follow Apple&rsquo;s [Coding Guidelines for Cocoa](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html#//apple_ref/doc/uid/10000146-SW1).

Some miscellaneous notes:

* We use the prefix "AR" for classes and constants.
* The pointer asterisk should go with the variable name in declarations,
* `make setup` will install [spacecommander](https://github.com/square/spacecommander) which will ensure that
  quarrels over syntax can be ignored.
*  All names except preprocessor definitions should be in ``camelCase``, with a ``LeadingCap`` for class names and constants.
* Now that it's possible to use methods that don't come with an argument as properties use some refrain against using it everywhere, something that you could think as being a computed instance variable that gets return ( like say self.artworks.count, or self.artwork.title.length )  but something that is just a method call without a return value ( _downloadOperation.start ) is confusing.
