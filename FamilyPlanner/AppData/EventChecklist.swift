//
//  EventChecklist.swift
//  AppData
//
//  Created by Daniel Meachum on 10/11/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import CloudKit
import SwiftDate

public class EventChecklistItem : EventCloudKitModel
{
    public var title : String
    
    public var isComplete = false
    
    public private(set) var completedBy : FamilyMember?
    
    public private(set) var completionDate : Date?
    
    public var notes : String?
    
    public var color : UIColor {
        
        return isComplete ? #colorLiteral(red: 0, green: 0.6509803922, blue: 0.3647058824, alpha: 1) : #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    }
    
    public var statusDescription : String {
        
        if let date = completionDate, let by = completedBy {
            
            var postNotes = ""
            
            if let notes = notes {
                postNotes = "\n" + notes
            }
            
            return "Completed on " + date.string(dateStyle: .short, timeStyle: .none, in: nil) + " by " + by.preferredFirstName + postNotes
        }
        
        return "Incomplete"
    }
    
    public init(title : String) {
        
        self.title = title
    }
    
    public func markAsComplete(by familyMember : FamilyMember, notes : String? = nil) {
        
        completionDate = Date()
        
        completedBy = familyMember
        
        self.notes = notes
        
        isComplete = true
    }
    
    public func markAsIncomplete() {
        
        completionDate = nil
        
        completedBy = nil
        
        isComplete = false
    }
}
