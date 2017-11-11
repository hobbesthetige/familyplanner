//
//  EventViewController+Segue.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/20/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit

extension EventViewController
{
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tabs" {
            
            let controller = segue.destination as! EventTabViewController
            
            controller.event = event
        }
    }
}
