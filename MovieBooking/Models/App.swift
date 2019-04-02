//
//  main.swift
//  Assignment4-Xuhang Liu
//
//  Created by xuhang on 2/13/19.
//  Copyright © 2019 xuhang. All rights reserved.
//

import Foundation


class App {
    var customers: [Customer] = []
    var movies: [Movie] = []
    var bookings: [Booking] = []
    
    //update Customer
    func replaceCustomer(_ cus: Customer) {
        var toIndx = -1
        for (index, item) in customers.enumerated() {
            if item.id == cus.id {
                toIndx = index
                break
            }
        }
        if toIndx >= 0 {
            customers[toIndx] = cus
        }
    }
    
    //update Movie
    func replaceMovie(_ mov: Movie) {
        var toIndx = -1
        for (index, item) in movies.enumerated() {
            if item.id == mov.id {
                toIndx = index
                break
            }
        }
        if toIndx >= 0 {
            movies[toIndx] = mov
        }
    }
    
    /// update movie number number: to add
    func updateMovieNumber(_ movie: Movie, number: Int) {
        var movie = movie
        var toIndx = -1
        for (index, item) in app.movies.enumerated() {
            if item.id == movie.id {
                toIndx = index
                movie = item
                break
            }
        }
        movie.quantity = movie.quantity + number
        if toIndx >= 0 {
            app.movies[toIndx] = movie
        }
    }
    
    /// Add booking and update quantity
    func addBooking(_ booking: Booking) {
        var movie = booking.movie
        movie.quantity = movie.quantity - booking.number
        var toIndx = -1
        for (index, item) in app.movies.enumerated() {
            if item.id == movie.id {
                toIndx = index
                break
            }
        }
        if toIndx >= 0 {
            app.movies[toIndx] = movie
        }
        
        app.bookings.append(booking)
    }
    
    /// update booking number
    func updateBookingNumber(_ booking: Booking, number: Int) {
        var movie = booking.movie
        var toIndx = -1
        for (index, item) in app.movies.enumerated() {
            if item.id == movie.id {
                toIndx = index
                break
            }
        }
        movie.quantity -= number
        if toIndx >= 0 {
            app.movies[toIndx] = movie
        }
    }
    
    //update Booking
    func replaceBooking(_ booking: Booking) {
        var toIndx = -1
        for (index, item) in bookings.enumerated() {
            if item.id == booking.id {
                toIndx = index
                break
            }
        }
        if toIndx >= 0 {
            bookings[toIndx] = booking
        }
    }
    
}

let app = App()
