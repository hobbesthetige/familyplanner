//
//  EventViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/17/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit
import AppData

public class EventViewController : UIViewController
{
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var thruLabel : UILabel!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionTextView : UITextView!
    @IBOutlet weak var subtitleLabel : UILabel!
    
    @IBOutlet weak var dateStackView: UIStackView!
    
    @IBOutlet weak var backgroundView : UIView!
    @IBOutlet weak var horizontalLine : UIView!
    
    @IBOutlet var showDescriptionConstraint : NSLayoutConstraint!
    @IBOutlet var hideDescriptionConstraint : NSLayoutConstraint!
    
    
    public var event : Event?
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

//
//  MARK: Actions
//
extension EventViewController {
    
    @IBAction func closeButtonAction() {
        
        dismiss(animated: true, completion: nil)
    }
}
