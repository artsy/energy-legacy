


@interface NSFetchRequest (ARModels)

/// Gets all artworks of an artwork container that can be found with current user settings with an additional scope predicate
+ (instancetype)ar_allArtworksOfArtworkContainerWithSelfPredicate:(NSPredicate *)selfScopePredicate inContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults;

/// Gets all instances of an artwork container that can be found with current user settings

+ (instancetype)ar_allInstancesOfArtworkContainerClass:(Class)klass inContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults;

@end
