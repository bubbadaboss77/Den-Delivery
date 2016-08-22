//
//  FirebaseController.swift
//  BDD
//
//  Created by Tim on 8/6/16.
//  Copyright © 2016 Bobcat Den Delivery. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    static let sharedController = FirebaseController()
    
    let closedMessageKey = "custom closed message"
    let deliveryFeesKey = "deliveryFees"
    let faqsKey = "faqs"
    let openKey = "open"
    let passwordKey = "password"
    
    // MARK: - Open Status
    
    func openStatusChangedObserver(completion: (success: Bool) -> Void) {
        firebaseRef.child(openKey).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            guard let open = snapshot.value as? Bool else { return }
            openForDelivery = open
            completion(success: true)
        }) { (error) in
            print("Error occurred while observing open status: \(error.localizedDescription)")
            completion(success: false)
        }
    }
    
    func setOpenStatus(value: Bool, completion: (error: NSError?) -> Void) {
        firebaseRef.child(openKey).setValue(value) { (error, _) in
            completion(error: error)
        }
    }
    
    // MARK: - Password
    
    func fetchPassword(completion: (password: String?, error: NSError?) -> Void) {
        firebaseRef.child(passwordKey).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            guard let password = snapshot.value as? String else { return }
            completion(password: password, error: nil)
        }) { (error) in
            print(error.localizedDescription)
            completion(password: nil, error: error)
        }
    }
    
    // MARK: - Custom Closed Message
    
    func fetchClosedMessage(completion: (message: String?, success: Bool) -> Void) {
        firebaseRef.child(closedMessageKey).observeEventType(.Value, withBlock: { (snapshot) in
            guard let message = snapshot.value as? String else { return }
            completion(message: message, success: true)
        }) { (error) in
            print(error.localizedDescription)
            completion(message: nil, success: false)
        }
    }
}