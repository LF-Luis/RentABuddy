//
//  APIConnection.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 12/30/15.
//  Copyright © 2015 Luis Fernandez. All rights reserved.
//

import UIKit

class APIConnection: NSObject {
    
    // Get data for table cells
    // Returns a dictionary of format [category.title:CategoryObject], and an array containing only category.title(s)
    class func getTableData(isService:Bool, serviceId:Int) -> (cellDataDict:NSDictionary, cellDataTitles: [String]){
        
        var resultDictionary: [String:AnyObject] = NSDictionary() as! [String : AnyObject]  // Dictionary storing categories in the CategoryCellModel with Key being its correspnding Id
        var resultArray = [String]()  // Store the titles only
        
        // Bulding url as string first
        var urlStr:String = "https://<api_url>/api/GetCategory"
        
        // Check if we're querying for services or categories
        if isService == true {
            urlStr = urlStr + "/" + String(serviceId)
        }
        
        let url = NSURL(string: urlStr)
        let urlData = NSData(contentsOfURL: url!)
        
        do{
            if let categoriesDict:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                
                /*
                // get dictionary
                if let itemsDictArr = categoriesDict.objectForKey("categories") as? [Dictionary<String, AnyObject>]{
                    for item in itemsDictArr{
                        if isService == false{      // is category
                            let tempItem = CategoryCellModel(cellData: item)
                            resultDictionary[tempItem.title] = tempItem
                            resultArray.append(tempItem.title)
                        }
                        else{
                            let tempItem = ServiceCellModel(cellData: item)
                            resultDictionary[tempItem.title] = tempItem
                            resultArray.append(tempItem.title)
                        }

                        
                    }
                }
                */
            }
        
        } catch{ print("error at APIConnection.getTableData _LF")}
        
        return (resultDictionary, resultArray)

    }

}
