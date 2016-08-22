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
        FirebaseController.sharedController.fetchClosedMessage { (message, success) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    ProgressHUD.showError("Network connection failed")
                    self.closedMessage.text = "No network connection available. Please connect to a network."
                } else {
                    self.closedMessage.text = message
                }

            })
        }
    }
}
