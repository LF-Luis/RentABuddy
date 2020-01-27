#import <Foundation/Foundation.h>

@interface Notifications : NSObject

@property NSData* deviceToken;

- (id)initWithConnectionString:(NSString*)listenConnectionString HubName:(NSString*)hubName;

- (void)storeCategoriesAndSubscribeWithCategories:(NSArray*)categories
                                       completion:(void (^)(NSError* error))completion;

- (NSSet*)retrieveCategories;

- (void)subscribeWithCategories:(NSSet*)categories completion:(void (^)(NSError *))completion;
@end
