//
//  CalendarDetailsViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 11/14/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit
import AppData

public class EventCalendarDetailsViewController : UIViewController
{
    var event : Event!
    
    @IBOutlet weak var startDateLabel : UILabel!
    
    @IBOutlet weak var endDateLabel : UILabel!
    
    @IBOutlet weak var titleLabel : UILabel!
    
    @IBOutlet var subtitleLabel : UILabel!
    
    @IBOutlet var organizerLabel : UILabel!
    
    @IBOutlet weak var eventDetailsStackView : UIStackView!
    
    @IBOutlet weak var descriptionTextView : UITextView!
    
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension EventCalendarDetailsViewController
{
    private func setup() {
        
        setupDate()
        setupDetails()
        setupDescriptionTextView()
        setupOrganizerDetails()
    }
    
    private func setupDate() {
        
        if let dateRange = event.dateRange {
            
            startDateLabel.text = "Starts " + dateRange.startDate.string(dateStyle: .medium, timeStyle: .short, in: nil)
            
            if dateRange.isAllDay {
                
                endDateLabel.text = "All day event"
            }
            else if dateRange.isSameDay {
                
                endDateLabel.text = "until " + dateRange.endDate.string(dateStyle: .none, timeStyle: .short, in: nil)
            }
            else {
                
                endDateLabel.text = "Ends " + dateRange.endDate.string(dateStyle: .medium, timeStyle: .short, in: nil)
            }
        }
    }
    
    private func setupDetails() {
        
        titleLabel.text = event.title
        
        subtitleLabel.text = event.subtitle
        
        if event.subtitle != nil {
            
            if subtitleLabel.superview == nil {
                
                eventDetailsStackView.addArrangedSubview(subtitleLabel)
            }
        }
        else {
            
            eventDetailsStackView.removeArrangedSubview(subtitleLabel)
            
            subtitleLabel.removeFromSuperview()
        }
    }
    
    private func setupOrganizerDetails() {
        
        organizerLabel.text = "Organized by " + event.author.firstName + " on " + event.createdDate.string(dateStyle: .short, timeStyle: .none, in: nil)
    }
    
    private func setupDescriptionTextView() {
        
        descriptionTextView.layer.cornerRadius = 3
        descriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.35).cgColor
        descriptionTextView.layer.borderWidth = 0.5
        
        if let description = event?.description {
            
            descriptionTextView.text = description
            
            descriptionTextView.font = UIFont.preferredFont(forTextStyle: .body)
        }
        else {
            
            descriptionTextView.text = "No details provided."
            
            descriptionTextView.font = UIFont.italicSystemFont(ofSize: 13.0)
        }
    }
}
