//
//  LineTextField.swift
//  AppUI
//
//  Created by Daniel Meachum on 10/28/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit
import NXConstraintKit

@IBDesignable public class LineTextField: UITextField {
    
    @IBInspectable var lineColor : UIColor = .darkGray {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override public var isEnabled: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var font: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        borderStyle = .none
        
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(setValueForSingleItem: self, attribute: .height, to: 34.0)
        heightConstraint.priority = UILayoutPriority(rawValue: 900)
        addConstraint(heightConstraint)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext(), let font = font else { return }
        
        if isEnabled {
            let lineY = rect.midY + (font.pointSize * 0.5) + 4.0
            context.setLineWidth(0.5)
            context.setStrokeColor(lineColor.cgColor)
            context.move(to: CGPoint(x: 0.0, y: lineY))
            context.addLine(to: CGPoint(x: rect.maxX, y: lineY))
            context.strokePath()
        }
    }
}
