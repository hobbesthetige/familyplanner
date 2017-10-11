//
//  ColorPickerCollectionView.swift
//  ColorPicker
//
//  Created by Joseph Sferrazza on 3/5/16.
//  Copyright © 2016 Sferrazza. All rights reserved.
//

import UIKit

open class ColorPickerCollectionView: UICollectionView {

    fileprivate var colorDataSource: ColorPickerDataSource
    open var selectionHandler: ((_ selectedColor: UIColor) -> Void)?
    
    /** Used to track the size that the current collectionViewLayout was generated for. */
    fileprivate var layoutSize = CGSize.zero
    
    /** 
     The number of variations to display for each hue. When using a horizontal scroll direction, this equates to the number of items displayed in each column. When using a vertical scroll direction, this equates to the number of columns in each row.
    */
    @IBInspectable open var hueVariations: Int = 8
    
    /** Approximate number of total colors to display. */
    @IBInspectable open var preferredColorTotal: Int = 400
    
    /** Initializes and returns a newly allocated collection view object with the specified frame and the default 'ColorPickerCollectionViewLayout'. */
    public convenience init(frame: CGRect) {
        let layout = ColorPickerCollectionViewLayout()
        self.init(frame: frame, collectionViewLayout: layout)
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        colorDataSource = ColorPickerDataSource(hueVariations: hueVariations, preferredTotal: preferredColorTotal)
        super.init(frame: frame, collectionViewLayout: layout)
        initializeUsingLayout(layout)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        colorDataSource = ColorPickerDataSource(hueVariations: hueVariations, preferredTotal: preferredColorTotal)
        super.init(coder: aDecoder)
        
        // If the storyboard has a flow layout assigned, use it's scroll direction.
        // Intentionally ignore the rest of the layout sso the user isn't requred to fill it out.
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let colorLayout = ColorPickerCollectionViewLayout()
            colorLayout.scrollDirection = layout.scrollDirection
            initializeUsingLayout(colorLayout)
        }
        else {
            let layout = ColorPickerCollectionViewLayout()
            initializeUsingLayout(layout)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // Invalidate the layout each time the collectionView's bounds change, so the cells always fill the view
        if bounds.size != layoutSize {
            layoutSize = bounds.size
            collectionViewLayout.invalidateLayout()
         }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()

        // Reassign the dataSource to pick up user values set in IB
        if colorDataSource.hueVariations != hueVariations || colorDataSource.preferredColorTotal != preferredColorTotal {
            colorDataSource = ColorPickerDataSource(hueVariations: hueVariations, preferredTotal: preferredColorTotal)
        }
        dataSource = colorDataSource
    }

    /** 
     Performs the initial set up of the collection view; sets the delegate, datasource & layout.
     */
    func initializeUsingLayout(_ layout: UICollectionViewLayout) {
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: ColorCellIdentifier)
        
        collectionViewLayout = layout
        dataSource = colorDataSource
        delegate = self
    }
}

extension ColorPickerCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let sectionSize = layout.scrollDirection == .horizontal ? collectionView.bounds.height : collectionView.bounds.width
            let sectionHeight = sectionSize - (layout.sectionInset.top + layout.sectionInset.bottom)
            let heightForItems = sectionHeight - (CGFloat(colorDataSource.hueVariations) * layout.minimumLineSpacing)
            let itemSize = heightForItems / CGFloat(colorDataSource.hueVariations)
            return CGSize(width: itemSize, height: itemSize)
        }
        return CGSize.zero
    }
}

extension ColorPickerCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let color = colorDataSource.colorFromIndexPath(indexPath), let handler = selectionHandler {
            handler(color)
        }
    }
}


//MARK: - Layout
class ColorPickerCollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    fileprivate func initialize() {
        sectionInset = UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)
        minimumInteritemSpacing = 1.0
        minimumLineSpacing = 1.0
        itemSize = CGSize(width: 50.0, height: 50.0)
        scrollDirection = .horizontal
    }
}
