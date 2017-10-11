//
//  UIStoryboard+NXUIKit.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/23/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit

extension UIStoryboard {
    fileprivate static let PhotoStoryboardName = "NXPhotoStoryboard"
    
    public class func photoStoryboard() -> UIStoryboard {
        return UIStoryboard(name: PhotoStoryboardName, bundle: Bundle.nxuiKitBundle())
    }
}
