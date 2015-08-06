

@interface ARManagedObjectID : NSManagedObjectID
@end


@interface ARManagedObject : NSManagedObject

@property (nonatomic, strong) NSString *slug;

// We'd really like every model's slugs to be unique in Folio
// but this isn't a given in Gravity.

+ (NSString *)folioSlug:(NSDictionary *)aDictionary;

- (BOOL)saveManagedObjectContextLoggingErrors;

- (void)updateWithDictionary:(NSDictionary *)aDictionary;

- (NSString *)tempId;


/// Parse a single dictionary into self's class
+ (instancetype)addOrUpdateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context saving:(BOOL)saving;

/// Parse multiple dictionaries into self's class - returns a set,
/// as this is most common in model relationships
+ (NSSet *)addOrUpdateWithDictionaries:(NSArray *)dictionaries inContext:(NSManagedObjectContext *)context saving:(BOOL)saving;


@end

// This empty protocol is used to check if the grid cell's
// item is something selectable.
@protocol ARMultipleSelectionItem <NSObject>
@end
