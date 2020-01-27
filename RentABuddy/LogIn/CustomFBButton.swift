//
//  CustomFBButton.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 6/7/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit

class CustomFBButton: FBSDKLoginButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton(frame: CGRect, title: String, font: UIFont, centeredInView: Bool) {

        // Setting frame
        self.frame = frame
        
        // Setting title
        self.setAttributedTitle(NSAttributedString(string: title), forState: UIControlState.Normal)
        
        // Setting font
        for views in self.subviews {
            if views is UILabel {
                let views: UILabel = views as! UILabel
                views.font = font
            }
        }
        
        // Centered in View
        if centeredInView {
            self.center.x = UIScreen.mainScreen().bounds.size.width / 2
        }
        
    }

}
