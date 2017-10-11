//
//  ModalProtocols.swift
//  NXUIKit
//
//  Created by Joe Sferrazza on 8/4/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import Foundation

//
// MARK: Cancel Modal
//
@objc public protocol CancelModal {
    func cancel()
}

public extension CancelModal where Self: UIViewController {
    func addCancelButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        navigationItem.leftBarButtonItem = cancelButton
    }
}



//
// MARK: Done Modal
//
@objc public protocol DoneModal {
    func done()
}

public extension DoneModal where Self: UIViewController {
    func addDoneButton() {
        addRightBarButton(item: .done)
    }
    
    func addNextButton() {
        addRightBarButton(title: "Next")
    }
    
    func addSaveButton() {
        addRightBarButton(item: .save)
    }
    
    func addSubmitButton() {
        addRightBarButton(title: "Submit")
    }
    
    func addRightBarButton(title: String) {
        let submitButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(self.done))
        navigationItem.rightBarButtonItem = submitButton
    }
    
    func addRightBarButton(item: UIBarButtonSystemItem) {
        let saveButton = UIBarButtonItem(barButtonSystemItem: item, target: self, action: #selector(self.done))
        navigationItem.rightBarButtonItem = saveButton
    }
}



//
// MARK: Cancel & Done
//
public protocol CancelAndDoneModal: CancelModal, DoneModal {
    
}

public extension CancelAndDoneModal where Self: UIViewController {
    func addCancelAndDoneButtons() {
        addCancelButton()
        addDoneButton()
    }
    
    func addCancelAndNextButtons() {
        addCancelButton()
        addNextButton()
    }
    
    func addCancelAndSaveButtons() {
        addCancelButton()
        addSaveButton()
    }
    
    func addCancelAndSubmitButtons() {
        addCancelButton()
        addSubmitButton()
    }
}


//
// MARK: Close Modal
//
@objc public protocol CloseModal {
    func close()
}

public extension CloseModal where Self: UIViewController {
    func addCloseButton() {
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.close))
        navigationItem.leftBarButtonItem = closeButton
    }
}
