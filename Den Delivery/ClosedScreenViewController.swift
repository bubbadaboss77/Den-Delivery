//
//  ClosedScreenViewController.swift
//  BDD
//
//  Created by Tim on 8/6/16.
//  Copyright © 2016 Bobcat Den Delivery. All rights reserved.
//

import UIKit

class ClosedScreenViewController: UIViewController {

    @IBOutlet weak var closedMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Observe closed message
        FirebaseController.sharedController.fetchClosedMessage { (message) in
            dispatch_async(dispatch_get_main_queue(), {
                self.closedMessage.text = message
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if !Reachability.isConnectedToNetwork() {
            self.closedMessage.text = "Error: No network connection"
            ProgressHUD.showError("No network connection")
            return
        }
    }
}
