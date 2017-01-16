Overview of Energy
==========

## App

#### OSS

We [OSSed Energy](http://artsy.github.io/blog/2015/08/06/open-sourcing-energy/) at the end of 2015. You can get an overview of how all the pieces come [together in this video](http://artsy.github.io/blog/2016/02/11/Code-Review-Energy/).

#### Switchboard

The switchboard is an abstraction for converting model objects into  view controllers, it can deal with paths like the artsy website or be given an object and a class and it will push the corrosponding view controller on to the nav stack it was init'd with.

see the [blog for more](http://artsy.github.io/blog/2015/08/19/Cocoa-Architecture-Switchboard-Pattern/)

#### ARRouter

The ARRouter is the class in-between the app and the API. Providing a way to generate URLRequests with an objective-c feel which the individual sync steps will then use to create methods for dealing with the network requests.

see the [blog for more](http://artsy.github.io/blog/2015/08/15/Cocoa-Architecture-Router-Pattern/)

#### AROptions

Features that aren't ready for alpha/beta users should be hidden behind an `AROption` which defaults to off. These are available for Artsy Admins to toggle in the admin menu.

## Sync

#### Overview

See [this video for a comprehensive overview](http://artsy.github.io/blog/2016/02/12/Code-Review-Energy-Sync/)

See [this graph](sync_tree.png) for a visual of the tree.

Sync correlates to a very large chunk of the Energy code-base. It works via an operation tree metaphor. You start a sync that triggers one operation, that operation outputs an object that goes into it's child operation trees. It continues this way until there are no more child trees. At the time of writing ( mid-2015 ) an `ARSync` object starts with a partner string. The root operation then takes that string, makes a network request to update the current partner, and then passes the partner into the following trees:

* Estimating the amount data to download, for progress indication
* Grabbing All Artworks
* Updating the Current User
* Getting a Partners Shows
* Getting a Partners Albums
* Getting a Partners Locations
* Getting a Partner's Artists
* Updating Partner Metadata ( for saying when Folio was last accessed. )

Each one of the actions above is an operation tree, which can have many dependant operation trees.

#### Speed

The sync can make a lot of requests, it expects that every object will have a canonical url that it can trust. It then uses plain old NSURL caching to know whether to download a result or to grab it from cache. We avoid making paginated full-json calls for this reason, instead aiming to get lists of IDs that we can use for canonical urls. Paginated lists, more or less, cannot be cached.

#### Deletions

In order to keep track of objects that are missing, and should be removed, there is an `ARDeleter` object on a sync. Before a sync it looks for all objects of certain classes within the managed object context, then different parts of the sync let the ARDeleter know that an object has been found. At the end of a sync, it will have knowledge about what objects haven't been referenced by the sync process.


## Tests

You can read Orta's book on [Pragmatic Testing](https://github.com/orta/pragmatic-testing/), which uses examples from Energy.

#### Mindset

* Cover the 90% use cases, snapshots help here
* Fast, fast, fast
* There's nearly always a way to not have async tests
* Add tests for un-tested code when you see it

The majority of this codebase's tests are based around using dependency injection to pass along composition objects. There are checks to make sure that the app isn't accessing the main Core Data stack, and networking during tests. See `CoreDataManager +mainManagedObjectContext` or `AROHHTTPNoStubAssertionBot` for more info. The `NSUserDefault`'s `standardUserDefaults` is switched out with an easily introspected `ARDefaults` also.
`CoreDataManager +stubbedManagedObjectContext` is a time-cheap.

### The Syncronicity of our City

* Use the `ar_dispatch_xxx` methods, they will always go syncronous in tests.
* Any time you use animations, make sure they are `UIView animateIf::`. If you cannot think of a good way to DI in a bool to make it syncronous in tests, expose `ARDispatchManager`'s is synchronous bool.
* Sync Steps can be tested by introspecting the NSOperation, and by directly running the completion block - see `ARPartnerMetadataUploaderSpec` for an example.

