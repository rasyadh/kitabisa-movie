//
//  Movie.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie {
    var id: Int = 0
    var title: String = ""
    var originalTitle: String = ""
    var overview: String = ""
    var originalLanguage: String = ""
    var posterPath: String = ""
    var backdropPath: String = ""
    var releaseDate: Date!
    var popularity: Float = 0.0
    var voteCount: Int = 0
    var voteAverage: Float = 0.0
    var video: Bool = false
    var adult: Bool = false
    var genreIds = [Int]()
    
    convenience init(_ data: JSON) {
        self.init()
        self.id = data["id"].intValue
        self.title = data["title"].stringValue
        self.originalTitle = data["original_title"].stringValue
        self.overview = data["overview"].stringValue
        self.originalLanguage = data["original_language"].stringValue
        self.posterPath = data["poster_path"].stringValue
        self.backdropPath = data["backdrop_path"].stringValue
        self.releaseDate = data["release_date"].stringValue.toDate(format: "yyyy-MM-dd") ?? nil
        
        self.popularity = data["popularity"].floatValue
        self.voteCount = data["vote_count"].intValue
        self.voteAverage = data["vote_average"].floatValue
        self.video = data["video"].boolValue
        self.adult = data["adult"].boolValue
        self.genreIds = data["genre_ids"].arrayValue.map { $0.intValue }   
    }
}
