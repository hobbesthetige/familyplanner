//
//  ColorPickerCollectionViewController.swift
//  ColorPicker
//
//  Created by Joseph Sferrazza on 3/7/16.
//  Copyright © 2016 Sferrazza. All rights reserved.
//

import UIKit


open class ColorPickerCollectionViewController: UICollectionViewController {
    
    open var selectionHandler: ((_ selectedColor: UIColor) -> Void)? {
        didSet {
            // Pass the selction handler down to the collectionview
            if let picker = collectionView as? ColorPickerCollectionView {
                picker.selectionHandler = selectionHandler
            }
        }
    }
    
    public init() {
        super.init(collectionViewLayout: ColorPickerCollectionViewLayout())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let layout = ColorPickerCollectionViewLayout()
        layout.scrollDirection = .vertical
        collectionView = ColorPickerCollectionView(frame: view.bounds, collectionViewLayout: layout)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
