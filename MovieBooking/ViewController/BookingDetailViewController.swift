//
//  BookingDetailViewController.swift
//  MovieBooking
//
//  Created by Xuhang Liu on 2019/2/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class BookingDetailViewController: UIViewController {

    var booking: Booking?
    
    @IBOutlet weak var movieIDField: UITextField!
    @IBOutlet weak var customerIDField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarLeftButton(self)
        
        title = "Booking Detail"
        view.addTapToCloseEditing()
        
        [movieIDField, customerIDField, numberField, startDateField, endDateField].forEach({$0?.addPaddingLeft(10)})
        
        startDateField.delegate = self
        endDateField.delegate = self
        
        if let info = booking {
            movieIDField.text = String(info.movie!.title!)
            customerIDField.text = String(info.customer!.name!)
            movieIDField.isEnabled = false
            customerIDField.isEnabled = false
            numberField.text = String(info.number)
            startDateField.text = info.startDate
            endDateField.text = info.endDate
        } else {
            deleteButton.isHidden = true
        }
        
    }
    
    @IBAction func submit() {
        if var info = booking {
            guard let text = movieIDField.text, text.count > 0 else {
                return showTips("Please enter movie ID ")
            }
            guard let c = customerIDField.text, c.count > 0 else {
                return showTips("Please enter customer ID ")
            }
            
            guard let n = numberField.text , n.count > 0, let number = Int(n), number > 0 else {
                return showTips("Please enter valid booking number ")
            }
            guard let start = startDateField.text, start.count > 0 else {
                return showTips("Please enter booking date ")
            }
            guard let _ = start.date("MM-dd-YYYY") else {
                return showTips("booking date must be 'MM-dd-YYYY'")
            }
            
            guard let end = endDateField.text , end.count > 0  else {
                return showTips("Please enter return date ")
            }
            guard let _ = end.date("MM-dd-YYYY") else {
                return showTips("booking date must be 'MM-dd-YYYY'")
            }
            
            let movs = DBManager.default.getMovies(text)
            if movs.count == 0 {
                showTips("can't find any movie")
                return
            }
            if Int(movs[0].quantity) - DBManager.default.getBookingQuantity(movs[0]) < number {
                showTips("Tips: No available quantity of movies")
                return
            }
            info.movie = movs[0]
            
            let cus = DBManager.default.getCustomers(c)
            if cus.count == 0 {
                showTips("can't find any movie")
                return
            }
            info.customer = cus[0]
            
            info.number = Int16(number)
            info.startDate = start
            info.endDate = end
            
            DBManager.default.updateBooking(info)
            
            popBack()
        } else {
            guard let text = movieIDField.text, text.count > 0 else {
                return showTips("Please enter movie ID ")
            }
            guard let c = customerIDField.text, c.count > 0 else {
                return showTips("Please enter customer ID ")
            }
            
            guard let n = numberField.text , n.count > 0, let number = Int(n), number > 0 else {
                return showTips("Please enter booking number ")
            }
            guard let start = startDateField.text, start.count > 0 else {
                return showTips("Please enter booking date ")
            }
            guard let _ = start.date("MM-dd-YYYY") else {
                return showTips("booking date must be 'MM-dd-YYYY'")
            }
            
            guard let end = endDateField.text , end.count > 0  else {
                return showTips("Please enter return date ")
            }
            guard let _ = end.date("MM-dd-YYYY") else {
                return showTips("booking date must be 'MM-dd-YYYY'")
            }

            let movs = DBManager.default.getMovies( text)
            if movs.count > 0 {
                if Int(movs[0].quantity) - DBManager.default.getBookingQuantity(movs[0]) < number {
                    showTips("Tips: No available quantity of movies")
                    return
                }
            } else {
                showTips("can't find any movie")
                return
            }
            let cus = DBManager.default.getCustomers(c)
            if cus.count == 0 {
                showTips("can't find any movie")
                return
            }
            
            DBManager.default.addBooking(movs[0], customer: cus[0], number: number, start: start, end: end)
            popBack()
        }
    }
    
    
    @IBAction func delete() {
        let alertController = UIAlertController(title: "Tips", message: "Delete booking detail?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Delete", style: .default) { _ in
            
            DBManager.default.deleteBooking(self.booking!)
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



extension BookingDetailViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == startDateField || textField == endDateField {
            RPicker.selectDate(title: "Select Date", didSelectDate: { (selectedDate) in
                // TODO: Your implementation for date
                textField.text = selectedDate.dateString("MM-dd-YYYY")
            })
            return false
        }
        return true
    }
}
