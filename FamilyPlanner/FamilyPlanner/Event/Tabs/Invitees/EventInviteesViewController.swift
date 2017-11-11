//
//  EventInviteesViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/23/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import Foundation
import AppData

public class EventInviteesViewController : UITableViewController
{
    public var invitees = [EventInvitees]()
    
    @IBOutlet private weak var attendingLabel : UILabel!
    @IBOutlet private weak var invitedLabel : UILabel!
    @IBOutlet private weak var noResponseLabel : UILabel!
    @IBOutlet private weak var declinedLabel : UILabel!
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeader()
    }
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return max(1, invitees.count)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if invitees.isEmpty {
            
            return tableView.dequeueReusableCell(withIdentifier: "no_results", for: indexPath)
        }
        
        let invitee = invitees[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventInviteeCell
        
        cell.invitee = invitee
        
        return cell
    }
}

extension EventInviteesViewController
{
    private func setupHeader() {
        
        let invitedCount = invitees.count
        let attendingInvitees = invitees.filter({ $0.response.type == .attending })
        var attendingCount = 0
        attendingInvitees.forEach({ attendingCount += $0.familyRepresentation.size })
        let waitingCount = invitees.filter({ $0.response.type == .notResponded || $0.response.type == .maybe }).count
        let declinedCount = invitees.filter({ $0.response.type == .notAttending }).count
        
        attendingLabel.text = String(attendingCount)
        invitedLabel.text = String(invitedCount)
        noResponseLabel.text = String(waitingCount)
        declinedLabel.text = String(declinedCount)
    }
}

extension EventInviteesViewController
{
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            
            let cell = sender as! EventInviteeCell
            
            let nav = segue.destination as! UINavigationController
            
            let controller = nav.topViewController as! InviteeDetailViewController
            
            controller.invitee = cell.invitee
            
            controller.completionHandler = { [weak self] in
                
                self?.setupHeader()
                
                self?.tableView.reloadData()
            }
        }
    }
}
