//
//  CloudKit+ValueType.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/10/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import CloudKit

protocol MyCKRecordValueType {
    var asObject: CKRecordValue { get }
}

extension CKRecord {
    func set<ValueType>(value: ValueType, forKey key: String) where ValueType : MyCKRecordValueType {
        let object = value.asObject
        self.setObject(object, forKey: key)
    }
    subscript(key : String) -> MyCKRecordValueType? {
        set {
            self.setObject(newValue?.asObject, forKey: key)
        }
        get {
            return object(forKey: key) as? MyCKRecordValueType
        }
    }
}

extension String : MyCKRecordValueType {
    var asObject: CKRecordValue { return self as NSString }
}
extension Bool : MyCKRecordValueType {
    var asObject: CKRecordValue { return self as NSNumber }
}
extension Int : MyCKRecordValueType {
    var asObject: CKRecordValue { return self as NSNumber }
}
extension Data : MyCKRecordValueType {
    var asObject: CKRecordValue { return self as NSData }
}

