//
//  ViewController.swift
//  MovieBooking
//
//  Created by Xuhang Liu on 2019/2/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Rental Application"
        
        DBManager.default.checkDefaultMovies()
        DBManager.default.checkDefaultCustomers()
    }

    @IBAction func toCustomerOption() {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomersViewController") as! CustomersViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func toMovieOption() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func toBookingOption() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingsViewController") as! BookingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func toSearchOption() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.type = .booking
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

