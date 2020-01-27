//
//  RegistrationCodeViewController.swift
//  ContactAndAlamo
//
//  Created by Luis Fernandez on 5/25/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit
import Eureka   // CocoaPod

class RegistrationCodeViewController: FormViewController {
    
    // Form
    var regitrationFormOptionsBackup : RowNavigationOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Registration Verification"
        
        self.loadForm()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func verifyButtonAction() {
        
        // Getting Verification Code from form
        let formValues = form.values()
        
        print("Should send Verification Code to back-end to verify")
        
        if let verfCode = formValues["verfCode"] as? String {
            // FIXME: Send verfCode to backend
            // check if it is legit.
            // When confirmation is recieved, the confirmation should have the New User's First and Last Name, and their phone number
            print(verfCode) // debug
            
            if verfCode == "1234" {
                self.performSegueWithIdentifier("SegueToFinishRegistrationVC", sender: self)
            }
        }
    }
    
    func getCodeButtonAction() {
        
        self.performSegueWithIdentifier("SegueToRegistrationFormVC", sender: self)
    }
    
    @IBAction func unwindToRegCodeVC(segue: UIStoryboardSegue) {}
    
    
    func loadForm() {
        
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        regitrationFormOptionsBackup = navigationOptions
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        
        form
        
        +++ Section() {
            var header = HeaderFooterView<UILabel>(.Class)
            header.onSetupView = { (view: UILabel, section: Section, form: FormViewController) -> () in
                view.frame = CGRectMake(0, 0, 0, 120)
                view.numberOfLines = 5
                view.textAlignment = .Center
                view.text = "Here at RentABuddy we value security very highly. For this reason, we require every New User to be verify by an exisiting User in order to create an account."
            }
            
            $0.header = header
        }
        
        <<< NameRow("verfCode") { $0.title = "Verification Code:"; $0.placeholder = "Code"}
        
        <<< ButtonRow() { (row: ButtonRow) -> Void in
            row.title = "Verify"
            }  .onCellSelection({ (cell, row) in
                self.verifyButtonAction()
            })

        +++ Section() {
            var header = HeaderFooterView<UILabel>(.Class)
            header.onSetupView = { (view: UILabel, section: Section, form: FormViewController) -> () in
                view.frame = CGRectMake(0, 0, 0, 72)
                view.numberOfLines = 5
                view.textAlignment = .Center
                view.text = "Don't have a Verification Code? That's fine, getting your Buddy to verify you is as simple as sending a text message!"
            }
            
            $0.header = header
        }
            
        +++ Section() {
            var header = HeaderFooterView<UIButton>(.Class)
            header.onSetupView = { (view: UIButton, section: Section, form: FormViewController) -> () in
                view.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), forState: .Normal)
                view.setTitle("Get Verification Code", forState: UIControlState.Normal)
                view.addTarget(self, action: (#selector(self.getCodeButtonAction)), forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            $0.header = header
        }
        
    }
    
    
}

