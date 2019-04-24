//
//  System+Ext.swift
//  TaodaiAgents
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation
import UIKit



public extension UIView {
    // MARK: - UIView Rect
    
    /// 高度
    var height: CGFloat {
        get { return frame.size.height }
        set { frame.size.height = newValue }
    }
    /// 宽度
    var width: CGFloat {
        get { return frame.size.width }
        set { frame.size.width = newValue }
    }
    /// 横坐标
    var x: CGFloat {
        get { return frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    /// Y 坐标
    var y: CGFloat {
        get { return frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    /// 最小 X
    var minX: CGFloat {
        return frame.minX
    }
    /// 最小 Y
    var minY: CGFloat {
        return frame.minY
    }
    
    /// The horizontal center coordinate of the UIView.
    public var centerX: CGFloat {
        get {
            return frame.centerX
        }
        set(value) {
            var frame = self.frame
            frame.centerX = value
            self.frame = frame
        }
    }
    
    /// The vertical center coordinate of the UIView.
    public var centerY: CGFloat {
        get {
            return frame.centerY
        }
        set(value) {
            var frame = self.frame
            frame.centerY = value
            self.frame = frame
        }
    }
    /// 最大 X
    var maxX: CGFloat {
        return frame.maxX
    }
    /// 最大 Y
    var maxY: CGFloat {
        return frame.maxY
    }
    
}



extension UIImage {
    
    /// UIImage根据高宽比缩放到高度
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    ///   - orientation: optional UIImage orientation (default is nil).
    /// - Returns: optional scaled UIImage (if applicable).
    public func scaled(toHeight: CGFloat, opaque: Bool = false, with orientation: UIImage.Orientation? = nil) -> UIImage? {
        if toHeight < size.height {
            let scale = toHeight / size.height
            let newWidth = size.width * scale
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, scale)
            draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        } else {
            return self
        }
    }
    
    /// UIImage根据高宽比缩放到宽度
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    ///   - orientation: optional UIImage orientation (default is nil).
    /// - Returns: optional scaled UIImage (if applicable).
    public func scaled(toWidth: CGFloat, opaque: Bool = false, with orientation: UIImage.Orientation? = nil) -> UIImage? {
        if toWidth < size.width {
            let scale = toWidth / size.width
            let newHeight = size.height * scale
            UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, scale)
            draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        else {
            return self
        }
    }
    
    

//    /// 质量压缩
//    ///
//    /// - Parameter maxLength:  最大尺寸，压缩后不超过此大小 (单位: Byte, 2M = 2 * 1024 * 1024)
//    /// - Returns: 压缩后的image
//    public func compress(_ maxLength: CGFloat) -> UIImage {
//        //图片的压缩比和压缩后的大小是线性关系(如果从quality从1开始就不是线性关系)
//        if var data = UIImageJPEGRepresentation(self, 0.99) {
//            let sizeOfImage = CGFloat(data.count)
//            print("=================sizeOfImage: \(sizeOfImage)")
//            let quality = maxLength / sizeOfImage
//            if quality < 1 {
//                if let specificImageData = UIImageJPEGRepresentation(self, quality) {
//                    print("=================sizeOfCompressImage: \(CGFloat(specificImageData.count))")
//                    return UIImage(data: specificImageData, scale: 1)!
//                }
//            }
//        }
//        return self
//    }
//
    
}


extension UIImage {
    // MARK: - UIImage+Resize
    
    /// 质量压缩  循环
    ///
    /// - Parameter expectedSize: 最大尺寸，压缩后不超过此大小 (单位: Byte, 2M = 2 * 1024 * 1024)
    /// - Returns: IMAGE
    func compressTo(_ expectedSize: Int) -> UIImage {
        
        var needCompress:Bool = true
        var imgData: Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < expectedSize {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < expectedSize) {
                return UIImage(data: data) ?? self
            }
        }
        return self
    }
    

}

// MARK: - Methods
public extension UINavigationController {
    

    /// 移除中间所有界面，保留首尾2个
    ///
    /// - Parameter item: viewcontroller
    public func removeMiddles() {
        var vcs = self.viewControllers
        if vcs.count > 2 {
            self.viewControllers = [vcs[0], vcs.last! ]
        }
    }
    
    /// 移除指定位置界面
    ///
    /// - Parameter item: viewcontroller
    public func remove(_ index: Int) {
        var vcs = viewControllers
        if vcs.count > index && index > -1 {
            vcs.remove(at: index)
        }
        viewControllers = vcs
    }
}


public extension UILabel {
    @objc public func pushTransition(_ duration: CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        self.layer.add(animation, forKey: convertFromCATransitionType(CATransitionType.push))
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
	return input.rawValue
}
