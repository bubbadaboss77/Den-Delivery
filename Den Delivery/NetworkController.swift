//
//  NetworkController.swift
//  BDD
//
//  Created by Tim on 7/15/16.
//  Copyright © 2016 Bobcat Den Delivery. All rights reserved.
//

import Foundation

class NetworkController {
    
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    static func performRequestForURL(_ url: URL, httpMethod: HTTPMethod, urlParameters: [String:String]? = nil, body: Data? = nil, completion: ((_ data: Data?, _ error: Error?) -> Void)?) {
        
        let requestURL = urlFromParameters(url, urlParameters: urlParameters)
        let request = NSMutableURLRequest(url: requestURL)
        
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, reponse, error) in
            if let completion = completion {
                completion(data, error)
            }
        }
        dataTask.resume()
    }
    
    static func urlFromParameters(_ url: URL, urlParameters: [String:String]?) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = urlParameters?.flatMap({URLQueryItem(name: $0.0, value: $0.1)})
        
        if let url = components?.url {
            return url
        } else {
            fatalError("URL optional is nil")
        }
    }
}
