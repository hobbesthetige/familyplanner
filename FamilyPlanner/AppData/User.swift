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

public class FamilyMember : FamilyMemberCloudKitModel
{
    public var emailAddress : String?
    
    public var phoneNumber : String?
    
    public var name : String
    
    public init(name : String, emailAddress : String? = nil, phoneNumber : String? = nil) {
        
        self.name = name
        
        self.emailAddress = emailAddress
        
        self.phoneNumber = phoneNumber
    }
}
