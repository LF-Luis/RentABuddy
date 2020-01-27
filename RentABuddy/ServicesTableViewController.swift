//
//  ServicesTableViewController.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 1/6/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit

class ServicesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var servicesDict = NSDictionary()
    var servicesTitles = [String]()
    
    var indexOfCellTouched:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set-up tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRectMake(0, 0, currentScreenWidth, self.view.frame.size.height)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = categoryCellHeight
    
        // Add tableview
        self.view.addSubview(tableView)
        

//        print(indexOfCellTouched, " num")
        indexOfCellTouched = indexOfCellTouched + 1

        // Get services
        servicesDict = APIConnection.getTableData(true, serviceId: indexOfCellTouched).cellDataDict
        servicesTitles = APIConnection.getTableData(true, serviceId: indexOfCellTouched).cellDataTitles
//        print(servicesDict)
//        print(servicesTitles)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Cell Functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Creating table view cell
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        // Loading custom category cell
        let currentCell = NSBundle.mainBundle().loadNibNamed("ServiceCell", owner: self, options: nil).last as! ServiceCell
        
        currentCell.frame = CGRectMake(0, 0, currentScreenWidth, categoryCellHeight)
        
        currentCell.addDataToServiceCellView((servicesDict[servicesTitles[indexPath.row]] as? ServiceCellModel)!)
        
        currentCell.updateConstraints()
        
        //        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        cell.addSubview(currentCell)
        //        })
        
        return cell
        
    }

}

