//
//  NXPhotoAsset.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/24/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit
import PhotosUI

let NXPhotoAssetFailedToDownloadNotification = "nxphotoasset.failedtodownloadimage"
let NXPhotoAssetProgressUpdatedNotification = "nxphotoasset.downloadprogressupdated"
let NXPhotoAssetFinishedDownloadingNotification = "nxphotoasset.finisheddownloadingimage"

class NXPhotoAsset {
    var libraryAsset: PHAsset
    var thumbnailImage: UIImage?
    var highQualityImage: UIImage?
    
    fileprivate(set) var highQualityImageProgress: Double = 0.0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: NXPhotoAssetProgressUpdatedNotification), object: self, userInfo: ["progress" : highQualityImageProgress])
        }
    }
    
    fileprivate var highQualityRequestID: PHImageRequestID?
    
    init(asset: PHAsset) {
        libraryAsset = asset
    }
}


//
// MARK: Internal
//
extension NXPhotoAsset {
    /// Cancels the high quality image request and clears the high quality image stored in memory.
    func cancelRequestsAndClearImage(_ shouldClear: Bool) {
        if let requestID = highQualityRequestID {
            PHImageManager.default().cancelImageRequest(requestID)
        }
        if shouldClear {
            highQualityImage = nil
        }
    }
    
    
    /// Requests the high quality version of this asset from the image manager. Use the NXPhotoAsset notifications to mointor progress.
    func requestHighQualityImageOfSize(_ size: CGSize, contentMode: PHImageContentMode) {
        requestHighQualityImageOfSize(size, contentMode: contentMode, completion: nil)
    }
    
    /// Requests the high quality version of this asset from the image manager. Use the NXPhotoAsset notifications to mointor progress.  Calls the specified completion block when finished.
    func requestHighQualityImageOfSize(_ size: CGSize, contentMode: PHImageContentMode, completion: ((_ success: Bool, _ error: NSError?) -> Void)?) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = true
        options.progressHandler = { (progress, error, stop, info) in
            if let error = error {
                self.highQualityImage = nil
                NotificationCenter.default.post(name: Notification.Name(rawValue: NXPhotoAssetFailedToDownloadNotification), object: self, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription])
            }
            else {
                self.highQualityImageProgress = progress
            }
        }
        
        self.highQualityImageProgress = 0.0
        PHImageManager.default().requestImage(for: libraryAsset, targetSize: size, contentMode: contentMode, options: options, resultHandler: { (image, info) in
            if let image = image {
                self.highQualityImage = image
                NotificationCenter.default.post(name: Notification.Name(rawValue: NXPhotoAssetFinishedDownloadingNotification), object: self, userInfo: nil)
            }
            else {
                self.highQualityImage = nil
                NotificationCenter.default.post(name: Notification.Name(rawValue: NXPhotoAssetFailedToDownloadNotification), object: self, userInfo: [NSLocalizedDescriptionKey : "No image was returned."])
            }
        })
    }
}
