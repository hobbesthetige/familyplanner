//
//  Stroke.swift
//  Annotate
//
//  Created by Joseph Sferrazza on 2/28/16.
//  Copyright © 2016 Sferrazza. All rights reserved.
//

import UIKit

private let MaximumStrokeWidthChange: CGFloat = 0.35

open class Stroke: NSObject, AnnotationType {
    
    
    open var color: UIColor
    open var location: CGPoint? {
        return paths.first?.currentPoint
    }
    fileprivate var brush: Brush = Brush()
    fileprivate var points: Array<CGPoint> = [CGPoint.zero, CGPoint.zero, CGPoint.zero, CGPoint.zero, CGPoint.zero]
    fileprivate var pointIndex: Int = 0
    fileprivate var previousPoint: CGPoint = CGPoint.zero
    fileprivate var previousPointWidth: CGFloat

    fileprivate var paths = Array<UIBezierPath>()
    
    init(startPoint: CGPoint, color: UIColor, brush: Brush) {
        self.brush = brush
        self.color = color
        points[0] = startPoint
        previousPoint = startPoint
        previousPointWidth = brush.startingThickness
    }
}

extension Stroke {
    func appendPoint(_ newPoint: CGPoint) {
        
        var strokeWidth = brush.startingThickness
        
        if brush.variableWidth {
            let deltaX = Float(previousPoint.x - newPoint.x)
            let deltaY = Float(previousPoint.y - newPoint.y)
            
            let distanceFromPreviousPoint: CGFloat = CGFloat(hypotf(deltaX, deltaY))
            
            strokeWidth = max(brush.minThickness, min(20.0 / distanceFromPreviousPoint, brush.maxThickness))
            
            let previousWidth: CGFloat
            if let previousPath = paths.last {
                previousWidth = previousPath.lineWidth
            }
            else {
                previousWidth = brush.maxThickness
            }
            
            if (strokeWidth > previousWidth) {
                strokeWidth = min(strokeWidth, previousWidth + MaximumStrokeWidthChange)
            }
            else {
                strokeWidth = max(strokeWidth, previousWidth - MaximumStrokeWidthChange)
            }
        }
        
        previousPoint = newPoint
        
        let newPath = UIBezierPath()
        newPath.lineWidth = strokeWidth
        newPath.lineJoinStyle = .round
        newPath.lineCapStyle = brush.capStyle
        
        pointIndex += 1
        points[pointIndex] = newPoint
        
        if pointIndex == 4 {
            points[3] = CGPoint(x: (points[2].x + points[4].x) / 2.0, y: (points[2].y + points[4].y) / 2.0)
            
            newPath.move(to: points[0])
            newPath.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
            
            paths.append(newPath)
            
            points[0] = points[3]
            points[1] = points[4]
            pointIndex = 1
        }
    }
    
    func endAtPoint(_ endPoint: CGPoint) {
        // If appendPoint was never called, create a subPath to add
        if paths.count == 0 {
            let newPath = UIBezierPath()
            newPath.lineWidth = brush.startingThickness
            newPath.lineCapStyle = brush.capStyle
            newPath.move(to: previousPoint)
            newPath.addLine(to: endPoint)
            paths.append(newPath)
        }
    }
}

extension Stroke {
    func draw() {
        for path in paths {
            path.stroke()
        }
    }
}
