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
    
    func createOrderFromForm() -> Order? {
        guard let name = formView.nameField.text, location = formView.locationField.text, areaCode = formView.areaCodeField.text, secondPhoneField = formView.secondPhoneField.text, thirdPhoneField = formView.thirdPhoneField.text, order = formView.orderBox.text else { return nil }
        
        let phoneNumber = areaCode + secondPhoneField + thirdPhoneField
        return OrderController.createOrder(name, location: location, phoneNumber: phoneNumber, order: order)
    }
    
    // MARK: - IBActions
    
    @IBAction func submitOrder(sender: AnyObject) {
        if formView.validateForm() {
            view.endEditing(true)
            guard let order = createOrderFromForm() else {
                ProgressHUD.showError("Error submitting order \u{1F615}")
                return
            }
            ProgressHUD.show("Submitting order...")
            OrderController.postOrder(order, completion: { (response, error) in
                if error != nil {
                    // Error
                    print("Error occurred: \(error)")
                    ProgressHUD.showError("Error submitting order \u{1F615}")
                } else {
                    // Success!
                    print("\(response)")
                    ProgressHUD.showSuccess("Order submitted successfully")
                    self.formView.clearFields()
                }
            })
        }
    }
    
    
    
}
