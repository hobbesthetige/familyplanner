//
//  EventCommentCell.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/28/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import Foundation
import AppData
import SwiftDate

public class EventCommentCell : UITableViewCell
{
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    
    var comment : EventComment? {
        
        didSet {
            
            guard let comment = comment else { return }
            
            titleLabel.text = comment.author.preferredFirstName + " says..."
            
            messageLabel.text = comment.comments
            
            dateLabel.text = comment.date.string(dateStyle: .short, timeStyle: .short, in: nil)
        }
    }
}
