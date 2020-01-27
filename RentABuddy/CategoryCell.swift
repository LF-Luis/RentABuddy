//
//  CategoryCell.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 12/29/15.
//  Copyright © 2015 Luis Fernandez. All rights reserved.
//

import UIKit
//import Concorde
// Ease image processing download

class CategoryCell: UIView {

    var CategoryTitle:UILabel = UILabel()
    var CategoryNumAvailable:UILabel = UILabel()
    
    var tempImg:UIImageView = UIImageView()
    
    func addDataToCategoryCellView(currentCategory:CategoryCellModel){

        // Set-up image view (using Concorde library)
        let imgFrame = CGRectMake(0, 0, currentScreenWidth, categoryCellHeight)
//        let imageView = CCBufferedImageView(frame: imgFrame)
//        if let imgUrl = NSURL(string: currentCategory.picURL){
//            imageView.load(imgUrl)
//        }
        
        tempImg.frame = imgFrame
        tempImg.image = UIImage(named: "tempImg.jpg")
        
//        BackgroungImg.contentMode = .ScaleAspectFill /*not using: Causes the cell size to grow*/
        
        // Set-up CategoryTitle
        CategoryTitle.frame = CGRectMake(0, 0, currentScreenWidth, categoryCellHeight)
//        CategoryTitle.textColor = UIColor.whiteColor()
        
        CategoryTitle.textColor = UIColor.blackColor()
        
        CategoryTitle.textAlignment = NSTextAlignment.Center
//        CategoryTitle.font = UIFont(name: (CategoryTitle.font?.fontName)!, size: 30)
        CategoryTitle.font = UIFont.boldSystemFontOfSize(24)
        CategoryTitle.text = currentCategory.title

        // Set-up CategoryNumAvailable
        CategoryNumAvailable.frame = CGRectMake(0, 95, currentScreenWidth, 30)
        CategoryNumAvailable.textColor = UIColor.whiteColor()
        CategoryNumAvailable.textAlignment = NSTextAlignment.Center
        CategoryNumAvailable.text = "num available"
        
        // Display temp image
//        addSubview(imageView)
        // Display temp image
        addSubview(tempImg)
        
        // Display CategoryTitle
        addSubview(CategoryTitle)
        
        // Display CategoryNumAvailable
        addSubview(CategoryNumAvailable)
        
    }

}