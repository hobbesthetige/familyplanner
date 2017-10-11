//
//  EventChecklist.swift
//  AppData
//
//  Created by Daniel Meachum on 10/11/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import CloudKit

public class EventChecklistItem : EventCloudKitModel
{
    var title : String
    
    var isComplete = false
    
    var completedBy : FamilyMember?
    
    var completionDate : Date?
    
    var notes : String?
    
    public init(title : String) {
        
        self.title = title
    }
    
    public func markAsComplete(by familyMember : FamilyMember) {
        
        completionDate = Date()
        
        completedBy = familyMember
        
        isComplete = true
    }
    
    public func markAsIncomplete() {
        
        completionDate = nil
        
        completedBy = nil
        
        isComplete = false
    }
}
