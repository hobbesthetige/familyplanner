//
//  NSLayoutConstraint+Core.swift
//  CustomerPortal
//
//  Created by Joe Sferrazza on 10/13/15.
//  Copyright © 2015 Nexcom. All rights reserved.
//

import UIKit

//MARK: - Initializers
extension NSLayoutConstraint {
    public convenience init(alignItem view1: AnyObject, attribute attr1: NSLayoutAttribute, toItem view2: AnyObject?, offset: CGFloat) {
        self.init(item: view1, attribute: attr1, relatedBy: .equal, toItem: view2, attribute: attr1, multiplier: 1.0, constant: offset)
    }
    
    public convenience init(alignItem view1: AnyObject, attribute attr1: NSLayoutAttribute, toItem view2: AnyObject?) {
        self.init(item: view1, attribute: attr1, relatedBy: .equal, toItem: view2, attribute: attr1, multiplier: 1.0, constant: 0.0)
    }
    
    public convenience init(setValueForSingleItem view1: AnyObject, attribute attr1: NSLayoutAttribute, to constant: CGFloat) {
        self.init(item: view1, attribute: attr1, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
    }
}

//MARK: - Class Functions
extension NSLayoutConstraint {
    @objc(constraintsByAligning:toItem:usingAttributes:) public class func constraintsByAligning(item item1: AnyObject, toItem item2: AnyObject, usingAttributes attributes: [NSNumber]) -> Array<NSLayoutConstraint> {
        
        return NSLayoutConstraint.constraintsByAligning(item: item1, toItem: item2, usingAttributes: attributes.map({ NSLayoutAttribute(rawValue: $0.intValue)!}), offsets: nil)
    }
    
    public class func constraintsByAligning(item item1: AnyObject, toItem item2: AnyObject, usingAttributes attributes: Array<NSLayoutAttribute>) -> Array<NSLayoutConstraint> {
        
        return NSLayoutConstraint.constraintsByAligning(item: item1, toItem: item2, usingAttributes: attributes, offsets: nil)
    }
    
    @objc(constraintsByAligning:toItem:usingAttributes:offsets:) public class func constraintsByAligning(item item1: AnyObject, toItem item2: AnyObject, usingAttributes attributes: Array<NSNumber>, offsets: Array<NSNumber>?) -> Array<NSLayoutConstraint> {
        
        return NSLayoutConstraint.constraintsByAligning(item: item1, toItem: item2, usingAttributes: attributes.map({ NSLayoutAttribute(rawValue: $0.intValue)!}), offsets: offsets?.map({ CGFloat($0.floatValue) }))
    }
    public class func constraintsByAligning(item item1: AnyObject, toItem item2: AnyObject, usingAttributes attributes: Array<NSLayoutAttribute>, offsets: Array<CGFloat>?) -> Array<NSLayoutConstraint> {
        
        if let offsets = offsets {
            assert(offsets.count == attributes.count, "You must provide the same number of attributes and offsets")
        }
        
        var constraints = Array<NSLayoutConstraint>()
        
        var index = 0
        for attr in attributes {
            let constraint : NSLayoutConstraint
            if let offsets = offsets {
                constraint = NSLayoutConstraint(alignItem: item1, attribute: attr, toItem: item2, offset: offsets[index])
            }
            else {
                constraint = NSLayoutConstraint(alignItem: item1, attribute: attr, toItem: item2)
            }
            constraints.append(constraint)
            index += 1
        }
        return constraints
    }
    
}
