//
//  DateFormatters.swift
//  AppUI
//
//  Created by Daniel Meachum on 10/17/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import Foundation

public struct DateFormatters
{
    public static var monthDateFormatter : DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        return formatter
    }()
}
