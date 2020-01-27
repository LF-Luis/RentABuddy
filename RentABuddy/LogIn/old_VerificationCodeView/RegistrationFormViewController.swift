//
//  RegistrationFormViewController.swift
//  GetContactCode
//
//  Created by Luis Fernandez on 5/24/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit
import Eureka   // CocoaPod
import Contacts
import ContactsUI

class RegistrationFormViewController: FormViewController, CNContactPickerDelegate {
    
    let contactStore = CNContactStore()
    
    var regitrationFormOptionsBackup : RowNavigationOptions?
    
    override func viewDidLoad() {
        navigationItem.title = "Verification Form"
        super.viewDidLoad()
        self.loadForm()
    }
    
    func loadForm() {
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        regitrationFormOptionsBackup = navigationOptions
        
        form

            +++ Section("Hello")
            
            <<< NameRow("userFName") { $0.title = "First Name:"; $0.placeholder = "First Name" }
            
            <<< NameRow("userLName") { $0.title = "Last Name:"; $0.placeholder = "Last Name" }
            
            <<< PhoneRow("userPhoneNum") { $0.title = "Cell Phone Number:"; $0.placeholder = "Phone Number" }
            
            <<< DateInlineRow("userBirthDay") { $0.value = NSDate(); $0.title = "Date of Birth" }
            
            +++ Section(header: "Your Buddy's Information", footer: "This information is used to send your Buddy a message to authenticate your new account.")
            
            <<< NameRow("buddyFName") { $0.title = "First Name:"; $0.placeholder = "First Name" }
            
            <<< NameRow("buddyLName") { $0.title = "Last Name:"; $0.placeholder = "Last Name"  }

            <<< PhoneRow("buddyPhoneNum") { $0.title = "Cell Phone Number:"; $0.placeholder = "Phone Number"  }
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Automatically Fill"
                }  .onCellSelection({ (cell, row) in
                    self.automaticallyFillForm()
                })
            
            +++ Section()
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Submit Registration"
                }  .onCellSelection({ (cell, row) in
                    self.submitRegistration()
                })
    }

    // MARK: Form Actions
    @IBAction func submitRegistration() {
        
        // Getting values from filled form
        // At this point, the form could have been filled manually or automatically using adress book (for Buddy)
        let formValues = form.values()
        
        let formDate = formValues["userBirthDay"] as! NSDate
        
        currentUser.firstName = formValues["userFName"] as? String
        currentUser.lastName = formValues["userLName"] as? String
        currentUser.phoneNum = formValues["userPhoneNum"] as? String
        currentUser.birthDay = formDate

        currentUser.buddyFName = formValues["buddyFName"] as? String
        currentUser.buddyLName = formValues["buddyLName"] as? String
        
        if let pNString = formValues["buddyPhoneNum"] as? String {   // pN stands for phone number
            let pNArr = pNString.componentsSeparatedByString(",")
            for pN in pNArr {
                let currentPN = PhoneNum()
                currentPN.phoneN = pN
                currentUser.buddyPhoneNums.append(currentPN)
            }
        }
       
        // If form is not fully complete, tell user to fully complete it
        // else, move on with registration
        if currentUser.firstName == nil || currentUser.lastName == nil || currentUser.phoneNum == nil || currentUser.birthDay == nil || currentUser.buddyFName == nil || currentUser.buddyLName == nil || currentUser.buddyPhoneNums.isEmpty {
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                AppDelegate.getAppDelegate().showMessage(self, message:"Please fully complete form.")
            })
            
        }
        else {
            
            // This big line gets the year difference between today and the formDate
            if NSCalendar.currentCalendar().components(.Year, fromDate: formDate, toDate: NSDate(), options: []).year < 18 {
                AppDelegate.getAppDelegate().showMessage(self, message: "Must be 18 years of age or older to use RentABuddy services.")
                
            }
            else {
                // Update and save user data
                UserHelperTools.saveTo_currentUser()
                
                // FIXME: Pass phone number to backend to get registration Code
                
                self.performSegueWithIdentifier("unwindToRegCodeVC", sender: self)
                
            }
        }
    }
    
    @IBAction func automaticallyFillForm() {
        AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                let contactPickerViewController = CNContactPickerViewController()
                contactPickerViewController.delegate = self
                self.presentViewController(contactPickerViewController, animated: true, completion: nil)
            }
        }
    }
    
    // ENDMARK:
    
    // MARK: CNContactPickerDelegate Methods
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        // If the user did not pick a contact from the list, this is a message saying to select one
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            AppDelegate.getAppDelegate().showMessage(self, message: "No Contact was selected.")
        })
    }
    
    // Return informaion (phone numbers) of picked user
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        
        // Getting Buddy's Name and Phone Numbers
        var numberArray = [String]()
        
        var buddysPhoneNums = String()
        
        if contact.isKeyAvailable(CNContactPhoneNumbersKey){
            
            for number in contact.phoneNumbers {
                let phoneNumber = number.value as! CNPhoneNumber
                numberArray.append(phoneNumber.stringValue)
            }
            buddysPhoneNums = numberArray.joinWithSeparator(", ") // Makes phone numbers in csv
            
        }
        
        if numberArray.isEmpty {
            // handle error that a contact with no phone number was selected
            print("No phone numbers are available")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                AppDelegate.getAppDelegate().showMessage(self, message:"This contact has no Phone Numbers. Please select another Contact.")
            })
        }

        // Reloading Form with Address Book information
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.form.setValues(["buddyFName": contact.givenName, "buddyLName": contact.familyName, "buddyPhoneNum": buddysPhoneNums])
            self.tableView?.reloadData()
        })

    }
    // ENDMARK:
    
}
