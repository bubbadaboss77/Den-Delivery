//
//  Order.swift
//  BDD
//
//  Created by Tim on 7/1/16.
//  Copyright © 2016 Bobcat Den Delivery. All rights reserved.
//

import Foundation

class Order {
    
    private let nameKey = "name"
    private let locationKey = "location"
    private let phoneNumberKey = "phoneNumber"
    
    var name: String
    var location: String
    var phoneNumber: String
    var orderText: String
    
    var orderDictionary: [String: AnyObject] {
        return [nameKey:name, locationKey:location, phoneNumberKey:phoneNumber]
    }
    
    init(name: String, location: String, phoneNumber: String, orderText: String) {
        self.name = name
        self.location = location
        self.phoneNumber = phoneNumber
        self.orderText = orderText
    }
    
    // Used to retrieve data from NSUserDefaults
    init?(dictionary: [String: AnyObject]) {
        if let name = dictionary[nameKey] as? String, location = dictionary[locationKey] as? String, phoneNumber = dictionary[phoneNumberKey] as? String {
            self.name = name
            self.location = location
            self.phoneNumber = phoneNumber
            self.orderText = ""
        } else {
            return nil
        }
    }
}