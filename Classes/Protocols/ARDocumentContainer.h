@protocol ARDocumentContainer <NSObject>
- (NSArray *)sortedDocuments;

- (NSFetchRequest *)sortedDocumentsFetchRequestInContext:(NSManagedObjectContext *)context;

- (NSString *)name;
@end
