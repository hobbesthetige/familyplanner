//
//  SuggestionsInputAccessoryView.swift
//  NXUIKit
//
//  Created by Joe Sferrazza on 1/12/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import Foundation

private let MinimumButtonWidth: CGFloat = 100.0

public class SuggestionsInputAccessoryView: UIView {
    fileprivate var decorationView = UIView()
    fileprivate var currentBtnWidth: CGFloat = 0.0
    
    /// Called whenever the user taps on a suggestion button
    public var selectionHandler: ((_ selection: String) -> Void)?
    
    /// An array of suggestions to display to the user above the keyboard
    public var suggestions = [String]() {
        didSet {
            updateButtonTitles()
        }
    }
    
    /// The user's current search text
    public var searchText: String? {
        didSet {
            updateButtonTitles()
        }
    }
    
    fileprivate var buttons = [UIButton]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    fileprivate func initialize() {
        backgroundColor = UIColor(white: 0.93, alpha: 1.0)
        layoutButtons()
        addDecoration()
    }
    
    
    public static func accessoryUsingItems(_ items: [String]) -> SuggestionsInputAccessoryView {
        let view = SuggestionsInputAccessoryView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
        view.suggestions = items
        return view
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutButtons()
        updateButtonTitles()
    }
}


//
// MARK: Private
//
extension SuggestionsInputAccessoryView {
    /// Adds a thin gray top decoration to this view
    fileprivate func addDecoration() {
        decorationView.translatesAutoresizingMaskIntoConstraints = false
        decorationView.backgroundColor = UIColor.lightGray
        addSubview(decorationView)
        
        var constraints = NSLayoutConstraint.constraintsByAligning(item: decorationView, toItem: self, usingAttributes: [.leading, .trailing, .top])
        let heightConstraint = NSLayoutConstraint(setValueForSingleItem: decorationView, attribute: .height, to: 0.5)
        constraints.append(heightConstraint)
        addConstraints(constraints)
    }
    
    /// Called each time a suggestion button is tapped
    @objc fileprivate func buttonWasTapped(_ sender: UIButton) {
        if let text = sender.title(for: .normal) {
            selectionHandler?(text)
        }
    }
    
    /// Clears all buttons by removing them from the view and emptying the `buttons` array.
    fileprivate func clearButtons() {
        for view in subviews {
            if view is UIButton {
                view.removeFromSuperview()
            }
        }
        buttons = []
    }
    
    /// Lays out the suggestion buttons in the view based on the current width.  
    /// Exits early if buttons in the view were already laid out for this view width.
    fileprivate func layoutButtons() {
        guard bounds.width > 0.0 else { return }
        
        var buttonCount = floor(bounds.width / MinimumButtonWidth)
        
        if suggestions.count < Int(buttonCount) {
            buttonCount = CGFloat(suggestions.count)
        }
        let btnWidth = bounds.width / buttonCount
        
        guard currentBtnWidth != btnWidth else { return }
        
        currentBtnWidth = btnWidth
        
        clearButtons()
        
        var xOrigin: CGFloat = 0.0
        
        for _ in 1...Int(buttonCount) {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: xOrigin, y: 0.0, width: btnWidth, height: bounds.height)
            button.addTarget(self, action: #selector(self.buttonWasTapped(_:)), for: .touchUpInside)
            button.tintColor = UIColor.darkGray
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.titleLabel?.numberOfLines = 2
            buttons.append(button)
            addSubview(button)
            
            xOrigin += btnWidth
        }
    }
    
    /// Populates the visible button titles using the first items in the specified array.
    fileprivate func populateButtonsUsing(items: [String]) {
        for index in 0 ..< buttons.count {
            let buttonTitle = index < items.count ? items[index] : ""
            buttons[index].setTitle(buttonTitle, for: .normal)
        }
    }
    
    /// Updates the visible button titles so they display results based on the current search text
    fileprivate func updateButtonTitles() {
        if let searchText = searchText {
            // Filter out matches
            let matches = suggestions.filter {
                return $0.containsOrderedMatch(for: searchText)
            }
            populateButtonsUsing(items: matches)
        }
        else {
            populateButtonsUsing(items: suggestions)
        }
    }
}

extension String {
    /// Performs a case-insensitive search for the specified search string.
    /// Charaters must be in order for a match but they do not need to be successive 
    ///
    /// Example: Searching for "em" in "Nexcom" would return a match.
    /// - parameters:
    ///   - searchText: The text to search for.
    public func containsOrderedMatch(for searchText: String) -> Bool {
        guard searchText.characters.count > 0 else { return true }
        guard self.characters.count > 0 else { return false }
        
        var itemToSearch = self
        var searchText = searchText
        
        // Compare the first character of each string for a match
        while itemToSearch.characters.count > 0 && searchText.characters.count > 0 {
            let nextSearchChar = searchText.firstCharacter()
            let nextItemChar = itemToSearch.firstCharacter()
            
            if nextItemChar.caseInsensitiveCompare(nextSearchChar) == .orderedSame {
                itemToSearch.remove(at: itemToSearch.startIndex)
                searchText.remove(at: searchText.startIndex)
            }
            else {
                itemToSearch.remove(at: itemToSearch.startIndex)
            }
        }
        // Successful searches will exhaust all searchText
        return searchText.characters.count == 0
    }
    
    public func firstCharacter() -> String {
        guard self.characters.count > 0 else { return "" }
        
        return self.substring(to: self.index(after: self.startIndex))
    }
}
