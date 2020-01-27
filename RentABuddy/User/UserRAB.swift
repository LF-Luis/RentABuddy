//
//  UserRAB.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 6/11/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import Foundation
import RealmSwift

class UserRAB: Object {
    
    dynamic var id = ""
    
    dynamic var firstName: String?
    dynamic var lastName: String?
    dynamic var email: String?
    dynamic var phoneNum: String?
    dynamic var address: String?
    dynamic var squareProfilePicURL: String?
    
    dynamic var facebookBusinessToken: String?
    
    dynamic var birthDay: NSDate?
    dynamic var age: String?
    dynamic var accountCreationDate: NSDate?
    
    dynamic var isLoggedInUser = false
    dynamic var isProvider = false
    
    // Information of Buddy who is Authorizing
    dynamic var buddyFName: String?
    dynamic var buddyLName: String?
    let buddyPhoneNums = List<PhoneNum>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

class PhoneNum: Object {
    dynamic var phoneN: String?
}

class UserHelperTools {
    
    class func isLoggedInUser() -> Bool {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            return true
        }
        else {
            return false
        }
    }
    
    class func logOut() {
        // Log out of all services (FB, Google, RAB database)
        FBSDKLoginManager().logOut()
        self.clearAllUserData()
    }
    
    class func loadUserData() {
        // FIXME: Load data after Log In
        print("RAB: Should load currentUser's Data")
        saveTo_currentUser()
    }
    
    
    class func setUserProfilePicURL() {
        // Setting profile picture of User
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "picture.type(normal)"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

                if ((error) != nil) {
                    // Process error
                    print("Error: \(error)")
                }
                else {
                    if let urlString = result.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as? String {
                        try! userRealm.write({ () -> Void in
                            currentUser.squareProfilePicURL = urlString
                            userRealm.add(currentUser, update: true)
                        })
                    }
                }
            })
        }
    }
    
    // MARK: User's local data management
    class func saveTo_currentUser() {
        currentUser.isLoggedInUser = true
//        currentUser.id = currentUserID
        try! userRealm.write({ () -> Void in
            userRealm.add(currentUser, update: true)
        })
    }
    
    class func saveTo_currentUserAtLogIn() {
        currentUser.isLoggedInUser = true
        currentUser.id = currentUserID
        try! userRealm.write({ () -> Void in
            userRealm.add(currentUser, update: true)
        })
    }
    
    class func setTo_currentUser() {
//        currentUser.id = currentUserID
        if let userExists = userRealm.objectForPrimaryKey(UserRAB.self, key: currentUserID) {
            currentUser = userExists
        }
    }
    
    class func clearAllUserData() {
        try! userRealm.write {
            userRealm.deleteAll()
        }
    }
    
    class func clean_currentUser() {
        currentUser = UserRAB()
    }
    
    class func test_printCurrentUserValues() {
        print(" *** ")
        print(currentUser.firstName)
        print(currentUser.lastName)
        print(currentUser.phoneNum)
        print(currentUser.birthDay)
        print(currentUser.buddyFName)
        print(currentUser.buddyLName)
        print(currentUser.buddyPhoneNums)
        print("User is logged in: \(currentUser.isLoggedInUser)")
        print("id: \(currentUser.id)")
        print(" *** ")
    }
    
    class func test_printRealmDirectory() {
        print("*** Realm Directory ***")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
}

