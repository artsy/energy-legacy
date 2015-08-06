#import "ARArtistViewController.h"


@interface ARArtistViewController () {
    Artist *_artist;
}
@end


@implementation ARArtistViewController

- (instancetype)initWithArtist:(Artist *)artist
{
    if (self = [super initWithRepresentedObject:artist]) {
        _artist = artist;
        self.title = artist.name ?: @"Unknown Artist";
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [ARAnalytics event:ARArtistViewEvent withProperties:@{ @"artist" : _artist.name }];
}

- (NSString *)pageID
{
    return ARArtistPage;
}

@end
