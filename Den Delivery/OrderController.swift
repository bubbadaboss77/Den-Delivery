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
    
    fileprivate let currentUserInfoKey = "currentUserInfo"
    
    // MARK: - Post Order
    
    static func postOrderWith(_ baseUrlString: String, fieldIds: [String], order: Order, completion: @escaping (NSString?, Error?) -> ()) {
        let fullBaseUrlString = baseUrlString + String("?")
        guard let url = URL(string: fullBaseUrlString) else {
            print("Optional url is nil")
            return
        }
        // Dictionary used in NetworkController method 'urlFromParameters'
        //let fieldIds = ["entry.30856469","entry.1459419707","entry.278265666","entry.1962294575"]
        let submissionParameters = [
            fieldIds[0]:order.name,
            fieldIds[1]:order.location,
            fieldIds[2]:order.phoneNumber,
            fieldIds[3]:order.orderText
        ]
        // Make POST request to Google Form
        NetworkController.performRequestForURL(url, httpMethod: .Post, urlParameters: submissionParameters) { (data, error) in
            // Switch back to main thread
            DispatchQueue.main.async(execute: {
                if let data = data, let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    completion(responseString, nil)
                } else {
                    completion(nil, error)
                }
            })
        }
    }
    
    // CRUD Methods
    
    static func createOrder(_ name: String, location: String, phoneNumber: String, order: String) -> Order {
        return Order(name: name, location: location, phoneNumber: phoneNumber, orderText: order)
    }
    
    // MARK: - NSUserDefaults
    
    func loadUserInfoFromPersistentStore() -> Order? {
        if let currentUserInfoDictionary = UserDefaults.standard.object(forKey: currentUserInfoKey) as? [String: AnyObject] {
            return Order(dictionary: currentUserInfoDictionary)
        } else {
            return nil
        }
    }
    
    func saveUserInfoToPersistentStore(_ order: Order) {
        UserDefaults.standard.set(order.orderDictionary, forKey: currentUserInfoKey)
    }
}
