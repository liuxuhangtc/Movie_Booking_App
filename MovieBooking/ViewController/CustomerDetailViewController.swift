//
//  CustomerDetailViewController.swift
//  MovieBooking
//
//  Created by Xuhang Liu on 2019/2/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class CustomerDetailViewController: UIViewController {

    var cus: Customer?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarLeftButton(self)
        
        title = "Customer Detail"
        view.addTapToCloseEditing()
        
        [nameField, ageField, emailField, addressField].forEach({$0?.addPaddingLeft(10)})
        
        if let info = cus {
            nameField.text = info.name
            ageField.text = String(info.age)
            emailField.text = info.email
            addressField.text = info.address
            
        } else {
            deleteButton.isHidden = true
        }
        
    }
    
    @IBAction func submit() {
        if let info = cus {
            guard let name = nameField.text, name.count > 0 else {
                return showTips("Please enter customer name ")
            }
            guard let text = ageField.text , text.count > 0, let age = Int(text) , age > 0 else {
                return showTips("Please enter customer age ")
            }
            guard let email = emailField.text, email.count > 0 else {
                return showTips("Please enter customer email ")
            }
            let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            guard predicate.evaluate(with: email) else {
                return showTips("Please enter customer email ")
            }
            guard let addr = addressField.text, addr.count > 0  else {
                return showTips("Please enter customer address ")
            }
            info.name = name
            info.age = Int16(age)
            info.email = email
            info.address = addr
            
            DBManager.default.updateCustomer(cus!)
            
            popBack()
        } else {
            guard let name = nameField.text, name.count > 0 else {
                return showTips("Please enter customer name ")
            }
            guard let text = ageField.text , text.count > 0, let age = Int(text) else {
                return showTips("Please enter customer age ")
            }
            guard let email = emailField.text, email.count > 0 else {
                return showTips("Please enter customer email ")
            }
            let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            guard predicate.evaluate(with: email) else {
                return showTips("Please enter customer email ")
            }
            guard let addr = addressField.text  else {
                return showTips("Please enter customer address ")
            }
            DBManager.default.addCustomer(name, age: age, email: email, address: addr)
           
            popBack()
        }
    }

    
    @IBAction func delete() {
        let alertController = UIAlertController(title: "Tips", message: "Delete customer detail?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Delete", style: .default) { _ in
            
            DBManager.default.deleteCustomer(self.cus!.name!)
            print("Delete Success")
            self.popBack()
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.navigationController?.present(alertController, animated: true, completion: nil)

    }

}
