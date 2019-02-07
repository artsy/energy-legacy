


@interface ARFeedTranslator : NSObject

/// Lets you toggle parsing in tests
+ (void)shouldParseJSON:(BOOL)shouldParseJSON;

/// Converts an array of JSON objects into an array of a particular class,
/// with the work all happening on a background thread
+ (NSArray *)backgroundAddOrUpdateObjects:(NSArray *)objects withClass:(Class) class inContext:(NSManagedObjectContext *)context saving:(BOOL)shouldSave completion:(void (^)(NSArray *objects))completion;

/// Finds or creates an object from a JSON object
+ (NSManagedObject *)addOrUpdateObject:(NSDictionary *)aDictionary
                        withEntityName:(NSString *)entityName
                             inContext:(NSManagedObjectContext *)context
                                saving:(BOOL)shouldSave;

/// Finds or creates an object from a JSON object
+ (NSArray *)addOrUpdateObjects:(NSArray *)anArray
                 withEntityName:(NSString *)entityName
                      inContext:(NSManagedObjectContext *)context
                         saving:(BOOL)shouldSave;

@end
