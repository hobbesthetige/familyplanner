//
//  NXUIKitManager.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/27/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import Foundation

open class NXUIKitManager: NSObject {
    open static let defaultManager = NXUIKitManager()
    
    /// A custom closure used that should open the settings app permissions for this application.
    /// If `nil`, the user will not be preseted with the option to open settings when  access to items like the photo library is denied.
    ///
    /// Allows NXUIKit to open settings without actually calling UIApplication
    ///
    /// Typical implementation:
    ///
    ///     if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
    ///         UIApplication.sharedApplication().openURL(url)
    ///     }
    open var openSettingsHandler: (() -> Void)?
    
    
    open var statusBarFrameHandler: (() -> CGRect)?
}
