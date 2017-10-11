//
//  ColorPickerDataSource.swift
//  ColorPicker
//
//  Created by Joseph Sferrazza on 3/5/16.
//  Copyright © 2016 Sferrazza. All rights reserved.
//

import UIKit

internal let ColorCellIdentifier = "ColorCell"

class ColorPickerDataSource: NSObject {
    let hueVariations: Int
    
    let preferredColorTotal: Int
    
    fileprivate(set) var sections: Array<Array<UIColor>>
    
    init(hueVariations: Int, preferredTotal: Int) {
        sections = Array<Array<UIColor>>()
        
        self.hueVariations = hueVariations
        self.preferredColorTotal = preferredTotal
        
        // Use 2 saturation variations for every brightness variation; completely arbitrary.
        let saturationVariations = Int(ceil(CGFloat(hueVariations) * (2.0/3.0)))
        let brightnessVariations = hueVariations - saturationVariations
        
        // Black / White
        var variations = Array<UIColor>()
        for blackVal in stride(from: CGFloat(0.0), to: 1.0, by: (1.0 / CGFloat(hueVariations))) {
            let color = UIColor(white: 1.0 - blackVal, alpha: 1.0)
            variations.append(color)
        }
        sections.append(variations)
        
        // Colors
        for hue in stride(from: CGFloat(0.0), to: 1.0, by: (1.0 / (CGFloat(preferredColorTotal) / CGFloat(hueVariations)))) {
            var variations = Array<UIColor>()
            
            let saturationIncrement = 1.0 / CGFloat(saturationVariations)
            for saturation in stride(from: saturationIncrement, to: 1.0, by: saturationIncrement) {
                let color = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
                variations.append(color)
            }
            // We've already created colors with a brightness = 1 so start with something lower.  Arbitrary.
            let maxBrightness: CGFloat = 0.8
            let brightnessIncrement = maxBrightness / CGFloat(brightnessVariations)
            for i in 0..<brightnessVariations {
                let brightness = maxBrightness - (brightnessIncrement * CGFloat(i))
                variations.append(UIColor(hue: hue, saturation: 1.0, brightness: brightness, alpha: 1.0))
            }
            sections.append(variations)
        }
    }
}

extension ColorPickerDataSource {
    func colorFromIndexPath(_ indexPath: IndexPath) -> UIColor? {
        if sections.count > (indexPath as NSIndexPath).section {
            let variations = sections[(indexPath as NSIndexPath).section]
            if variations.count > (indexPath as NSIndexPath).row {
                return variations[(indexPath as NSIndexPath).row]
            }
        }
        return nil
    }
}

extension ColorPickerDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCellIdentifier, for: indexPath)
        cell.backgroundColor = colorFromIndexPath(indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = sections[section]
        return items.count
    }
}
