//
//  ViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/10/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit
import NXUIKit

class LandingViewController: UIViewController {

    var photoController : UIViewController {
        
        return childViewControllers[0]
    }
    
    var tabController : LandingTabController {
        
        return childViewControllers[1] as! LandingTabController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

