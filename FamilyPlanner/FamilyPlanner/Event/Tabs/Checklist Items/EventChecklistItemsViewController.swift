//
//  EventChecklistItemsViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/28/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import Foundation
import AppData

public class EventChecklistItemsViewController : UITableViewController
{
    @IBOutlet weak var incompleteLabel : UILabel!
    @IBOutlet weak var completeLabel : UILabel!
    
    
    public var checklistItems = [EventChecklistItem]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeader()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return max(1, checklistItems.count)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if checklistItems.isEmpty {
            
            return tableView.dequeueReusableCell(withIdentifier: "no_results", for: indexPath)
        }
        
        let item = checklistItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChecklistItemCell
        
        cell.checklistItem = item
        
        return cell
    }
}

extension EventChecklistItemsViewController
{
    private func setupHeader() {
        
        let completeCount = checklistItems.filter({ $0.isComplete == true }).count
        let incompleteCount = checklistItems.count - completeCount
        
        completeLabel.text = String(completeCount)
        incompleteLabel.text = String(incompleteCount)
    }
}
