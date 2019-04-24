//
//  config.swift
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation
import  UIKit


    /// API
    let BaseUrl =  "http://192.168.55.36:8081"
    /// H5
    let BaseWebUrl =  "http://192.168.55.36:8082"

    let SystemConfig_PartnerId = "test"
    let SystemConfig_SecretKey = "06f7aab08aa2431e6dae6a156fc9e0b4"

    /// API
//    let BaseUrl =  "http://platform.amyglzx.com"
//    /// H5
//    let BaseWebUrl =  "https://app.amyglzx.com"
//
//    let SystemConfig_PartnerId = "19010221023636680001"
//    let SystemConfig_SecretKey = "5b74da88a016ef842a9db69c78a93e01"


let API_BASE_URL = BaseUrl + "/gateway.do"

let UPLOAD_URL_IMAGE = BaseUrl + "/api/upload"

let UPLOAD_URL_VIDEO = BaseUrl + "/protal/fileTransfer/upload"

//com.ihunlizhe.marriageclass
//com.hunlizhe.MarriageClass

/*UMeng*/
let uMengAppKey = "5c204bb1b465f560d30001a8"
//let uMengAppKey = "5c414b2cb465f51aff000f9a"



public typealias JSONMap = [String: Any]

struct AppConfig {

    static let closeImage = CAShapeLayer.closeShape(edgeLength: 15, fillColor: MTColor.main).toImage()
    static let backImage = CAShapeLayer.backShape(edgeLength: 16).toImage()
}




extension NSNotification.Name {
    public static var indexNeedRefresh: NSNotification.Name = NSNotification.Name("MTIndexNeedRefresh")
    
    public static var userDidLogin: NSNotification.Name = NSNotification.Name("MTUserDidLoginNotification")
    public static var userDidLogOut: NSNotification.Name = NSNotification.Name("MTUserDidLogOutNotification")
    
    
}



struct MTColor {
    static var main = UIColor(red:0.17, green:0.34, blue:0.60, alpha:1.00)
    static var mainX = UIColor(hex: 0xFF4F00)    //#FF4F00
    
    static var secondBlue = UIColor(red:0.15, green:0.53, blue:1.00, alpha:1.00) //蓝色

    static var pageback = UIColor.white
    
    static var title111 = UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.00)
    static var title222 = UIColor(hex: 0x222222)
    
    static var des666 = UIColor(hex: 0x666666)
    static var des999 = UIColor(hex: 0x999999)         //999999
    
}




struct pingFang_SC {
    static func bold(_ size: CGFloat = 15.0) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    static func medium(_ size: CGFloat = 15.0) -> UIFont {
        return UIFont(name: "PingFang-SC-Medium", size: size)!
    }
    static func regular(_ size: CGFloat = 15.0) -> UIFont {
        return UIFont(name: "PingFang-SC-Regular", size: size)!
    }
    static func light(_ size: CGFloat = 15.0) -> UIFont {
        return UIFont(name: "PingFang-SC-Light", size: size)!
    }
    
}

// status bar height.
let kStatusBarHeight: CGFloat = (UIDevice.isIPhoneXSeries ? 44.0 : 20.0)

// Navigation bar height.
let  kNavigationBarHeight: CGFloat = 44.0

// Tabbar height.
let kTabbarHeight: CGFloat = (UIDevice.isIPhoneXSeries ? (49.0 + 34.0) : 49.0)

// Tabbar safe bottom margin.
let kTabbarSafeBottomMargin: CGFloat = (UIDevice.isIPhoneXSeries ? 34.0 : 0.0)

// Status bar & navigation bar height.
let kStatusBarAndNavigationBarHeight: CGFloat = (UIDevice.isIPhoneXSeries ? 88.0 : 64.0)


let PasswordRegix = "^[A-Za-z0-9]{6,16}$"
//let PasswordRegix = "[a-zA-Z]{1}[\\w|&|@|#|$|-]{7,15}"
