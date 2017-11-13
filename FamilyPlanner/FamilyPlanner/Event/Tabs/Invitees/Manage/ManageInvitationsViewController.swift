//
//  AddinvitationsViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 11/11/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import AppData
import AppUI


public class ManageInvitationsViewController : UITableViewController
{
    var invitations = [EventInvitation]() {
        
        didSet {
            
            modifiedInvitations = Set(invitations)
        }
    }
    
    var modifiedInvitations = Set<EventInvitation>()
    
    private var immediateFamily = FamilyMember.allFamilyRepresentationOfGroup(group: .immediate)
    private var extendedFamily = FamilyMember.allFamilyRepresentationOfGroup(group: .extended)
    
    private let immediateFamilySection = 0
    private let extendedFamilySection = 1
    
    var completionHandler : ([EventInvitation])->Void = { _ in }
    
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isEditing = true
    }
    
    
    @IBAction func cancelButtonAction(sender : UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonAction(sender : UIBarButtonItem) {
        
        showConfirmAlertIfNeeded { [unowned self] in
            
            self.completionHandler(Array(self.modifiedInvitations))
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showConfirmAlertIfNeeded(continueHandler : @escaping ()->Void) {
        
        let difference = Set(invitations).subtracting(modifiedInvitations)
        
        guard !difference.isEmpty else {
            
            continueHandler()
            
            return
        }
        
        let names = difference.map({ $0.familyRepresentation.nameRepresentation })
        
        let message = "Are you sure you want to uninvite " + names.joined(separator: ", ") + "?"
        
        let alertController = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Uninvite & Close", style: .destructive, handler: { (_) in
            
            continueHandler()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ManageInvitationsViewController
{
    public override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == immediateFamilySection {
            
            return max(1, immediateFamily.count)
        }
        
        return max(1, extendedFamily.count)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == immediateFamilySection && immediateFamily.isEmpty {
            
            return tableView.dequeueReusableCell(withIdentifier: "no_results", for: indexPath)
        }
        else if indexPath.section == extendedFamilySection && extendedFamily.isEmpty {
            
            return tableView.dequeueReusableCell(withIdentifier: "no_results", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManageInviteeCell
        
        cell.model = modelFor(indexPath: indexPath)
        
        if cell.model?.response != nil && self.tableView(tableView, canEditRowAt: indexPath) {
            
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = SectionHeaderView.dequeueViewIn(tableView: tableView)
        
        if section  == immediateFamilySection {
            
            view.titleLabel.text = "Immediate Family"
        }
        else {
            
            view.titleLabel.text = "Extended Family"
        }
        
        return view
    }
    
    public override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == immediateFamilySection && immediateFamily.isEmpty {
            
            return nil
        }
        else if indexPath.section == extendedFamilySection && extendedFamily.isEmpty {
            
            return nil
        }
        
        let model = modelFor(indexPath: indexPath)
        
        if model.response?.type == .attending {
            
            return nil //Don't allow invitation to be removed when already accepted
        }
        
        return indexPath
    }
    public override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let model = modelFor(indexPath: indexPath)
        
        if model.response?.type == .attending {
            
            return nil //Don't allow invitation to be removed when already accepted
        }
        
        return indexPath
    }
    
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == immediateFamilySection && immediateFamily.isEmpty {
            
            return false
        }
        else if indexPath.section == extendedFamilySection && extendedFamily.isEmpty {
            
            return false
        }
        
        let model = modelFor(indexPath: indexPath)
        
        if model.response?.type == .attending {
            
            return false //Don't allow invitation to be removed when already accepted
        }
        
        return true
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let familyRepresentation = familyRepresentationFor(indexPath: indexPath)
        
        if let invitation = invitationFor(familyRepresentation: familyRepresentation) {
            
            modifiedInvitations.insert(invitation)
        }
        else {
            
            let invitation = EventInvitation(familyRepresentation: familyRepresentation)
            
            modifiedInvitations.insert(invitation)
        }
    }
    
    public override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let familyRepresentation = familyRepresentationFor(indexPath: indexPath)
        
        if let invitation = modifiedInvitations.first(where: { $0.familyRepresentation.nameRepresentation == familyRepresentation.nameRepresentation }) {
            
            modifiedInvitations.remove(invitation)
        }
    }
}

extension ManageInvitationsViewController
{
    private func familyRepresentationFor(indexPath : IndexPath) -> FamilyRepresentation {
        
        let familyRepresentation : FamilyRepresentation
        
        if indexPath.section == immediateFamilySection {
            
            familyRepresentation = immediateFamily[indexPath.row]
        }
        else {
            familyRepresentation = extendedFamily[indexPath.row]
        }
        
        return familyRepresentation
    }
    
    private func invitationFor(familyRepresentation : FamilyRepresentation) -> EventInvitation? {
        
        return invitations.first(where: { $0.familyRepresentation.nameRepresentation == familyRepresentation.nameRepresentation })
    }
    
    private func modelFor(indexPath : IndexPath) -> (familyRepresentation : FamilyRepresentation, response: EventInvitationResponse?) {
        
        let familyRepresentation = familyRepresentationFor(indexPath: indexPath)
        
        let matchingInvitation = invitationFor(familyRepresentation: familyRepresentation)
        
        return (familyRepresentation, matchingInvitation?.response)
    }
}
