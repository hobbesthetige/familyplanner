//
//  CellDequeuing.swift
//  NXUIKit
//
//  Created by Joe Sferrazza on 8/3/17.
//  Copyright © 2017 Nexcom. All rights reserved.
//

import UIKit

public protocol CellDequeuing {
    associatedtype CellIdentifier: RawRepresentable
}

public extension CellDequeuing where Self: UITableViewDataSource, CellIdentifier.RawValue == String {
    func dequeueCellFrom<T: UITableViewCell>(_ tableView: UITableView, identifier: CellIdentifier, indexPath: IndexPath) -> T {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier.rawValue, for: indexPath) as! T
        return cell
    }
    
    func dequeueCellFrom<T: UICollectionViewCell>(_ collectionView: UICollectionView, identifier: CellIdentifier, indexPath: IndexPath) -> T {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier.rawValue, for: indexPath) as! T
        return cell
    }
}
