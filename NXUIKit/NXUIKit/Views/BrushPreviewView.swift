//
//  BrushPreviewView.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/16/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit

class BrushPreviewView: UIView {

    var color: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    var radius: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        
        let brushRect = CGRect(x: (rect.width / 2.0) - radius, y: (rect.height / 2.0) - radius, width: radius * 2.0, height: radius * 2.0)
        context?.fillEllipse(in: brushRect)
    }
}
