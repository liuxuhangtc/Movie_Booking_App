//
//  Pro+Ext.swift
//  TaodaiAgents
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func toImage() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        self.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

public extension CAShapeLayer {
    static func closeShape(edgeLength: CGFloat, fillColor: UIColor = .white) -> CAShapeLayer {
        
        let container = CAShapeLayer()
        container.bounds.size = CGSize(width: edgeLength + 4, height: edgeLength + 4)
        container.frame.origin = CGPoint.zero
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: edgeLength, y: edgeLength))
        linePath.move(to: CGPoint(x: 0, y: edgeLength))
        linePath.addLine(to: CGPoint(x: edgeLength, y: 0))
        
        let elementBorder = CAShapeLayer()
        elementBorder.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementBorder.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementBorder.lineCap = CAShapeLayerLineCap.round
        elementBorder.path = linePath.cgPath
        elementBorder.strokeColor = UIColor.darkGray.cgColor
        elementBorder.lineWidth = 2
        
        let elementFill = CAShapeLayer()
        elementFill.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementFill.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementFill.lineCap = CAShapeLayerLineCap.round
        elementFill.path = linePath.cgPath
        elementFill.strokeColor = fillColor.cgColor
        elementFill.lineWidth = 2
        
        container.addSublayer(elementBorder)
        container.addSublayer(elementFill)
        
        return container
    }
    
    /// 返回Layer
    ///
    /// - Parameters:
    ///   - edgeLength: 长度
    ///   - fillColor: 颜色
    /// - Returns: shape layer
    static func backShape(edgeLength: CGFloat, fillColor: UIColor = .white) -> CAShapeLayer {
        
        let container = CAShapeLayer()
        container.bounds.size = CGSize(width: edgeLength + 4, height: edgeLength + 4)
        container.frame.origin = CGPoint.zero
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: edgeLength / 3 * 1.57, y: 0))      //1.62
        linePath.addLine(to: CGPoint(x: 0, y: edgeLength / 2))
        linePath.move(to: CGPoint(x: 0, y: edgeLength / 2))
        linePath.addLine(to: CGPoint(x: edgeLength / 3 * 1.57, y: edgeLength))
        
        let elementBorder = CAShapeLayer()
        elementBorder.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementBorder.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementBorder.lineCap = CAShapeLayerLineCap.round
        elementBorder.path = linePath.cgPath
        elementBorder.strokeColor = UIColor.clear.cgColor
        elementBorder.lineWidth = 2
        
        let elementFill = CAShapeLayer()
        elementFill.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementFill.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementFill.lineCap = CAShapeLayerLineCap.round
        elementFill.path = linePath.cgPath
        
        elementFill.strokeColor = fillColor.cgColor
        
        elementFill.lineWidth = 2
        
        container.addSublayer(elementBorder)
        container.addSublayer(elementFill)
        
        return container
    }
    
    /// 确认Layer （勾）
    ///
    /// - Parameters:
    ///   - edgeLength: 长度
    ///   - fillColor: 颜色
    /// - Returns: shape layer
    static func confirmShape(edgeLength: CGFloat, fillColor: UIColor = .white) -> CAShapeLayer {
        
        let container = CAShapeLayer()
        container.bounds.size = CGSize(width: edgeLength + 4, height: edgeLength + 4)
        container.frame.origin = CGPoint.zero
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: edgeLength * 0.47))
        linePath.addLine(to: CGPoint(x: edgeLength * 0.32, y: edgeLength * 0.88))
        linePath.move(to: CGPoint(x: edgeLength * 0.32, y: edgeLength * 0.88))
        linePath.addLine(to: CGPoint(x:  edgeLength * 0.96, y: edgeLength * 0.18))
        
        let elementBorder = CAShapeLayer()
        elementBorder.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementBorder.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementBorder.lineCap = CAShapeLayerLineCap.round
        elementBorder.path = linePath.cgPath
        elementBorder.strokeColor = UIColor.darkGray.cgColor
        elementBorder.lineWidth = 2.5
        
        let elementFill = CAShapeLayer()
        elementFill.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementFill.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementFill.lineCap = CAShapeLayerLineCap.round
        elementFill.path = linePath.cgPath
        elementFill.strokeColor = fillColor.cgColor
        elementFill.lineWidth = 2
        
        container.addSublayer(elementBorder)
        container.addSublayer(elementFill)
        
        return container
    }
    
    
    /// 加号Layer
    ///
    /// - Parameters:
    ///   - edgeLength: 长度
    ///   - fillColor: 颜色
    /// - Returns: shape layer
    static func plusShape(edgeLength: CGFloat, fillColor: UIColor = .white) -> CAShapeLayer {
        
        let container = CAShapeLayer()
        container.bounds.size = CGSize(width: edgeLength + 4, height: edgeLength + 4)
        container.frame.origin = CGPoint.zero
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: edgeLength / 2, y: 0))
        linePath.addLine(to: CGPoint(x: edgeLength / 2, y: edgeLength))
        linePath.move(to: CGPoint(x: 0, y: edgeLength / 2))
        linePath.addLine(to: CGPoint(x: edgeLength , y: edgeLength / 2))
        
        let elementBorder = CAShapeLayer()
        elementBorder.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementBorder.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementBorder.lineCap = CAShapeLayerLineCap.round
        elementBorder.path = linePath.cgPath
        elementBorder.strokeColor = UIColor.clear.cgColor
        elementBorder.lineWidth = 2.5
        
        let elementFill = CAShapeLayer()
        elementFill.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementFill.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementFill.lineCap = CAShapeLayerLineCap.round
        elementFill.path = linePath.cgPath
        
        elementFill.strokeColor = fillColor.cgColor
        elementFill.lineWidth = 2
        
        container.addSublayer(elementBorder)
        container.addSublayer(elementFill)
        
        return container
    }

}

extension UIDevice {
    /// iphone有刘海
    public static var isIPhoneXSeries: Bool {
        var iPhoneXSeries = false
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return iPhoneXSeries
        }
        
        if #available(iOS 11.0, *)  {
            if let bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom {
                if bottom > CGFloat(0.0) {
                    iPhoneXSeries = true
                }
            }
        }
        
        return iPhoneXSeries
    }

    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    static func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
}

public extension LazyMapCollection  {
    
    func toArray() -> [Element] {
        return Array(self)
    }
}
