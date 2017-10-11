//
//  NXAnnotationHelpViewController.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/21/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit

class NXAnnotationHelpViewController: UIViewController {

    @IBOutlet weak var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurView.layer.cornerRadius = 20.0
        blurView.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeWasTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    class func instantiateFromStoryboard() -> NXAnnotationHelpViewController {
        return UIStoryboard(name: "NXUIKitStoryboard", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "AnnotationHelp") as! NXAnnotationHelpViewController
    }
    
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        if let presenter = presentingViewController {
            return presenter.preferredStatusBarStyle
        }
        return .lightContent
    }
}
