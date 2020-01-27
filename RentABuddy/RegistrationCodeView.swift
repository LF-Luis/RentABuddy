//
//  RegistrationCodeView.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 6/5/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit

class RegistrationCodeView: UIScrollView {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    var mainTitle: UILabel = UILabel()
    var explanationLabel: UILabel = UILabel()
    var shortVerificationLabel: UILabel = UILabel()
    var noCodeLabel: UILabel = UILabel()
    
    var codeField: UITextField = UITextField()
    
    var verifyButton: UIButton = UIButton()
    var getCodeButton: UIButton = UIButton()
    
    func loadRegistrationCodeView (frame : CGRect) {
        
        let labelWidth : CGFloat = frame.size.width - 60    // 20 is the desired right plus left padding of view
        let frameMidX : CGFloat = frame.midX
        
        // Set-up mainTitle:
        mainTitle.frame = CGRectMake(0, 25, frame.size.width, 27.0)
        mainTitle.center.x = frameMidX
        mainTitle.text = "Registration Verification"
        mainTitle.textAlignment = .Justified
        mainTitle.font = UIFont.boldSystemFontOfSize(24)
        
        // Set-up explanationLabel:
        explanationLabel.frame = CGRectMake(0, 70, labelWidth, 120.0)
        explanationLabel.center.x = frameMidX
        explanationLabel.numberOfLines = 5
        explanationLabel.text = "Here at RentABuddy we value security very highly. For this reason, we require every New User to be verify by an exisiting User in order to create an account."
        explanationLabel.textAlignment = .Center
        
        // Set-up shortVerificationLabel:
        shortVerificationLabel.frame = CGRectMake(0, 190, labelWidth, 24.0)
        shortVerificationLabel.center.x = frameMidX
        shortVerificationLabel.text = "Enter Verification Code Below"
        shortVerificationLabel.textAlignment = .Center
        
        // Set-up codeField textfield:
        codeField.frame = CGRectMake(frame.size.width/4, 225, frame.size.width/2, 24.0) // This also centers this field view
        codeField.backgroundColor = UIColor.whiteColor()
        codeField.textAlignment = .Center
        codeField.borderStyle = UITextBorderStyle.RoundedRect
        codeField.keyboardType = UIKeyboardType.Default
        codeField.returnKeyType = UIReturnKeyType.Done
        codeField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        codeField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        codeField.placeholder = "Verification Code"
        
        // Sign Up Button
        verifyButton  = UIButton(type: UIButtonType.System) as UIButton
        verifyButton.frame = CGRectMake(0, 260, 70, 24)
        verifyButton.center.x = frameMidX
        verifyButton.setTitle("Verify", forState: UIControlState.Normal)
        //        verifyButton.addTarget(self, action: #selector(verifyButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set-up noCodeLabel:
        noCodeLabel.frame = CGRectMake(0, 320, labelWidth, 120.0)
        noCodeLabel.center.x = frameMidX
        noCodeLabel.numberOfLines = 5
        noCodeLabel.text = "Don't have a Verification Code? That's fine, getting your Buddy to verify you is simple as sending a text message!"
        noCodeLabel.textAlignment = .Center
        
        // Set-up Get Verification Code Button
        getCodeButton = UIButton(type: UIButtonType.System) as UIButton
        getCodeButton.frame = CGRectMake(0, 427, 150, 24)
        getCodeButton.center.x = frameMidX
        getCodeButton.setTitle("Get Verification Code", forState: UIControlState.Normal)
        
        // Adding Subviews:
        addSubview(mainTitle)
        addSubview(explanationLabel)
        addSubview(shortVerificationLabel)
        addSubview(codeField)
        addSubview(verifyButton)
        addSubview(noCodeLabel)
        addSubview(getCodeButton)
    }
    
}
