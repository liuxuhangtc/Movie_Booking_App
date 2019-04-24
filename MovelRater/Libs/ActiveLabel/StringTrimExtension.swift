//
//  StringTrimExtension.swift
//  ActiveLabel
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation

extension String {

    func trim(to maximumCharacters: Int) -> String {
        return "\(self[..<index(startIndex, offsetBy: maximumCharacters)])" + "..."
    }
}
