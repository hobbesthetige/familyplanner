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
    }
    
    private func setupTestEvent1() {
        let event = Event(title: "Glenn's 32nd Birthday")
        
        event.color = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        var sComponents = DateComponents()
        
        sComponents.calendar = Calendar.current
        sComponents.year = 2017
        sComponents.day = 17
        sComponents.month = 10
        sComponents.hour = 0
        sComponents.minute = 0
        sComponents.second = 0
        
        event.dateRange = DateRange(singleDate: sComponents.date!)
        
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
}
