//
//  NotificationsViewController.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 7/2/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationItem.title = "Notifications"
    }
    

}
