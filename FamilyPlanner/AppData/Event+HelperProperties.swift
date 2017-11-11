//
//  Event+Mutability.swift
//  AppData
//
//  Created by Daniel Meachum on 10/19/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import Foundation
import SwiftDate

extension Event {
    
    public var isInPast : Bool {
        
        if let endDate = dateRange?.endDate {
            
            return endDate.compare(to: Date(), granularity: .day) == .orderedAscending
        }
        return false
    }
    
    public var isOccurringNow : Bool {
        
        if let dateRange = dateRange {
            
            if dateRange.isSingleDate {
                
                return dateRange.startDate.isToday
            }
            
            return Date().isAfter(date: dateRange.startDate - 1.day, granularity: .day) && Date().isBefore(date: dateRange.endDate, granularity: .day)
        }
        
        return false
    }
    
    public var isSingleDate : Bool {
        
        return dateRange?.isSingleDate ?? false
    }
    
    public var startMonthFormattedString : String? {
        
        return dateRange?.startDate.string(custom: "MMM")
    }
    
    public var relativeTime : String {
        
        guard let dateRange = dateRange else {
            
            return "Open date"
        }
        
        if isOccurringNow {
            
            return "Today"
        }
        else {
            do {
                let time = try dateRange.startDate.timeComponents(to: Date(), options: ComponentsFormatterOptions(allowedUnits: [.weekOfMonth,.day,.hour], style: .short, zero: .dropAll), shared: true)
                
                return time
            } catch (_) {
                return ""
            }
        }
    }
}
