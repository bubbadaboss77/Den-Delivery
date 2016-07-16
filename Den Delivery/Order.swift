//
//  Order.swift
//  BDD
//
//  Created by Tim on 7/1/16.
//  Copyright © 2016 Bobcat Den Delivery. All rights reserved.
//

import Foundation

class Order {
    
    var name: String
    var location: String
    var phoneNumber: String
    var orderText: String
    
    
    
    init(name: String, location: String, phoneNumber: String, orderText: String) {
        self.name = name
        self.location = location
        self.phoneNumber = phoneNumber
        self.orderText = orderText
    }
}