//
//  Nib.swift
//  NXUIKit
//
//  Created by Joe Sferrazza on 6/28/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import UIKit

public protocol Nib {
    
}

public extension Nib where Self: UIView {
    public static var nib: UINib? {
        let name = String(describing: self)
        return UINib(nibName: name, bundle: Bundle(for: self))
    }
    
    public static func instantiateNibView() -> Self? {
        return nib?.instantiate(withOwner: nil, options: nil).first as? Self
    }
}
