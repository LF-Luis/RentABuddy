//
//  CustomSearchBar.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 1/15/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    var adoptedFont: UIFont!
    
    var adoptedTextColor: UIColor!
    
    // Access and modify search field. Draw a custom line at the bottom of search bar.
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRectMake(5.0, 5.0, frame.size.width - 10.0, frame.size.height - 10.0)
            
            // Set the font and text color of the search field.
            searchField.font = adoptedFont
            searchField.textColor = adoptedTextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
        }
        
        // Draw line under search bar
        let startPoint = CGPointMake(0.0, frame.size.height)
        let endPoint = CGPointMake(frame.size.width, frame.size.height)
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = adoptedTextColor.CGColor
        shapeLayer.lineWidth = 2.5
        
        layer.addSublayer(shapeLayer)
        
        super.drawRect(rect)
    }
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        self.frame = frame
        
        adoptedFont = font
        adoptedTextColor = textColor
        
        // change the default search bar style
        searchBarStyle = UISearchBarStyle.Prominent // search bar with a translucent background and opaque search field
        translucent = false // to remmove translucency
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    // Get the index of the search field (the text field of the search bar) inside of UISearchBar
    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0]
        
        for var i=0; i<searchBarView.subviews.count; ++i {
            if searchBarView.subviews[i].isKindOfClass(UITextField) {
                index = i
                break
            }
        }
        
        return index
    }
    


}
