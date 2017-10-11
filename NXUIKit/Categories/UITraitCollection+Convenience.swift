//
//  UITraitCollection+Convenience.swift
//  NXUIKit
//
//  Created by Joe Sferrazza on 6/28/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import UIKit

public extension UITraitCollection {
    var isCompactWidth: Bool {
        return horizontalSizeClass == .compact
    }
    
    var isCompactHeight: Bool {
        return verticalSizeClass == .compact
    }
}

public extension UIView {
    var isCompactWidth: Bool {
        return traitCollection.isCompactWidth
    }
    
    var isCompactHeight: Bool {
        return traitCollection.isCompactHeight
    }
}

public extension UIViewController {
    var isCompactWidth: Bool {
        return traitCollection.isCompactWidth
    }
    
    var isCompactHeight: Bool {
        return traitCollection.isCompactHeight
    }
}
