#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ARBrowseDisplayMode) {
    ARBrowseDisplayModeArtists,
    ARBrowseDisplayModeShows,
    ARBrowseDisplayModeLocations,
    ARBrowseDisplayModeAlbums
};


@interface ARBrowseProvider : NSObject <UITableViewDataSource, UITableViewDelegate>

- (void)refreshWithTableView:(UITableView *)tableView;

@property (nonatomic, assign, readwrite) ARBrowseDisplayMode currentDisplayMode;

// TODO: rename this guy? I'm just going with the established terminology
@property (nonatomic, assign, readwrite) NSManagedObject *selectedItem;

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;

@end
