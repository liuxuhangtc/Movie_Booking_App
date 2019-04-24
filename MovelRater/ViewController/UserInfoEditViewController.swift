//
//  UserInfoEditViewController.swift
//  MovelRater
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class UserInfoEditViewController: MTBaseViewController {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addrField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarLeftButton(self)
        title = "User info"
        
        if let user :JSONMap = UserDefaults.standard.dictionary(forKey: kUserInfo) {
            if let v =  user["name"] as? String {
                nameField.text =  v
            }
            if let age = user["age"] as? Int {
                ageField.text = String(age)
            }
            if let v =  user["email"] as? String {
                emailField.text =  v
            }
            if let v = user["address"] as? String {
                addrField.text =  v
            }
        }
    }

    
    @IBAction func save() {
        
        guard let name = nameField.text, name.count > 0 else {
            return showTips("Please enter name ")
        }
        guard let v = ageField.text, v.count > 0 , let age = Int(v), age > 0 else {
            return showTips("Invalid age ")
        }
        guard let email = emailField.text, email.count > 0 else {
            return showTips("Please enter email ")
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard predicate.evaluate(with: email) else {
            return showTips("Invalid email ")
        }
        
        guard let addr = addrField.text, addr.count > 0 else {
            return showTips("Please enter address ")
        }
        
        let u = DBManager.default.getUserInfos(User.shared.userName!)[0]
        u.name = name
        u.age = Int16(age)
        u.email = email
        u.address = addr
        
        
        DBManager.default.updateUserInfo(u)
        User.shared.bind(u)
        self.navigationController?.popViewController(animated: true)
    }
}
