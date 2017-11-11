//
//  ChecklistItemCell.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/28/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import Foundation
import AppData
import AppUI


public class ChecklistItemCell : UITableViewCell
{
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    
    @IBOutlet weak var circleView : CircleView!
    
    weak var checklistItem : EventChecklistItem? {
        
        didSet {
            
            titleLabel.text = checklistItem?.title
            
            statusLabel.text = checklistItem?.statusDescription
            
            circleView.backgroundColor = checklistItem?.color
        }
    }
}
