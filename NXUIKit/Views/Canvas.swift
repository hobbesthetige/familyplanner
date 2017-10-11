//
//  Canvas.swift
//  Annotate
//
//  Created by Joseph Sferrazza on 2/28/16.
//  Copyright © 2016 Sferrazza. All rights reserved.
//

import UIKit

public protocol CanvasDelegate {
    func annotationsUpdated(in canvas: Canvas)
    func willBeginAddingText(in canvas: Canvas)
    func presentColorPicker(in canvas: Canvas, fromFrame: CGRect, inView view: UIView, completion: @escaping (_ color: UIColor) -> Void)
}

open class Canvas: UIView {

    enum InputType {
        case stroke, text, none
    }
    
    // Public
    open var delegate: CanvasDelegate?
    open var isEditable: Bool = true
    
    var currentInputType: InputType = .stroke {
        didSet {
            isUserInteractionEnabled = currentInputType != .none
        }
    }
    
    // Private
    fileprivate var annotationTextField: UITextField = UITextField()
    fileprivate var annotations = Array<AnnotationType>()
    fileprivate var currentAnnotation: AnnotationType?
    fileprivate var redoStack = Array<AnnotationType>()
    
    override open var tintColor: UIColor! {
        didSet {
            annotationTextField.inputAccessoryView?.tintColor = tintColor
        }
    }
    
    open var currentBrushColor: UIColor = ColorPalette.Defaults.Annotations.StrokeColor
    open var currentTextColor: UIColor = ColorPalette.Defaults.Annotations.TextColor
    open var currentBrush: Brush = Brush(thickness: 2.0, thicknessVarianceFactor: 0.5, startThick: true)
    
    open var canUndo: Bool {
        return annotations.count > 0
    }
    open var canRedo: Bool {
        return redoStack.count > 0
    }
    
    open func clear() {
        currentAnnotation = nil
        annotations = Array<AnnotationType>()
        redoStack = Array<AnnotationType>()
        updateDrawing()
    }
    
    open func firstResponderFrame() -> CGRect? {
        if annotationTextField.isFirstResponder {
            return annotationTextField.frame
        }
        return nil
    }
    
    open func redo() {
        if let last = redoStack.last {
            annotations.append(last)
            redoStack.removeLast()
            updateDrawing()
        }
    }
    
    open func undo() {
        currentAnnotation = nil
        
        if let last = annotations.last {
            redoStack.append(last)
            annotations.removeLast()
            updateDrawing()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    override open func draw(_ rect: CGRect) {
        currentAnnotation?.color.setStroke()
        currentAnnotation?.draw()
        
        for annotation in annotations {
            annotation.color.setStroke()
            annotation.draw()
        }
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let startPoint = pointFromTouches(touches as NSSet) {
            switch currentInputType {
            case .none:
                return
            case .stroke:
                currentAnnotation = Stroke(startPoint: startPoint, color: currentBrushColor, brush: currentBrush)
                break
            case .text:
                return
            }
            setNeedsDisplay()
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let newPoint = pointFromTouches(touches as NSSet) {
            switch currentInputType {
            case .none:
                return
            case .stroke:
                if let stroke = currentAnnotation as? Stroke {
                    stroke.appendPoint(newPoint)
                }
            case .text:
                return
            }
            setNeedsDisplay()
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let endPoint = pointFromTouches(touches as NSSet) {
            switch currentInputType {
            case .none:
                return
            case .stroke:
                if let stroke = currentAnnotation as? Stroke {
                    stroke.endAtPoint(endPoint)
                    annotations.append(stroke)
                }
            case .text:
                moveTextFieldAtPoint(endPoint)
            }
            updateDrawing()
        }
    }
}

extension Canvas {
    func moveTextFieldAtPoint(_ point: CGPoint) {
        annotationTextField.frame = CGRect(origin: point, size: annotationTextField.frame.size)
        annotationTextField.textColor = currentTextColor
        annotationTextField.tintColor = currentTextColor
        annotationTextField.alpha = 1.0
        annotationTextField.becomeFirstResponder()
    }
    
    func initialize() {
        isMultipleTouchEnabled = false
        isUserInteractionEnabled = true
        
        annotationTextField = UITextField(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 75.0, height: 20.0)))
        annotationTextField.delegate = self
        annotationTextField.alpha = 0.0
        annotationTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        let inputAccessory = TextAnnotationInputAccessoryView(frame: CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0))
        inputAccessory.update = { [weak self] (color, font) in
            guard let _self = self else { return }
            _self.annotationTextField.font = font
            _self.sizeTextField(_self.annotationTextField)
        }
        inputAccessory.getColor = { [weak self] () in
            guard let _self = self, let inputView = _self.annotationTextField.inputAccessoryView, let _ = inputView.superview else { return }
            _self.delegate?.presentColorPicker(in: _self, fromFrame: _self.annotationTextField.frame, inView: _self, completion: { (color) in
                _self.annotationTextField.textColor = color
                _self.annotationTextField.tintColor = color
                _self.currentTextColor = color
            })
        }
        annotationTextField.inputAccessoryView = inputAccessory
        annotationTextField.font = UIFont.systemFont(ofSize: inputAccessory.fontSize)
        addSubview(annotationTextField)
    }
    
    func pointFromTouches(_ touches: NSSet) -> CGPoint? {
        let touch = touches.anyObject() as? UITouch
        return touch?.location(in: self)
    }
    
    func sizeTextField(_ textField: UITextField) {
        if let font = textField.font {
            let attributes = [NSFontAttributeName : font]
            if let string: NSString = textField.text as NSString? {
                let size = string.size(attributes: attributes)
                textField.frame = CGRect(origin: textField.frame.origin, size: size)
            }
        }
    }
    
    func updateDrawing() {
        if let delegate = delegate {
            delegate.annotationsUpdated(in: self)
        }
        setNeedsDisplay()
    }
}

extension Canvas: UITextFieldDelegate {
    func textFieldValueChanged(_ textField: UITextField) {
        sizeTextField(textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == annotationTextField {
            if let text = textField.text, let color = textField.textColor {
                let textAnnotation = Text(text: text, color: color, location: textField.frame.origin)
                if let font = textField.font {
                    textAnnotation.font = font
                }
                annotations.append(textAnnotation)
                updateDrawing()
            }
            textField.resignFirstResponder()
        }
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == annotationTextField {
            currentInputType = .stroke
            annotationTextField.alpha = 0.0
            annotationTextField.text = ""
        }
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let delegate = delegate {
            delegate.willBeginAddingText(in: self)
        }
        return true
    }
}
