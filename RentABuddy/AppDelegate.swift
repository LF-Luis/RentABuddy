//
//  AppDelegate.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 12/29/15.
//  Copyright © 2015 Luis Fernandez. All rights reserved.
//

import UIKit
import Contacts
import RealmSwift

var notification = Notifications()

var firstTimeUserLogsInWithFB = false   // This will only be used when a New User finishes registration

// Only one user will be created and used throughout app. currentUser's data is persistive.
let userRealm = try! Realm()
var currentUser = UserRAB()
let currentUserID = "USER"    // This ID is just used to retrieve the same object from Realm, it does not need to be secured

// Testing. This is acting as Log In Token
var test_userToken: String = "12345"
var test_userIsRegisteres: Bool = false

// Global variable for screen size of current device
var currentScreenWidth = CGFloat()
var currentScreenHeight = CGFloat()

// Global variable for category cell height
var categoryCellHeight:CGFloat = 175.0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var contactStore = CNContactStore()
      
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Sets background to a blank/empty image
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().alpha = 0.1
        // Translucent background color
//        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        UINavigationBar.appearance().translucent = true
        
        
        // Setting size of current screen
        // These two sizes will be used everywhere in the app to set view sizes
        let bounds:CGRect = UIScreen.mainScreen().bounds
        currentScreenWidth = bounds.size.width      // 414 on iPhone 6S plus
        currentScreenHeight = bounds.size.height    // 736 on iPhone 6S plus
        
        let setting = UIUserNotificationSettings(forTypes:[
            UIUserNotificationType.Sound,
            UIUserNotificationType.Badge,
            UIUserNotificationType.Alert], categories: nil)
        
        notification = Notifications(connectionString: HUBLISTENACCESS, hubName: HUBNAME)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let hub : SBNotificationHub = SBNotificationHub(connectionString: HUBLISTENACCESS, notificationHubPath: HUBNAME)
//        hub.registerNativeWithDeviceToken(deviceToken, tags: nil)
        hub.registerNativeWithDeviceToken(deviceToken, tags: nil, completion: { (error) -> Void in
            if error != nil {
                print("Error: \(error)")
            }
            else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let message = "APNS: REGISTERED SUCCEFULLY"
                    self.showMessage(self.getTopVC(), message:message)
                })
            }
        })
        
//        self.notification
        
    }

    // Handle remote notifications
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("\(userInfo)")
        
        let tempStr = userInfo["aps"]?.valueForKey("alert") as! String
        
        print(tempStr)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let message = tempStr
            self.showMessage(self.getTopVC(), message:message)
        })

    }
    
    // App will open up again after user has validated login credentials
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Allow FB tp capture events of the application
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: Custom functions
    
    // Access any property and method of the app delegate
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    // Custom alert message (can be used in any case)
    func showMessage(currentViewController: UIViewController, message: String) {
        let alertController = UIAlertController(title: "RentABuddy", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in }
        
        alertController.addAction(dismissAction)
        
        //                let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        //                let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        //                presentedViewController.presentViewController(alertController, animated: true, completion: nil)
        
        //        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        currentViewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // This functions requests for access the first time it is ever called in the app.
    // After that, it checks our access. If we have access to contacts: all is good.
    // If we do not have access then an alert is shown to user to give us access from iPhone Settings
    func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
            
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(self.getTopVC(), message:message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(accessGranted: false)
        }
    }
    
    // Get top-most View Controller
    func getTopVC() -> UIViewController {
        var topViewController = UIApplication.sharedApplication().keyWindow!.rootViewController
        
        while (( topViewController?.presentedViewController ) != nil){
            topViewController = topViewController?.presentedViewController
        }
        
        return topViewController!
    }
    
}


// MARK: - My Extensions

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        // Dismiss keyboard when view is tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

private var kAssociationKeyNextField: UInt8 = 0

extension UITextField {
    var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

