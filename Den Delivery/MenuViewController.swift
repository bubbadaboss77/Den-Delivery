//
//  MenuViewController.swift
//  Den Delivery
//
//  Created by Tim on 4/8/16.
//  Copyright © 2016 Den Delivery. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var path = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
//        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        path = Bundle.main.path(forResource: "menu", ofType: "pdf")!
        
        let url = URL(fileURLWithPath: path)
        self.webView.loadRequest(URLRequest(url: url))
    }
    
    override var shouldAutorotate : Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

