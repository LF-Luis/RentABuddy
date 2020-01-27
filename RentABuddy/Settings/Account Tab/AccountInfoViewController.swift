//
//  AccountInfoViewController.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 7/2/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit
import Eureka   // CocoaPod

class AccountInfoViewController: FormViewController {
    
    let currentUser = MainUser()
    
    let cellContentWidth = 0.909 * currentScreenWidth
    
    // Form
    var regitrationFormOptionsBackup : RowNavigationOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        getAndSetUserData()
        
        self.loadForm()

        navigationItem.title = "Account" //currentUser.getUserName()
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAndSetUserData() {
        // TODO: Load via API call
        
        // Fake User data
        currentUser.firstName = "Luis" as String!
        currentUser.lastName = "Fernandez"
        currentUser.email = "fakeEmail@email.com"
        currentUser.mobilePhone = "1234567890"
        currentUser.address = Address(street: "123 Main St.", state: "Texas", zipCode: "75130", city: "Dallas", country: "U.S.")
        currentUser.accountCreationDate = NSDate()
        currentUser.squareProfilePicURL = String("https://scontent.xx.fbcdn.net/v/t1.0-1/s100x100/10354686_10150004552801856_220367501106153455_n.jpg?oh=c31c6e4ec53c9288515ac374d749ff46&oe=5801E573")
        currentUser.squareProfilePic = APIConnectionRAB.getUIImage(currentUser.squareProfilePicURL)
        
        // Set data to form:
        form.setValues(["IntRowTag": 8, "TextRowTag": "Hello world!"])
        
        tableView?.reloadData()
        
    }
    
    // MARK: Form
    
    func loadForm() {
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        regitrationFormOptionsBackup = navigationOptions
        
        form
            
            +++ Section() {
                var header = HeaderFooterView<ProfilePicView>(.Class)
                header.onSetupView = { (view: ProfilePicView, section: Section, form: FormViewController) -> () in
                    
                    view.profilePic.image = UIImage(named: "tempimg.jpg")
                    let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
                    view.profilePic.addGestureRecognizer(tapGesture)
                    view.profilePic.userInteractionEnabled = true
                }
                
                $0.header = header
            }
            
            +++ Section() {
                var header = HeaderFooterView<SettingsUserName>(.Class)
                header.onSetupView = { (view: SettingsUserName, section: Section, form: FormViewController) -> () in
                    
                    view.orText.text = "Luis F."
                }
                
                $0.header = header
            }
            
            +++ Section()
            
            <<< LabelRow () {
                $0.title = "Name"
                $0.value = "\(self.currentUser.firstName as String!) \(self.currentUser.lastName as String!)"
            }
            
            <<< ButtonRow("Email") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.Show(controllerProvider: ControllerProvider.Callback { AccountEmailViewController()}, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) } )
                }.cellSetup {
                    cell, row in
                    
                    let text = UILabel(frame: cell.frame)
                    text.frame.size.width = self.cellContentWidth - 68
                    text.frame.origin.x = 68
                    text.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
                    text.textAlignment = .Right
                    text.text = self.currentUser.email
                    cell.addSubview(text)
                    
            }
            
            <<< ButtonRow("Phone Number") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.Show(controllerProvider: ControllerProvider.Callback { AccountPhoneViewController()}, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) } )
                }.cellSetup {
                    cell, row in
                    
                    let text = UILabel(frame: cell.frame)
                    text.text = self.currentUser.mobilePhone
                    text.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
                    text.frame.size.width = self.cellContentWidth - 140
                    text.frame.origin.x = 140
                    text.textAlignment = .Right
                    cell.addSubview(text)
                    
            }
            
            <<< ButtonRow("Home Address") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.Show(controllerProvider: ControllerProvider.Callback { AccountAddressViewController()}, completionCallback: { vc in vc.navigationController?.popViewControllerAnimated(true) } )
                }.cellSetup {
                    cell, row in
                    
                    let text = UILabel(frame: cell.frame)
                    text.text = self.currentUser.getUSAddress()
                    text.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
                    text.frame.size.width = self.cellContentWidth - 140
                    text.frame.origin.x = 140
                    text.textAlignment = .Right
                    cell.addSubview(text)
                    
            }
        
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        
        if let imageView = gesture.view as? UIImageView {
            print("Image Tapped \(imageView)")
        
        }
    }
    
}

class ProfilePicView : UIView {
    
    let profilePic = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profilePic.translatesAutoresizingMaskIntoConstraints = false
    
        profilePic.frame = CGRect(x: 0, y: 0, width: 130, height: 130)
        
        profilePic.layer.cornerRadius =  profilePic.frame.size.width / 2  // Circular pic   10.0
        
        profilePic.clipsToBounds = true
        profilePic.contentMode = .ScaleAspectFit
        
        // Add Frame to pic
        profilePic.layer.borderWidth = 3.0
        profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        
//        profilePic.autoresizingMask = .FlexibleWidth

        self.frame = CGRect(x: 0, y: 0, width: 130, height: 130)
        
        self.addSubview(profilePic)
        
        let views = [
            "img" : self.profilePic
        ]
        
        let ctImgHorzConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[img]|", options: [], metrics: nil, views: views)

        let ctImgVerConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[img]|", options: [], metrics: nil, views: views)
        
        self.addConstraints(ctImgHorzConstraint)
        self.addConstraints(ctImgVerConstraint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SettingsUserName: UIView {
    
    var orText = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        orText = UILabel(frame: CGRectMake(0, 0, 320, 12))
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
