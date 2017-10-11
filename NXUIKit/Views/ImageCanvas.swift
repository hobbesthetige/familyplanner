//
//  ImageCanvas.swift
//  Annotate
//
//  Created by Joseph Sferrazza on 2/28/16.
//  Copyright © 2016 Sferrazza. All rights reserved.
//

import UIKit

class ImageCanvas: UIImageView {
    
    var canvas = Canvas()
    
    init() {
        super.init(frame: CGRect.zero)
        
        setUpCanvas()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpCanvas()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpCanvas()
    }
    
    fileprivate func setUpCanvas() {
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFit
        canvas.contentMode = .scaleAspectFit
        canvas.backgroundColor = UIColor.clear
        canvas.translatesAutoresizingMaskIntoConstraints = false
        let canvasContraints = NSLayoutConstraint.constraintsByAligning(item: canvas, toItem: self, usingAttributes: [.top, .leading, .bottom, .trailing])
        addSubview(canvas)
        addConstraints(canvasContraints)
    }

    override func didMoveToSuperview() {
        if let view = superview {
            tintColor = view.tintColor
            canvas.tintColor = view.tintColor
        }
    }
}
