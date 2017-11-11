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
        
        UINavigationBar.appearance().barTintColor = lightTintColor
        UINavigationBar.appearance().tintColor = darkTintColor
        
        UIApplication.shared.keyWindow?.tintColor = lightTintColor
    }
    
    public static let lightTintColor = #colorLiteral(red: 0.924164474, green: 0.9534993768, blue: 0.9876795411, alpha: 1)
    
    public static let darkTintColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
}
