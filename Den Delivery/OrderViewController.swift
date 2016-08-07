//
//  OrderViewController.swift
//  Den Delivery
//
//  Created by Tim Chamberlin on 4/21/16.
//  Copyright © 2016 Den Delivery. All rights reserved.
//

import UIKit
import Firebase

class OrderViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var closedScreen: UIView!
    
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var formContainerView: UIView!
    @IBOutlet weak var submitButton: UIButton!

    
    var formView: FormViewController! = nil
    
    // MARK: - View Lifecycle Methods
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for open status changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setupClosedView), name: openStatusChangedNotificationKey, object: nil)

        setupFormViews()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OrderViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrderViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OrderViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        if !Reachability.isConnectedToNetwork() {
            ProgressHUD.showError("No network connection")
            return
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embed" {
            formView = segue.destinationViewController as? FormViewController
        } else if segue.identifier == "showOrderFormSegue" {
            
        }
    }
    
    // MARK: - Views Setup
    
    func setupClosedView() {
        if openForDelivery {
            closedScreen.hidden = true
        } else {
            closedScreen.hidden = false
        }
    }
    
    func setupFormViews() {
        headerContainer.layer.cornerRadius = 4.0
        headerContainer.layer.shadowColor = UIColor.blackColor().CGColor
        headerContainer.layer.shadowOpacity = 0.3
        headerContainer.layer.shadowRadius = 2.0
        headerContainer.layer.shadowOffset = CGSizeMake(3.0, 3.0)
        
        formContainerView.layer.shadowColor = UIColor.blackColor().CGColor
        formContainerView.layer.shadowOpacity = 0.3
        formContainerView.layer.shadowRadius = 2.0
        formContainerView.layer.shadowOffset = CGSizeMake(3.0, 3.0)
        
        submitButton.setTitle("SUBMIT ORDER", forState: .Normal)
        submitButton.layer.shadowColor = UIColor.blackColor().CGColor
        submitButton.layer.shadowOpacity = 0.3
        submitButton.layer.shadowRadius = 2.0
        submitButton.layer.shadowOffset = CGSizeMake(3.0, 3.0)
    }
    
    // MARK: - Keyboard Handling
    
    func keyboardWillShow(notification: NSNotification) {
        self.scrollView.setContentOffset(CGPointMake(0, self.scrollView.frame.minY+(self.formContainerView.frame.minY/2)), animated: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.scrollView.frame.origin.y = 0.0
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Form Submission
    
    func createOrderFromForm() -> Order? {
        guard let name = formView.nameField.text, location = formView.locationField.text, areaCode = formView.areaCodeField.text, secondPhoneField = formView.secondPhoneField.text, thirdPhoneField = formView.thirdPhoneField.text, order = formView.orderBox.text else { return nil }
        
        let phoneNumber = areaCode + secondPhoneField + thirdPhoneField
        return OrderController.createOrder(name, location: location, phoneNumber: phoneNumber, order: order)
    }
    
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
                    print("Successfully posted to form!")
                    ProgressHUD.showSuccess("Order submitted successfully")
                    self.formView.clearFields()
                }
            })
        }
    }
    
    
    
}
