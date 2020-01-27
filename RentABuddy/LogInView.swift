//
//  LogInView.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 6/1/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit

class LogInView: UIScrollView {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    var MainTitle:UILabel = UILabel()
    var UserNameTitle:UILabel = UILabel()
    var PsswrdTitle:UILabel = UILabel()
    var SignUpTitle:UILabel = UILabel()
    
    var UserName:UITextField = UITextField()
    var Psswrd:UITextField = UITextField()
    
    func loadLogInView(){
        
        // Making Password text field secure
        Psswrd.secureTextEntry = true
        
        // Set-up MainTitle:
        MainTitle.frame = CGRectMake(0, 25, currentScreenWidth, 27.0)
        MainTitle.text = "Please Sign In"
        MainTitle.textAlignment = .Center
        //        MainTitle.textColor = UIColor.blackColor()
        MainTitle.font = UIFont.boldSystemFontOfSize(24)
        
        // Set-up UserNameTitle:
        UserNameTitle.frame = CGRectMake(0, 85, currentScreenWidth, 24.0)
        UserNameTitle.text = "Email or Phone Number"
        UserNameTitle.textAlignment = .Center
        
        // Set-up UserName textfield:
        UserName.frame = CGRectMake(currentScreenWidth/4, 115, currentScreenWidth/2, 24.0)
        UserName.backgroundColor = UIColor.whiteColor()
        UserName.textAlignment = .Center
        UserName.borderStyle = UITextBorderStyle.RoundedRect
        UserName.keyboardType = UIKeyboardType.Default
        UserName.returnKeyType = UIReturnKeyType.Done
        UserName.clearButtonMode = UITextFieldViewMode.WhileEditing;
        UserName.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        // Set-up PsswrdTitle:
        PsswrdTitle.frame = CGRectMake(0, 170, currentScreenWidth, 24.0)
        PsswrdTitle.text = "Password"
        PsswrdTitle.textAlignment = .Center
        
        // Set-up Psswrd textfield:
        Psswrd.frame = CGRectMake(currentScreenWidth/4, 200, currentScreenWidth/2, 24.0)
        Psswrd.backgroundColor = UIColor.whiteColor()
        Psswrd.textAlignment = .Center
        Psswrd.borderStyle = UITextBorderStyle.RoundedRect
        Psswrd.keyboardType = UIKeyboardType.Default
        Psswrd.returnKeyType = UIReturnKeyType.Done
        Psswrd.clearButtonMode = UITextFieldViewMode.WhileEditing;
        Psswrd.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        // Set-up SignUpTitleTitle:
        SignUpTitle.frame = CGRectMake(0, 340, currentScreenWidth, 48.0)
        SignUpTitle.numberOfLines = 2
        SignUpTitle.text = "New to RentABuddy? \n Try our quick Sign Up process:"
        SignUpTitle.textAlignment = .Center
        
        // Adding Subviews:
        addSubview(MainTitle)
        addSubview(UserNameTitle)
        addSubview(UserName)
        addSubview(PsswrdTitle)
        addSubview(Psswrd)
        addSubview(SignUpTitle)
    }
    
}