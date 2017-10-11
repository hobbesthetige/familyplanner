//
//  PhotoLibraryCollectionViewController.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/23/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit
import PhotosUI

private let reuseIdentifier = "Cell"

class NXPhotoLibraryCollectionViewController: UICollectionViewController {

    fileprivate var savingPhotoIndicator: NXIndicatorView?
    fileprivate var thumbnailSize = CGSize.zero
    fileprivate var allPhotosFetchResult: PHFetchResult<PHAsset>?
    fileprivate lazy var cacheManager: PHCachingImageManager? = {
        return PHCachingImageManager()
    }()
    fileprivate(set) var selections = [NXPhotoAsset]()
    
    internal var options = NXPhotoPickerOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let multiPicker = navigationController as? NXMultiPhotoPicker {
            options = multiPicker.options
        }
        assert(navigationController != nil, "\(self) must be presented inside a UINavigationController")
        
        initialViewSetUp()
        fetchAllPhotos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calculateThumbnailSize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if size.width != view.bounds.size.width {
            coordinator.animate(alongsideTransition: { (context) in
                self.updateLayoutForSize(size)
                }) { (context) in
            }
        }
    }
}


//
// MARK: Private Actions
//
extension NXPhotoLibraryCollectionViewController {
    @objc fileprivate func cameraTapped() {
        takePhoto()
    }
    
    @objc fileprivate func cancel() {
        if let completion = options.completion {
            completion([])
        }
    }
    
    @objc fileprivate func done() {
        guard selections.count > 0 else {
            let alert = UIAlertController(title: "No Selection", message: "Please select at least one photo.", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            return
        }
        
        var undownloadedCount = 0
        for item in selections {
            if item.highQualityImage == nil {
                undownloadedCount += 1
            }
        }
        
        guard undownloadedCount == 0 else {
            let photoText = undownloadedCount == 1 ? "photo is" : "photos are"
            let alert = UIAlertController(title: "Still Downloading", message: "\(undownloadedCount) \(photoText) still downloading or failed to download.  Remove it from your selection or wait for it to finish.", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            return
        }
        if let completion = options.completion {
            let images = selections.flatMap { $0.highQualityImage }
            completion(images)
        }
    }
}


//
// MARK: Private
//
extension NXPhotoLibraryCollectionViewController {

    fileprivate func addCameraToolbar() {
        if options.allowTakingPhotos {
            let bottomToolbar = UIToolbar()
            bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
            
            let cameraButtonItem = UIBarButtonItem(image: UIImage(identifier: .CameraIcon), style: .plain, target: self, action: #selector(self.cameraTapped))
            cameraButtonItem.isEnabled = UIImagePickerController.isCameraDeviceAvailable(.rear)
            let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            bottomToolbar.items = [flexItem, cameraButtonItem]
            
            let toolbarConstraints = NSLayoutConstraint.constraintsByAligning(item: bottomToolbar, toItem: view, usingAttributes: [.leading, .trailing, .bottom])
            view.addSubview(bottomToolbar)
            view.addConstraints(toolbarConstraints)
        }
    }
    
    fileprivate func calculateThumbnailSize() {
        let screenScale = UIScreen.main.scale
        if let cellSize = (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize {
            thumbnailSize = CGSize(width: cellSize.width * screenScale, height: cellSize.height * screenScale)
        }
    }
    
    fileprivate func fetchAllPhotos() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            allPhotosFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
        case .denied, .restricted:
            let alert = UIAlertController(title: "Access Denied", message: "You've denied access to your photo library.  You can change this in the settings app.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                self.cancel()
            }))
            if let handler = NXUIKitManager.defaultManager.openSettingsHandler {
                alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
                    handler()
                }))
            }
            alert.view.tintColor = view.tintColor
            present(alert, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                OperationQueue.main.addOperation({ 
                    switch status {
                    case .authorized:
                        self.fetchAllPhotos()
                        self.collectionView?.reloadData()
                    case .denied, .restricted, .notDetermined:
                        self.cancel()
                    }
                })
            })
        }
    }
    
    /// Called after the UIImagePickerController attempts to save an image to the user's photo library
    @objc fileprivate func finishedSavingImage(_ image: UIImage, withError error: NSError?, contextInfo: UnsafeRawPointer) {
        savingPhotoIndicator?.hide()
        if let error = error {
            let alert = UIAlertController.alert(fromError: error)
            present(alert!, animated: true, completion: nil)
        }
        else {
            fetchAllPhotos()
            collectionView?.reloadData()
        }
    }
    
    fileprivate func initialViewSetUp() {
        collectionView?.allowsMultipleSelection = true
        updateLayoutForSize(view.bounds.size)
        
        self.collectionView?.register(NXPhotoLibraryGridCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if title == nil {
            title = "Your Photos"
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.done))
        updateSelectionButtonCount()
        
        if options.allowTakingPhotos {
            addCameraToolbar()
        }
    }
    
    fileprivate func locateSelectedAsset(_ asset: NXPhotoAsset) -> (found:Bool, index: Int) {
        var index = -1
        for selection in self.selections {
            index += 1
            if selection.libraryAsset.localIdentifier == asset.libraryAsset.localIdentifier {
                return (found: true, index: index)
            }
        }
        return (found: false, index: -1)
    }

    fileprivate func takePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func updateLayoutForSize(_ size: CGSize) {
        guard let collectionView = collectionView , collectionView.collectionViewLayout is UICollectionViewFlowLayout else {
            return
        }
        
        collectionView.collectionViewLayout = FilledFlowLayout(minCellSize: options.targetPreviewCellLength, viewSize: size)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    fileprivate func updateSelectionButtonCount() {
        // Add a space at the end to help prevent truncation while changing the count
        navigationItem.rightBarButtonItem?.title = "Select (\(selections.count)) "
        navigationItem.rightBarButtonItem?.isEnabled = selections.count > 0
    }
}


