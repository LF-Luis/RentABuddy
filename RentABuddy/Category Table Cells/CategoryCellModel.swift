//
//  CategoryCellModel.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 12/30/15.
//  Copyright © 2015 Luis Fernandez. All rights reserved.
//

import UIKit

// Model for Category cell object (Data to construct cell)

class CategoryCellModel: NSObject {
    
    var categoryTitle : String?
    var categoryNumAvailable : String?
    var categoryImageURL : String?
    var categoryImage : UIImage?
    var id : Int?
    var desc : String?
    
    init(cellData: NSDictionary) {
        super.init()
        
        if let title = cellData["Title"] as? String{
            self.categoryTitle = title
        }
        
        if let numAvailable = cellData["Available"] as? String{
            self.categoryNumAvailable = numAvailable
        }
        
        if let picURL = cellData["DefaultLargeImageUrl"] as? String{
            self.categoryImageURL = picURL
            // Set actual image to current CategoryCellModel object
        }
        
        if let id = cellData["Id"] as? Int{
            self.id = id
        }
        
        if let desc = cellData["Description"] as? String{
            self.desc = desc
        }
        
    }
    
}

/***** Sample API Response to https://<api_url>/api/GetCategory ******/
//"Id": 1,
//"ParentID": 0,
//"Title": "Automobile Help",
//"Description": "For helping with one's automobile such as changing oil",
//"DefaultLargeImageUrl": "http://www.wemoit.com/bgfull/auto-help-tire-606100_1920.jpg",
//"DefaultSmallImageUrl": "http://www.wemoit.com/thumbs/auto-help-tire-606100_1920.jpg"
