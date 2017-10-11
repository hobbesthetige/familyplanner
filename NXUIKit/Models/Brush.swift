//
//  Brush.swift
//  Annotate
//
//  Created by Joseph Sferrazza on 2/28/16.
//  Copyright © 2016 Sferrazza. All rights reserved.
//

import UIKit

open class Brush {
    internal fileprivate(set) var startingThickness: CGFloat = 0.0
    internal fileprivate(set) var maxThickness: CGFloat = 0.0
    internal fileprivate(set) var minThickness: CGFloat = 0.0
    
    fileprivate var variance: CGFloat = 0.0
    fileprivate var shouldStartThick = false
    
    open var thickness: CGFloat {
        didSet {
            updateMinAndMaxThickness()
        }
    }
    
    var variableWidth: Bool {
        return maxThickness != minThickness
    }
    open var capStyle: CGLineCap = .round
    
    convenience init() {
        self.init(thickness: 0.5, thicknessVarianceFactor: 0.0, startThick: true)
    }
    
    convenience init(thickness: CGFloat) {
        self.init(thickness: thickness, thicknessVarianceFactor: 0.0, startThick: true)
    }
    
    init(thickness: CGFloat, thicknessVarianceFactor varianceFactor: CGFloat, startThick shouldStartThick: Bool) {
        self.thickness = thickness
        self.shouldStartThick = shouldStartThick
        self.variance = varianceFactor
        updateMinAndMaxThickness()
    }
    
    fileprivate func updateMinAndMaxThickness() {
        self.minThickness = thickness - (thickness * variance)
        self.maxThickness = thickness + (thickness * variance)
        self.startingThickness = shouldStartThick ? self.maxThickness : self.minThickness
    }
}
