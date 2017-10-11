//
//  AnnotationType.swift
//  Annotate
//
//  Created by Joseph Sferrazza on 2/28/16.
//  Copyright © 2016 Sferrazza. All rights reserved.
//

import UIKit

protocol AnnotationType {
    var color: UIColor { get set }
    var location: CGPoint? { get }
    
    func draw()
}