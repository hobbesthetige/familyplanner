//
//  UIManager.swift
//  AppUI
//
//  Created by Daniel Meachum on 10/16/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import NXUIKit

public class UIManager
{
    public static func setAppAppearance() {
        
        UINavigationBar.appearance().barTintColor = tintColor
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        UIApplication.shared.keyWindow?.tintColor = tintColor
    }
    
    public static let tintColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
}
