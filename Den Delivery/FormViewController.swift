//
//  FormViewController.swift
//  Den Delivery
//
//  Created by Tim Chamberlin on 4/8/16.
//  Copyright © 2016 Den Delivery. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}




class FormViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var areaCodeField: UITextField!
    @IBOutlet weak var secondPhoneField: UITextField!
    @IBOutlet weak var thirdPhoneField: UITextField!
    @IBOutlet weak var orderBox: UITextView!
    
    let textStyle = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: placeholderFont!]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatTextView()
        formatTableView()
        formatTextFields()
        
        // Phone text fields targets
        areaCodeField.addTarget(self, action: #selector(FormViewController.firstFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        secondPhoneField.addTarget(self, action: #selector(FormViewController.secondFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        thirdPhoneField.addTarget(self, action: #selector(FormViewController.thirdFieldDidChange(_:)), for: UIControlEvents.editingChanged)

    }
    
    // MARK: - View Formatting
    
    func formatTableView() {
        // Custom separators
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView.separatorInset = UIEdgeInsetsMake(10, 30, 10, 30)
        self.tableView.layer.cornerRadius = 4.0
    }
    
    func formatTextFields() {
        // placeholders
        nameField.attributedPlaceholder = NSAttributedString(string: "NAME", attributes: textStyle)
        locationField.attributedPlaceholder = NSAttributedString(string: "DORM/BUILDING, ROOM #", attributes: textStyle)
        areaCodeField.attributedPlaceholder = NSAttributedString(string: "123", attributes: textStyle)
        secondPhoneField.attributedPlaceholder = NSAttributedString(string: "456", attributes: textStyle)
        thirdPhoneField.attributedPlaceholder = NSAttributedString(string: "7890", attributes: textStyle)
    }
    
    func formatTextView() {
        // Order textbox placeholder
        orderBox.text = "ORDER"
        orderBox.textColor = UIColor.lightGray
        orderBox.font = placeholderFont
        orderBox.layer.borderColor = UIColor.clear.cgColor
        orderBox.layer.borderWidth = 1.0
        orderBox.layer.cornerRadius = 2.0
    }
    
    
    // MARK: - TextField Delegate Methods
    
    func firstFieldDidChange(_ phoneField: UITextField) {
        let areaCode = areaCodeField.text
        if areaCode?.characters.count >= 3 {
            checkMaxLength(phoneField, maxLength: 3)
            secondPhoneField.becomeFirstResponder()
        }
    }
    
    func secondFieldDidChange(_ phoneField: UITextField) {
        let secondField = secondPhoneField.text
        if (secondField?.characters.count >= 3) {
            checkMaxLength(phoneField, maxLength: 3)
            thirdPhoneField.becomeFirstResponder()
        }
    }
    
    func thirdFieldDidChange(_ phoneField: UITextField) {
        checkMaxLength(thirdPhoneField, maxLength: 4)
    }
    
    func checkMaxLength(_ textField: UITextField!, maxLength: Int) {
        if (textField.text!.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nameField:
            self.locationField.becomeFirstResponder()
        case self.locationField:
            self.areaCodeField.becomeFirstResponder()
        case self.secondPhoneField:
            self.thirdPhoneField.becomeFirstResponder()
        default:
            return true
        }
        return true
    }
    
    // MARK: - UITextView Delegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
        textView.font = formTextFont
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "ORDER"
            textView.textColor = UIColor.lightGray
            textView.font = placeholderFont
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.orderBox.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - Helper Functions
    
    func clearFields() {
//        nameField.text = ""
//        locationField.text = ""
//        areaCodeField.text = ""
//        secondPhoneField.text = ""
//        thirdPhoneField.text = ""
        
        // Order textbox placeholder
        orderBox.text = "ORDER"
        orderBox.textColor = UIColor.lightGray
        orderBox.font = placeholderFont
    }
    
    func validateForm() -> Bool {
        
        if self.nameField.text == "" {
            ProgressHUD.showError("Please enter your name")
            return false
        } else if self.locationField.text == "" {
            ProgressHUD.showError("Please enter your location")
            return false
        } else if self.areaCodeField.text?.characters.count < 3 {
            ProgressHUD.showError("Please complete your phone number")
            return false
        } else if self.secondPhoneField.text?.characters.count < 3 {
            ProgressHUD.showError("Please complete your phone number")
            return false
        } else if self.thirdPhoneField.text?.characters.count < 4 {
            ProgressHUD.showError("Please complete your phone number")
            return false
        } else if self.orderBox.text == "ORDER" || self.orderBox.text == "" {
            ProgressHUD.showError("Please enter your order")
            return false
        }
        return true
    }
    
}

