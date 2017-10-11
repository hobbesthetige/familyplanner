//
//  NXPhotoEditor.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/7/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit
import NXConstraintKit

open class NXPhotoAnnotator: UIViewController {
    open var blurEffect: UIBlurEffectStyle = .dark
    
    open let topToolbar = UIToolbar()
    fileprivate let titleLabel = UILabel()
    fileprivate let bottomBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    fileprivate let imageScrollView = UIScrollView()
    fileprivate let imageCanvas = ImageCanvas()
    fileprivate let cancelButton = UIButton(type: .system)
    fileprivate let doneButton = UIButton(type: .system)
    fileprivate var undoButton = UIButton(type: .system)
    fileprivate var redoButton = UIButton(type: .system)
    fileprivate var brushFillButton = UIButton(type: .system)
    fileprivate var addTextInstructionLabel = UILabel()
    
    fileprivate var upAnimator = ModalUpAnimator()
    fileprivate var downAnimator = ModalDownAnimator()
    
    open var topToolbarHeight: CGFloat = 64.0
    open var bottomBarTint: UIColor? = UIColor.white {
        didSet {
            for view in bottomBlurView.contentView.subviews {
                view.tintColor = bottomBarTint
            }
        }
    }
    
    open var image: UIImage? {
        didSet {
            if let image = image , originalImage == nil {
                originalImage = image
            }
            imageCanvas.image = image
        }
    }
    fileprivate var originalImage: UIImage?
    open var completionBlock: ((_ image: UIImage?, _ cancelled: Bool) -> Void)?
}

// MARK: View Lifecycle
extension NXPhotoAnnotator {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyEffects()
        shouldListenForKeyboardChanges(true)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shouldListenForKeyboardChanges(false)
    }
}


// MARK: UIViewController
extension NXPhotoAnnotator {
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return blurEffect == .dark ? .lightContent : .default
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Add extra space between the save and help button if we have room
        if let items = topToolbar.items , (previousTraitCollection == nil || traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass) && traitCollection.horizontalSizeClass == .regular {
            for item in items {
                if item.target == nil {
                    item.width = 20.0
                }
            }
        }
    }
}


// MARK: Actions
extension NXPhotoAnnotator {
    func addTextWasTapped() {
        imageCanvas.canvas.currentInputType = .text
        
        addTextInstructionLabel.alpha = 1.0
    }
    
    func brushWasTapped() {
        let brushSettings = BrushSettingsTableViewController.initializeFromStoryboard()
        brushSettings.brushColor = imageCanvas.canvas.currentBrushColor
        brushSettings.brushThickness = imageCanvas.canvas.currentBrush.thickness
        brushSettings.updateBlock = { [weak self] (thickness, color) in
            self?.brushFillButton.tintColor = color
            self?.imageCanvas.canvas.currentBrushColor = color
            self?.imageCanvas.canvas.currentBrush.thickness = thickness
        }
        
        let navController = UINavigationController(rootViewController: brushSettings)
        navController.modalPresentationStyle = traitCollection.horizontalSizeClass == .compact ? .overCurrentContext : .popover
        navController.popoverPresentationController?.sourceRect = brushFillButton.frame
        navController.popoverPresentationController?.sourceView = brushFillButton.superview
        navController.definesPresentationContext = true
        navController.navigationBar.barStyle = blurEffect == .dark ? .black : .default
        navController.view.tintColor = view.tintColor
        navController.view.backgroundColor = traitCollection.horizontalSizeClass == .compact ? UIColor.black.withAlphaComponent(0.33) : UIColor.clear
        present(navController, animated: true, completion: nil)
    }
    
    func cancelWasTapped() {
        if let completionBlock = completionBlock {
            completionBlock(originalImage, true)
        }
    }
    
