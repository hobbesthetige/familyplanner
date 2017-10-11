//
//  Borderable.swift
//  NXUIKit
//
//  Created by Joe Sferrazza on 8/9/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import UIKit

public protocol Borderable {
    var borderEdges: UIRectEdge { get set }
}

public extension Borderable where Self: UIView {
    func drawBorder(width: CGFloat = 0.5, color: UIColor = .lightGray) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let offset = width / 2.0
        let drawAll = borderEdges.contains(.all)
        
        if drawAll || borderEdges.contains(.top) {
            context.move(to: CGPoint(x: 0.0, y: offset))
            context.addLine(to: CGPoint(x: bounds.width, y: offset))
        }
        
        if drawAll || borderEdges.contains(.bottom) {
            context.move(to: CGPoint(x: 0.0, y: bounds.height - offset))
            context.addLine(to: CGPoint(x: bounds.width, y: bounds.height - offset))
        }
        
        if drawAll || borderEdges.contains(.left) {
            context.move(to: CGPoint(x: 0.0 + offset, y: 0.0))
            context.addLine(to: CGPoint(x: 0.0 + offset, y: bounds.height))
        }
        
        if drawAll || borderEdges.contains(.right) {
            context.move(to: CGPoint(x: bounds.width - offset, y: 0.0))
            context.addLine(to: CGPoint(x: bounds.width - offset, y: bounds.height))
        }
        
        context.setStrokeColor(color.cgColor)
        context.strokePath()
    }
}
