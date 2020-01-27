//
//  Person.swift
//  ContactAndAlamo
//
//  Created by Luis Fernandez on 5/25/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit

class Person: NSObject {
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNum: [String]?
    var mobilePhone : String?
    var address : Address?
    var squareProfilePicURL: String?
    var squareProfilePic : UIImage?
    
    var userName: String?   // of formatt "Luis F."
    
    var birthDay: NSDate?
    var age: String?
    var accountCreationDate: NSDate?
    
    var userJustSignedInWithFB: Bool = false    // This is only used to ask the user once if they want to use their FB picture for their profile picture. This will be used when User finishes registration and the VC unwinds to HomeVC
    
    var isLoggedInUser: Bool = false
    var isProvider: Bool?
    
    /**
     Get the name of Person to display publicly.
     
     - returns:
     Returns the name of user (Luis Fernandez) formatted as: "Luis F."
     
     - important:
     Will only return formatted userName if firstName and lastName of this object is specified. Otherwise it will return nil.
    */
    func getUserName() -> String? {
        
        if firstName != nil && lastName != nil {
            
            let lIni = lastName![(lastName?.startIndex.advancedBy(0))!] // last name inital
            
            return firstName! + " " + String(lIni) + "."
            
        }
        
        return nil
        
    }
    
    /**
     Get the address of Person in U.S. postal format.
     
     - returns:
     Address formatted as: street, city, state, zip code, country
     
     - important:
     Will only return formatted address if address.street, address.city, address.state, address.zipCode, and address.country are specified for ths object. Else, this will return nil.
     */
    func getUSAddress() -> String? {
        if address?.street != nil && address?.state != nil && address?.zipCode != nil && address?.city != nil && address?.country != nil {
            return String(address!.street! + " " + address!.city! + " " + address!.state! + " " + address!.zipCode! + " " + address!.country!)
        }
        
        return nil
    }
    
}

class Address : NSObject {
    
    var street : String?
    var state : String?
    var zipCode : String?
    var city : String?
    var country : String?
    
    override init() {
        super.init()
    }
    
    init(street: String?, state: String?, zipCode: String?, city: String?, country: String?){
        self.street = street
        self.state = state
        self.zipCode = zipCode
        self.city = city
        self.country = country
    }
    
    
    
}

class MainUser: Person{
    
    var facebookBusinessToken: String?

    override init() {
        super.init()
        self.isLoggedInUser = true
    }
    
    class func isLoggedIn() -> Bool {
        // TODO: Check with Google and RAB
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            return true
        }
        else {
            return false
        }
    }
    
//    func setTokenUserDefaults(token:String) {
//        // User Token:
//        // User Token will be stored using NSUserDefaults
//        // This is the key for the User's Token store in the User's phone
//        let UserTokenKey: String = "UserTokenKey"
//        
//        userDefaults.setObject(token, forKey: UserTokenKey)
//    }
    
//    func getTokenUserDefaults() -> String {
//        let UserTokenKey: String = "UserTokenKey"
//        
//        var retToken = String()
//        
//        if let token = userDefaults.stringForKey(UserTokenKey) {
//            retToken = token
//            isLoggedInUser = true   // Safety, redundant setting
//        }
//        else {
//            retToken = "NoToken"
//            isLoggedInUser = false  // Safety, redundant setting
//        }
//        
//        return retToken
//    }
    
    // This method should be run as much as needed when views load and reload to check if current user is a Registered User
    func setisLoggedInUser() {
        // FIXME: Using Lan's API, check if user is Registered User
        if test_userIsRegisteres {
            self.isLoggedInUser = true
        }
        else {
            self.isLoggedInUser = false
        }
    }
    
    func setUserProfilePicURL() {
        // Setting profile picture of User
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "picture.type(normal)"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil) {
                    // Process error
                    print("Error: \(error)")
                }
                else {
                    self.squareProfilePicURL = String(result.valueForKey("picture")?.valueForKey("data")?.valueForKey("url"))
                }
            })
        }
    }
    
    func setEndOfRegistrationUserInfo() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, email"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil) {
                    // Process error
                    print("Error: \(error)")
                }
                else {
                    self.firstName = result.valueForKey("first_name") as? String
                    self.lastName = result.valueForKey("last_name") as? String
                    self.email = result.valueForKey("email") as? String
                }
            })
        }
    }
    
}
