//
//  ProfileViewController.swift
//  MovelRater
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

let aaa = "https://image.tmdb.org/t/p/w1000_and_h563_face//5BkSkNtfrnTuKOtTaZhl8avn4wU.jpg"
class ProfileViewController: MTBaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        userNameLabel.text = User.shared.userName
        nameLabel.text = ""
        ageLabel.text = ""
        emailLabel.text = ""
        addrLabel.text = ""
        
        if let user :JSONMap = UserDefaults.standard.dictionary(forKey: kUserInfo) {
            if let v =  user["name"] as? String {
                nameLabel.text = "Name: " + v
            }
            if let age = user["age"] as? Int {
                ageLabel.text = "Age: " + String(age)
            }
            if let v =  user["email"] as? String {
                emailLabel.text = "Email: " + v
            }
            if let v = user["address"] as? String {
                addrLabel.text = "Address: " + v
            }
        }
    }
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addrLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = .white
        
        topImageView.kf.setImage(with: URL(string: aaa))
        
        
    }
    
    
    @IBAction func edit() {
        let vc = self.storyboard?.instantiateVC(UserInfoEditViewController.self)
        vc?.hidesBottomBarWhenPushed  = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func signout() {
        User.logout()
        (AppDelegate.root as? ESTabBarController)?.selectedIndex = 0
    }
    
}
