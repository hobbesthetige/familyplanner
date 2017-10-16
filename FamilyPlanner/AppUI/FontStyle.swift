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
    static let strikethruBody = [
        NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .body),
        NSAttributedStringKey.strikethroughStyle : 2,
        NSAttributedStringKey.strikethroughColor : UIColor.darkGray,
        NSAttributedStringKey.foregroundColor : UIColor.darkGray
        ] as [NSAttributedStringKey : Any]
    
    static let strikethruBody = [
        NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .body),
        NSAttributedStringKey.strikethroughStyle : 2,
        NSAttributedStringKey.strikethroughColor : UIColor.darkGray,
        NSAttributedStringKey.foregroundColor : UIColor.darkGray
        ] as [NSAttributedStringKey : Any]
}
