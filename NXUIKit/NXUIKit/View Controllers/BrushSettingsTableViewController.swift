//
//  BrushSettingsTableViewController.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/16/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit

class BrushSettingsTableViewController: UITableViewController {

    fileprivate let ColorCellTag = 201
    
    @IBOutlet weak var brushSlider: UISlider!
    @IBOutlet weak var brushPreview: BrushPreviewView!
    @IBOutlet weak var colorView: UIView!
    
    var brushColor: UIColor = ColorPalette.Defaults.Annotations.StrokeColor {
        didSet {
            if isViewLoaded {
                colorView.backgroundColor = brushColor
            }
        }
    }
    var brushThickness: CGFloat = 2.0 {
        didSet {
            if isViewLoaded {
                brushSlider.value = Float(brushThickness)
            }
        }
    }
    
    var updateBlock: ((_ thickness: CGFloat, _ color: UIColor) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        colorView.layer.cornerRadius = colorView.bounds.width / 2.0
    }
    
    class func initializeFromStoryboard() -> BrushSettingsTableViewController {
        return UIStoryboard(name: "NXUIKitStoryboard", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "BrushSettingsTableViewController") as! BrushSettingsTableViewController
    }
}


// MARK: Actions
extension BrushSettingsTableViewController {
    @IBAction func brushThicknessChanged(_ sender: UISlider) {
        brushThickness = CGFloat(sender.value)
        brushPreview.radius = brushThickness
        update()
    }
}


// MARK: Private
extension BrushSettingsTableViewController {
    func dismissVC() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setUpView() {
        title = "Settings"
        preferredContentSize = CGSize(width: 300.0, height: 400.0)
        
        view.backgroundColor = UIColor.clear
        
        if let navView = navigationController?.view {
            navView.backgroundColor = UIColor.clear
            let blurBackground = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            blurBackground.translatesAutoresizingMaskIntoConstraints = false
            navView.insertSubview(blurBackground, at: 0)
            let blurContraints = NSLayoutConstraint.constraintsByAligning(item: blurBackground, toItem: navView, usingAttributes: [.top, .leading, .bottom, .trailing])
            navView.addConstraints(blurContraints)
        }
        brushSlider.minimumValue = 1.0
        brushSlider.maximumValue = 15.0
        brushSlider.value = Float(brushThickness)
        brushPreview.radius = brushThickness
        
        colorView.backgroundColor = brushColor
        colorView.layer.borderColor = UIColor.black.cgColor
        colorView.layer.borderWidth = 0.5
        
        let applyButton = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(self.dismissVC))
        navigationItem.rightBarButtonItem = applyButton
    }
    
    func showColorPicker() {
        let colorPicker = ColorPickerCollectionViewController()
        colorPicker.selectionHandler = { [weak self] (color) in
            self?.brushColor = color
            _ = self?.navigationController?.popViewController(animated: true)
            self?.update()
        }
        colorPicker.title = "Select a Color"
        navigationController?.pushViewController(colorPicker, animated: true)
    }
    
    func update() {
        if let updateBlock = updateBlock {
            updateBlock(brushThickness, brushColor)
        }
    }
}


// MARK: UITableViewDelegate
extension BrushSettingsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), cell.tag == ColorCellTag {
            showColorPicker()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.tag == ColorCellTag {
            colorView.backgroundColor = brushColor
        }
    }
}
