//
//  UISegmentedControl+Convenience.swift
//  NXUIKit
//
//  Created by Joe Sferrazza on 8/21/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import UIKit

public extension UISegmentedControl {
    var titles: [String] {
        var types: [String] = []
        
        for index in 0..<numberOfSegments {
            if let type = titleForSegment(at: index) {
                types.append(type)
            }
        }
        return types
    }
    
    /// Selects the segment with a matching title.
    /// - note: Case-sensitive
    func selectSegmentTitled(_ title: String) {
        selectedSegmentIndex = -1
        
        for(index, itemName) in titles.enumerated() {
            if title == itemName {
                selectedSegmentIndex = index
                break
            }
        }
    }
}
