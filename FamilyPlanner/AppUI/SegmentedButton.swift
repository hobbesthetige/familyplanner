//
//  SegmentedButton.swift
//  SegmentedButton
//
//  Created by Daniel Meachum on 9/22/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import UIKit

public struct SegmentedButtonOption : Hashable
{
    
    public let title : String
    public let color : UIColor
    public let font  : UIFont?
    public let selection : ()->Void
    
    public init(title : String, color : UIColor, font : UIFont? = nil, selection : @escaping ()->Void) {
        
        self.title = title
        self.color = color
        self.font = font
        self.selection = selection
    }
    
    public var hashValue: Int {
        
        return title.hashValue
    }
    
    public static func ==(lhs: SegmentedButtonOption, rhs: SegmentedButtonOption) -> Bool {
        
        return lhs.hashValue == rhs.hashValue
    }
}

private class SegmentedOptionLabel : UILabel
{
    var isSelected = false {
        didSet{
            updateSelection()
        }
    }
    
    let option : SegmentedButtonOption
    
    let deselectedColor : UIColor
    
    let isTextColorAlwaysVisible : Bool
    
    public init(option : SegmentedButtonOption, deselectedColor : UIColor, font : UIFont, isTextColorAlwaysVisible : Bool) {
        
        self.option = option
        
        self.deselectedColor = deselectedColor
        
        self.isTextColorAlwaysVisible = isTextColorAlwaysVisible
        
        super.init(frame: .zero)
        
        text = option.title
        
        if let optionFont = option.font {
            self.font = optionFont
        }
        else {
            self.font = font
        }
        
        textAlignment = .center
        
        numberOfLines = 2
        
        updateSelection()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSelection() {
        
        if isSelected {
            textColor = option.color
            
            option.selection()
        }
        else {
            textColor = isTextColorAlwaysVisible ? option.color : deselectedColor
        }
    }
}

@IBDesignable public class SegmentedButton : UIControl
{
    //Layers & Layout
    private let backgroundLayer = RoundLayer()
    
    private let selectionLayer = RoundLayer()
    
    private let padding = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
    
    
    //Touch Handling
    private var previousPoint : CGPoint?
    
    private var isHandlingTouch = false
    private var isTouchWithinSelectionLayer = false
    private var isTouchMoving = false
    
    
    //Selection
    public private(set) var selectedIndex : Int? {
        
        didSet {
            
            previousSelectedIndex = oldValue
        }
    }
    
    private var previousSelectedIndex : Int?
    
    
    //Views
    private let stackView = UIStackView()
    
