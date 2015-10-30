@class ARSyncDeleter;

/// The configuration object for the ARSync


@interface ARSyncConfig : NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                    defaults:(NSUserDefaults *)defaults
                                     deleter:(ARSyncDeleter *)deleter;

@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, strong) NSUserDefaults *defaults;
@property (nonatomic, readonly, strong) ARSyncDeleter *deleter;

@end
