//
//  CalendarTabController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/16/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import NXUIKit

public class LandingTabController : NXTabbedPageViewController
{
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        
        setupUI()
    }
    
    private func setupControllers() {
        
        let controllers = [instantiateEventsController(), instantiateCalendarController()]
        
        configure(using: controllers)
    }
    
    private func instantiateEventsController() -> UIViewController {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "events")
        
        return controller
    }
    
    private func instantiateCalendarController() -> UIViewController {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "memories")
        
        return controller
    }
    
    private func setupUI() {
        
        tabBarView.tabFont = UIFont.preferredFont(forTextStyle: .headline)
        
        tabBarView.tabBackgroundColor = .white
        
    }
}
