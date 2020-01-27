//
//  AccountPhoneViewController.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 7/4/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit
import Eureka   // CocoaPod

class AccountPhoneViewController: FormViewController {
    
    let currentUser = MainUser()
    
    // Form
    var regitrationFormOptionsBackup : RowNavigationOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        getAndSetUserData()
        
        self.loadForm()
        
        navigationItem.title = "Change Phone"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAndSetUserData() {
        // TODO: Load via API call
        
        // Fake User data
        currentUser.mobilePhone = "1234567890"
        
        // Set data to form:
        form.setValues(["IntRowTag": 8, "TextRowTag": "Hello world!"])
        
        tableView?.reloadData()
        
    }
    
    func changePhoneNum() {
        
        // Getting values from filled form
        let formValues = form.values()
        
        if let newPhone = formValues["newPhone"] as? String {
            // TODO: Store new email in backend
            
            print("Should send new phone number ( \(newPhone) ) to backend")
            
        }
        
    }
    
    // MARK: Form
    
    func loadForm() {
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        regitrationFormOptionsBackup = navigationOptions
        
        form
            
            +++ Section()
            
            <<< LabelRow () {
                $0.title = "Current Phone"
                $0.value = self.currentUser.mobilePhone
            }
            
            <<< EmailRow("newPhone") {
                $0.title = "New Phone"
                $0.placeholder = "New Phone"
            }
            
            <<< ButtonRow() {
                (row: ButtonRow) -> Void in row.title = "Change Phone Number"
                }.onCellSelection({
                    (cell, row) in self.changePhoneNum()
                })
    }
    
}
