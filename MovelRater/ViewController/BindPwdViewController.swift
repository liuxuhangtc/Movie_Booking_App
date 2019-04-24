//
//  BindPwdViewController.swift
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit



class BindPwdViewController: MTBaseViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var pwdField: UITextField!
    
    @IBOutlet weak var confirmPwdField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign up"
        
        
        addNavigationBarLeftButton(self)
        self.view.backgroundColor  = .white
        //pwdField.addPaddingLeft(15)
        
        pwdField.delegate = self
        confirmPwdField.delegate = self
        
        
        
        pwdField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        confirmPwdField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        editingChanged()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        userNameField.becomeFirstResponder()
    }
    
    /// check status
    @objc private func editingChanged() {
        if let name = userNameField.text, name.count > 0, let text = pwdField.text, text.count > 0 , let confirm = confirmPwdField.text, confirm.count > 0 {
            if confirm == text {
                loginButton.isEnabled = true
                return
            }else{
                return showTips("Two passswords are differet")
            }
        }
        
        loginButton.isEnabled = false
        
    }

    
    @IBAction func login() {
        guard let name = userNameField.text, name.count > 0 else {
            return showMessage("Please enter user name")
        }
        guard let text = pwdField.text, text.count > 0 else {
            return showMessage("Please enter user password")
        }
        guard let confirm = confirmPwdField.text, confirm.count > 0 else {
            return showMessage("Please enter confirm password")
        }
        guard text == confirm else {
            return showTips("Two passswords are differet")
        }
        
        view.endEditing(true)
        

        /// set login password
        MTHUD.showLoading()
        DBManager.default.addUserInfo(name, password: text, name: nil, age: nil, email: nil, address: nil)
        MTHUD.hide()
        
        let users = DBManager.default.getUserInfos(name, pwd: text)
        if users.count > 0 {
            User.shared.bind(users[0])
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else{
            showTips("Invalid")
        }
    }
}

extension BindPwdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == pwdField {
            confirmPwdField.becomeFirstResponder()
        }
        return true
    }
}
