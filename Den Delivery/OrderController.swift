//
//  OrderController.swift
//  BDD
//
//  Created by Tim on 7/1/16.
//  Copyright © 2016 Bobcat Den Delivery. All rights reserved.
//

import Foundation

class OrderController {
    
    
    // CRUD
    
    func createOrder(name: String, location: String, phoneNumber: String, order: String) -> Order {
        return Order(name: name, location: location, phoneNumber: phoneNumber, orderText: order)
    }
}
