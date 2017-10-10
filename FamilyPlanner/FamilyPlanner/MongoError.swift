//
//  MongoError.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/10/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import Foundation

public enum MongoError : Error {
    case jsonEncodingError(String)
    case jsonDecodingError(String)
    case urlError(String)
    case responseError(String)
    case parseError(String)
    
    public var localizedError : NSError {
        let domain = "Mongo"
        let code : Int
        let message : String
        
        switch self {
        case .jsonDecodingError(let string):
            code = 100
            message = string
        case .jsonEncodingError(let string):
            code = 101
            message = string
        case .urlError(let string):
            code = 102
            message = string
        case .responseError(let string):
            code = 103
            message = string
        case .parseError(let string):
            code = 104
            message = string
        }
        
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : message])
    }
}
