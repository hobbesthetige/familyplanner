//
//  UISwitch+Convenience.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 7/22/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit

extension UISwitch {
    /// Disables the switch in the on position.
    public func disableInOnPosition() {
        self.enable(false, onPosition: true)
    }
    
    /// Disables the switch in the off position.
    public func disableInOffPosition() {
        self.enable(false, onPosition: false)
    }
    
    /// Enables the switch in the off position.
    public func enableInOffPosition() {
        self.enable(true, onPosition: false)
    }
    
    /// Enables the switch in the on position.
    public func enableInOnPosition() {
        self.enable(true, onPosition: true)
    }
    
    fileprivate func enable(_ enable: Bool, onPosition: Bool) {
        self.isOn = onPosition
        self.isEnabled = enable
    }
}
