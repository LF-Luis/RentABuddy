//
//  ServiceCellModel.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 12/30/15.
//  Copyright © 2015 Luis Fernandez. All rights reserved.
//

import UIKit

// Model for Service cell object (Data to construct cell)

class ServiceCellModel: NSObject {
    
    var id:Int!
    var title:String!
    var desc:String!
    var picURL:String!
    
    init(cellData: NSDictionary) {
        super.init()
        if let title = cellData["Title"] as? String{
            self.title = title
        }   // safety build

        if let picURL = cellData["DefaultLargeImageUrl"] as? String{
            self.picURL = picURL
        }
        
        if let id = cellData["Id"] as? Int{
            self.id = id
        }
        
        if let desc = cellData["Description"] as? String{
            self.desc = desc
        }
        
//        print(title)
//        print(picURL)
//        print(id)
//        print(desc)
    }
}


/***** Sample API Response to https://<api_url>/api/GetCategory/1 ******/
//    "Id": 8,
//    "ParentID": 1,
//    "Title": "Oil change",
//    "Description": "Change my car oil",
//    "DefaultLargeImageUrl": "http://www.wemoit.com/bgfull/car-repair-362150.jpg",
//    "DefaultSmallImageUrl": "http://www.wemoit.com/thumbs/car-repair-362150.jpg"
