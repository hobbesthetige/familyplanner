//
//  User.swift
//  AppData
//
//  Created by Daniel Meachum on 10/11/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import CloudKit

public class FamilyMemberCloudKitModel : CloudKitModel
{
    var recordID: CKRecordID?
    
    let zone = CKRecordZone.memberZone
}

public enum FamilyMemberGroup : CustomStringConvertible
{
    case immediate, extended
    
    public var description: String {
        
        switch self {
        case .immediate : return "Immediate"
        case .extended : return "Extended"
        }
    }
}

public protocol Name
{
    var firstName : String { get }
    
    var lastName : String { get }
    
    var nickName : String? { get }
}

extension Name {
    
    public var preferredFirstName : String {
        
        if let nickName = nickName {
            
            return nickName
        }
        
        return firstName
    }
}

extension Name where Self : Equatable
{
    public static func == (lhs : Name, rhs : Name) -> Bool {
        
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
    }
}

public protocol Person : Name
{
    var birthday : Date { get }
}

public protocol Adult : Person
{
    var emailAddress : String? { get }
    
    var phoneNumber : String? { get }
}

public class Child : Person
{
    
    public let firstName : String
    public let lastName: String
    public let nickName: String?
    
    public weak var parent : FamilyMember?
    
    public let birthday : Date
    
    public init(firstName : String, nickName : String? = nil, birthday : Date, parent : FamilyMember) {
        
        self.firstName = firstName
        self.lastName = parent.lastName
        self.nickName = nickName
        self.birthday = birthday
        
        self.parent = parent
    }
}

public class Family
{
    public let husband : FamilyMember
    public let wife : FamilyMember
    
    public let group : FamilyMemberGroup
    
    public var children = [Child]()
    
    public var familyName : String {
        
        return husband.firstName + "'s family"
    }
    
    public var allFamilyMemembers : [Person] {
        
        return [husband,wife] + children
    }
    
    public init(husband : FamilyMember, wife : FamilyMember, children : [Child] = [], group : FamilyMemberGroup = .immediate) {
        
        self.husband = husband
        self.wife = wife
        self.children = children
        self.group = group
    }
}

public class FamilyMember : Adult
{
    public let firstName : String
    public let lastName : String
    public let nickName: String?
    
    public let birthday : Date
    
    public var emailAddress: String?
    
    public var phoneNumber: String?
    
    public let group : FamilyMemberGroup
    
    public weak var spouse : FamilyMember?
    
    public init(firstName : String, lastName : String, nickName : String? = nil, group : FamilyMemberGroup, emailAddress : String? = nil, phoneNumber : String? = nil, birthday : Date) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.nickName = nickName
        
        self.group = group
        
        self.emailAddress = emailAddress
        
        self.phoneNumber = phoneNumber
        
        self.birthday = birthday
    }
}

public protocol FamilyRepresentation
{
    var nameRepresentation : String { get }
    
    var familyMembers : [FamilyMember] { get }
    
    var group : FamilyMemberGroup { get }
    
    var size : Int { get }
    
    var memberSize : Int { get }
    
}

extension FamilyMember : FamilyRepresentation
{
    public var nameRepresentation: String {
        
        return preferredFirstName
    }
    
    public var familyMembers: [FamilyMember] {
        
        return [self]
    }
    
    public var size: Int { return 1 }
    public var memberSize: Int { return 1 }
}
extension Family : FamilyRepresentation
{
    public var nameRepresentation: String {
        
        return familyName
    }
    
    public var familyMembers: [FamilyMember] {
        
        return [husband,wife]
    }
    
    public var size: Int { return 2 + children.count }
    public var memberSize: Int { return 2 }
}
