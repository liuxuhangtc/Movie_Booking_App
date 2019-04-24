//
//  ES.swift
//  ESPullToRefreshExample
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit


public protocol ESExtensionsProvider: class {
    associatedtype CompatibleType
    var es: CompatibleType { get }
}

extension ESExtensionsProvider {
    /// A proxy which hosts reactive extensions for `self`.
    public var es: ES<Self> {
        return ES(self)
    }

}

public struct ES<Base> {
    public let base: Base
    
    // Construct a proxy.
    //
    // - parameters:
    //   - base: The object to be proxied.
    fileprivate init(_ base: Base) {
        self.base = base
    }
}

// 
extension UIScrollView: ESExtensionsProvider {}


