//
//  HomeViewController.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 12/29/15.
//  Copyright © 2015 Luis Fernandez. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

let cellCache = NSCache()

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var tableView : UITableView!
    
    var cellDataDict_ByID = Dictionary<String, CategoryCellModel>()
    var cellIdsDict_ByTitle = Dictionary<String, [String]>()
    var cellIdArr = [String]()

    // Store Img cache
    var imageCache = [String:UIImage]()

    // Navigation bar item
    let barTopRightItem = UIBarButtonItem()
    
    // Access AppDelegate
    let appDelegate = AppDelegate.getAppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /********* Test Button ***********/
        let testLogOutFB = UIBarButtonItem()
        navigationItem.leftBarButtonItem = testLogOutFB
        testLogOutFB.target = self
        testLogOutFB.title = "TEST_LOGOUT_FB"
        testLogOutFB.action = #selector(test_LogOutFB)
        /**************************/
        
        // Navigation bar set-up
        navigationItem.rightBarButtonItem = barTopRightItem
        self.barTopRightItem.target = self
        self.barTopRightItem.action = #selector(self.barRightItemAction)
        self.setBarRightItemTitle()
        
        // Set-up tableView:
        self.tableView = UITableView(frame:self.view.frame)
        // Insets to show transperrancy of navigation controller without hidding tableview
        let topTVInset = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.height
        let bottomTVInset = self.tabBarController?.tabBar.frame.size.height
        let inset = UIEdgeInsets(top: topTVInset, left: 0, bottom: bottomTVInset!, right: 0)
        self.tableView.contentInset = inset
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView!.dataSource = self
        self.tableView!.registerClass(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView!.rowHeight = 200.0
        
        // Getting cel data
        cellDataDict_ByID = APIConnectionRAB.getCellData().dictByID   // Dictionary<ID, let cellDataDict_ByID>
        cellIdsDict_ByTitle = APIConnectionRAB.getCellData().dictByTitle   // <Titles, [ID]>
        cellIdArr = APIConnectionRAB.getCellData().arrID   // [ID] by index of apperance in GET: JSON file
        
        self.view.addSubview(self.tableView)
////        tableView.reloadData()
    }
    
    /********* Test ***********/
    func test_LogOutFB() {
        // Test FB logout and Real data: erase data
//        UserHelperTools.logOut()     // Also sets currentUser.isLoggedInUser = false
//        self.setBarRightItemTitle()     // Change button to "Log In"
        
        // test segue into Settings of app
//        self.performSegueWithIdentifier("segueToSettingsVC", sender: self)
        
        // test gettin JSON using Alamofire:
        APIConnectionRAB.getDictFromJSON()
    }
    /**************************/
    
    override func viewDidAppear(animated: Bool) {
        self.setBarRightItemTitle()
        UserHelperTools.test_printRealmDirectory()
        UserHelperTools.test_printCurrentUserValues()
        self.getFBProfilePic()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    func setBarRightItemTitle() {
        if UserHelperTools.isLoggedInUser() {
            barTopRightItem.title = "Log Out"
        }
        else {
            barTopRightItem.title = "Log In"
        }
    }
    
    func barRightItemAction() {
        if UserHelperTools.isLoggedInUser() {
            // Is Logged In User, so log-out:
            UserHelperTools.logOut()     // Also sets currentUser.isLoggedInUser = false
            self.setBarRightItemTitle()     // Change button to "Log In"
        }
        else {
            // Current User is not a Registered. Allow Seque to Log In view
            self.performSegueWithIdentifier("SegueToLogInVC", sender: self)
        }
    }
    
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {}
    
    func getFBProfilePic() {
        // Asking permission to use FB profile pic for RAB profile pic.
        // This is done only after registration.
        if firstTimeUserLogsInWithFB {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let alertController = UIAlertController(title: "RentABuddy", message: "Allow RentABuddy to use your Facebook profile picture", preferredStyle: UIAlertControllerStyle.Alert)
                
                let allowAction = UIAlertAction(title: "Allow", style: .Default) { action in
                    firstTimeUserLogsInWithFB = false
                    UserHelperTools.setUserProfilePicURL()
                }
                
                let dismissAction = UIAlertAction(title: "No", style: .Default) { (action) -> Void in }
                
                alertController.addAction(allowAction)
                alertController.addAction(dismissAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                firstTimeUserLogsInWithFB = false
            })
        }
        firstTimeUserLogsInWithFB = false
    }
    
    // ENDMARK:
    
    // MARK: Table View Functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier( "cell") as! CategoryTableViewCell
        
        if let cachedVersion = cellCache.objectForKey(cellIdArr[indexPath.row]) as? CategoryCellModel {
            // use the cached version
            cell.loadCellData(cachedVersion) // Loading to view
            print("Loading but not caching")
        }
        else {
            let cellObj = cellDataDict_ByID[cellIdArr[indexPath.row]]!
            
//            cell.loadCellData(cellObj) // Loading to view basic info (not the image yet)
            
            // Storing UIImage into cell data object
//            if let url = NSURL(string: (cellObj.categoryImageURL)!) {
//                if let data = NSData(contentsOfURL: url) {
//                    dispatch_async(dispatch_get_main_queue()) {
//                        cellObj.categoryImage = UIImage(data: data)
//                    }
//                    print("----First time loading UIImage")
//                }
//            }
            Alamofire.request(.GET, cellObj.categoryImageURL!).response { (request, response, data, error) in
                cellObj.categoryImage = UIImage(data: data!, scale:1)
                
                // Finish putting in cache the current cell data object
                cellCache.setObject(cellObj, forKey: self.cellIdArr[indexPath.row])
                cell.loadCellData(cellObj) // Loading with Image
            }
            
            print("First time caching this object")
        }
        
        return cell
    }

}


