//
//  OrderController.swift
//  BDD
//
//  Created by Tim on 7/1/16.
//  Copyright © 2016 Bobcat Den Delivery. All rights reserved.
//

import Foundation

class OrderController {
    
    static let sharedController = OrderController()
    
    private let currentUserInfoKey = "currentUserInfo"
    
    // MARK: - Post Order
    
    static let baseURL = NSURL(string: "https://docs.google.com/a/bates.edu/forms/d/1PyTKKFUNXpN170_GHW2eah-ub8yd32hHwq_ckVrJ_LM/formResponse?")
    
    static func postOrder(order: Order, completion: (NSString?, NSError?) -> ()) {
        guard let url = baseURL else {
            print("Optional url is nil")
            return
        }
        // Dictionary used in NetworkController method 'urlFromParameters'
        let fieldIds = ["entry.30856469","entry.1459419707","entry.278265666","entry.1962294575"]
        let submissionParameters = [
            fieldIds[0]:order.name,
            fieldIds[1]:order.location,
            fieldIds[2]:order.phoneNumber,
            fieldIds[3]:order.orderText
        ]
        // Make POST request to Google Form
        NetworkController.performRequestForURL(url, httpMethod: .Post, urlParameters: submissionParameters) { (data, error) in
            // Switch back to main thread
            dispatch_async(dispatch_get_main_queue(), { 
                if let data = data, responseString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    completion(responseString, nil)
                } else {
                    completion(nil, error)
                }
            })
        }
    }
    
    // CRUD Methods
    
    static func createOrder(name: String, location: String, phoneNumber: String, order: String) -> Order {
        return Order(name: name, location: location, phoneNumber: phoneNumber, orderText: order)
    }
    
    // MARK: - NSUserDefaults
    
    func loadUserInfoFromPersistentStore() -> Order? {
        if let currentUserInfoDictionary = NSUserDefaults.standardUserDefaults().objectForKey(currentUserInfoKey) as? [String: AnyObject] {
            return Order(dictionary: currentUserInfoDictionary)
        } else {
            return nil
        }
    }
    
    func saveUserInfoToPersistentStore(order: Order) {
        NSUserDefaults.standardUserDefaults().setObject(order.orderDictionary, forKey: currentUserInfoKey)
    }
}
