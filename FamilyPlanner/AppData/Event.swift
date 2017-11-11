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
    
    public var description : String?
    
    public var color : UIColor
    
    public var location : Location?
    
    public var dateRange : DateRange?
    
    public var invitees = [EventInvitees]()
    
    public var comments = [EventComment]()
    
    public var checklistItems = [EventChecklistItem]()
    
    public var isComplete = false
    
    
    
    public init(title : String) {
        
        self.title = title
        
        self.color = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    }
    
    public func inviteAllFamily() {
        
        invitees += EventInvitees.createInvitationsForAllFamilyRepresentations()
    }
    
    public func inviteAllFamily(ofGroup group : FamilyMemberGroup) {
        
        invitees += EventInvitees.createInvitationsForAllFamilyRepresentations(ofGroup: group)
    }
}

public enum EventInviteeResponseType : String
{
    case attending = "Attending", maybe = "Maybe Attending", notAttending = "Not Attending", notResponded = "No Response Yet"
    
    public var color : UIColor {
        
        switch self {
        case .attending:
            return #colorLiteral(red: 0, green: 0.6509803922, blue: 0.3647058824, alpha: 1)
        case .maybe:
            return #colorLiteral(red: 0.9619782567, green: 0.8221537471, blue: 0.1951468289, alpha: 1)
        case .notAttending:
            return #colorLiteral(red: 0.9334495664, green: 0.3899522722, blue: 0.2985906601, alpha: 1)
        case .notResponded:
            return #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        }
    }
}
public class EventInviteeResponse
{
    public var type = EventInviteeResponseType.notResponded
    
    public var comments : String?
    
    public init() { }
    
    public init(type : EventInviteeResponseType, comments : String?) {
        
        self.type = type
        self.comments = comments
    }
}

public class EventInvitees : EventCloudKitModel
{
    public let response = EventInviteeResponse()
    
    public var dateRange : DateRange?
    
    public var familyRepresentation : FamilyRepresentation
    
    public init(familyMember : FamilyMember, dateRange : DateRange? = nil) {
        
        self.familyRepresentation = familyMember
        
        self.dateRange = dateRange
    }
    
    public init(family : Family) {
        
        self.familyRepresentation = family
    }
    
    public init(familyRepresentation : FamilyRepresentation) {
        
        self.familyRepresentation = familyRepresentation
    }
    
    fileprivate static func createInvitationsForAllFamilyRepresentations() -> [EventInvitees] {
        
        var invitees = [EventInvitees]()
        
        for representation in FamilyMember.allFamilyRepresentation {
            
            invitees.append(EventInvitees(familyRepresentation: representation))
        }
        
        return invitees
    }
    
    fileprivate static func createInvitationsForAllFamilyRepresentations(ofGroup group : FamilyMemberGroup) -> [EventInvitees] {
        
        var invitees = [EventInvitees]()
        
        for representation in FamilyMember.allFamilyRepresentationOfGroup(group: group) {
            
            invitees.append(EventInvitees(familyRepresentation: representation))
        }
        
        return invitees
    }
    
    public func respond(response : EventInviteeResponse) {
        
        self.response.type = response.type
        self.response.comments = response.comments
    }
}

public class EventComment : EventCloudKitModel
{
    public var comments : String?
    
    public var author : FamilyMember
    
    public let date : Date
    
    public init(comments : String?, author : FamilyMember) {
        
        self.comments = comments
        
        self.author = author
        
        self.date = Date()
    }
}
