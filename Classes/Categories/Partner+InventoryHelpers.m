#import "Partner+InventoryHelpers.h"


@implementation Partner (InventoryHelpers)

- (BOOL)hasPublishedWorks
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPublished = YES"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasUnpublishedWorks
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPublished = NO"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasWorksWithPrice
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayPrice != '' OR backendPrice != ''"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasForSaleWorks
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isAvailableForSale = YES"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasNotForSaleWorks
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isAvailableForSale = NO"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasSoldWorks
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"availability = 'sold'"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasSoldWorksWithPrices
{
    NSPredicate *hasPricesPredicate = [NSPredicate predicateWithFormat:@"displayPrice != '' OR backendPrice != ''"];
    NSPredicate *hasSoldWorksPredicate = [NSPredicate predicateWithFormat:@"availability = 'sold'"];
    
    NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ hasPricesPredicate, hasSoldWorksPredicate ]];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasConfidentialNotes
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"confidentialNotes != ''"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}


@end
