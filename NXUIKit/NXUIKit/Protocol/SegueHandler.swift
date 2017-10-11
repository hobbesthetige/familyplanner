//
//  SegueHandler.swift
//  NXUIKit
//
//  Created by Joe Sferrazza on 8/2/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import UIKit

public protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

public extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
}
