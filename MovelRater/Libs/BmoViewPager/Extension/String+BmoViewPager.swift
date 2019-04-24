//
//  String+BmoViewPager.swift
//  ETNews
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

protocol BmoVPStringType {
    var bmoVPStringValue: String { get }
}
extension String: BmoVPStringType {
    var bmoVPStringValue: String {
        return String(self)
    }
}

public struct StringBmoVPProxy<Type> {
    public var base: Type
    public init(_ base: Type) {
        self.base = base
    }
}
public protocol StringBmoVPCompatible {
    var bmoVP: StringBmoVPProxy<String> { get }
}

extension String: StringBmoVPCompatible {
    public var bmoVP: StringBmoVPProxy<String> {
        get {
            return StringBmoVPProxy(self)
        }
    }
}

extension StringBmoVPProxy where Type: BmoVPStringType {
    func size(attribute: [NSAttributedString.Key : Any], size: CGSize) -> CGSize {
        let attributedText = NSAttributedString(string: base.bmoVPStringValue, attributes: attribute)
        return attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
    }
}
