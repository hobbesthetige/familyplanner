//
//  Event.swift
//  AppData
//
//  Created by Daniel Meachum on 10/11/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import CloudKit

public typealias DateRange = (startDate : Date, endDate : Date)


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
    
    public var dateRange : DateRange?
    
    public var invitees = [EventInvitees]()
    
    public var comments = [EventComment]()
    
    public var checklistItems = [EventChecklistItem]()
    
    public init(title : String) {
        
        self.title = title
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
