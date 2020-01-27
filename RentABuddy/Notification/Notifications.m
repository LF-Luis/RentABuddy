#import "Notifications.h"
#import <WindowsAzureMessaging/WindowsAzureMessaging.h>

// Example to follow:

@implementation Notifications

/*
 Copy the following code in the implementation section of the file Notifications.m.
 https://azure.microsoft.com/en-us/documentation/articles/notification-hubs-ios-send-breaking-news/
 */
SBNotificationHub* hub;

- (id)initWithConnectionString:(NSString*)listenConnectionString HubName:(NSString*)hubName{
    
    hub = [[SBNotificationHub alloc] initWithConnectionString:listenConnectionString
                                          notificationHubPath:hubName];
    
    return self;
}

- (void)storeCategoriesAndSubscribeWithCategories:(NSSet *)categories completion:(void (^)(NSError *))completion {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[categories allObjects] forKey:@"BreakingNewsCategories"];
    
    [self subscribeWithCategories:categories completion:completion];
}

- (NSSet*)retrieveCategories {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray* categories = [defaults stringArrayForKey:@"BreakingNewsCategories"];
    
    if (!categories) return [[NSSet alloc] init];
    return [[NSSet alloc] initWithArray:categories];
}

- (void)subscribeWithCategories:(NSSet *)categories completion:(void (^)(NSError *))completion
{
    //[hub registerNativeWithDeviceToken:self.deviceToken tags:categories completion: completion];
    
    NSString* templateBodyAPNS = @"{\"aps\":{\"alert\":\"$(messageParam)\"}}";
    
    [hub registerTemplateWithDeviceToken:self.deviceToken name:@"simpleAPNSTemplate"
                        jsonBodyTemplate:templateBodyAPNS expiryTemplate:@"0" tags:categories completion:completion];
}
/*
 In the AppDelegate.h file, add an import statement for Notifications.h and add a property for an instance of the Notifications class:
 */
@end
