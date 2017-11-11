//
//  EventViewController+Setup.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/17/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import Foundation
import AppData

extension EventViewController
{
    internal func setup() {
        
        setupHeaderUI()
    }
    
    private func setupHeaderUI() {
        
        setupDateUI()
        setupTitles()
    }
    
    private func setupDateUI() {
        
        guard let event = event else { return }
        
        if event.isSingleDate {
            
            hideThruLabelForSingleDate()
        }
        else if let startMonth = event.startMonthFormattedString {
            
            monthLabel.text = startMonth
        }
        else {
            
            hideLabelsForOpenDateRange()
            
            monthLabel.text = "Open"
        }
    }
    
    private func setupTitles() {
        
        guard let event = event else { return }
        
        titleLabel.text = event.title
        
        subtitleLabel.text = event.relativeTime
        
        
        setupDescriptionTextView()
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
    
    private func hideThruLabelForSingleDate() {
        
        removeArrangedView(view: thruLabel)
    }
    
    private func hideLabelsForOpenDateRange() {
        
        removeArrangedView(view: monthLabel)
        removeArrangedView(view: thruLabel)
    }
    
    private func removeArrangedView(view : UIView) {
        
        dateStackView.removeArrangedSubview(view)
        
        view.removeFromSuperview()
    }
}
