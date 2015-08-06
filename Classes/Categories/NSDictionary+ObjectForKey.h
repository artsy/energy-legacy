#import <Foundation/Foundation.h>


@interface NSDictionary (ObjectForKey)

- (NSString *)onlyStringForKey:(NSString *)key;

- (NSDictionary *)onlyDictionaryForKey:(NSString *)key;

- (NSArray *)onlyArrayForKey:(NSString *)key;

- (NSDecimalNumber *)onlyDecimalForKey:(NSString *)key;

- (NSNumber *)onlyNumberForKey:(NSString *)key;

- (id)objectForKeyNotNull:(id)key;

- (NSDate *)onlyDateFromStringForKey:(NSString *)key;
@end
