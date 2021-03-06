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
import SwiftDate

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
    
    let isInPast : Bool
    
    let isComplete : Bool
    
    let isOccurringNow : Bool
    
    let relativeTime : String
    
    public init?(event : Event) {
        
        guard let dateRange = event.dateRange else { return nil }
        
        self.event = event
        
        let calendar = Calendar.current
        let formatter = DateFormatters.monthDateFormatter
        
        startDay = calendar.component(.day, from: dateRange.startDate).description
        endDay = calendar.component(.day, from: dateRange.endDate).description
        startMonth = formatter.string(from: dateRange.startDate)
        
        title = event.title
        color = event.color
        isSingleDate = dateRange.isSameDay
        isComplete = event.isComplete
        isInPast = event.isInPast
        isOccurringNow = event.isOccurringNow
        
        relativeTime = event.relativeTime
    }
}

public class EventCell : UITableViewCell
{
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet var thruLabel : UILabel!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var relativeTimeLabel : UILabel!
    @IBOutlet weak var circleView : CircleView!
    @IBOutlet weak var dateStackView: UIStackView!
    
    public var model : EventCellViewModel? {
        
        didSet {
            
            monthLabel.text = model?.startMonth
            dateLabel.text = model?.startDay
            relativeTimeLabel.text = model?.relativeTime
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
            else if model?.isInPast == true {
                
                markAsInPast()
            }
            else if model?.isOccurringNow == true {
                
                markAsOccurringNow()
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
    
    private func markAsInPast() {
        
        guard let text = titleLabel.text else { return }
        
        titleLabel.attributedText = NSAttributedString(string: text, attributes: FontStyle.body)
        
        let views = [monthLabel,dateLabel,thruLabel]
        
        for view in views {
            view?.textColor = .lightGray
        }
    }
    
    private func markAsOccurringNow() {
        
        guard let text = titleLabel.text else { return }
        
        titleLabel.attributedText = NSAttributedString(string: text, attributes: FontStyle.body)
        
        let views = [dateLabel]
        
        for view in views {
            view?.textColor = .red
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
