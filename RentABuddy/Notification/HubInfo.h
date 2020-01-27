#ifndef HubInfo_h
#define HubInfo_h

//this key is the "Listen" only key for client app
#define HUBNAME @"LuisTestRab"
#define HUBLISTENACCESS @"Endpoint=sb://<servicebus_url>/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=Aln1e/gy1lgeQg32p2o0Ucqgc9QsdGTUZBQ3c+Jv6Gw="//"<Enter your DefaultListenSharedAccess connection string"

/* this key if for full access
 Because credentials that are distributed with a client app are not generally secure, you should only distribute the key for listen access with your client app. Listen access enables your app to register for notifications, but existing registrations cannot be modified and notifications cannot be sent. The full access key is used in a secured backend service for sending notifications and changing existing registrations.
 */
#define API_VERSION @"?api-version=2015-01"
#define HUBFULLACCESS @"Endpoint=sb://<servicebus_url>/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=q2wqE8W88nDaYWR7IMAng1P1hEsorIT1BiNvBbRKyzQ="//"<Enter Your DefaultFullSharedAccess Connection string>"
#endif /* HubInfo_h */