    func clearWasTapped() {
        let alert = UIAlertController(title: "Clear All", message: "Are you sure you want to remove all annotations?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self](action) in
            self?.imageCanvas.canvas.clear()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func doneWasTapped() {
        if let completionBlock = completionBlock {
            if let img = captureAnnotatedImage() {
                completionBlock(img, false)
            }
            else {
                let alert = UIAlertController(title: "Unable to Capture", message: "An error occurred while capturing your annotations.  Please try again.", preferredStyle: .alert)
                present(alert, animated: true, completion: nil)
            }
        }
    }

    func helpWasTapped() {
        let helpController = NXAnnotationHelpViewController.instantiateFromStoryboard()
        helpController.modalPresentationStyle = .custom
        helpController.transitioningDelegate = self
        helpController.view.tintColor = view.tintColor
        present(helpController, animated: true, completion: nil)
    }
    
    func redoWasTapped() {
        imageCanvas.canvas.redo()
        updateUndoRedoAvailability()
    }
    
    func undoWasTapped() {
        imageCanvas.canvas.undo()
        updateUndoRedoAvailability()
    }
    
    func updateUndoRedoAvailability() {
        undoButton.isEnabled = imageCanvas.canvas.canUndo
        redoButton.isEnabled = imageCanvas.canvas.canRedo
    }
}


// MARK: Public
extension NXPhotoAnnotator {

}


// MARK: Private
extension NXPhotoAnnotator {
    func applyEffects() {
        bottomBlurView.effect = UIBlurEffect(style: blurEffect)
    }
    
    func bottomButtonFromIdentifier(_ identifier: UIImage.AssetIdentifier, action: Selector?) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(identifier: identifier), for: UIControlState())
        button.tintColor = bottomBarTint
        button.translatesAutoresizingMaskIntoConstraints = false
        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        return button
    }
    
    func captureAnnotatedImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(imageCanvas.bounds.size, false, 0)
        
