//
//  InfoTableViewController.swift
//  BDD
//
//  Created by Tim on 8/6/16.
//  Copyright © 2016 Bobcat Den Delivery. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {
    
    var items: [String] = []
    var parentDirectory = ""
    var sender = ""
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchInfoFromFirebase { (items) in
            dispatch_async(dispatch_get_main_queue(), {
                self.items = items
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 44
                self.tableView.reloadData()
                
            })
        }
    }
    
    func fetchInfoFromFirebase(completion: (items: [String]) -> Void) {
        firebaseRef.child(parentDirectory).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            guard let items = snapshot.value as? NSArray else { return }
            // Convert to [String]
            let completionItems = items.flatMap { $0 as? String }
            completion(items: completionItems)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as? InfoTableViewCell else { return UITableViewCell() }
        
        
        cell.cellLabel.text = items[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0  {
            return self.sender
        }
        return ""
    }
    
    
}
