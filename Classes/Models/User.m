#import "NSDictionary+ObjectForKey.h"


@implementation User

- (void)updateWithDictionary:(NSDictionary *)dict
{
    self.slug = [self.class folioSlug:dict];
    self.name = [dict onlyStringForKey:ARFeedNameKey];
    self.type = [dict onlyStringForKey:ARFeedTypeKey];
    self.email = [dict onlyStringForKey:ARFeedEmailKey];
}

+ (User *)currentUser
{
    return [self currentUserInContext:[CoreDataManager mainManagedObjectContext]];
}

+ (User *)currentUserInContext:(NSManagedObjectContext *)context
{
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:ARUserEmailAddress];
    return (id)[User findFirstByAttribute:@keypath(User.new, email) withValue:email inContext:context];
}

- (BOOL)isAdmin
{
    return [self.type isEqualToString:@"Admin"];
}

@end
