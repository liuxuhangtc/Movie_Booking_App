//
//  ActiveLabel+Bond.swift
//  HouseShop
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation

extension ActiveLabel {
    func bind(_ text: String, link: String, handle: (()->())? = nil) {
        let customType = ActiveType.custom(pattern: "\\s" + link)  //不能使用view.addTapToCloseEditing,会被拦截
        self.enabledTypes.append(customType)
        
        self.customize { label in
            label.text  = text
            label.numberOfLines = 0
            label.customColor[customType] = MTColor.mainX
            //label.customSelectedColor[customType] = MTColor.des666
            
            label.handleCustomTap(for: customType) {_ in
                handle?()
            }
        }
    }
}
