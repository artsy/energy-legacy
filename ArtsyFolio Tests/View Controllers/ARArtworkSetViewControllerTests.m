#import "ARArtworkSetViewController.h"
#import "ARModelFactory.h"
#import "SDWebImage+EasyCache.h"
SpecBegin(ARArtworkSetViewController);

__block NSManagedObjectContext *context;

describe(@"visuals", ^{
    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"default", ^id {

        [SDWebImageManager cacheImageNamed:@"example-image" toCacheWithAddress:@"(null)/13/-2147483648_-2147483648.jpg"];

        context = [CoreDataManager stubbedManagedObjectContext];
        [ARModelFactory partiallyFilledArtworkInContext:context];
        [ARModelFactory partiallyFilledArtworkInContext:context];
        
        NSFetchedResultsController *controller = [Artwork allArtworksInContext:context];
        [controller performFetch:nil];
    
        return [[ARArtworkSetViewController alloc] initWithArtworks:controller atIndex:0 representedObject:nil];
    });


});

SpecEnd
