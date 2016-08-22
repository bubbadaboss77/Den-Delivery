//
//  FaqViewController.swift
//  Den Delivery
//
//  Created by Tim Chamberlin on 4/8/16.
//  Copyright © 2016 Den Delivery. All rights reserved.
//

import UIKit
import Firebase

class FaqViewController: UITableViewController {
    
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var openLabel: UILabel!
    
    var openStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleOpenButton()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(toggleOpenButton), name: openStatusChangedNotificationKey, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - UI Functions
    
    func toggleOpenButton() {
        if openForDelivery {
            openSwitch.setOn(true, animated: true)
            openStatus = "Open for business"
            ProgressHUD.showSuccess(openStatus)
            openLabel.text = openStatus
        } else {
            openSwitch.setOn(false, animated: true)
            openStatus = "DD is closed"
            ProgressHUD.showSuccess(openStatus)
            openLabel.text = openStatus
        }
    }
    
    func presentPasswordAlert() {
        let alert = UIAlertController(title: "Enter password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Enter password..."
            textField.secureTextEntry = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in
            if self.openSwitch.on {
                self.openSwitch.setOn(false, animated: false)
                return
            } else {
                self.openSwitch.setOn(true, animated: true)
                return
            }
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .Default) { (_) in
            guard let enteredText = alert.textFields?[0].text else { return }
            FirebaseController.sharedController.fetchPassword({ (password, error) in
                if let _ = error {
                    ProgressHUD.showError("Network connection failed")
                } else {
                    guard let password = password else { return }
                    
                    if enteredText == password {
                        FirebaseController.sharedController.setOpenStatus(!openForDelivery, completion: { (error) in
                            if error != nil {
                                print("Error occurred while setting open status: \(error?.localizedDescription)")
                            } else {
                                ProgressHUD.showError("Network connection failed")
                            }
                        })
                    } else {
                        self.toggleOpenButton()
                        ProgressHUD.showError("Wrong password")
                    }

                }
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func switchChanged(sender: AnyObject) {
        presentPasswordAlert()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                // open den delivery facebook page
                let url = NSURL(string: "https://www.facebook.com/BobcatDenDelivery/?fref=ts")!
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "snapchat" {
            guard let vc = segue.destinationViewController as? WebViewController else { return }
            vc.url = NSURL(string: "http://www.snapchat.com/add/den_delivery")!
        } else if segue.identifier == "faqSegue" {
            guard let vc = segue.destinationViewController as? InfoTableViewController else { return }
            vc.parentDirectory = FirebaseController.sharedController.faqsKey
            vc.sender = "FAQs"
        } else if segue.identifier == "deliveryFeesSegue" {
            guard let vc = segue.destinationViewController as? InfoTableViewController else { return }
            vc.parentDirectory = FirebaseController.sharedController.deliveryFeesKey
            vc.sender = "Delivery Fees"
        }
    }
}





