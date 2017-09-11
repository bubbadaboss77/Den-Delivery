//
//  MoreViewController.swift
//  Den Delivery
//
//  Created by Tim Chamberlin on 4/8/16.
//  Copyright © 2016 Den Delivery. All rights reserved.
//

import UIKit
import Firebase

class MoreViewController: UITableViewController {
    
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var openLabel: UILabel!
    
    var openStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleOpenButton()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleOpenButton), name: NSNotification.Name(rawValue: openStatusChangedNotificationKey), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - UI Functions
    
    func toggleOpenButton() {
        if openForDelivery {
            openSwitch.setOn(true, animated: true)
            openStatus = "Open for business"
            openLabel.text = openStatus
        } else {
            openSwitch.setOn(false, animated: true)
            openStatus = "BDD is closed"
            openLabel.text = openStatus
        }
        ProgressHUD.showSuccess(openStatus)
    }
    
    func presentPasswordAlert() {
        let alert = UIAlertController(title: "Enter password", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter password..."
            textField.isSecureTextEntry = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            if self.openSwitch.isOn {
                self.openSwitch.setOn(false, animated: false)
                return
            } else {
                self.openSwitch.setOn(true, animated: true)
                return
            }
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            guard let enteredText = alert.textFields?[0].text else { return }
            FirebaseController.sharedController.fetchPassword({ (password, error) in
                if let _ = error {
                    ProgressHUD.showError("Network connection failed")
                } else {
                    guard let password = password else { return }
                    
                    if enteredText == password {
                        FirebaseController.sharedController.setOpenStatus(!openForDelivery, completion: { (error) in
                            if error != nil {
                                print("Error occurred while setting open status: \(String(describing: error?.localizedDescription))")
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
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func switchChanged(_ sender: AnyObject) {
        presentPasswordAlert()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                // open den delivery facebook page
                let url = URL(string: "https://www.facebook.com/BobcatDenDelivery/?fref=ts")!
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "snapchat" {
            guard let vc = segue.destination as? WebViewController else { return }
            vc.url = URL(string: "http://www.snapchat.com/add/den_delivery")!
        } else if segue.identifier == "faqSegue" {
            guard let vc = segue.destination as? InfoTableViewController else { return }
            vc.parentDirectory = FirebaseController.sharedController.faqsKey
            vc.sender = "FAQs"
        } else if segue.identifier == "deliveryFeesSegue" {
            guard let vc = segue.destination as? InfoTableViewController else { return }
            vc.parentDirectory = FirebaseController.sharedController.deliveryFeesKey
            vc.sender = "Delivery Fees"
        }
    }
}





