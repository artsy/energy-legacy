#import "ARSortOrderHost.h"
#import "ARSortDefinition.h"
#import "ARArtworkContainer.h"


@implementation ARSortOrderHost

+ (NSArray *)defaultSortsWithoutArtist
{
    return @[
        [ARSortDefinition definitionWithName:@"Date" andOrder:ARArtworksSortOrderDefault],
        [ARSortDefinition definitionWithName:@"Title" andOrder:ARArtworksSortOrderAlphabetic],
        [ARSortDefinition definitionWithName:@"Medium" andOrder:ARArtworksSortOrderMedium]
    ];
}

+ (NSArray *)defaultSorts
{
    return @[
        [ARSortDefinition definitionWithName:@"Artist, Title" andOrder:ARArtworksSortOrderArtistTitle],
        [ARSortDefinition definitionWithName:@"Artist, Date" andOrder:ARArtworksSortOrderArtistDate],
        [ARSortDefinition definitionWithName:@"Artist, Medium" andOrder:ARArtworksSortOrderArtistMedium],
        [ARSortDefinition definitionWithName:@"Title" andOrder:ARArtworksSortOrderAlphabetic],
        [ARSortDefinition definitionWithName:@"Date" andOrder:ARArtworksSortOrderDate],
        [ARSortDefinition definitionWithName:@"Medium" andOrder:ARArtworksSortOrderMedium]
    ];
}

+ (NSArray *)sortDescriptorsWithoutArtistWithOrder:(ARArtworkSortOrder)order;
{
    switch (order) {
        case ARArtworksSortOrderDefault:
        case ARArtworksSortOrderDate: {
            NSSortDescriptor *byYear = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
            NSSortDescriptor *byTitle = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            return @[ byYear, byTitle ];
        }

        case ARArtworksSortOrderMedium: {
            NSSortDescriptor *byMedium = [NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES];
            NSSortDescriptor *byYear = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
            NSSortDescriptor *byTitle = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            return @[ byMedium, byYear, byTitle ];
        }

        case ARArtworksSortOrderAlphabetic: {
            NSSortDescriptor *byYear = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
            NSSortDescriptor *byTitle = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            return @[ byTitle, byYear ];
        }
        default:
            return @[];
    }
}

+ (NSArray *)sortDescriptorstWithOrder:(ARArtworkSortOrder)order;
{
    NSSortDescriptor *byArtist = [[NSSortDescriptor alloc] initWithKey:@"artist.orderingKey" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSSortDescriptor *byTitle = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSSortDescriptor *byYear = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSSortDescriptor *byMedium = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES selector:@selector(caseInsensitiveCompare:)];

    switch (order) {
        case ARArtworksSortOrderDefault:
        case ARArtworksSortOrderArtistTitle:
            return @[ byArtist, byTitle, byYear ];

        case ARArtworksSortOrderArtistDate:
            return @[ byArtist, byYear, byTitle ];

        case ARArtworksSortOrderArtistMedium:
            return @[ byArtist, byMedium, byYear, byTitle ];

        case ARArtworksSortOrderMedium:
            return @[ byMedium, byArtist, byYear, byTitle ];

        case ARArtworksSortOrderAlphabetic:
            return @[ byTitle, byArtist, byYear ];

        case ARArtworksSortOrderDate:
            return @[ byYear, byArtist, byTitle ];

        default:
            return @[];
    }
}

@end
