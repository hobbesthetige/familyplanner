//
//  NXPhotoLibraryCollectionViewCell.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/23/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit
import NXConstraintKit
import Photos



class NXPhotoLibraryGridCollectionViewCell: UICollectionViewCell {
    
    fileprivate var downloadingLabel = UILabel()
    fileprivate var progressBar = UIProgressView()
    fileprivate var imageView = UIImageView()
    fileprivate var checkedImageView = UIImageView(image: UIImage(identifier: .CheckCircleIcon).withRenderingMode(.alwaysTemplate))
    fileprivate var xCircleImageView = UIImageView(image: UIImage(identifier: .XCircleIcon).withRenderingMode(.alwaysTemplate))
    
    var asset: NXPhotoAsset? {
        didSet {
            if let asset = asset {
                imageView.image = asset.thumbnailImage
                if asset.highQualityImageProgress < 1.0 {
                    if asset.highQualityImageProgress > 0.0 {
                        progressBar.progress = Float(asset.highQualityImageProgress)
                        progressBar.alpha = 1.0
                        downloadingLabel.alpha = 1.0
                    }
                    observeAsset()
                }
            }
        }
    }
    var selectionHandler: ((_ selected: Bool, _ asset: NXPhotoAsset?) -> Void)?
    var selectedBorderWidth: CGFloat = 2.0
    
    override var isSelected: Bool {
        didSet {
            if oldValue != isSelected && window != nil {
                if !isSelected {
                    hideDownloadSubviewsAnimated(true)
                }
                layer.borderWidth = isSelected ? selectedBorderWidth : 0.0
                if let handler = selectionHandler {
                    handler(isSelected, asset)
                }
                performSelectionAnimation()
            }
        }
    }
    
    override func didMoveToSuperview() {
        if superview != nil {
            layer.borderColor = tintColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepareForReuse() {
        // Clear the asset before calling super so it's gone before the 'selected' property of this cell is changed
        asset = nil
        hideDownloadSubviewsAnimated(false)
        super.prepareForReuse()
    }
}


//
// MARK: Internal
//
extension NXPhotoLibraryGridCollectionViewCell {
    func updateThumbnail() {
        imageView.image = asset?.thumbnailImage
    }
}


//
// MARK: Private
//
extension NXPhotoLibraryGridCollectionViewCell {
    fileprivate func hideDownloadSubviewsAnimated(_ animated: Bool) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseIn], animations: {
            self.downloadingLabel.alpha = 0.0
            self.xCircleImageView.alpha = 0.0
        }) { (finished) in
        }
        UIView.animate(withDuration: 0.25, delay: 0.15, options: [.curveEaseIn], animations: {
            self.progressBar.alpha = 0.0
            }, completion: { (finished) in
                
        })
    }
    
    fileprivate func initialize() {
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 0.0
        
        if imageView.superview == nil {
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            let imageViewConstraints = NSLayoutConstraint.constraintsByAligning(item: imageView, toItem: self, usingAttributes: [.top, .leading, .bottom, .trailing])
            addConstraints(imageViewConstraints)
            
            addSubview(checkedImageView)
            checkedImageView.alpha = 0.0
            checkedImageView.translatesAutoresizingMaskIntoConstraints = false
            checkedImageView.tintColor = UIColor.white
            let checkConstraints = NSLayoutConstraint.constraintsByAligning(item: checkedImageView, toItem: self, usingAttributes: [.centerX, .centerY])
            addConstraints(checkConstraints)
            
            addSubview(xCircleImageView)
            xCircleImageView.alpha = 0.0
            xCircleImageView.translatesAutoresizingMaskIntoConstraints = false
            xCircleImageView.tintColor = UIColor.red
            let xConstraints = NSLayoutConstraint.constraintsByAligning(item: xCircleImageView, toItem: self, usingAttributes: [.centerX, .centerY])
            addConstraints(xConstraints)
            
            progressBar.progress = 0.0
            progressBar.alpha = 0.0
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            addSubview(progressBar)
            let progressConstraints = NSLayoutConstraint.constraintsByAligning(item: progressBar, toItem: self, usingAttributes: [.leading, .bottom, .trailing], offsets: [0.0, -selectedBorderWidth, 0.0])
            addConstraints(progressConstraints)
            
            downloadingLabel.alpha = 0.0
            downloadingLabel.text = "Downloading..."
            downloadingLabel.font = UIFont.systemFont(ofSize: 10.0)
            downloadingLabel.textColor = UIColor.white
            downloadingLabel.textAlignment = .center
            downloadingLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(downloadingLabel)
            var downloadingConstraints = NSLayoutConstraint.constraintsByAligning(item: downloadingLabel, toItem: progressBar, usingAttributes: [.centerX])
            downloadingConstraints += [NSLayoutConstraint(item: downloadingLabel, attribute: .bottom, relatedBy: .equal, toItem: progressBar, attribute: .top, multiplier: 1.0, constant: -4.0)]
            addConstraints(downloadingConstraints)
        }
    }
    
    fileprivate func observeAsset() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NXPhotoAssetProgressUpdatedNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NXPhotoAssetFinishedDownloadingNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NXPhotoAssetFailedToDownloadNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.progressUpdated(_:)), name: NSNotification.Name(rawValue: NXPhotoAssetProgressUpdatedNotification), object: asset)
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadFailed(_:)), name: NSNotification.Name(rawValue: NXPhotoAssetFailedToDownloadNotification), object: asset)
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadFinished(_:)), name: NSNotification.Name(rawValue: NXPhotoAssetFinishedDownloadingNotification), object: asset)
    }
    
    fileprivate func performSelectionAnimation() {
        xCircleImageView.alpha = 0.0
        checkedImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.imageView.alpha = self.isSelected ? 0.3 : 1.0
            
            if self.isSelected {
                self.checkedImageView.alpha = 1.0
                self.checkedImageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }
        }) { (finished) in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                self.checkedImageView.transform = self.isSelected ? CGAffineTransform(scaleX: 1.0, y: 1.0) : CGAffineTransform(scaleX: 3.0, y: 3.0)
                
                if !self.isSelected {
                    self.checkedImageView.alpha = 0.0
                }
            }) { (finished) in
                self.checkedImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
}


//
// MARK: Notification Responders
//
extension NXPhotoLibraryGridCollectionViewCell {
    func downloadFailed(_ notification: Notification) {
        OperationQueue.main.addOperation({
            self.progressBar.alpha = 0.0
            self.xCircleImageView.alpha = 1.0
            self.checkedImageView.alpha = 0.0
            self.downloadingLabel.alpha = 0.0
        })
    }
    
    func downloadFinished(_ notification: Notification) {
        OperationQueue.main.addOperation({
            self.hideDownloadSubviewsAnimated(true)
        })
    }
    
    func progressUpdated(_ notification: Notification) {
        if let progress = (notification as NSNotification).userInfo?["progress"] as? Double {
            // Only show the progress bar if we need to
            // If the photo is already local to the device a progress of 1 gets called immediately after 0.0
            // Don't present the progress bar in this instance to avoid it flashing on screen quickly then disappearing.
            OperationQueue.main.addOperation({
                if progress > 0.0 {
                    self.progressBar.alpha = 1.0
                    self.downloadingLabel.alpha = 1.0
                    self.progressBar.progress = Float(progress)
                }
            })
        }
    }
}
