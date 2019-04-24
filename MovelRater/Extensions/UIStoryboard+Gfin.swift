//
//  UIStoryboard+Gfin.swift
//  Gfintech
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit


public extension UIStoryboard {
    
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }


    

    static var login: UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }

    public struct Scene {
        static var home: HomeViewController {
            return UIStoryboard.main.instantiateVC(HomeViewController.self)!
        }
        
        static var index: IndexViewController {
            return UIStoryboard.main.instantiateVC(IndexViewController.self)!
        }
        static var collection: CollectionViewController {
            return UIStoryboard.main.instantiateVC(CollectionViewController.self)!
        }
        static var map: GoogleMapViewController {
            return UIStoryboard.main.instantiateVC(GoogleMapViewController.self)!
        }
        
        static var mine: ProfileViewController {
            return UIStoryboard.main.instantiateVC(ProfileViewController.self)!
        }

        

        // MARK: - Setting

        static var login: LoginViewController {
            return UIStoryboard.login.instantiateVC(LoginViewController.self)!
        }

        
        /// 设置密码
        static var bindPwd: BindPwdViewController {
            return UIStoryboard.login.instantiateVC(BindPwdViewController.self)!
        }

        
    }
    
}

public extension UIStoryboard {
    
    /// Get view controller from storyboard by its class type
    ///
    ///         let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    ///
    /// Warning: identifier should match storyboard ID in storyboard of identifier class
    func instantiateVC<T>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        if let vc = instantiateViewController(withIdentifier: storyboardID) as? T {
            return vc
        } else {
            return nil
        }
    }
    
    /// Get view controller from storyboard by its class type
    ///
    ///         let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    ///
    func instantiate<T: UIViewController>(controller: T.Type) -> T
        where T: Identifiable {
            return instantiateViewController(withIdentifier: T.identifier) as! T
    }
    
}


public protocol Identifiable {
    
    static var identifier: String { get }
}

public extension Identifiable {
    
    static var identifier: String {
        return String(describing: self)
    }
}
