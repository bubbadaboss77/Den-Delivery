//
//  FormViewController.swift
//  Den Delivery
//
//  Created by Tim Chamberlin on 4/8/16.
//  Copyright © 2016 Den Delivery. All rights reserved.
//

import UIKit



class FormViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var areaCodeField: UITextField!
    @IBOutlet weak var secondPhoneField: UITextField!
    @IBOutlet weak var thirdPhoneField: UITextField!
    @IBOutlet weak var orderBox: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textStyle = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName: placeholderFont!
        ]
        
        self.nameField.attributedPlaceholder = NSAttributedString(string: "NAME", attributes: textStyle)
        self.locationField.attributedPlaceholder = NSAttributedString(string: "DORM/BUILDING, ROOM #", attributes: textStyle)
        
        // Order textbox placeholder
        self.orderBox.text = "ORDER"
        self.orderBox.textColor = UIColor.lightGrayColor()
        self.orderBox.font = placeholderFont!
        
        areaCodeField.addTarget(self, action: #selector(FormViewController.firstFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        secondPhoneField.addTarget(self, action: #selector(FormViewController.secondFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        thirdPhoneField.addTarget(self, action: #selector(FormViewController.thirdFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        orderBox.layer.borderColor = UIColor.clearColor().CGColor
        orderBox.layer.borderWidth = 1.0;
        orderBox.layer.cornerRadius = 2.0;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.separatorInset = UIEdgeInsetsMake(10, 30, 10, 30)
        self.tableView.layer.cornerRadius = 4.0
        // No separator after order cell

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func firstFieldDidChange(phoneField: UITextField) {
        let areaCode = areaCodeField.text
        if areaCode?.characters.count == 3 {
            secondPhoneField.becomeFirstResponder()
        }
    }
    
    func secondFieldDidChange(phoneField: UITextField) {
        let secondField = secondPhoneField.text
        if (secondField?.characters.count == 3) {
            thirdPhoneField.becomeFirstResponder()
        }
    }
    
    func thirdFieldDidChange(phoneField: UITextField) {
        checkMaxLength(thirdPhoneField, maxLength: 4)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
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
    
    // UITextView Delegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.darkGrayColor()
        }

        textView.font = UIFont(name: "Helvetica Neue", size: 14)
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "ORDER"
            textView.textColor = UIColor.lightGrayColor()
            textView.font = placeholderFont!
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.orderBox.resignFirstResponder()
            return false
        }
        return true
    }
    
    // Google Form HTTP POST Request
    func postResponse(url: String, completionHandler: (NSString?, NSError?) -> ()) -> NSURLSessionTask {
        ProgressHUD.show("Sending...")
        let URL = NSURL(string: url)!
        let request = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        let fieldIds = ["entry.30856469","entry.1459419707","entry.278265666","entry.1962294575"]
        var postString = "entry.30856469=" + self.nameField.text!
        postString += "&" + fieldIds[1] + "=" + self.locationField.text!
        // The phone number must be sent in the form of 10 numbers, xxxxxxxxxx, due to the data validation in place in google forms
        postString += "&" + fieldIds[2] + "=" + self.areaCodeField.text! + self.secondPhoneField.text! + self.thirdPhoneField.text!
        
        postString += "&" + fieldIds[3] + "=" + self.orderBox.text!
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            dispatch_async(dispatch_get_main_queue()) {
                guard data != nil else {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(NSString(data: data!, encoding: NSUTF8StringEncoding), nil)
            }
        }
        task.resume()
        return task
    }
    
    func validateForm() -> Bool {

        // Check connection
        if Reachability.isConnectedToNetwork() == false {
            ProgressHUD.showError("No internet connection")
            return false
        }
        
        if self.nameField.text == "" {
            ProgressHUD.showError("Please enter your name")
            return false
        } else if self.locationField.text == "" {
            ProgressHUD.showError("Please enter your location")
            return false
        } else if self.areaCodeField.text == "" {
            ProgressHUD.showError("Please complete your phone number")
            return false
        } else if self.secondPhoneField.text == "" {
            ProgressHUD.showError("Please complete your phone number")
            return false
        } else if self.thirdPhoneField.text == "" {
            ProgressHUD.showError("Please complete your phone number")
            return false
        } else if self.orderBox.text == "ORDER" || self.orderBox.text == "" {
            ProgressHUD.showError("Please enter your order")
            return false
        }
        print("form is valid")
        return true
    }
    

}

