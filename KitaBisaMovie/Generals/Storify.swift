//
//  Storify.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CategorySortMovie {
    case popular,
    upcoming,
    nowPlaying,
    topRated
}

/**
 Class used to handle stored Data using Repository pattern.
*/
class Storify: NSObject {
    static let shared = Storify()
    
    // Paging
    var page = [String: JSON]()
    
    var movies = [Movie]()
    
    // MovieSortCategory
    var currentCategory: CategorySortMovie = .popular
    
    func storeMovies(_ data: JSON, _ meta: JSON) {
        page["movies"] = meta
        if page["movies"]!["page"].intValue == 1 {
            movies = data.arrayValue.map { Movie($0) }
        } else {
            data.arrayValue.forEach { movies.append(Movie($0)) }
        }
        Notify.post(name: NotifName.getMovies, sender: self, userInfo: ["success": true])
    }
    
    func storeMovieDetail(_ data: JSON) {
        Notify.post(name: NotifName.getMovieDetail, sender: self, userInfo: ["success": true])
    }
    
    func storeMovieReviews(_ data: JSON, _ meta: JSON) {
        Notify.post(name: NotifName.getMovieReviews, sender: self, userInfo: ["success": true])
    }
}