        if let imageSize = image?.size {
            let scale = fmin(imageCanvas.bounds.width / imageSize.width, imageCanvas.bounds.height / imageSize.height)
            let scaledSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
            let imageRect = CGRect(x: round(0.5*(imageCanvas.bounds.width - scaledSize.width)), y: round(0.5*(imageCanvas.bounds.height - scaledSize.height)), width: round(scaledSize.width), height: round(scaledSize.height))
            
            imageCanvas.drawHierarchy(in: imageCanvas.bounds, afterScreenUpdates: true)
            let annotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            
            let scaledRect = CGRect(x: imageRect.minX * (annotatedImage?.scale)!, y: imageRect.minY * (annotatedImage?.scale)!, width: imageRect.width * (annotatedImage?.scale)!, height: imageRect.height * (annotatedImage?.scale)!)
            if let croppedImageRef = (annotatedImage?.cgImage)?.cropping(to: scaledRect) {
                let croppedImage = UIImage(cgImage: croppedImageRef, scale: (annotatedImage?.scale)!, orientation: (annotatedImage?.imageOrientation)!)
                return croppedImage
            }
        }
        return nil
    }
    
    func keyboardFrameWillChangeNotification(_ notification: Notification) {
        guard let canvasTextFieldFrame = imageCanvas.canvas.firstResponderFrame(),
            let newKeyboardFrame = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }

        if newKeyboardFrame.minY >= view.bounds.maxY {
            //Off-screen, reset the view
            var originalFrame = view.frame
            originalFrame.origin.y = 0.0
            UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                self.view.frame = originalFrame
                }, completion:nil)
        }
        else {
            // On-screen, adjust the view if overlapping
            let overlap = canvasTextFieldFrame.maxY - newKeyboardFrame.minY
            if overlap > 0.0 {
                var offsetFrame = view.frame
                offsetFrame.origin.y = -overlap
                UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
                    self.view.frame = offsetFrame
                    }, completion: { (finished) in
                })
            }
        }
    }
    
    func shouldListenForKeyboardChanges(_ should: Bool) {
        if should {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardFrameWillChangeNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        }
        else {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        }
    }
    
    func setUpView() {
        imageCanvas.canvas.currentBrushColor = ColorPalette.Defaults.Annotations.StrokeColor
        imageCanvas.canvas.delegate = self
        
        // Add the image view and scroll view
        view.addSubview(imageScrollView)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        let imageScrollViewConstraints = NSLayoutConstraint.constraintsByAligning(item: imageScrollView, toItem: view, usingAttributes: [.top, .leading, .trailing, .bottom])
        view.addConstraints(imageScrollViewConstraints)
        imageScrollView.delegate = self
        imageScrollView.maximumZoomScale = 10.0
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.zoomScale = 1.0
        imageScrollView.panGestureRecognizer.isEnabled = false
        if let recognizers = imageScrollView.gestureRecognizers {
            for recognizer in recognizers {
                if !(recognizer is UIPinchGestureRecognizer) {
                    imageScrollView.removeGestureRecognizer(recognizer)
                }
            }
        }
        
        imageScrollView.addSubview(imageCanvas)
        imageCanvas.translatesAutoresizingMaskIntoConstraints = false
        let canvasConstraints = NSLayoutConstraint.constraintsByAligning(item: imageCanvas, toItem: imageScrollView, usingAttributes: [.top, .leading, .trailing, .bottom, .centerX, .centerY])
        imageScrollView.addConstraints(canvasConstraints)
        
        // Add the top toolbar
        topToolbar.delegate = self
        topToolbar.translatesAutoresizingMaskIntoConstraints = false
        // Even though we're using a toolbar, since it's at the top, check for navigation bar appearance defaults
        if let tint = UINavigationBar.appearance().barTintColor {
            topToolbar.barTintColor = tint
        }
        if let tint = UINavigationBar.appearance().tintColor {
            topToolbar.tintColor = tint
        }
        view.addSubview(topToolbar)
        let topToolbarConstraints = NSLayoutConstraint.constraintsByAligning(item: topToolbar, toItem: view, usingAttributes: [.topMargin, .leading, .trailing], offsets: [topToolbarHeight - 44.0, 0.0, 0.0])
        view.addConstraints(topToolbarConstraints)

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.adjustsFontSizeToFitWidth = true
        var titleConstraints = NSLayoutConstraint.constraintsByAligning(item: titleLabel, toItem: topToolbar, usingAttributes: [.centerX, .centerY])
        titleConstraints += [NSLayoutConstraint(item: topToolbar, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: titleLabel, attribute: .trailing, multiplier: 1.0, constant: 85.0)]
        view.addConstraints(titleConstraints)
        if let title = title, let attributes = UINavigationBar.appearance().titleTextAttributes {
            titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        }
        else {
            titleLabel.text = title
        }
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelWasTapped))
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.doneWasTapped))
        let helpBarButton = UIBarButtonItem(image: UIImage(identifier: .QuestionMarkIcon), style: .plain, target: self, action: #selector(self.helpWasTapped))
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedBarButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)

        topToolbar.items = [cancelBarButton, flexBarButton, helpBarButton, fixedBarButton, saveBarButton]
        
        // Add the bottom blur
        view.addSubview(bottomBlurView)
        var bottomBlurViewConstraints = NSLayoutConstraint.constraintsByAligning(item: bottomBlurView, toItem: view, usingAttributes: [.bottom, .leading, .trailing])
        bottomBlurViewConstraints.append(NSLayoutConstraint(setValueForSingleItem: bottomBlurView, attribute: .height, to: 50.0))
        bottomBlurView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(bottomBlurViewConstraints)
        
        // Set up the bottom toolbar
        let brushButton = bottomButtonFromIdentifier(.BrushSettingsIcon, action: #selector(self.brushWasTapped))
        bottomBlurView.contentView.addSubview(brushButton)
        var brushConstraints = NSLayoutConstraint.constraintsByAligning(item: brushButton, toItem: bottomBlurView.contentView, usingAttributes: [.centerY, .leading, .height], offsets: [0.0, 20.0, 0.0])
        brushConstraints.append(NSLayoutConstraint(setValueForSingleItem: brushButton, attribute: .width, to: 44.0))
        bottomBlurView.contentView.addConstraints(brushConstraints)
        
        brushFillButton = bottomButtonFromIdentifier(.BrushFillIcon, action: nil)
        bottomBlurView.contentView.insertSubview(brushFillButton, belowSubview: brushButton)
        let brushFillConstraints = NSLayoutConstraint.constraintsByAligning(item: brushFillButton, toItem: brushButton, usingAttributes: [.centerY, .centerX, .height, .width])
        bottomBlurView.contentView.addConstraints(brushFillConstraints)
        brushFillButton.tintColor = ColorPalette.Defaults.Annotations.StrokeColor
        
        let addTextButton = bottomButtonFromIdentifier(.AddTextIcon, action: #selector(self.addTextWasTapped))
        bottomBlurView.contentView.addSubview(addTextButton)
        var addtextConstraints = NSLayoutConstraint.constraintsByAligning(item: addTextButton, toItem: brushButton, usingAttributes: [.height, .width])
        addtextConstraints.append(NSLayoutConstraint(item: addTextButton, attribute: .leading, relatedBy: .equal, toItem: brushButton, attribute: .trailing, multiplier: 1.0, constant: 20.0))
        addtextConstraints.append(NSLayoutConstraint(alignItem: addTextButton, attribute: .centerY, toItem: bottomBlurView.contentView))
        bottomBlurView.contentView.addConstraints(addtextConstraints)
        
        let clearButton = bottomButtonFromIdentifier(.BrushClearIcon, action: #selector(self.clearWasTapped))
        bottomBlurView.contentView.addSubview(clearButton)
        var trashConstraints = NSLayoutConstraint.constraintsByAligning(item: clearButton, toItem: bottomBlurView.contentView, usingAttributes: [.centerY, .trailing], offsets: [0.0, -20.0])
        trashConstraints += NSLayoutConstraint.constraintsByAligning(item: clearButton, toItem: brushButton, usingAttributes: [.height, .width])
        bottomBlurView.contentView.addConstraints(trashConstraints)
        
        redoButton = bottomButtonFromIdentifier(.RedoIcon, action: #selector(self.redoWasTapped))
        bottomBlurView.contentView.addSubview(redoButton)
        var redoConstraints = NSLayoutConstraint.constraintsByAligning(item: redoButton, toItem: brushButton, usingAttributes: [.height, .width])
        redoConstraints.append(NSLayoutConstraint(item: redoButton, attribute: .trailing, relatedBy: .equal, toItem: clearButton, attribute: .leading, multiplier: 1.0, constant: -20.0))
        redoConstraints.append(NSLayoutConstraint(alignItem: redoButton, attribute: .centerY, toItem: bottomBlurView.contentView))
        bottomBlurView.contentView.addConstraints(redoConstraints)
        
        undoButton = bottomButtonFromIdentifier(.UndoIcon, action: #selector(self.undoWasTapped))
        bottomBlurView.contentView.addSubview(undoButton)
        var undoConstraints = NSLayoutConstraint.constraintsByAligning(item: undoButton, toItem: brushButton, usingAttributes: [.height, .width])
        undoConstraints.append(NSLayoutConstraint(item: undoButton, attribute: .trailing, relatedBy: .equal, toItem: redoButton, attribute: .leading, multiplier: 1.0, constant: -20.0))
        undoConstraints.append(NSLayoutConstraint(alignItem: undoButton, attribute: .centerY, toItem: bottomBlurView.contentView))
        bottomBlurView.contentView.addConstraints(undoConstraints)
        
        updateUndoRedoAvailability()
        
        addTextInstructionLabel.translatesAutoresizingMaskIntoConstraints = false
        addTextInstructionLabel.alpha = 0.0
        addTextInstructionLabel.text = "Tap to Add Text"
        addTextInstructionLabel.textAlignment = .center
        addTextInstructionLabel.font = UIFont.nx_systemFont(ofSize: 36.0, weight: NX_UIFontWeightMedium)
        addTextInstructionLabel.textColor = UIColor.white
        addTextInstructionLabel.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        view.addSubview(addTextInstructionLabel)
        let instructionConstraints = NSLayoutConstraint.constraintsByAligning(item: addTextInstructionLabel, toItem: self.view, usingAttributes: [.top, .leading, .bottom, .trailing])
        view.addConstraints(instructionConstraints)
    }
}


extension NXPhotoAnnotator: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageCanvas
    }
}

extension NXPhotoAnnotator: CanvasDelegate {
    public func presentColorPicker(in canvas: Canvas, fromFrame: CGRect, inView view: UIView, completion: @escaping (UIColor) -> Void) {
        let colorPicker = ColorPickerCollectionViewController()
        colorPicker.selectionHandler = { [weak self] (color) in
            self?.presentedViewController?.dismiss(animated: true, completion: nil)
            completion(color)
        }
        colorPicker.modalPresentationStyle = .popover
        colorPicker.popoverPresentationController?.sourceRect = fromFrame
        colorPicker.popoverPresentationController?.sourceView = view
        colorPicker.popoverPresentationController?.delegate = self
        colorPicker.popoverPresentationController?.permittedArrowDirections = [.down, .up, .right]
        colorPicker.preferredContentSize = CGSize(width: 300.0, height: 400.0)
        present(colorPicker, animated: true, completion: nil)
    }
    
    public func annotationsUpdated(in canvas: Canvas) {
        if canvas === imageCanvas.canvas {
            updateUndoRedoAvailability()
        }
    }
    
    public func willBeginAddingText(in canvas: Canvas) {
        addTextInstructionLabel.alpha = 0.0
    }
}

extension NXPhotoAnnotator: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension NXPhotoAnnotator: UIToolbarDelegate {
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension NXPhotoAnnotator: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return upAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return downAnimator
    }
}
