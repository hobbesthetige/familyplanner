//
//  EventsViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/16/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit
import AppData

public class EventsViewController : UITableViewController
{
    var events = [Event]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvents()
    }
    
    private func setupEvents() {
        
        setupTestEvent1()
        setupTestEvent2()
        setupTestEvent3()
        setupTestEvent4()
    }
    
    private func setupTestEvent1() {
        let event = Event(title: "Glenn's 32nd Birthday")
        
        event.color = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        event.description = "Happy\nBirthday\nBro!\nHope you have\na great day!"
        
        var sComponents = DateComponents()
        
        sComponents.calendar = Calendar.current
        sComponents.year = 2017
        sComponents.day = 17
        sComponents.month = 10
        sComponents.hour = 0
        sComponents.minute = 0
        sComponents.second = 0
        
        event.dateRange = DateRange(singleDate: sComponents.date!)
        
        let locationBuilder = LocationBuilder(title: "The Blue House", coordinate: (34.988189,-80.266907))
        locationBuilder.street = "103 Upper White Store Road"
        locationBuilder.city = "Peachland"
        locationBuilder.state = "NC"
        locationBuilder.zipcode = "28133"
        locationBuilder.createLocation { (location) in
            
            if let location = location {
                event.location = location
            }
        }
        
        event.inviteAllFamily()
        
        if let invitee = event.invitations.last {
           
            let response = EventInvitationResponse(type: .attending, comments: "Looking forward to it!")
            invitee.respond(response: response)
        }
        
        let item1 = EventChecklistItem(title: "Bring the turkey")
        let item2 = EventChecklistItem(title: "Need three casseroles")
        let item3 = EventChecklistItem(title: "Volunteer for bringing drinks")
        
        item3.markAsComplete(by: FamilyMember.dad, notes: "I got this. 💪🏻")
        
        event.checklistItems = [item1,item2,item3]
        
        let comment1 = EventComment(comments: "Wassupppppp!!! Looking forward to this.", author: FamilyMember.dansFamily.husband)
        
        let comment2 = EventComment(comments: "I'll be in my room hiding.", author: FamilyMember.dansFamily.wife)
        
        event.comments = [comment1,comment2]
        
        events.append(event)
    }
    private func setupTestEvent2() {
        let event = Event(title: "2017 Thanksgiving")
        
        event.color = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        var sComponents = DateComponents()
        
        sComponents.calendar = Calendar.current
        sComponents.year = 2017
        sComponents.day = 23
        sComponents.month = 11
        sComponents.hour = 0
        sComponents.minute = 0
        sComponents.second = 0
        
        event.dateRange = DateRange(singleDate: sComponents.date!)
        
        events.append(event)
    }
    private func setupTestEvent3() {
        let event = Event(title: "2017 Family Christmas")
        
        event.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        var sComponents = DateComponents()
        
        sComponents.calendar = Calendar.current
        sComponents.year = 2017
        sComponents.day = 25
        sComponents.month = 12
        sComponents.hour = 0
        sComponents.minute = 0
        sComponents.second = 0
        
        event.dateRange = DateRange(singleDate: sComponents.date!)
        
        events.append(event)
    }
    private func setupTestEvent4() {
        let event = Event(title: "Meachum Christmas @ Pam & Steve's Lake House")
        
        event.color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        events.append(event)
    }
    
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let event = events[indexPath.row]
        
        if let viewModel = EventCellViewModel(event: event) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventCell
            
            cell.model = viewModel
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "nodate_cell", for: indexPath) as! NoDateEventCell
            
            cell.model = NoDateEventCellViewModel(event: event)
            
            return cell
        }
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "event" {
            
            if let cell = sender as? EventCell, let model = cell.model {
                
                let event = model.event
                
                let controller = segue.destination as! EventViewController
                
                controller.event = event
            }
            else if let cell = sender as? NoDateEventCell, let model = cell.model {
                
                let event = model.event
                
                let controller = segue.destination as! EventViewController
                
                controller.event = event
            }
        }
    }
}
