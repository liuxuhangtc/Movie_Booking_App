//
//  User.swift
//  Gfintech
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation


let kUserInfo = "loginedUser"

public class User {
    private static let _sharedInstance = User()
    
    public static var shared: User {
        return _sharedInstance
    }



    var userName: String?
    
    
    
    func bind(_ source: UserInfo) {
        var object : JSONMap = [:]
        object["userName"] = source.userName
        object["password"] = source.password
        object["name"] = source.name
        object["age"] = source.age
        object["email"] = source.email
        object["address"] = source.address
        
        if let userName = object["userName"] as? String {
            self.userName = userName
        }

        UserDefaults.standard.set(object, forKey: kUserInfo)
 
        
    }
    

    static func logout() {

        UserDefaults.standard.removeObject(forKey: kUserInfo)
        
        User.shared.userName = nil
        
    }

    
    static var isLogined: Bool {
        if let user :JSONMap = UserDefaults.standard.dictionary(forKey: kUserInfo) {
            if let userName = user["userName"] as? String {
                User.shared.userName = userName
            }
            
            return true
        }
        return false
    }
}
