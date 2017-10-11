//
//  FullscreenFlowLayout.swift
//  NXUIKit
//
//  Created by Joseph Sferrazza on 6/23/16.
//  Copyright © 2016 Nexcom. All rights reserved.
//

import UIKit

class FilledFlowLayout: UICollectionViewFlowLayout {
    
    convenience init(viewSize: CGSize) {
        self.init(spacing: 0.5, minCellSize: 100.0, viewSize: viewSize, direction: .vertical)
    }
    
    convenience init(minCellSize: CGFloat, viewSize: CGSize) {
        self.init(spacing: 0.5, minCellSize: minCellSize, viewSize: viewSize, direction: .vertical)
    }
    
    init(spacing: CGFloat, minCellSize: CGFloat, viewSize: CGSize, direction: UICollectionViewScrollDirection) {
        super.init()
        
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        
        let constrainedViewDimension = direction == .horizontal ? viewSize.height : viewSize.width
        
        let numOfItemsAcross = floor(constrainedViewDimension / minCellSize)
        let extraSpace = constrainedViewDimension - (minCellSize * numOfItemsAcross) - (spacing * (numOfItemsAcross - 1))
        let extraSpacePerCell = extraSpace / numOfItemsAcross
        
        let newSize = floor(minCellSize + extraSpacePerCell)
        itemSize = CGSize(width: newSize, height: newSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
