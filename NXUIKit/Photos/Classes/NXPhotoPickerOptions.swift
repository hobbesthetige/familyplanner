//
//  NXPhotoPickerOptions.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/24/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit
import Photos

open class NXPhotoPickerOptions: NSObject {
    
    /// Whether or not to allow the user to take photos while the picker is displayed. YES by default.
    open var allowTakingPhotos: Bool = true
    
    /// A completion block which is called when the user either cancels or selects images.  If the user cancels, an empty array is returned.
    open var completion: ((_ images: [UIImage]) -> Void)?
    
    /// The target size for the grid preview cells.  This corresponds to the minimum height & width that a cell will display at.
    ///
    /// Defaults to 100 x 100
    /// - note: This must be less than or equal to the width of the view.
    open var targetPreviewCellLength: CGFloat = 100.0
    
    /// The target size for the images returned in the `completion` closure.
    ///
    /// Defaults to 1000 x 1000
    open var targetPhotoSize = CGSize(width: 1000.0, height: 1000.0)
    
    /// The content mode to use, when sizing to the `targetPhotoSize`, for the high quality image.
    open var photoContentMode = PHImageContentMode.aspectFit
    
    /// The width of the border that is displayed when cells are selected.
    ///
    /// Defaults to 2.0
    open var selectedPhotoBorderWidth: CGFloat = 2.0
    
    /// A custom closure to execute just prior to displaying each photo cell.  Use this to perform custom animations on the cell.
    open var willDisplayCellHandler: ((_ cell: UICollectionViewCell) -> Void)?
}
