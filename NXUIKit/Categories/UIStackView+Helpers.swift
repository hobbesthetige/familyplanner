//
//  UIStackView+Helpers.swift
//  NXUIKit
//
//  Created by Joe Sferrazza on 8/4/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import UIKit

@available(iOSApplicationExtension 9.0, *)
extension UIStackView {
    public func clearArrangedSubviews() {
        let views = arrangedSubviews
        for view in views {
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
