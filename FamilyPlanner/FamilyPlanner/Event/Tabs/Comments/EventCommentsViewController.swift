//
//  EventCommentsViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/28/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit
import AppUI
import AppData


public class EventCommentsViewController : UITableViewController
{
    public var comments = [EventComment]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return max(1, comments.count)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if comments.isEmpty {
            
            return tableView.dequeueReusableCell(withIdentifier: "no_results", for: indexPath)
        }
        
        let comment = comments[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventCommentCell
        
        cell.comment = comment
        
        return cell
    }
}
