//
//  ServiceCell.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 12/30/15.
//  Copyright © 2015 Luis Fernandez. All rights reserved.
//

import UIKit
//import Concorde
// Ease image processing dowload

class ServiceCell: UIView {
    var ServiceTitle:UILabel = UILabel()
    var ServiceDesc:UILabel = UILabel()
    
    var tempImg:UIImageView = UIImageView()
    
    func addDataToServiceCellView(currentService:ServiceCellModel){
        
//        print(currentService.picURL)
//        print("CURRENT SERVICE:", currentService.title)
//        print(currentService.desc)
        
        // Set-up image view (using Concorde library)
        let imgFrame = CGRectMake(0, 0, currentScreenWidth, categoryCellHeight)
//        let imageView = CCBufferedImageView(frame: imgFrame)
//        if let imgUrl = NSURL(string: currentService.picURL){
////        if let imgUrl = NSURL(string: "http://wp.stolaf.edu/map/files/2013/11/HolstadHouse.jpg"){
////            print("IMAGE:", imgUrl)
//            imageView.load(imgUrl)
//        }
        
        tempImg.frame = imgFrame
        tempImg.image = UIImage(named: "tempImg.jpg")
        
        // Set-up ServiceTitle
        ServiceTitle.frame = CGRectMake(10, 10, currentScreenWidth, 24)
        ServiceTitle.backgroundColor = UIColor.blueColor()
        ServiceTitle.textColor = UIColor.whiteColor()
        ServiceTitle.textAlignment = NSTextAlignment.Left
        ServiceTitle.font = UIFont.boldSystemFontOfSize(24)
        ServiceTitle.text = currentService.title
        
        // Set-up ServiceDesc
//        ServiceDesc.frame = CGRectMake(0, 0, currentScreenWidth, currentScreenHeight)
//        ServiceDesc.textColor = UIColor.whiteColor()
//        ServiceDesc.textAlignment = NSTextAlignment.Center
//        ServiceDesc.font = UIFont.systemFontOfSize(20)
//        ServiceDesc.text = currentService.desc
        
        // Display image
//        addSubview(imageView)
        // Display temp image
        addSubview(tempImg)
        
        // Display CategoryTitle
        addSubview(ServiceTitle)
        
        // Display ServiceDesc
//        addSubview(ServiceDesc)
        
    }

}
