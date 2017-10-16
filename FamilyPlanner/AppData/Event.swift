//
//  Event.swift
//  AppData
//
//  Created by Daniel Meachum on 10/11/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import CloudKit

public struct DateRange
{
    public let startDate : Date
    public let endDate : Date
    
    public var isSingleDate : Bool {
        
        return Calendar.current.compare(startDate, to: endDate, toGranularity: .second) == .orderedSame
    }
    
    public init(startDate : Date, endDate : Date) {
        
        self.startDate = startDate
        self.endDate = endDate
    }
    
    public init(singleDate date : Date) {
        
        self.startDate = date
        self.endDate = date
    }
}


public class EventCloudKitModel : CloudKitModel
{
    public var recordID: CKRecordID?
    
    public let zone = CKRecordZone.eventZone
    
    public init() {
        
    }
}

public class Event : EventCloudKitModel
{
    public var title : String
    
    public var color : UIColor
    
    public var dateRange : DateRange?
    
    public var invitees = [EventInvitees]()
    
    public var comments = [EventComment]()
    
    public var checklistItems = [EventChecklistItem]()
    
    public var isComplete = false
    
    public init(title : String) {
        
        self.title = title
        
        self.color = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    }
}

public class EventInvitees : EventCloudKitModel
{
    public var isAttending : Bool?
    
    public var dateRange : DateRange?
    
    public var familyMember : FamilyMember
    
    public init(familyMember : FamilyMember, dateRange : DateRange? = nil, isAttending : Bool? = nil) {
        
        self.familyMember = familyMember
        
        self.dateRange = dateRange
        
        self.isAttending = isAttending
    }
}

public class EventComment : EventCloudKitModel
{
    public var comments : String
    
    public var author : FamilyMember
    
    public init(comments : String, author : FamilyMember) {
        
        self.comments = comments
        
        self.author = author
    }
}
