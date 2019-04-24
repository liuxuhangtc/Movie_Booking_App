//
//  LoginViewController.swift
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class LoginViewController: MTBaseViewController {

    @IBOutlet weak var smsLoginView: UIView!
    
    @IBOutlet weak var mobileNoField: UITextField!
    
    @IBOutlet weak var pwdField: UITextField!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = .white
        //view.addTapToCloseEditing()
        
//        #if DEBUG
//        mobileNoField.text = "13629723564"
//            pwdField.text = "aaaa1111"
//        #endif

        closeButton.setImage(AppConfig.closeImage, for: .normal)
        
        mobileNoField.becomeFirstResponder()
    }

    @IBAction func colse() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func register() {
        let vc = self.storyboard?.instantiateVC(BindPwdViewController.self)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func login() {
        loginWithAccount()
    }
    

    private func loginWithAccount() {
        guard let text = mobileNoField.text, text.count > 0 else {
            return showMessage("Please enter user name")
        }

        guard let password = pwdField.text, password.count > 0 else {
            return showMessage("Please enter password")
        }
 
        view.endEditing(true)
        
        let users = DBManager.default.getUserInfos(text, pwd: password)
        if users.count > 0 {
            User.shared.bind(users[0])
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else{
            showTips("Invalid login")
        }
    }
    

}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == pwdField {
            login()
        }

        return true
    }

}
