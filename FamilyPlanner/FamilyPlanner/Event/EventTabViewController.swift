//
//  EventTabViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/19/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import NXUIKit
import AppData

public class EventTabViewController : NXTabbedPageViewController
{
    var event : Event?
    
    private(set) var locationController : EventLocationViewController!
    private(set) var attendeesController : EventInviteesViewController!
    private(set) var checklistsController : EventChecklistItemsViewController!
    private(set) var commentsController : EventCommentsViewController!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        
        setupUI()
    }
    
    private func setupControllers() {
        
        instantiateAllControllers()
        
        configure(using: [locationController,attendeesController,checklistsController,commentsController])
    }
    
    private func instantiateAllControllers() {
        
        instantiateLocationController()
        instantiateAttendeesController()
        instantiateChecklistsController()
        instantiateCommentsController()
    }
    
    private func instantiateLocationController() {
        
        locationController = storyboard!.instantiateViewController(withIdentifier: "location") as! EventLocationViewController
        
        locationController.location = event?.location
    }
    
    private func instantiateAttendeesController() {
        
        attendeesController = storyboard!.instantiateViewController(withIdentifier: "attendees") as! EventInviteesViewController
        
        attendeesController.invitees = event?.invitees ?? []
    }
    
    private func instantiateChecklistsController() {
        
        checklistsController = storyboard!.instantiateViewController(withIdentifier: "checklists") as! EventChecklistItemsViewController
        
        checklistsController.checklistItems = event?.checklistItems ?? []
    }
    
    private func instantiateCommentsController() {
        
        commentsController = storyboard!.instantiateViewController(withIdentifier: "comments") as! EventCommentsViewController
        
        commentsController.comments = event?.comments ?? []
    }
    
    private func setupUI() {
        
        tabBarView.tabFont = UIFont.preferredFont(forTextStyle: .headline)
        
        tabBarView.tabBackgroundColor = .white
        
    }
}
