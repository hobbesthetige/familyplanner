//
//  InviteeDetailViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/28/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import AppUI
import AppData

public class InviteeDetailViewController : UIViewController
{
    var invitee : EventInvitation! {
        
        didSet {
            
            adjustedStatusType = invitee.response.type
        }
    }
    
    var completionHandler = { }
    
    private var adjustedStatusType = EventInvitationResponseType.notResponded
    
    private var attendingAction : SegmentedButtonOption!
    private var notattendingAction : SegmentedButtonOption!
    private var unsureAction : SegmentedButtonOption!
    private var noResponseAction : SegmentedButtonOption!
    
    
    @IBOutlet weak var statusButton : SegmentedButton!
    
    @IBOutlet weak var textField : LineTextField!
    
    @IBOutlet weak var stackView : UIStackView!
    
    @IBAction func cancelButtonAction(sender : UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonAction(sender : UIBarButtonItem) {
        
        invitee.respond(response: EventInvitationResponse(type: adjustedStatusType, comments: textField.text))
        
        completionHandler()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
    
    private func setupButton() {
        
        let action = {
            
            self.resetSuggestions()
            self.prefillResponseIfNeeded()
        }
        
        attendingAction = SegmentedButtonOption(title: "👍", color: #colorLiteral(red: 0, green: 0.6509803922, blue: 0.3647058824, alpha: 1)) {
            
            self.adjustedStatusType = .attending
            action()
        }
        
        notattendingAction = SegmentedButtonOption(title: "👎", color: #colorLiteral(red: 0.9334495664, green: 0.3899522722, blue: 0.2985906601, alpha: 1)) {
            
            self.adjustedStatusType = .notAttending
            action()
        }
        
        unsureAction = SegmentedButtonOption(title: "🤷‍♂️❓", color: #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)) {
            
            self.adjustedStatusType = .maybe
            action()
        }
        
        noResponseAction = SegmentedButtonOption(title: "💭", color: #colorLiteral(red: 0.4975314736, green: 0.5528564453, blue: 0.6072936058, alpha: 1)) {
            
            self.adjustedStatusType = .notResponded
            action()
        }
        
        statusButton.font = UIFont.preferredFont(forTextStyle: .headline)
        
        statusButton.options = [attendingAction, notattendingAction, unsureAction, noResponseAction]
        
        selectInitialOption()
    }
    
    private func selectInitialOption() {
        
        switch adjustedStatusType {
        case .attending: statusButton.selectOption(option: attendingAction)
        case .maybe: statusButton.selectOption(option: unsureAction)
        case .notAttending: statusButton.selectOption(option: notattendingAction)
        case .notResponded: statusButton.selectOption(option: noResponseAction)
        }
        
        textField.text = invitee.response.comments
        
    }
    
    private func resetSuggestions() {
        
        switch adjustedStatusType {
        case .attending:
            
            addSuggestions(suggestions: Responses.attending)
            
        case .maybe:
            
            addSuggestions(suggestions: Responses.unsure)
            
        case .notAttending:
            
            addSuggestions(suggestions: Responses.notAttending)
            
        case .notResponded:
            
            addSuggestions(suggestions: Responses.noResponse)
        }
    }
    
    private func addSuggestions(suggestions : [String]) {
        
        removeAllSuggestions()
        
        for suggestion in suggestions {
            
            let button = UIButton()
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            
            button.setTitleColor(UIManager.darkTintColor, for: .normal)
            
            button.setTitle(suggestion, for: .normal)
            
            button.addTarget(self, action: #selector(self.suggestionButtonAction(sender:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    private func prefillResponseIfNeeded() {
        
        if let text = textField.text, !text.isEmpty && !Responses.allResponses.contains(text) {
            
            return
        }
        
        switch adjustedStatusType {
        case .attending:
            
            textField.text = Responses.attending.randomItem()
            
        case .maybe:
            
            textField.text = Responses.unsure.randomItem()
            
        case .notAttending:
            
            textField.text = Responses.notAttending.randomItem()
            
        case .notResponded:
            
            textField.text = Responses.noResponse.randomItem()
        }
    }
    
    private func removeAllSuggestions() {
        
        for view in stackView.arrangedSubviews {
            
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    @objc func suggestionButtonAction(sender : UIButton) {
        
        textField.text = sender.title(for: .normal)
    }
}

extension InviteeDetailViewController : UITextFieldDelegate
{
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            
            textField.selectAll(nil)
        }
    }
}

fileprivate struct Responses
{
    static let attending = ["Can't wait!","I'm so pumped!","I'll be there!","We'll be late ⌚️","Looking forward to it!","See you then!"]
    
    static let notAttending = ["Out of town on this weekend","I can't make it","I'm busy. Leave me alone! 👹","I would never in my life...","I don't want to be where Glenn is...","I'm sick"]
    
    static let unsure = ["Let me check with the wifey...","I'll check my calendar 📅","Let me ask my girlfriend if we're busy..."]
    
    static let noResponse = ["I'm busy taking a dump right now. BRB","I'm still thinking on this one...","'BRB' - God"]
    
    static var allResponses : [String] {
        
        return attending + notAttending + unsure + noResponse
    }
}

public func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
    let length = Int64(range.upperBound - range.lowerBound + 1)
    let value = Int64(arc4random()) % length + Int64(range.lowerBound)
    return T(value)
}

extension Collection {
    func randomItem() -> Self.Iterator.Element {
        let count = distance(from: startIndex, to: endIndex)
        let roll = randomNumber(inRange: 0...count-1)
        return self[index(startIndex, offsetBy: roll)]
    }
}
