//
//  SettingsViewController.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 7/1/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit
import Eureka   // CocoaPod

class SettingsViewController: FormViewController {
    
    // Navigation bar item
    let barTopDoneItem = UIBarButtonItem()
    
    // Form
    var regitrationFormOptionsBackup : RowNavigationOptions?
    var userName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar set-up
        navigationItem.rightBarButtonItem = barTopDoneItem
        self.barTopDoneItem.target = self
        self.barTopDoneItem.action = #selector(self.barTopDoneAction)
        self.barTopDoneItem.title = "Done"
    }
    
    override func viewDidAppear(animated: Bool) {
        
        navigationItem.title = "Settings"
        
        if MainUser.isLoggedIn() {
            loadUserName()
            loadForm()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadUserName() {
        // TODO: APIConnection getUserName
        
        // fake data:
        userName = "Luis Fernandez"
    }
    
    func barTopDoneAction() {
        self.performSegueWithIdentifier("unwindToHomeVC", sender: self)
    }
    
    func logOut() {
        //        let this = AccountInfoViewController() as! UIViewController
        //        self.navigationController?.pushViewController(AccountInfoViewController(), animated: true)
        // TODO: Log Out
        print("Should Log Out")
    }

    // MARK: Form
    
    func loadForm() {
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        regitrationFormOptionsBackup = navigationOptions
        
        form =
            
            Section("\(userName as String!)")
            
            <<< ButtonRow("Account") {
                $0.title = $0.tag
                
//                $0.presentationMode = PresentationMode.Show(controllerProvider: ControllerProvider.Callback { AccountInfoViewController()}, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) } )
                $0.presentationMode = PresentationMode.Show(controllerProvider: ControllerProvider.Callback { AccountInfoViewController()}, completionCallback: { vc in vc.navigationController?.showDetailViewController(vc, sender: nil) } )
                }
            
            <<< ButtonRow("Payment") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.Show(controllerProvider: ControllerProvider.Callback { PaymentInfoViewController()}, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) } )
            }
            
            <<< ButtonRow("History") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.Show(controllerProvider: ControllerProvider.Callback { HistoryViewController()}, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) } )
            }
            
            <<< ButtonRow("Notifications") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.Show(controllerProvider: ControllerProvider.Callback { NotificationsViewController()}, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) } )
            }
            
            <<< ButtonRow("Help") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.Show(controllerProvider: ControllerProvider.Callback { HelpViewController()}, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) } )
            }
            
            +++ Section()
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Log Out"
                }
                .cellUpdate { cell, row in
                    cell.textLabel!.textColor = UIColor.redColor()
                }
                .onCellSelection({ (cell, row) in
                    self.logOut()
                })
        
    }
    
}
