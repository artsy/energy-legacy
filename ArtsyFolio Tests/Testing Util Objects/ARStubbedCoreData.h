

@interface ARStubbedCoreData : NSObject

+ (instancetype)stubbedCoreDataInstance;

@property (readonly, nonatomic, strong) NSManagedObjectContext *context;
@property (readonly, nonatomic, strong) Artist *artist1;

@end
