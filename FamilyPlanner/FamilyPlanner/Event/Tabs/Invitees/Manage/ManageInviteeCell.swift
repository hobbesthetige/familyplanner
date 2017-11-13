//
//  AddInviteeCell.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 11/13/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit
import AppData

public class ManageInviteeCell : UITableViewCell
{
    @IBOutlet weak var nameLabel : UILabel!
    
    @IBOutlet weak var responseLabel : UILabel!
    
    var model : (familyRepresentation : FamilyRepresentation,response : EventInvitationResponse?)? {
        
        didSet {
            
            nameLabel.text = model?.familyRepresentation.nameRepresentation
            
            var responseString = model?.response?.type.rawValue ?? ""
            
            if let response = model?.response, response.type == .attending {
                
                responseString += " 🔒"
            }
            responseLabel.text = responseString
            
            responseLabel.textColor = model?.response?.type.color ?? .black
        }
    }
}
