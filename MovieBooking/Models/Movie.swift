//
//  Movie.swift
//  Assignment4-Xuhang Liu
//
//  Created by xuhang on 2/13/19.
//  Copyright © 2019 xuhang. All rights reserved.
//

import Foundation

struct Movie {
    var id : Int = 0
    var title: String = ""
    var release: String = ""
    var type: String = ""
    var quantity: Int = 0
    var cover: String = ""
    
    static func enterMovie() {
        
        var movie = Movie()
        if let id = app.movies.last?.id {
            movie.id = id + 1
        } else {
            movie.id = 1
        }
        
        func add() {
            if movie.title.count == 0 {
                print("Please enter movie name:")
                if let title = readLine() {
                    movie.title = title
                }
                add()
                return
            }
            
            if movie.release.count == 0 {
                print("Please enter movie release date:")
                if let value = readLine() {
                    movie.release = value
                }
                add()
                return
            }
            if movie.type.count == 0 {
                print("Please enter movie type:")
                if let value = readLine() {
                    movie.type = value
                }
                add()
                return
            }
            if movie.quantity == 0 {
                print("Please enter movie quantity:")
                if let value = readLine(),  let q = Int(value) {
                    movie.quantity = q
                }else{
                    print("Please enter a valid number")
                    add()
                    return
                }
            }
            
            app.movies.append(movie)
            enterMovie()
        }
        
        func delete() {
            print("Available Movies:", app.movies.count)
            print("Please enter id to delete:")
            if let del = readLine() , let delete_id = Int(del) {
                app.movies = app.movies.filter({$0.id != delete_id })
                print("Delete Success")
            } else {
                print("Invalid id")
            }
        }
        
        /// update Movie
        func update() {
            
            func updateDetail(_ mov: Movie) {
                var mov = mov
                print(mov)
                print("1.Name \n 2.Release date \n 3.Type \n 4.Quantity \n 5.Exit")
                if let option = readLine() {
                    switch option {
                    case "1":
                        print("Please enter update name:")
                        if let value = readLine() ,value.count > 0  {
                            mov.title = value
                            app.replaceMovie(mov)
                        }
                        updateDetail(mov)
                    case "2":
                        print("Please enter update release date:")
                        if let value = readLine(),value.count > 0  {
                            mov.release = value
                            app.replaceMovie(mov)
                        }
                        updateDetail(mov)
                    case "3":
                        print("Please enter update type:")
                        if let value = readLine(),value.count > 0  {
                            mov.type = value
                            app.replaceMovie(mov)
                        }
                        updateDetail(mov)
                    case "4":
                        print("Please enter update quantity:")
                        if let value = readLine() , let q = Int(value) , q > 0 {
                            mov.quantity = q
                            app.replaceMovie(mov)
                        }
                        print("Please enter valid number")
                        updateDetail(mov)
                    default:
                        print("error option")
                        update()
                    }
                }
            }
            print("Available Movies:",app.movies.count)
            print("Please enter id to update:")
            if let value = readLine(), let id = Int(value) {
                let movies = app.movies.filter({$0.id == id})
                if movies.count > 0 {
                    updateDetail(movies[0])
                }else {
                    print("Invalid id")
                }
            }
            print("Invalid id")
            enterMovie()
        }
        
        
    }
    
}


