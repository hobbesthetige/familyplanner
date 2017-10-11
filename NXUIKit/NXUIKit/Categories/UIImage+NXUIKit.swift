//
//  File.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/7/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum AssetIdentifier: String {
        case ActionIcon = "nxuikit_icon_action_16"
        case AddTextIcon = "nxuikit_icon_text-add_22"
        case BackIcon16 = "nxuikit_icon_back-arrow_16"
        case BackIcon25 = "nxuikit_icon_back_25"
        case BrushIcon = "nxuikit_icon_brush_25"
        case BrushClearIcon = "nxuikit_icon_brush-clear_22"
        case BrushSettingsIcon = "nxuikit_icon_brush-settings_25"
        case BrushFillIcon = "nxuikit_icon_brush-fill_25"
        case CameraIcon = "nxuikit_icon_camera_25"
        case CheckCircleIcon = "nxuikit_icon_check-circle_25"
        case ForwardIcon16 = "nxuikit_icon_forward-arrow_16"
        case ForwardIcon25 = "nxuikit_icon_forward_25"
        case MinusIcon = "nxuikit_icon_minus_22"
        case TextColorIcon = "nxuikit_icon_text-color_22"
        case PlusIcon = "nxuikit_icon_plus_22"
        case QuestionMarkIcon = "nxuikit_icon_question-mark-circle_22"
        case RedoIcon = "nxuikit_icon_redo_24"
        case TrashIcon = "nxuikit_icon_trash_16"
        case TrashIcon22 = "nxuikit_icon_trash_22"
        case UndoIcon = "nxuikit_icon_undo_24"
        case XCircleIcon = "nxuikit_icon_circle-x_25"
    }
    
    convenience init!(identifier: AssetIdentifier) {
        self.init(named: identifier.rawValue, in: Bundle.nxuiKitBundle(), compatibleWith: nil)
    }
}
