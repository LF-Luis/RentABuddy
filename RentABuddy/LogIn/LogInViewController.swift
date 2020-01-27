//
//  LogInViewController.swift
//  ContactAndAlamo
//
//  Created by Luis Fernandez on 5/25/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit
import Eureka   // CocoaPod

class LogInViewController: FormViewController, FBSDKLoginButtonDelegate {
    
    // Form
    var regitrationFormOptionsBackup : RowNavigationOptions?
    
    // Navigation bar item
    let barTopCancelItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Whenever this VC and View is reached, there should not be a Token.
        // Incase there is, this if-statement is being added for redundancy:
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            self.loadForm()
        }
    
        navigationItem.title = "Log In"
        
        // Navigation bar set-up
        navigationItem.leftBarButtonItem = barTopCancelItem
        self.barTopCancelItem.target = self
        self.barTopCancelItem.action = #selector(self.barTopCancelAction)
        self.barTopCancelItem.title = "Cancel"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func barTopCancelAction() {
        self.performSegueWithIdentifier("unwindToHomeVC", sender: self)
    }
    
    // MARK: FB Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil){
            print("Facebook Log In Failed: \n \(error.localizedDescription)")
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                AppDelegate.getAppDelegate().showMessage(self, message: "Facebook Log In failed. Please try again.")
            })
        }
        else if result.isCancelled {
            print("Facebook Log In Cancelled by current user")
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                AppDelegate.getAppDelegate().showMessage(self, message: "Facebook Log In was cancelled. You will need to Log In to be able to use RentABuddy.")
            })
        }
        else {
            // If asking for multiple permissions at once, check if specific permissions missing
//            if result.grantedPermissions.contains("email") 
            self.getFBUserData()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {}    // Log out will be handled somewhere else
    
    func getFBUserData() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            // Show loading overlay while request finishes:
            LoadOverlay.shared.showOverlayOverAppWindow()
            
            // App has an authentication token from facebook, check if we got the information we needed:
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, age_range, email, picture.type(normal)"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                // -TODO: Check if User is in RAB database
                /*
                 If this is the case, then bypass the following and load data fromRAB database.
                 This can be done by using the Facebook Bussiness ID.
                 */
                
                if ((error) != nil) {
                    // Process error
                    print("Error: \(error)")
                    UserHelperTools.logOut()
                }
                else {
                    // Check if results has what we asked for
                    // At time of writing, "public_profile" comes with first and last name, email, and profile picture (as well as other things that we do not need)
                    // Checking for first name here checks if public profile was received:
                    if let firstName = result.valueForKey("first_name") as? String {
                        
                        currentUser.firstName = firstName
                        currentUser.lastName = result.valueForKey("last_name") as? String
                        currentUser.accountCreationDate = NSDate()
                        
                        if (result.valueForKey("age_range")?.valueForKey("min") as? Int) < 18 {
                            // quit
                            self.ageReqNotMet()
                        }
                        
                        // Checking if especial permission for "email" was returned User's email
                        // Sometimes FB users sign up with a phone number. In that case,  let's allow them to provide an email.
                        if let email = result.valueForKey("email") as? String {
                            // email received from FB
                            currentUser.email = email
                            self.successfulRegistration_exitToHomeVC()
                        }
                        else {
                            self.alertToGetEmail({ (emailString) in
                                if !(emailString!.isEmpty) {
                                    // email recieved from Alert
                                    currentUser.email = emailString as String!
                                    self.successfulRegistration_exitToHomeVC()
                                }
                                else {
                                    // Unsuccesful at getting User's data: email permission not granted
                                    UserHelperTools.logOut()
                                }
                            })
                        }
                    }
                    else {
                        // Unsuccesful at getting User's data
                        // An error occured, public_profile could not be loaded
                        // Log Out user and ask to log in again
                        UserHelperTools.logOut()
                    }
                }
            })
            
            // End overlay
            LoadOverlay.shared.endOverlay()
        }
    }
    
    func ageReqNotMet() {
        // Age requirement not met
        UserHelperTools.logOut()
        LoadOverlay.shared.endOverlay()
        // Segue to HomeVC:
        self.performSegueWithIdentifier("unwindToHomeVC", sender: self)
    }
    
    func alertToGetEmail(completion:((emailString: String?) -> Void)) {
        let alert = UIAlertController(title: "RentABuddy", message: "MANDATORY: Your email could not be received from Facebook. Please enter the email you wish to associate with your RentABuddy account:", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "email"
        })
        alert.addAction(UIAlertAction(title: "Enter", style: .Default, handler: { (action) -> Void in
            let emailText = alert.textFields![0] as UITextField
            completion(emailString: emailText.text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive) { (action) -> Void in })
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func successfulRegistration_exitToHomeVC() {
        // At this point, our app has the FB token, as well as the user information we requested. Exit to HomeVC:
        // FIXME: Send to back-end User Info
        
        // Update and save user data
        UserHelperTools.saveTo_currentUserAtLogIn()
        
        firstTimeUserLogsInWithFB = true  // Set to true to ask User to use FB profile pic as profile pic for RAB. This will be done in HomeVC
        
        LoadOverlay.shared.endOverlay()
        // Segue to HomeVC:
        self.performSegueWithIdentifier("unwindToHomeVC", sender: self)
    }
    
    // ENDMARK:
    
    // MARK: - Form
    func loadForm() {
        
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        regitrationFormOptionsBackup = navigationOptions
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        
        form
            +++ Section()
            
            +++ Section()
            
            +++ Section() {
                var header = HeaderFooterView<UILabel>(.Class)
                header.onSetupView = { (view: UILabel, section: Section, form: FormViewController) -> () in
                    view.frame = CGRectMake(0, 0, 0, 48.0)
                    view.numberOfLines = 2
                    view.textAlignment = .Center
                    view.text = "Please Sign In using your favorite service to start using RentABuddy!"
                }
                
                $0.header = header
            }
            
            +++ Section() {
                var header = HeaderFooterView<CustomFBButton>(.Class)
                header.onSetupView = { (view: CustomFBButton, section: Section, form: FormViewController) -> () in
                    
                    view.setupButton(CGRectMake(0, 0, 0, 40), title: "Log In With Facebook", font: UIFont.boldSystemFontOfSize(16), centeredInView: false)
                    view.autoresizingMask = .FlexibleWidth
                    view.readPermissions = ["public_profile", "email"]
                    view.delegate = self
                    
                }
                
                $0.header = header
            }
    }
    

}