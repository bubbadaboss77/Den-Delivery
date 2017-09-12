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

        OrderController.sharedController.loadUserInfoFromPersistentStore()
        
        // Listen for open status changes
        NotificationCenter.default.addObserver(self, selector: #selector(setupClosedView), name: NSNotification.Name(rawValue: openStatusChangedNotificationKey), object: nil)

        setupFormViews()
        updateFormWithUserInfo()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OrderViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(OrderViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OrderViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed" {
            formView = segue.destination as? FormViewController
        } else if segue.identifier == "showOrderFormSegue" {
            
        }
    }
    
    // MARK: - Views Setup
    
    func updateFormWithUserInfo() {
        if let order = OrderController.sharedController.loadUserInfoFromPersistentStore() {
            formView.nameField.text = order.name
            formView.locationField.text = order.location
            // Split phone number into digits to fill text fields
            let digits = Array(order.phoneNumber.characters)
            formView.areaCodeField.text = String(digits[0...2])
            formView.secondPhoneField.text = String(digits[3...5])
            formView.thirdPhoneField.text = String(digits[6...9])
        }
    }
    
    func setupClosedView() {
        if openForDelivery {
            closedScreen.isHidden = true
        } else {
            closedScreen.isHidden = false
        }
    }
    
    func setupFormViews() {
        headerContainer.layer.cornerRadius = 4.0
        headerContainer.layer.shadowColor = UIColor.black.cgColor
        headerContainer.layer.shadowOpacity = 0.3
        headerContainer.layer.shadowRadius = 2.0
        headerContainer.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        
        formContainerView.layer.shadowColor = UIColor.black.cgColor
        formContainerView.layer.shadowOpacity = 0.3
        formContainerView.layer.shadowRadius = 2.0
        formContainerView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        
        submitButton.setTitle("SUBMIT ORDER", for: UIControlState())
        submitButton.layer.shadowColor = UIColor.black.cgColor
        submitButton.layer.shadowOpacity = 0.3
        submitButton.layer.shadowRadius = 2.0
        submitButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    }
    
    // MARK: - Keyboard Handling
    
    func keyboardWillShow(_ notification: Notification) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.frame.minY+(self.formContainerView.frame.minY/2)), animated: true)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.scrollView.frame.origin.y = 0.0
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Form Submission
    
    func createOrderFromForm() -> Order? {
        guard let name = formView.nameField.text, let location = formView.locationField.text, let areaCode = formView.areaCodeField.text, let secondPhoneField = formView.secondPhoneField.text, let thirdPhoneField = formView.thirdPhoneField.text, let order = formView.orderBox.text else { return nil }
        
        let phoneNumber = areaCode + secondPhoneField + thirdPhoneField
        return OrderController.createOrder(name, location: location, phoneNumber: phoneNumber, order: order)
    }
    
    @IBAction func submitOrder(_ sender: AnyObject) {
        if formView.validateForm() {
            view.endEditing(true)
            guard let order = createOrderFromForm() else {
                ProgressHUD.showError("Error submitting order \u{1F615}")
                return
            }
            ProgressHUD.show("Submitting order...")
            FirebaseController.sharedController.fetchGoogleFormBaseUrl({ (baseUrlString, success) in
                guard let urlString = baseUrlString, success else {
                    ProgressHUD.showError("Error submitting order \u{1F615}")
                    return
                }
                FirebaseController.sharedController.fetchGoogleFormFieldIds({ (fieldIds, success) in
                    guard let fieldIds = fieldIds else {
                        ProgressHUD.showError("Error submitting order \u{1F615}")
                        return
                    }
                    OrderController.postOrderWith(urlString, fieldIds: fieldIds, order: order, completion: { (response, error) in
                        if error != nil {
                            // Error
                            print("Error occurred: \(String(describing: error))")
                            ProgressHUD.showError("Error submitting order \u{1F615}")
                        } else {
                            // Success!
                            print("Successfully posted to form!")
                            OrderController.sharedController.saveUserInfoToPersistentStore(order)
                            ProgressHUD.showSuccess("Order submitted successfully")
                            self.formView.clearFields()
                        }
                    })
                })
            })
        }
    }
}
