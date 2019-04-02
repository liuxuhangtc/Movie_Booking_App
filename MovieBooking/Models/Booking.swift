//
//  Booking.swift
//  Assignment4-Xuhang Liu
//
//  Created by xuhang on 2/13/19.
//  Copyright © 2019 xuhang. All rights reserved.
//

import Foundation

struct Booking {
    var id : Int = 0
    var movie: Movie = Movie()
    var customer: Customer = Customer()
    var number: Int = 0
    var startDate: String = ""
    var endDate: String = ""
    
    
    static func enterBooking() {
        var booking = Booking()
        if let id = app.bookings.last?.id {
            booking.id = id + 1
        } else {
            booking.id = 1
        }
        
        func add() {
            if app.movies.count > 0 {
                print("Available movies:", app.movies.count)
                print("Please select a movie with id:")
                if let value = readLine() , let id = Int(value) {
                    let movs = app.movies.filter({$0.id == id})
                    if movs.count > 0 {
                        booking.movie = movs[0]
                    }
                }
            }else{
                print("Please create a movie first")
                enterBooking()
            }
            
            if app.customers.count > 0 {
                print("Available customers:", app.customers.count)
                print("Please select a booking customer with id:")
                if let value = readLine(), let id = Int(value) {
                    let cus = app.customers.filter({$0.id == id})
                    if cus.count > 0 {
                        booking.customer = cus[0]
                    }
                }
            }else{
                print("Please create a customer first")
                enterBooking()
            }
            
            
            if booking.number == 0 {
                print("Please enter booking quantity:")
                if let value = readLine(), let n = Int(value), n > 0 {
                    //Check Availability
                    if booking.movie.quantity - n  < 0 {
                        print("Tips: No available quantity of movies")
                        add()
                        return
                    } else {
                        booking.number = n
                    }
                }
            }
            if booking.startDate.count == 0 {
                print("Please enter booking date:")
                if let value = readLine() {
                    booking.startDate = value
                }
            }
            if booking.endDate.count == 0 {
                print("Please enter return date:")
                if let value = readLine() {
                    booking.endDate = value
                }
            }
        }
        
        func delete() {
            print("Available bookings:", app.bookings.count)
            print("Please enter id to delete:")
            if let del = readLine() , let delete_id = Int(del) {
                app.bookings = app.bookings.filter({$0.id != delete_id })
                print("Delete Success")
            } else {
                print("error option")
            }
        }
        
        /// update booking
        func update() {
            
            func updateDetail(_ boo: Booking) {
                var boo = boo
                print(boo)
                print("1.Update booking Movie \n2.Update booking Customer\n3.Update booking Quantity \n4.Update Date of Booking\n5.Update Date of Return \n6.Exit")
                if let option = readLine() {
                    switch option {
                    case "1":
                        print("Please enter movie id:")
                        if let value = readLine() , let id = Int(value) {
                            let movs = app.movies.filter({$0.id == id})
                            if movs.count > 0 {
                                boo.movie = movs[0]
                                app.replaceBooking(boo)
                            }
                        }
                        updateDetail(boo)
                    case "2":
                        print("Please enter customer id:")
                        if let value = readLine(), let id = Int(value) {
                            let cus = app.customers.filter({$0.id == id})
                            if cus.count > 0 {
                                boo.customer = cus[0]
                                app.replaceBooking(boo)
                            }
                        }
                        updateDetail(boo)
                    case "3":
                        print("Please enter a booking quantity:")
                        if let value = readLine(), let n = Int(value), n > 0 {
                            /// check availability
                            if boo.movie.quantity + boo.number - n  < 0 {
                                print("Tips: No available quantity of movies")
                            } else {
                                boo.number = n
                                app.updateBookingNumber(boo, number: n)
                                app.replaceBooking(boo)
                            }
                        }
                        updateDetail(boo)
                    case "4":
                        print("Please enter Date of Booking:")
                        if let value = readLine(),value.count > 0  {
                            boo.startDate = value
                            app.replaceBooking(boo)
                        }
                        updateDetail(boo)
                    case "5":
                        print("Please enter Date of return:")
                        if let value = readLine(),value.count > 0  {
                            boo.endDate = value
                            app.replaceBooking(boo)
                        }
                        updateDetail(boo)
                    case "6":
                        enterBooking()
                    default:
                        print("error option")
                        update()
                    }
                }
            }
            print("Available Bookings:",app.bookings.count)
            print("Please enter id to update:")
            if let value = readLine(), let id = Int(value) {
                let bookings = app.bookings.filter({$0.id == id})
                if bookings.count > 0 {
                    updateDetail(bookings[0])
                }else {
                    print("Invalid id")
                }
            }
            enterBooking()
        }
        

    }
}
