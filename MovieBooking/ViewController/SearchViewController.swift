//
//  SearchViewController.swift
//  MovieBooking
//
//  Created by Xuhang Liu on 2019/2/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

enum SearchType: String {
    case customer = "customer"
    case movie = "movie"
    case booking = "booking"
}

class SearchViewController: UIViewController {
    
    var type: SearchType = .movie
    
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationBarLeftButton(self)
        title = "Search"
        view.addTapToCloseEditing()
        
        textField.addPaddingLeft(10)
        
        desLabel.text = "Please enter " + type.rawValue + " to search:"
    
    }
    
    
    @IBAction func submit() {
        guard let text = textField.text else {
            return showTips("Please enter valid data")
        }
        switch type {
        case .movie:
            let movies = DBManager.default.getMovies(text)
            if movies.count > 0 {
                let creater = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
                creater.mov = movies[0]
                navigationController?.pushViewController(creater, animated: true)
                
            } else {
                showTips("Can't find any movie")
                return
            }
 
        case .customer:
            let customers = DBManager.default.getCustomers(text)
            if customers.count > 0 {
                let creater = storyboard?.instantiateViewController(withIdentifier: "CustomerDetailViewController") as! CustomerDetailViewController
                creater.cus = customers[0]
                navigationController?.pushViewController(creater, animated: true)
                
            } else {
                showTips("Can't find any customer")
                return
            }
            
        case .booking:
            let bookings = DBManager.default.getBooking(text)
            if bookings.count > 0 {
                let creater = storyboard?.instantiateViewController(withIdentifier: "BookingDetailViewController") as! BookingDetailViewController
                creater.booking = bookings[0]
                navigationController?.pushViewController(creater, animated: true)
                
            } else {
                showTips("Can't find any booking")
                return
            }
        }
        
    }

}
