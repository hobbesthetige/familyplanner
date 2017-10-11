//
//  CloudKitHelper.swift
//  AppData
//
//  Created by Daniel Meachum on 10/11/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import CloudKit


internal protocol CKRecordZoneHolder
{
    var zone : CKRecordZone { get }
}

internal protocol CKRecordIDHolder
{
    var recordID : CKRecordID? { get set }
}

internal protocol CloudKitModel : CKRecordIDHolder, CKRecordZoneHolder
{
    
}

internal extension CKRecordZone
{
    static let eventZone = CKRecordZone(zoneName: "Event")
    
    static let memberZone = CKRecordZone(zoneName: "FamilyMember")
}

