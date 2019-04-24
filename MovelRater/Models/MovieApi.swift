//
//  MovieApi.swift
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation

let top_movieUrl = "https://api.themoviedb.org/3/movie/top_rated?api_key=b25bf50a35c8eaf1b03f7cfd0bdebdcc&page=%d"
let upcoming_movieUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=b25bf50a35c8eaf1b03f7cfd0bdebdcc&page=%d"
let playing_movieUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=b25bf50a35c8eaf1b03f7cfd0bdebdcc&page=%d"

let search_movieUrl = "https://api.themoviedb.org/3/search/movie?api_key=b25bf50a35c8eaf1b03f7cfd0bdebdcc&query=%@&total_pages=50&page=%d"

let movieDetailUrl = "https://api.themoviedb.org/3/movie/%d?api_key=b25bf50a35c8eaf1b03f7cfd0bdebdcc&"

let movieReviewsUrl = "https://api.themoviedb.org/3/movie/%d/reviews?api_key=b25bf50a35c8eaf1b03f7cfd0bdebdcc&page=1&total_pages=50"

let imgUrl = "https://image.tmdb.org/t/p/w1000_and_h563_face/"


struct TheMovie: Decodable {
    let id: Int
    let title: String
    let poster_path: String?
    let overview: String
    let release_date: String
    let quantity = 100
    let vote_average: Double
}

struct DataBase: Decodable {
    let results: [TheMovie]
    let page: Int
    let total_pages: Int
    
    init() {
        results = []
        page = 0
        total_pages = 0
    }
    
    
    static func getMovies(_ page: Int = 1, type: Int = 0, completionHandle: @escaping (_ movies: [TheMovie], _ pages: Int) -> ()) {
        let path = String(format: [top_movieUrl, upcoming_movieUrl, playing_movieUrl][type], page)
        if let url = URL(string: path) {
            let session = URLSession.shared
            // closure containing asynchronous download process
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else { return }
                do {
                    
                    let decoder = JSONDecoder()
                    let dataBase = try decoder.decode(DataBase.self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        dataBase.results.forEach({ m in
//                            DBManager.default.addMovie(m.id, title: m.title, quantity: m.quantity, m_release: m.release_date, cover: m.poster_path)
                        })
                        
                        completionHandle(dataBase.results, dataBase.total_pages)
                    }
                } catch let jsonErr {
                    DispatchQueue.main.async {
                        completionHandle([], 0)
                    }
                    print("Error decoding JSON", jsonErr)
                }
                }.resume()
            
        }
    }
    
    static func getSearchMovies(_ page: Int = 1, query: String, completionHandle: @escaping (_ movies: [TheMovie], _ pages: Int) -> ()) {
        let path = String(format: search_movieUrl, query, page)
        if let url = URL(string: path) {
            let session = URLSession.shared
            // closure containing asynchronous download process
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else { return }
                do {
                    
                    let decoder = JSONDecoder()
                    let dataBase = try decoder.decode(DataBase.self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        print("\n\n")
                        print(dataBase.results)
                        dataBase.results.forEach({ m in
//                            DBManager.default.addMovie(m.id, title: m.title, quantity: m.quantity, m_release: m.release_date, cover:  m.poster_path)
                        })
                        
                        completionHandle(dataBase.results, dataBase.total_pages)
                    }
                } catch let jsonErr {
                    DispatchQueue.main.async {
                       completionHandle([], 0)
                    }
                    
                    print("Error decoding JSON", jsonErr)
                }
                }.resume()
            
        }
    }
    
    
    
    static func getMovieDetail(_ id: Int, completionHandle: @escaping (_ movie: TheMovie) -> (), failedHandle: @escaping () -> ()) {
        if let url = URL(string: String(format: movieDetailUrl, id)) {
            let session = URLSession.shared
            // closure containing asynchronous download process
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else { return }
                do {
                    
                    let decoder = JSONDecoder()
                    let m = try decoder.decode(TheMovie.self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        completionHandle(m)
                    }
                } catch let jsonErr {
                    DispatchQueue.main.async {
                        failedHandle()
                    }
                    print("Error decoding JSON", jsonErr)
                }
                }.resume()
            
        }
    }
    
    static func getMovieReviews(_ id: Int, completionHandle: @escaping (_ results: [JSONMap]) -> (), failedHandle: @escaping () -> ()) {
        if let url = URL(string: String(format: movieReviewsUrl, id)) {
            let session = URLSession.shared
            // closure containing asynchronous download process
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    DispatchQueue.main.async {
                        failedHandle()
                    }
                    return
                }
                
                do {
                    let res: JSONMap = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! JSONMap
                    
                    if let ip = res["results"] as? [JSONMap] {
                        DispatchQueue.main.async {
                            completionHandle(ip)
                            return
                        }
                    }
                    
                }catch{
                    print("EMPTY")
                    DispatchQueue.main.async {
                        failedHandle()
                    }
                }
                
                }.resume()
            
        }
    }
}



