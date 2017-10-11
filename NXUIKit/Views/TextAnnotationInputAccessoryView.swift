//
//  TextAnnotationInputAccessoryView.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/21/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit

class TextAnnotationInputAccessoryView: UIView {
    
    var fontSize: CGFloat = 18.0
    var color = ColorPalette.Defaults.Annotations.TextColor
    var update: ((_ color: UIColor, _ font: UIFont) -> Void)?
    var getColor: (() -> Void)?
    
    fileprivate let fontSizeLabel = UILabel()
    fileprivate let minusButton = UIButton(type: .system)
    fileprivate let plusButton = UIButton(type: .system)
    fileprivate let textButton = UIButton(type: .system)
    
    fileprivate struct FontLimits {
        static let Min: CGFloat = 6.0
        static let Max: CGFloat = 48.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        let background = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        background.translatesAutoresizingMaskIntoConstraints = false
        addSubview(background)
        let backgroundConstraints = NSLayoutConstraint.constraintsByAligning(item: background, toItem: self, usingAttributes: [.top, .leading, .bottom, .trailing])
        addConstraints(backgroundConstraints)
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.setImage(UIImage(identifier: .MinusIcon), for: UIControlState())
        minusButton.addTarget(self, action: #selector(self.decrementFontSize), for: .touchUpInside)
        background.contentView.addSubview(minusButton)
        var minusButtonConstraints = NSLayoutConstraint.constraintsByAligning(item: minusButton, toItem: background.contentView, usingAttributes: [.centerY, .leading], offsets: [0.0, 8.0])
        minusButtonConstraints += [NSLayoutConstraint(setValueForSingleItem: minusButton, attribute: .height, to: 44.0), NSLayoutConstraint(setValueForSingleItem: minusButton, attribute: .width, to: 44.0)]
        background.contentView.addConstraints(minusButtonConstraints)
        
        fontSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        fontSizeLabel.textColor = UIColor.white
        fontSizeLabel.text = "\(fontSize) pt"
        background.contentView.addSubview(fontSizeLabel)
        var fontSizeLabelConstraints = NSLayoutConstraint.constraintsByAligning(item: fontSizeLabel, toItem: minusButton, usingAttributes: [.centerY])
        fontSizeLabelConstraints.append(NSLayoutConstraint(item: fontSizeLabel, attribute: .leading, relatedBy: .equal, toItem: minusButton, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        background.contentView.addConstraints(fontSizeLabelConstraints)
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setImage(UIImage(identifier: .PlusIcon), for: UIControlState())
        plusButton.addTarget(self, action: #selector(self.incrementFontSize), for: .touchUpInside)
        background.contentView.addSubview(plusButton)
        var plusButtonConstraints = NSLayoutConstraint.constraintsByAligning(item: plusButton, toItem: fontSizeLabel, usingAttributes: [.centerY])
        plusButtonConstraints.append(NSLayoutConstraint(item: fontSizeLabel, attribute: .trailing, relatedBy: .equal, toItem: plusButton, attribute: .leading, multiplier: 1.0, constant: 0.0))
        plusButtonConstraints += [NSLayoutConstraint(setValueForSingleItem: plusButton, attribute: .height, to: 44.0), NSLayoutConstraint(setValueForSingleItem: plusButton, attribute: .width, to: 44.0)]
        background.contentView.addConstraints(plusButtonConstraints)
        
        textButton.translatesAutoresizingMaskIntoConstraints = false
        textButton.setImage(UIImage(identifier: .TextColorIcon), for: UIControlState())
        textButton.addTarget(self, action: #selector(self.colorWasTapped(_:)), for: .touchUpInside)
        background.contentView.addSubview(textButton)
        var textButtonConstraints = NSLayoutConstraint.constraintsByAligning(item: textButton, toItem: background.contentView, usingAttributes: [.centerY, .trailing], offsets: [0.0, -8.0])
        textButtonConstraints += [NSLayoutConstraint(setValueForSingleItem: textButton, attribute: .height, to: 44.0), NSLayoutConstraint(setValueForSingleItem: textButton, attribute: .width, to: 44.0)]
        background.contentView.addConstraints(textButtonConstraints)
    }
}


// MARK: Actions
extension TextAnnotationInputAccessoryView {
    func colorWasTapped(_ sender: AnyObject) {
        if let getColor = getColor {
            getColor()
        }
    }
    
    func decrementFontSize() {
        fontSize -= 1.0
        fontSize = max(FontLimits.Min, fontSize)
        fontSizeLabel.text = "\(fontSize) pt"
        updateButtonAvailability()
        if let update = update {
            update(color, UIFont.systemFont(ofSize: fontSize))
        }
    }
    
    func incrementFontSize() {
        fontSize += 1.0
        fontSize = min(FontLimits.Max, fontSize)
        fontSizeLabel.text = "\(fontSize) pt"
        updateButtonAvailability()
        if let update = update {
            update(color, UIFont.systemFont(ofSize: fontSize))
        }
    }
    
    func updateButtonAvailability() {
        minusButton.isEnabled = fontSize > FontLimits.Min
        plusButton.isEnabled = fontSize < FontLimits.Max
    }
}
