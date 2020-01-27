//
//  APIConnectionRAB.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 6/19/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit
import Alamofire

class APIConnectionRAB {
    class func RABLogIn (userName:String, psswrd:String) -> Bool {
        
        print("Using RAB credentials to log in.")
        print("Should send to backend for aunthetication: \n User Name: \(userName), Password: \(psswrd)")
        
        // FIXME: Send login to backend
        
//        let url = NSURL(string: "")
//        
//        Alamofire.request(.GET, url!)
//            .authenticate(user: userName, password: psswrd)
//            .validate()
//            .responseJSON{ response in
//                print(response)
//                print(response.result.isFailure)
//            }
        
        // if succesful log in: return true
        // else false
        return true
        
    }
    
    
    /* Fake func to fill table cell data */
    
    class func getCellData() -> (dictByID : Dictionary<String, CategoryCellModel>, dictByTitle : Dictionary<String, [String]>, arrID : [String]) {
        /*
         <ID, cell data object> to keep each data object unique
         <title, [ID]> for searching     // note: "title" can be changed later to expand sarch criteria
         */
        
        let fakeRawData = [ // Array
            [
                "Title" : "Kitchen",
                "Available" : "50",
                "DefaultLargeImageUrl" : "http://hookedonhouses.net/wp-content/uploads/2009/01/Father-of-the-Bride-Lookalike-house.jpg",
                "Id" : "1",
                "Description" : "This is a fake cell"
            ],
            [
                "Title" : "Backyard",
                "Available" : "50",
                "DefaultLargeImageUrl" : "http://hookedonhouses.net/wp-content/uploads/2009/01/Father-of-the-Bride-Lookalike-house.jpg",
                "Id" : "2",
                "Description" : "This is a fake cell"
            ],
            [
                "Title" : "Kitchen",
                "Available" : "50",
                "DefaultLargeImageUrl" : "http://hookedonhouses.net/wp-content/uploads/2009/01/Father-of-the-Bride-Lookalike-house.jpg",
                "Id" : "3",
                "Description" : "This is a fake cell"
            ],
            [
                "Title" : "Kitchen",
                "Available" : "50",
                "DefaultLargeImageUrl" : "http://hookedonhouses.net/wp-content/uploads/2009/01/Father-of-the-Bride-Lookalike-house.jpg",
                "Id" : "4",
                "Description" : "This is a fake cell"
            ],
            [
                "Title" : "Kitchen",
                "Available" : "50",
                "DefaultLargeImageUrl" : "http://hookedonhouses.net/wp-content/uploads/2009/01/Father-of-the-Bride-Lookalike-house.jpg",
                "Id" : "5",
                "Description" : "This is a fake cell"
            ],
            [
                "Title" : "Kitchen",
                "Available" : "50",
                "DefaultLargeImageUrl" : "http://hookedonhouses.net/wp-content/uploads/2009/01/Father-of-the-Bride-Lookalike-house.jpg",
                "Id" : "6",
                "Description" : "This is a fake cell"
            ]
        ]
        
        var cellIDsDict_ByTitle = Dictionary<String, [String]>()   // <Titles, [ID]>
        
        var cellDataDict_ByID = Dictionary<String, CategoryCellModel>()
        
        var cellIDArray = [String]()
        
        for elements in fakeRawData {
            
            if let id = elements["Id"] as String? {
                
                if let title = elements["Title"] as String? {
                    
                    cellDataDict_ByID[id] = CategoryCellModel(cellData: elements)   // set: <ID, cell data object>
                    
                    cellIDArray.append(id)
                    
                    if cellIDsDict_ByTitle[title] != nil {  // set: <Titles, [ID]>
                        cellIDsDict_ByTitle[title]?.append(id)
                    }
                    else {
                        // if it does not exist
                        cellIDsDict_ByTitle[title] = [id]
                    }
                    
                }
                
            }
            
        }
        
        return (cellDataDict_ByID, cellIDsDict_ByTitle, cellIDArray)
    }

    
    // Asynchroneously return an UIImage using AlamoFire
    class func getUIImage(url: String?) -> UIImage?{
        
        var uiImg : UIImage?
        
        if let picUrl = url as String! {
            Alamofire.request(.GET, picUrl).response { (request, response, data, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                else {
                    uiImg = UIImage(data: data!)
                }
            }
        }
        
        return uiImg
        
    }
    
    class func getDictFromJSON() {
        
//        Returns Array<String> of Building Acronym + Name, and Dictionary<String, String> of Building Acronym + Name and Building Id.
        
//        let urlStr : String = "https://<api_url>/api/roomview"
//        let urlStr : String = "https://<api_url>/api/RoomView"
        
        let urlStr : String = "https://<api_url>/api/BuildingApi"
        
        Alamofire.request(.GET, urlStr, parameters: nil, encoding: .JSON).responseJSON{
            response in switch response.result {
            case .Success(let JSON):
                
                print("Success, JSON was received:")
                print(JSON)
                
//                var displayName = [String]()
//                var displayName_toId = Dictionary<String, String>()
//                
//                var tempAcronym = ""
//                var tempName = ""
//                var tempId = ""
//                
//                let response = JSON as! NSDictionary
//                let buildings = response.objectForKey("myBuildings")! as! NSArray
//                for building in buildings {
//                    
//                    tempAcronym = ""
//                    tempName = ""
//                    tempId = ""
//                    
//                    if let acronym = building["acronymName"] as? String{
//                        tempAcronym = acronym
//                    }
//                    
//                    if let name = building["buildingName"] as? String{
//                        tempName = name
//                    }
//                    
//                    if let id = building["id"] as? String{
//                        tempId = id
//                    }
//                    
//                    if (tempAcronym != "" || tempName != "") && tempId != "" {
//                        displayName.append(tempAcronym + tempName)
//                        displayName_toId[tempAcronym + tempName] = tempId
//                    }
//                }
//                
//                /////////
//                print(displayName)
//                for item in displayName_toId {
//                    print(item)
//                }

            case .Failure(let error):
                print(error.localizedDescription)
                // completion with nil values
            }
        }
        
        //should return Dictionary
    }
}

