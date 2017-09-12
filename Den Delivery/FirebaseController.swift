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
    let googleFormBaseUrlKey = "googleFormBaseUrl"
    let googleFormFieldIdsKey = "googleFormFieldIds"
    
    // MARK: - Open Status
    
    func openStatusChangedObserver(_ completion: @escaping (_ success: Bool) -> Void) {
        firebaseRef.child(openKey).observe(DataEventType.value, with: { (snapshot) in
            guard let open = snapshot.value as? Bool else { return }
            openForDelivery = open
            completion(true)
        }) { (error) in
            completion(false)
        }
    }
    
    func setOpenStatus(_ value: Bool, completion: @escaping (_ error: NSError?) -> Void) {
        firebaseRef.child(openKey).setValue(value)
    }
    
    // MARK: - Password
    
    func fetchPassword(_ completion: @escaping (_ password: String?, _ error: NSError?) -> Void) {
        firebaseRef.child(passwordKey).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let password = snapshot.value as? String else { return }
            completion(password, nil)
        }) { (error) in
            print(error.localizedDescription)
            completion(nil, error as NSError)
        }
    }
    
    // MARK: - Custom Closed Message
    
    func fetchClosedMessage(_ completion: @escaping (_ message: String?, _ success: Bool) -> Void) {
        firebaseRef.child(closedMessageKey).observe(.value, with: { (snapshot) in
            guard let message = snapshot.value as? String else { return }
            completion(message, true)
        })
        
        completion(nil, false)
    }
    
    // MARK: - Google Form Parameters
    
    func fetchGoogleFormBaseUrl(_ completion: @escaping (_ urlString: String?, _ success: Bool) -> Void) {
        firebaseRef.child(googleFormBaseUrlKey).observe(.value, with: { (snapshot) in
            guard let baseUrlString = snapshot.value as? String else {
                completion(nil, false)
                return
            }
            completion(baseUrlString, true)
        })
    }
    
    func fetchGoogleFormFieldIds(_ completion: @escaping (_ fieldIds: [String]?, _ success: Bool) -> Void) {
        firebaseRef.child(googleFormFieldIdsKey).observe(.value, with: { (snapshot) in
            guard let items = snapshot.value as? NSArray else {
                completion(nil, false)
                return
            }
            // Convert to [String]
            let completionItems = items.flatMap { $0 as? String }
            completion(completionItems, true)
        })
    }
}
