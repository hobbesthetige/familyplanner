//
//  FontStyle.swift
//  AppUI
//
//  Created by Daniel Meachum on 10/16/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit

public struct FontStyle
{
    public static let strikethroughBody = [
        NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .body),
        NSAttributedStringKey.strikethroughStyle : 1,
        NSAttributedStringKey.strikethroughColor : UIColor.lightGray,
        NSAttributedStringKey.foregroundColor : UIColor.lightGray
        ] as [NSAttributedStringKey : Any]
    
    public static let body = [
        NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .body),
        ] as [NSAttributedStringKey : Any]
}
