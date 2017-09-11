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
        self.title = sender
        
        fetchInfoFromFirebase { (items) in
            DispatchQueue.main.async(execute: {
                self.items = items
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 44
                self.tableView.reloadData()
                
            })
        }
    }
    
    func fetchInfoFromFirebase(_ completion: @escaping (_ items: [String]) -> Void) {
        firebaseRef.child(parentDirectory).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let items = snapshot.value as? NSArray else { return }
            // Convert to [String]
            let completionItems = items.flatMap { $0 as? String }
            completion(completionItems)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? InfoTableViewCell else { return UITableViewCell() }
        
        
        cell.cellLabel.text = items[indexPath.row]
        
        return cell
    }
    
    
}
