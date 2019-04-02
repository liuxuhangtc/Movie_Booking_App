//
//  Customer.swift
//  Assignment4-Xuhang Liu
//
//  Created by xuhang on 2/13/19.
//  Copyright © 2019 xuhang. All rights reserved.
//

import Foundation

//regex for email
let emailRegex = "^[A-Za-z\\d]+([-_.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-.])+[A-Za-z\\d]{2,4}$"

struct Customer {
    var id : Int = 0
    var name: String = ""
    var age: Int = 0
    var email: String = ""
    var address: String = ""
    
    
    static func enterCustomer() {
        
        var customer = Customer()
        if let id = app.customers.last?.id {
            customer.id = id + 1
        } else {
            customer.id = 1
        }
        //Add customer function
        func add() {
            
            if customer.name.count == 0 {
                print("Please enter customer name:")
                if let name = readLine() {
                    customer.name = name
                }
            }
            if customer.age == 0 {
                print("Please enter customer age:")
                if let age = readLine(), let value = Int(age) {
                    customer.age = value
                }else{
                    print("Please enter a valid number")
                    add()
                }
                
            }
            if customer.email.count == 0 {
                print("Please enter customer email:")
                if let email = readLine() {
                    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                    let isValid = predicate.evaluate(with: email)
                    if isValid {
                        customer.email = email
                    } else {
                        print("Incorrect Email format!")
                    }
                }
                add()
            }
            if customer.address.count == 0 {
                print("Please enter customer address:")
                if let addr = readLine() {
                    customer.address = addr
                }
            }
            
            app.customers.append(customer)
            enterCustomer()
        }
        
        func delete() {
            print("Please enter id to delete:")
            if let del = readLine() , let delete_id = Int(del) {
                app.customers = app.customers.filter({$0.id != delete_id })
                print("Delete Success")

            } else {
                print("Invalid id")
            }
        }
        
        /// update Customer
        func update() {
            
            //main update function
            func updateDetail(_ cus: Customer) {
                var cus = cus
                print(cus)
                print("1.Name \n 2.Age \n 3.Email \n 4.Address \n 5.Exit")
                if let option = readLine() {
                    switch option {
                    case "1":
                        print("Please enter update name:")
                        if let value = readLine() ,value.count > 0  {
                            cus.name = value
                            app.replaceCustomer(cus)
                        }
                        updateDetail(cus)
                    case "2":
                        print("Please enter update age:")
                        if let value = readLine(), let age = Int(value) {
                            cus.age = age
                            app.replaceCustomer(cus)
                        }
                        updateDetail(cus)
                    case "3":
                        print("Please enter update email:")
                        
                        if let email = readLine() {
                            let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                            let isValid = predicate.evaluate(with: email)
                            if isValid {
                                cus.email = email
                                app.replaceCustomer(cus)
                            }else{
                                print("Incorrect Email format!")
                            }
                        }
                        updateDetail(cus)
                    case "4":
                        print("Please enter update address:")
                        if let value = readLine(), value.count > 0 {
                            cus.address = value
                            app.replaceCustomer(cus)
                        }
                        updateDetail(cus)
                    case "5":
                        enterCustomer()
                    default:
                        print("error option")
                        update()
                    }
                }
            }
            print("Available Customers:",app.customers.count)
            print("Please enter id to update:")
            if let value = readLine(), let id = Int(value) {
                let custs = app.customers.filter({$0.id == id})
                if custs.count > 0 {
                    updateDetail(custs[0])
                }else{
                    print("Invalid id")
                }
            }
            print("Invalid id")
            enterCustomer()
        }
        
      
    }
    
}
