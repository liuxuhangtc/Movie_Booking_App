//
//  MTGradientButton.swift
//  MTCobwebs
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {
    
    ///
    /// ```
    ///     let colors = [UIColor(hex: "FF8960"), UIColor(hex: "FF62A5")]
    ///     button.setGradientBackgroundColors(colors, direction: .toRight, for: .normal)
    /// ```
    ///
    /// - Parameters:
    ///   - colors
    ///   - direction: toLeft  see `MTImageGradientDirection`
    ///   - state
    func setGradientBackgroundColors(_ colors: [UIColor], direction: MTImageGradientDirection = .toLeft, for state: UIControl.State) {
        if colors.count > 1 {
            // Gradient background
            setBackgroundImage(UIImage(size: CGSize(width: 1, height: 1), direction: direction, colors: colors), for: state)
        }
        else {
            if let color = colors.first {
                // Mono color background
                setBackgroundImage(UIImage(fillColor: color, size: CGSize(width: 1, height: 1)), for: state)
            }
            else {
                // Default background color
                setBackgroundImage(nil, for: state)
            }
        }
    }
}

///
/// - toLeft: toLeft
/// - toRight: toRight
/// - toTop: toTop
/// - toBottom: toBottom
/// - toBottomLeft: toBottomLeft
/// - toBottomRight: toBottomRight
/// - toTopLeft: toTopLeft
/// - toTopRight: toTopRight
/// - degree
public enum MTImageGradientDirection {
    case toLeft
    case toRight
    case toTop
    case toBottom
    case toBottomLeft
    case toBottomRight
    case toTopLeft
    case toTopRight
    case degree(CGFloat)
}

public extension UIImage {
    
    ///
    /// ```
    ///     let colors = [UIColor(hex: "FF8960"), UIColor(hex: "FF62A5")]
    ///     let image = UIImage(size: CGSize(width: 100, height: 100), direction: .toBottom, colors: colors)
    /// ```
    ///
    /// - Parameters:
    ///   - size
    ///   - direction
    ///   - colors
    convenience init?(size: CGSize, direction: MTImageGradientDirection, colors: [UIColor]) {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil } // If the size is zero, the context will be nil.
        
        guard colors.count >= 1 else { return nil } // If less than 1 color, return nil
        
        if colors.count == 1 {
            // Mono color
            let color = colors.first!
            color.setFill()
            
            let rect = CGRect(origin: CGPoint.zero, size: size)
            UIRectFill(rect)
        }
        else {
            // Gradient color
            var location: CGFloat = 0
            var locations: [CGFloat] = []
            
            for (index, _) in colors.enumerated() {
                let index = CGFloat(index)
                locations.append(index / CGFloat(colors.count - 1))
            }
            
            guard let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: colors.compactMap { $0.cgColor.components }.flatMap { $0 }, locations: locations, count: colors.count) else {
                return nil
            }
            
            var startPoint: CGPoint
            var endPoint: CGPoint
            
            switch direction {
            case .toLeft:
                startPoint = CGPoint(x: size.width, y: size.height/2)
                endPoint = CGPoint(x: 0.0, y: size.height/2)
            case .toRight:
                startPoint = CGPoint(x: 0.0, y: size.height/2)
                endPoint = CGPoint(x: size.width, y: size.height/2)
            case .toTop:
                startPoint = CGPoint(x: size.width/2, y: size.height)
                endPoint = CGPoint(x: size.width/2, y: 0.0)
            case .toBottom:
                startPoint = CGPoint(x: size.width/2, y: 0.0)
                endPoint = CGPoint(x: size.width/2, y: size.height)
            case .toBottomLeft:
                startPoint = CGPoint(x: size.width, y: 0.0)
                endPoint = CGPoint(x: 0.0, y: size.height)
            case .toBottomRight:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: size.width, y: size.height)
            case .toTopLeft:
                startPoint = CGPoint(x: size.width, y: size.height)
                endPoint = CGPoint(x: 0.0, y: 0.0)
            case .toTopRight:
                startPoint = CGPoint(x: 0.0, y: size.height)
                endPoint = CGPoint(x: size.width, y: 0.0)
            case .degree(let degree):
                let radian = degree * .pi / 180
                startPoint = CGPoint(x: 0.5 * (cos(radian) + 1), y: 0.5 * (1 - sin(radian)))
                endPoint = CGPoint(x: 0.5 * (cos(radian + .pi) + 1), y: 0.5 * (1 + sin(radian)))
            }
            
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions())
        }
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        
        self.init(cgImage: image)
        
        defer { UIGraphicsEndImageContext() }
    }
    
    convenience init?(fillColor: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        fillColor.setFill()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIRectFill(rect)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        
        self.init(cgImage: image)
        
        defer { UIGraphicsEndImageContext() }
    }
}