//
// MARK: UICollectionViewDataSource
//
extension NXPhotoLibraryCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = allPhotosFetchResult?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? NXPhotoLibraryGridCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let result = allPhotosFetchResult , result.count > (indexPath as NSIndexPath).row {
            let phasset = result[(indexPath as NSIndexPath).row]
            
            let asset = NXPhotoAsset(asset: phasset)
            cell.asset = asset
            cell.selectedBorderWidth = options.selectedPhotoBorderWidth
            
            cell.isSelected = locateSelectedAsset(asset).found
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .opportunistic
            
            cacheManager?.requestImage(for: phasset, targetSize: thumbnailSize, contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, info) in
                if cell.asset?.libraryAsset.localIdentifier == phasset.localIdentifier {
                    cell.asset?.thumbnailImage = image
                    cell.updateThumbnail()
                }
            })
            
            cell.selectionHandler = { [weak self] (selected, asset) in
                guard let _self = self, let asset = asset else { return }
                
                if selected {
                    let result = _self.locateSelectedAsset(asset)
                    if !result.found {
                        asset.requestHighQualityImageOfSize(_self.options.targetPhotoSize, contentMode: _self.options.photoContentMode)
                        _self.selections.append(asset)
                    }
                    _self.updateSelectionButtonCount()
                }
                else {
                    let result = _self.locateSelectedAsset(asset)
                    if result.found {
                        asset.cancelRequestsAndClearImage(true)
                        _self.selections.remove(at: result.index)
                    }
                    _self.updateSelectionButtonCount()
                }
            }
        }
        return cell
    }
}


//
// MARK: UICollectionViewDelegate
//
extension NXPhotoLibraryCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let handler = options.willDisplayCellHandler {
            handler(cell)
        }
        else {
            cell.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.alpha = 0.5
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.alpha = 1.0
                }) { (finished) in
                    
            }
        }
    }
}

extension NXPhotoLibraryCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true) { [weak self]() in
            guard let _self = self else { return }
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                _self.savingPhotoIndicator = NXIndicatorView.showIndicator(with: .activitySmall, superview: _self.view, title: "Saving", disableInteraction: true)
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.finishedSavingImage(_:withError:contextInfo:)), nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
