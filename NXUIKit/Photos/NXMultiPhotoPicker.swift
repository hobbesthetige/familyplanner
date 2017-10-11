//
//  NXMultiPhotoPicker.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/23/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit

open class NXMultiPhotoPicker: UINavigationController {

    open override var title: String? {
        didSet {
            if topViewController is NXPhotoLibraryCollectionViewController && topViewController?.title != title {
                topViewController?.title = title
            }
        }
    }
    
    open var options = NXPhotoPickerOptions() {
        didSet {
            if let photosView = topViewController as? NXPhotoLibraryCollectionViewController {
                photosView.options = options
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init() {
        let layout = UICollectionViewFlowLayout()
        let root = NXPhotoLibraryCollectionViewController(collectionViewLayout: layout)
        super.init(rootViewController: root)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}


//
// MARK: UIViewController
//
extension NXMultiPhotoPicker {
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
