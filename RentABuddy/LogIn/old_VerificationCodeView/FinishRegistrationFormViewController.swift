//
//  FinishRegistrationFormViewController.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 6/6/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit
import Eureka   // CocoaPod
//import FBSDKLoginKit

class FinishRegistrationFormViewController:  FormViewController, FBSDKLoginButtonDelegate{
    
    let appDelegate = AppDelegate.getAppDelegate()
    
    // Form
    var regitrationFormOptionsBackup : RowNavigationOptions?
    
    // Navigation bar item
    let barTopCancelItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Finish Registration"
        
        // Navigation bar set-up
        navigationItem.leftBarButtonItem = barTopCancelItem
        self.barTopCancelItem.target = self
        self.barTopCancelItem.action = #selector(self.barTopCancelAction)
        self.barTopCancelItem.title = "Cancel"

        // Whenever this VC and View is reached, there should not be a Token.
        // Incase there is, this if-statement is being added for redundancy:
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            self.loadForm()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            // Show loading overlay while request finishes:
            LoadOverlay.shared.showOverlayOverAppWindow()
            
            // App has an authentication token from facebook, check if we got the information we needed:
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, age_range, email, picture.type(normal)"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil) {
                    // Process error
                    print("Error: \(error)")
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
                                    self.failedSignUp()
                                }
                            })
                        }
                    }
                    else {
                        // Unsuccesful at getting User's data
                        // An error occured, public_profile could not be loaded
                        // Log Out user and ask to log in again
                        self.failedSignUp()
                    }
                }
            })
            
            // End overlay
            LoadOverlay.shared.endOverlay()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func failedSignUp() {
        FBSDKLoginManager().logOut()    // Log out of Facebook
        UserHelperTools.clean_currentUser() // Set currentUser to new RABUser object
    }
    
    func ageReqNotMet() {
        // Age requirement not met
        self.failedSignUp()
        // Segue to HomeVC:
        self.performSegueWithIdentifier("unwindToHomeVC", sender: self)
        LoadOverlay.shared.endOverlay()
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
        UserHelperTools.saveTo_currentUser()
        
        firstTimeUserLogsInWithFB = true  // Set to true to ask User to use FB profile pic as profile pic for RAB. This will be done in HomeVC
        
        LoadOverlay.shared.endOverlay()
        // Segue to HomeVC:
        self.performSegueWithIdentifier("unwindToHomeVC", sender: self)
    }
    
    func barTopCancelAction() {
        // Cancel on top bar was hit
        FBSDKLoginManager().logOut()    // Log out of Facebook
        self.performSegueWithIdentifier("unwindToHomeVC", sender: self)
    }
    
    // MARK: Form
    
    @IBAction func submitForm() {
        
        // Log out of Facebook just incase some log in was done (which it should not have been if this button is available)
        FBSDKLoginManager().logOut()
        
        // Getting values from filled form
        let formValues = form.values()
        
        /* Should be Set Values from Verification Code */
        currentUser.firstName = formValues["userFName"] as? String
        currentUser.lastName = formValues["userLName"] as? String
        currentUser.birthDay = formValues["userBirthDay"] as? NSDate
        currentUser.phoneNum = formValues["userPhoneNum"] as? String
        /**********************************************/
        
        currentUser.email = formValues["userEmail"] as? String
        let ps1 = formValues["password"]
        let ps2 = formValues["confirmPassword"]
        
        // If form is not fully complete, tell user to fully complete it
        // else, move on with registration
        if currentUser.email != nil || ps1 != nil || ps2 != nil {
            
            if ps1 as? String == ps2 as? String{
            
                // FIXME: Pass User registration data to backend
                
                // Update and save user data
                UserHelperTools.saveTo_currentUser()
                
                self.performSegueWithIdentifier("unwindToRegCodeVC", sender: self)
            }
            else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    AppDelegate.getAppDelegate().showMessage(self, message:"Passwords do not match.")
                })
            }
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                AppDelegate.getAppDelegate().showMessage(self, message:"Please fully complete form.")
            })
        }
        
    }
    
    // MARK: FB Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    func returnUserData() {
    }
    // ENDMARK:

    
    func loadForm() {
        
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        regitrationFormOptionsBackup = navigationOptions
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }

        form
        // Sign Up with Facebook
        
        +++ Section() {
            var header = HeaderFooterView<CustomFBButton>(.Class)
            header.onSetupView = { (view: CustomFBButton, section: Section, form: FormViewController) -> () in
                
                view.setupButton(CGRectMake(0, 0, 0, 60), title: "Sign Up With Facebook", font: UIFont.boldSystemFontOfSize(16), centeredInView: false)
                view.autoresizingMask = .FlexibleWidth
                view.readPermissions = ["public_profile", "email"]
                view.delegate = self
                
            }
            
            $0.header = header
        }
            
        +++ Section() { $0.header = HeaderFooterView<Divider>(HeaderFooterProvider.Class) }
            
        +++ Section(header: "Create an Account", footer: "")
            
            <<< NameRow("userFName") { $0.title = "First Name:"; $0.placeholder = "First Name"}
            
            <<< NameRow("userLName") { $0.title = "Last Name:"; $0.placeholder = "Last Name" }
            
            <<< DateInlineRow("userBirthDay") { $0.value = NSDate(); $0.title = "Date of Birth" }
            
            <<< PhoneRow("userPhoneNum") { $0.title = "Cell Phone Number:"; $0.placeholder = "Phone Number" }
            
            <<< EmailRow("userEmail") { $0.title = "Email:"; $0.placeholder = "Email" }
            
            <<< PasswordRow("password") { $0.title = "Password"; $0.placeholder = "Password" }
            
            <<< PasswordRow("confirmPassword") { $0.title = "Confirm Password"; $0.placeholder = "Password" }
         
        +++ Section()
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in row.title = "Sign Up" }  .onCellSelection({ (cell, row) in self.submitForm() })
    }
    
}

// Divider "or" view
class Divider: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let orText: UILabel = UILabel(frame: CGRectMake(0, 0, 320, 12))
        orText.text = "-  OR  -"
        orText.textAlignment = .Center
        orText.font = UIFont.boldSystemFontOfSize(14)
        orText.autoresizingMask = .FlexibleWidth
        self.frame = CGRect(x: 0, y: 0, width: 320, height: 12)
        orText.contentMode = .ScaleAspectFit
        self.addSubview(orText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
