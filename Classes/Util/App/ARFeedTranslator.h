

@interface ARFeedTranslator : NSObject

+ (void)shouldParseJSON:(BOOL)shouldParseJSON;

+ (NSArray *)backgroundAddOrUpdateObjects:(NSArray *)objects withClass:(Class) class inContext:(NSManagedObjectContext *)context saving:(BOOL)shouldSave completion:(void (^)(NSArray *objects))completion;

+ (NSManagedObject *)addOrUpdateObject:(NSDictionary *)aDictionary
                        withEntityName:(NSString *)entityName
                             inContext:(NSManagedObjectContext *)context
                                saving:(BOOL)shouldSave;

+ (NSArray *)addOrUpdateObjects:(NSArray *)anArray
                 withEntityName:(NSString *)entityName
                      inContext:(NSManagedObjectContext *)context
                         saving:(BOOL)shouldSave;

+ (NSDictionary *)objectsIndexedByIdFromIds:(NSArray *)objectIDs
                             withEntityName:(NSString *)entityName
                                  inContext:(NSManagedObjectContext *)context;

@end
