//
//  EventInviteeCell.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/23/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import Foundation
import AppData
import AppUI


public class EventInviteeCell : UITableViewCell
{
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    @IBOutlet weak var commentsLabel : UILabel!
    @IBOutlet weak var circleView : CircleView!
    
    public weak var invitee : EventInvitation? {
        
        didSet {
            
            nameLabel.text = invitee?.familyRepresentation.nameRepresentation
            statusLabel.text = invitee?.response.type.rawValue
            commentsLabel.text = invitee?.response.comments
            circleView.backgroundColor = invitee?.response.type.color ?? .lightGray
        }
    }
}

public class MyEventInviteeResponseCell : UITableViewCell
{
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var statusButton : UIButton!
    @IBOutlet weak var circleView : CircleView!
    @IBOutlet weak var commentsTextField : UITextField!
    
    public weak var invitee : EventInvitation? {
        
        didSet {
            
            nameLabel.text = invitee?.familyRepresentation.nameRepresentation
            statusButton.setTitle(invitee?.response.type.rawValue, for: .normal)
            commentsTextField.text = invitee?.response.comments
            circleView.backgroundColor = invitee?.response.type.color ?? .lightGray
        }
    }
}
