//
//  Array+GetterSetter.swift
//  Pods
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//
//

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