    //Inspectable Properties
    @IBInspectable open var borderColor : UIColor = UIColor.lightGray {
        didSet {
            backgroundLayer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable open var borderWidth : CGFloat = 1.0 {
        didSet {
            backgroundLayer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var selectionBorderWidth : CGFloat = 1.0 {
        didSet {
            selectionLayer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var deselectedColor : UIColor = UIColor.lightGray {
        didSet {
            setupStackView()
        }
    }
    
    @IBInspectable open var font : UIFont = UIFont.preferredFont(forTextStyle: .title2) {
        didSet {
            setupStackView()
        }
    }
    
    @IBInspectable open var isTextColorAlwaysVisible : Bool = false {
        didSet {
            setupStackView()
        }
    }
    
    //Configurable Properties
    public var options = [SegmentedButtonOption]() {
        didSet{
            setupStackView()
        }
    }
    
    
    //Initializers
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
}

//Property overrides
extension SegmentedButton
{
    public override var tintColor: UIColor! {
        didSet {
            selectionLayer.borderColor = tintColor.cgColor
        }
    }
}

//Public Methods
extension SegmentedButton
{
    public func selectOption(option : SegmentedButtonOption) {
        
        guard let index = options.index(of: option) else { return }
        
        selectedIndex = index
        
        updateLayerFrames()
        
        updateLabelToSelection(atIndex: index, updateSelectionBorder: true)
    }
}

//Private Methods
extension SegmentedButton
{
    //Inits & Setups
    private func setup() {
        
        initLayers()
        initStackView()
    }
    
    private func setupStackView() {
        
        stackView.arrangedSubviews.forEach({ stackView.removeArrangedSubview($0); $0.removeFromSuperview() })
        
        for option in options {
            
            let button = SegmentedOptionLabel(option: option, deselectedColor: deselectedColor, font: font, isTextColorAlwaysVisible: isTextColorAlwaysVisible)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    private func initStackView() {
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right).isActive = true
        
        stackView.axis = .horizontal
        
        stackView.distribution = .fillEqually
        
        stackView.backgroundColor = .clear
        
        stackView.spacing = 16.0
        
        setupStackView()
    }
    
    private func initLayers() {
        
        initBackgroundLayer()
        initSelectionLayer()
    }
    
    private func initBackgroundLayer() {
        
        backgroundLayer.backgroundColor = UIColor.white.cgColor
        
        backgroundLayer.borderColor = borderColor.cgColor
        
        backgroundLayer.borderWidth = borderWidth
        
        layer.addSublayer(backgroundLayer)
    }
    
    private func initSelectionLayer() {
        
        selectionLayer.borderColor = tintColor.cgColor
        
        selectionLayer.borderWidth = selectionBorderWidth
        
        layer.addSublayer(selectionLayer)
    }
    
    //Layout
    private func updateLayerFrames() {
        
        backgroundLayer.frame = layer.bounds
        
        if let index = selectedIndex {
            
            selectionLayer.frame = calculateSelectionFrame(forIndex: index)
        }
        else {
            
            selectionLayer.frame = layer.bounds
        }
    }
    
    private func calculateSelectionFrame(forIndex index : Int) -> CGRect {
        
        let view = stackView.arrangedSubviews[index]
        
        var x : CGFloat = view.frame.minX + padding.left
        let y : CGFloat = 0
        var w : CGFloat = view.bounds.width
        let h : CGFloat = bounds.height
        
        let spacingAdjustment = stackView.spacing / 2.0
        
        if index == 0 {
            if options.count == 1 {
                x = 0
                w = bounds.width
            }
            else {
                x = 0
                w += spacingAdjustment + padding.left
            }
        }
        else if index == stackView.arrangedSubviews.count - 1{
            x -= spacingAdjustment
            w = bounds.width - x
        }
        else {
            x -= spacingAdjustment
            w += spacingAdjustment * 2
        }
        
        let origin = CGPoint(x: x, y: y)
        let size = CGSize(width: w, height: h)
        
        return CGRect(origin: origin, size: size)
    }
    
    private func applyShiftToSelectionLayer(point : CGPoint) {
        
        guard let previousPoint = previousPoint else { return }
        
        let transform = CGAffineTransform(translationX: point.x - previousPoint.x, y: 0)
        
        var position = selectionLayer.position.applying(transform)
        
        let lastIndex = stackView.arrangedSubviews.count - 1
        
        let minX = selectionLayer.bounds.width/2
        
        let maxX = calculateSelectionFrame(forIndex: lastIndex).centerPoint.x
        
        position.x = max(minX, min(position.x, maxX))
        
        selectionLayer.position = position
    }
    
    private func determineNewSelectionValue(point : CGPoint?) {
        
        var closestIndex : Int? = nil
        
        if let point = point {
            closestIndex = determineNearestOptionFrom(point: point)
        }
        else {
            closestIndex = determineNearestOptionFromSelectionFrame()
        }
        
        closestIndex = closestIndex ?? previousSelectedIndex
        
        //print("Updated selection to " + String.init(describing: closestIndex))
        
        if let closestIndex = closestIndex, closestIndex != selectedIndex {
            
            selectedIndex = closestIndex
            
            updateLayerFrames()
            
            updateLabelToSelection(atIndex: closestIndex, updateSelectionBorder: true)
            
            sendActions(for: .valueChanged)
        }
    }
    
    private func determineNearestOptionFromSelectionFrame() -> Int? {
        
        let selectionFrame = selectionLayer.frame
        
        var closestIndex : Int?
        var highestIntersectionWidth : CGFloat = 0
        
        for (index, _) in stackView.arrangedSubviews.enumerated() {
            
            let frame = calculateSelectionFrame(forIndex: index)
            
            let intersectionWidth = frame.intersection(selectionFrame).width
            
            if intersectionWidth > highestIntersectionWidth {
                
                highestIntersectionWidth = intersectionWidth
                
                closestIndex = index
            }
        }
        
        return closestIndex
    }
    
    private func determineNearestOptionFrom(point : CGPoint) -> Int? {
        
        for (index,_) in stackView.arrangedSubviews.enumerated() {
            
            let selectionFrame = calculateSelectionFrame(forIndex: index)
            
            if selectionFrame.contains(point) {
                
                return index
            }
        }
        
        return nil
    }
    
    private func updateLabelToSelection(atIndex index : Int?, updateSelectionBorder : Bool) {
        
        for label in stackView.arrangedSubviews as! [SegmentedOptionLabel] {
            
            label.isSelected = false
        }
        
        if let index = index {
            
            let label = stackView.arrangedSubviews[index] as! SegmentedOptionLabel
            
            UIView.transition(with: label, duration: 0.1, options: .transitionCrossDissolve, animations: {
                
                label.isSelected = true
            }, completion: nil)
            
            
            if updateSelectionBorder {
                
                selectionLayer.borderColor = label.option.color.cgColor
                selectionLayer.backgroundColor = label.option.color.withAlphaComponent(0.2).cgColor
            }
            else {
                
                selectionLayer.borderColor = tintColor.cgColor
                selectionLayer.backgroundColor = nil
            }
        }
    }
}

//Method Overrides
extension SegmentedButton
{
    //Layout
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        guard layer == self.layer else { return }
        
        updateLayerFrames()
    }
    
    //Touches
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        isHandlingTouch = true
        
        previousPoint = touches.first?.location(in: self)
        
        if let point = previousPoint {
            
            let convertedPoint = selectionLayer.convert(point, from: layer)
            
            isTouchWithinSelectionLayer = selectionLayer.contains(convertedPoint)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        isTouchMoving = true
        
        guard let point = touches.first?.location(in: self), isTouchWithinSelectionLayer else { return }
        
        applyShiftToSelectionLayer(point: point)
        
        previousPoint = point
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard isHandlingTouch else { return }
        
        if let point = touches.first?.location(in: self), !isTouchWithinSelectionLayer {
            
            determineNewSelectionValue(point: point)
        }
        else {
            
            determineNewSelectionValue(point: nil)
        }
        
        resetTouchProperties()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        guard isHandlingTouch else { return }
        
        if var point = previousPoint {
            
            point.y = bounds.midY
            
            determineNewSelectionValue(point: point)
        }
        
        resetTouchProperties()
    }
    
    private func resetTouchProperties() {
        
        previousPoint = nil
        
        isHandlingTouch = false
        
        isTouchWithinSelectionLayer = false
        
        isTouchMoving = false
    }
    
    //Sizing
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        var size = stackView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        size.height += padding.top + padding.bottom
        size.width += padding.left + padding.right
        
        return size
    }
    
    var desiredSize : CGSize {
        
        var size = stackView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        size.height += padding.top + padding.bottom
        size.width += padding.left + padding.right
        
        return size
    }
}

public class RoundLayer : CALayer
{
    public override func layoutSublayers() {
        super.layoutSublayers()
        
        cornerRadius = bounds.height / 2.0
    }
}

extension CGRect {
    
    var centerPoint : CGPoint {
        
        return CGPoint(x: midX, y: midY)
    }
}
