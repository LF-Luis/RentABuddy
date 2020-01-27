//
//  AccountEmailViewController.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 7/4/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit
import Eureka   // CocoaPod

class AccountEmailViewController: FormViewController {
    
    let currentUser = MainUser()
    
    // Form
    var regitrationFormOptionsBackup : RowNavigationOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        getAndSetUserData()
        
        self.loadForm()
        
        navigationItem.title = "Change Email"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAndSetUserData() {
        // TODO: Load via API call
        
        // Fake User data
        currentUser.email = "fakeEmail@email.com"
        
        // Set data to form:
        form.setValues(["IntRowTag": 8, "TextRowTag": "Hello world!"])
        
        tableView?.reloadData()
        
    }
    
    func changeEmail() {
        
        // Getting values from filled form
        let formValues = form.values()
        
        if let newEmail = formValues["newEmail"] as? String {
            // TODO: Store new email in backend
            
            print("Should send new email ( \(newEmail) ) to backend")

        }
        
    }
    
    // MARK: Form
    
    func loadForm() {
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        regitrationFormOptionsBackup = navigationOptions
        
        form
            
            +++ Section()
            
            <<< LabelRow () {
                $0.title = "Current Email"
                $0.value = self.currentUser.email
            }
        
            <<< EmailRow("newEmail") {
                $0.title = "New Email"
                $0.placeholder = "New Email"
            }
        
            <<< ButtonRow() {
                (row: ButtonRow) -> Void in row.title = "Change Email"
            }.onCellSelection({
                (cell, row) in self.changeEmail()
            })
    }
    
}
