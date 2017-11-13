//
//  SectionHeaderView.swift
//  AppUI
//
//  Created by Daniel Meachum on 11/13/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit

open class SectionHeaderView : UITableViewHeaderFooterView
{
    @IBOutlet weak public var titleLabel : UILabel!
    
    @IBOutlet weak public var underlineView : UIView!
    
    static public let defaultIdentifier = "SectionHeader"
    
    static public func registerIn(tableView : UITableView) {
        
        let nib = UINib(nibName: "SectionHeaderView", bundle: Bundle(for: SectionHeaderView.self))
        
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: defaultIdentifier)
    }
    
    static public func dequeueViewIn(tableView : UITableView) -> SectionHeaderView {
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: defaultIdentifier) as! SectionHeaderView
    }
}

extension UITableViewController
{
    open override func viewDidLoad() {
        super.viewDidLoad()

        SectionHeaderView.registerIn(tableView: tableView)
    }
}
