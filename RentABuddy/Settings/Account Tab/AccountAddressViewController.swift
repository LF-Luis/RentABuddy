//
//  AccountAddressViewController.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 7/4/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit
import Eureka   // CocoaPod

class AccountAddressViewController: FormViewController {
    
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
        currentUser.address = Address(street: "123 Main St.", state: "Texas", zipCode: "75130", city: "Dallas", country: "U.S.")
        
        // Set data to form:
//        form.setValues(["IntRowTag": 8, "TextRowTag": "Hello world!"])
        
        tableView?.reloadData()
        
    }
    
    func changeAddress() {
        
        // Getting values from filled form
        let formValues = form.values()
        
        /* Should be Set Values from Verification Code */
        if let this = formValues["address"] {
            print(this)
        }
        
//        
//        if let newAddress = formValues["newPhone"] as? String {
//            // TODO: Store new email in backend
//            
//            print("Should send new phone number ( \(newAddress) ) to backend")
//            
//            getAndSetUserData()
//            
//            tableView?.reloadData()
//        }
        
    }
    
    // MARK: Form
    
    func loadForm() {
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        regitrationFormOptionsBackup = navigationOptions
        
        form
        
            +++ Section("Address")

            <<< PostalAddressRow("address"){
                $0.title = "Home"
                $0.streetPlaceholder = "Street"
                $0.statePlaceholder = "State"
                $0.postalCodePlaceholder = "ZipCode"
                $0.cityPlaceholder = "City"
                $0.countryPlaceholder = "Country"

                $0.value = PostalAddress(
                    street: self.currentUser.address!.street,
                    state: self.currentUser.address!.state,
                    postalCode: self.currentUser.address!.zipCode,
                    city: self.currentUser.address!.city,
                    country: self.currentUser.address!.country
                )
            }
            
            <<< ButtonRow() {
                (row: ButtonRow) -> Void in row.title = "Change Home Address"
                }.onCellSelection({
                    (cell, row) in self.changeAddress()
                })
    }
    
}

