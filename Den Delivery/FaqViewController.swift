//
//  FaqViewController.swift
//  Den Delivery
//
//  Created by Tim Chamberlin on 4/8/16.
//  Copyright © 2016 Den Delivery. All rights reserved.
//

import UIKit

class FaqViewController: UITableViewController {
    
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var openLabel: UILabel!

    var password = ""
    var openStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let openRef = firebaseRef.child("open")
        openRef.observeEventType(FIRDataEventType.Value, withBlock: {(snapshot) in
            openForDelivery = snapshot.value as! Bool
        })
//        let openRef = firebaseRef.childByAppendingPath("open")
//        openRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            openForDelivery = snapshot.value as! Bool
//        })
        
        if openForDelivery {
            openLabel.text = "Open for business"
            self.openSwitch.on = true
        } else {
            openLabel.text = "DD is closed"
            self.openSwitch.on = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchChanged(sender: AnyObject) {
        
        
        let alert = UIAlertController(title: "Enter password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:handleDone))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    var tField: UITextField!
    
    func configurationTextField(textField: UITextField!) {
        textField.placeholder = "Enter password..."
        tField = textField
        tField.secureTextEntry = true
    }
    
    func handleDone(alertView: UIAlertAction!) {
        // Check password value
        let passRef = firebaseRef.child("password")
        passRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.password = snapshot.value as! String
            
            if self.tField.text! == self.password {
                let openRef = firebaseRef.child("open")
                openRef.setValue(self.openSwitch.on)
                openForDelivery = self.openSwitch.on
                
                ProgressHUD.showSuccess("Success!")
                
                
                if self.self.openSwitch.on {
                    self.openStatus = "Open for business"
                    ProgressHUD.showSuccess(self.openStatus)
                    self.openLabel.text = "Open for business"
                } else {
                    
                    let orderRef = firebaseRef.child("orders")
                    orderRef.removeValue()
                    
                    self.openStatus = "DD is closed"
                    ProgressHUD.showSuccess(self.openStatus)
                    self.openLabel.text = "DD is closed"
                }
                
                
            } else {
                ProgressHUD.showError("Wrong password")
                
                if self.openSwitch.on {
                    self.openSwitch.setOn(false, animated: false)
                } else {
                    self.openSwitch.setOn(true, animated: true)
                }
            }

        })
    }
    
    func handleCancel(alertView: UIAlertAction!) {
        if openSwitch.on {
            openSwitch.setOn(false, animated: false)
        } else {
            openSwitch.setOn(true, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                // open den delivery facebook page
                let url = NSURL(string: "https://www.facebook.com/BobcatDenDelivery/?fref=ts")!
                let application = UIApplication.sharedApplication()
                application.openURL(url)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "snapchat" {
            let vc = segue.destinationViewController as! WebViewController
            vc.url = NSURL(string: "http://www.snapchat.com/add/den_delivery")!
        }
    }
    

}





