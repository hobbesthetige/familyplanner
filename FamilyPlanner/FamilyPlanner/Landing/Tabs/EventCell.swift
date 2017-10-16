//
//  EventCell.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/16/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit
import AppUI
import AppData

public protocol EventViewModel
{
    var event : Event { get }
}

public struct NoDateEventCellViewModel : EventViewModel
{
    public let event : Event
    
    let title : String
    
    let color : UIColor
    
    public init(event : Event) {
        
        self.event = event
        
        title = event.title
        color = event.color
    }
}

public struct EventCellViewModel : EventViewModel
{
    public let event : Event
    
    let startDay : String
    
    let startMonth : String
    
    let endDay : String
    
    let title : String
    
    let color : UIColor
    
    let isSingleDate : Bool
    
    let isComplete : Bool
    
    public init?(event : Event) {
        
        guard let dateRange = event.dateRange else { return nil }
        
        self.event = event
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        startDay = calendar.component(.day, from: dateRange.startDate).description
        endDay = calendar.component(.day, from: dateRange.endDate).description
        startMonth = formatter.string(from: dateRange.startDate)
        
        title = event.title
        color = event.color
        isSingleDate = dateRange.isSingleDate
        isComplete = event.isComplete
    }
}

public class EventCell : UITableViewCell
{
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet var thruLabel : UILabel!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var circleView : CircleView!
    @IBOutlet weak var dateStackView: UIStackView!
    
    public var model : EventCellViewModel? {
        
        didSet {
            
            monthLabel.text = model?.startMonth
            dateLabel.text = model?.startDay
            
            titleLabel.text = model?.title
            circleView.backgroundColor = model?.color
            
            if model?.isSingleDate == true {
                
                hideThruLabel()
            }
            else {
                thruLabel.text = "thru " + (model?.endDay ?? "")
                
                showThruLabel()
            }
            
            if model?.isComplete == true {
                
                markAsCompleted()
            }
            else {
                markAsIncomplete()
            }
        }
    }
    
    private func showThruLabel() {
        
        if thruLabel.superview == nil {
            
            dateStackView.addArrangedSubview(thruLabel)
        }
    }
    
    private func hideThruLabel() {
        
        if thruLabel.superview != nil {
            
            dateStackView.removeArrangedSubview(thruLabel)
            
            thruLabel.removeFromSuperview()
        }
    }
    
    private func markAsCompleted() {
        
        guard let text = titleLabel.text else { return }
        
        titleLabel.attributedText = NSAttributedString(string: text, attributes: FontStyle.strikethroughBody)
        
        let views = [monthLabel,dateLabel,thruLabel]
        
        for view in views {
            view?.textColor = .lightGray
        }
    }
    
    private func markAsIncomplete() {
        
        guard let text = titleLabel.text else { return }
        
        titleLabel.attributedText = NSAttributedString(string: text, attributes: FontStyle.body)
        
        let views = [monthLabel,dateLabel,thruLabel]
        
        for view in views {
            view?.textColor = .black
        }
    }
}

public class NoDateEventCell : UITableViewCell
{
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var circleView : CircleView!
    
    public var model : NoDateEventCellViewModel? {
        
        didSet {
            
            titleLabel.text = model?.title
            circleView.backgroundColor = model?.color
        }
    }
}
