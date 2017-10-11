//
//  Text.swift
//  Annotate
//
//  Created by Joseph Sferrazza on 2/28/16.
//  Copyright © 2016 Sferrazza. All rights reserved.
//

import UIKit

open class Text: AnnotationType {
    open var text: String?
    open var author: String?
    open var font: UIFont
    
    open var color: UIColor
    open var location: CGPoint? = CGPoint.zero
    
    init(text: String, color: UIColor, location: CGPoint) {
        self.color = color
        self.text = text
        self.location = location
        font = UIFont.systemFont(ofSize: 24.0)
    }
    
    func draw() {
        let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : color] as [String : Any]
        if let string: NSString = text as NSString?, let location = location {
            let size = string.size(attributes: attributes)
            let origin = location
            string.draw(in: CGRect(origin: origin, size: size), withAttributes: attributes)
        }
    }
}
