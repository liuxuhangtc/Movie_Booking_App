//
//  PlaceholderImageView.swift
//  HouseShop
//
//  Created by Luochun on 2018/8/20.
//  Copyright © 2018 Mantis Group. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    private struct AssociatedKeys {
        static var initalStyleKey = "initalStyleKey"
    }
    
    fileprivate final func init_PlaceholderStyle() {
        self.image = UIImage(size: self.bounds.size, direction: .toRight, colors: [UIColor(hex:  0xeeeeee), UIColor(hex: 0xdddddd)])
        clipsToBounds = true
    }
    
    fileprivate final func removeStyle() {
        self.image = nil
    }
    
    
    /// 是否将UIImageView改变样式
    @IBInspectable open var placeholder: Bool {
        get { return (objc_getAssociatedObject(self, &AssociatedKeys.initalStyleKey) as? Bool) ?? true }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.initalStyleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            if newValue {
                init_PlaceholderStyle()
            } else {
                removeStyle()
            }
        }
        
    }
    
}
