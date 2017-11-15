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
        
        subtitleLabel.text = event.relativeTime
        titleLabel.text = event.title
        
        if let dateRange = event.dateRange {
            
            dateLabel.text = Calendar.current.component(.day, from: dateRange.startDate).description
        }
        
        if event.isSingleDate {
            
            hideThruLabelForSingleDate()
        }
        if let startMonth = event.startMonthFormattedString {
            
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
