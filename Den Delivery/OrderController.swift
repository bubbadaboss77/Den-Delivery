//
//  OrderController.swift
//  BDD
//
//  Created by Tim on 7/1/16.
//  Copyright © 2016 Bobcat Den Delivery. All rights reserved.
//

import Foundation

class OrderController {
    
    static let baseURL = NSURL(string: "https://docs.google.com/a/bates.edu/forms/d/1PyTKKFUNXpN170_GHW2eah-ub8yd32hHwq_ckVrJ_LM/formResponse?")
    static let testBaseURL = NSURL(string: "https://docs.google.com/forms/d/e/1FAIpQLSf3phHZCGsDdbOCaM6s8VeX0KH6qZe0igmQpnrpO1N9RXwXDA/formResponse?")

    static func postOrder(order: Order, completion: (NSString?, NSError?) -> ()) {
        
        // TODO: Change URL
        guard let url = testBaseURL else {
            print("Optional url is nil")
            return
        }
        
        // TODO: Change to actual form
        let testFieldIds = ["entry.1931078188","entry.1523690174"]
        let testSubmissionParameters = [
            testFieldIds[0]:"This is the first answer",
            testFieldIds[1]:"This is the second answer"
        ]
        
        // Dictionary used in NetworkController method 'urlFromParameters'
        let fieldIds = ["entry.30856469","entry.1459419707","entry.278265666","entry.1962294575"]
        let submissionParameters = [
            fieldIds[0]:order.name,
            fieldIds[1]:order.location,
            fieldIds[2]:order.phoneNumber,
            fieldIds[3]:order.orderText
        ]
        
        // Make POST request
        // TODO: Change url parameters
        NetworkController.performRequestForURL(url, httpMethod: .Post, urlParameters: testSubmissionParameters) { (data, error) in
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
}
