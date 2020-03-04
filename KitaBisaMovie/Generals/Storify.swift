//
//  Storify.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import SwiftyJSON

enum MovieSortCategory {
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
    
    // MovieSortCategory
    var sortMovie: MovieSortCategory = .popular
    
    func storePopularMovies(_ data: JSON, _ meta: JSON) {
        Notify.post(name: NotifName.getPopularMovies, sender: self, userInfo: ["success": true])
    }
    
    func storeUpcomingMovies(_ data: JSON, _ meta: JSON) {
        Notify.post(name: NotifName.getUpcomingMovies, sender: self, userInfo: ["success": true])
    }
    
    func storeNowPlayingMovies(_ data: JSON, _ meta: JSON) {
        Notify.post(name: NotifName.getNowPlayingMovies, sender: self, userInfo: ["success": true])
    }
    
    func storeTopRatedMovies(_ data: JSON, _ meta: JSON) {
        Notify.post(name: NotifName.getTopRatedMovies, sender: self, userInfo: ["success": true])
    }
    
    func storeMovieDetail(_ data: JSON) {
        Notify.post(name: NotifName.getMovieDetail, sender: self, userInfo: ["success": true])
    }
    
    func storeMovieReviews(_ data: JSON, _ meta: JSON) {
        Notify.post(name: NotifName.getMovieReviews, sender: self, userInfo: ["success": true])
    }
}
