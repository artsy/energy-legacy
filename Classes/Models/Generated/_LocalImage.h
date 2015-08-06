// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LocalImage.h instead.

#import <CoreData/CoreData.h>
#import "Image.h"


@interface LocalImageID : ImageID {
}
@end


@interface _LocalImage : Image {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;

- (LocalImageID *)objectID;

@end


@interface _LocalImage (CoreDataGeneratedPrimitiveAccessors)

@end
