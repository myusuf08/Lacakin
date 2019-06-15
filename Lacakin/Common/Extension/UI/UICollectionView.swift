//
//  UICollectionView.swift
//  CIRCL
//
//  Created by Muhammad Yusuf on 07/12/18.
//  Copyright © 2018 Circl.It. All rights reserved.
//

import UIKit

protocol ReusableCollectionView {}

extension ReusableCollectionView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(_: T.Type) where T: ReusableCollectionView {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerHeader<T: UICollectionViewCell>(_: T.Type) where T: ReusableCollectionView {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueClass<T: UICollectionViewCell>(_ indexPath: IndexPath,_ class: T.Type) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.nibName, for: indexPath) as! T
    }
    
    func dequeueHeader<T: UICollectionViewCell>(_ kind: String,_ indexPath: IndexPath,_ class: T.Type) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.nibName, for: indexPath) as! T
    }
    
    
    
}

