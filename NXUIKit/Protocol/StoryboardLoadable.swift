//
//  StoryboardLoadable.swift
//  NXUIKit
//
//  Created by Joe Sferrazza on 6/28/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import UIKit

public protocol StoryboardLoadable: class {
    static var storyboardIdentifier: String { get }
    static var loadingStoryboard: UIStoryboard { get }
}

public extension StoryboardLoadable where Self: UIViewController {
    static func instantiateFromStoryboard() -> Self {
        return loadingStoryboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
