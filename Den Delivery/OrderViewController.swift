//
//  OrderViewController.swift
//  Den Delivery
//
//  Created by Tim Chamberlin on 4/21/16.
//  Copyright © 2016 Den Delivery. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var formContainerView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var closedScreen: UIView!
    @IBOutlet weak var closedMessage: UILabel!
    
    var formView: FormViewController! = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let customMessageRef = firebaseRef.child("custom closed message")
        customMessageRef.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            self.closedMessage.text = snapshot.value as? String
            
        }) { (error) in
            print("Error: " + error.localizedDescription)
        }

        
        let openRef = firebaseRef.child("open")
        openRef.observeEventType(FIRDataEventType.Value, withBlock: {(snapshot) in
            openForDelivery = snapshot.value as! Bool
            if openForDelivery == true {
                self.closedScreen.hidden = true
            } else {
                self.closedScreen.hidden = false
            }
        })
        
//        let openRef = firebaseRef.childByAppendingPath("open")
//        openRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            openForDelivery = snapshot.value as! Bool
//            if openForDelivery == true {
//                self.closedScreen.hidden = true
//            } else {
//                self.closedScreen.hidden = false
//            }
//        })
        
        self.headerContainer.layer.cornerRadius = 4.0
        self.headerContainer.layer.shadowColor = UIColor.blackColor().CGColor
        self.headerContainer.layer.shadowOpacity = 0.3
        self.headerContainer.layer.shadowRadius = 2.0
        self.headerContainer.layer.shadowOffset = CGSizeMake(3.0, 3.0)
        
        self.formContainerView.layer.shadowColor = UIColor.blackColor().CGColor
        self.formContainerView.layer.shadowOpacity = 0.3
        self.formContainerView.layer.shadowRadius = 2.0
        self.formContainerView.layer.shadowOffset = CGSizeMake(3.0, 3.0)
        
        self.submitButton.setTitle("SUBMIT ORDER", forState: .Normal)
        self.submitButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.submitButton.layer.shadowOpacity = 0.3
        self.submitButton.layer.shadowRadius = 2.0
        self.submitButton.layer.shadowOffset = CGSizeMake(3.0, 3.0)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OrderViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrderViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrderViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if Reachability.isConnectedToNetwork() == true {
            
        } else {
            print("Internet connection failed")
            ProgressHUD.showError("Not connected to internet")
        }
        
        if openForDelivery {
            closedScreen.hidden = true
        } else {
            closedScreen.hidden = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.scrollView.setContentOffset(CGPointMake(0, self.scrollView.frame.minY+(self.formContainerView.frame.minY/2)), animated: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.scrollView.frame.origin.y = 0.0
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embed" {
            formView = segue.destinationViewController as? FormViewController
        }
    }
    
    
    @IBAction func submitOrder(sender: AnyObject) {
        if formView.validateForm() {
            view.endEditing(true)
            formView.postResponse("https://docs.google.com/a/bates.edu/forms/d/1PyTKKFUNXpN170_GHW2eah-ub8yd32hHwq_ckVrJ_LM/formResponse?", completionHandler: { (string, error) in
                
                if error != nil {
                    print("Error occured: \(error)")
                    ProgressHUD.showError("Error submitting order")
                }
                print("Data saved successfully!")
                ProgressHUD.showSuccess("Order submitted successfully")
                
                self.formView.nameField.text = ""
                self.formView.locationField.text = ""
                self.formView.areaCodeField.text = ""
                self.formView.secondPhoneField.text = ""
                self.formView.thirdPhoneField.text = ""
                
                // Order textbox placeholder
                self.formView.orderBox.text = "ORDER"
                self.formView.orderBox.textColor = UIColor.lightGrayColor()
                self.formView.orderBox.font = placeholderFont
            })
        }
    }
}
