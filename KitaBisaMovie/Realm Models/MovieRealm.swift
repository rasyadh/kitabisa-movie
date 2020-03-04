//
//  MovieRealm.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class MovieRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var originalTitle: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var originalLanguage: String = ""
    @objc dynamic var posterPath: String = ""
    @objc dynamic var backdropPath: String = ""
    @objc dynamic var releaseDate: Date!
    @objc dynamic var popularity: Float = 0.0
    @objc dynamic var voteCount: Int = 0
    @objc dynamic var voteAverage: Float = 0.0
    @objc dynamic var video: Bool = false
    @objc dynamic var adult: Bool = false
    @objc dynamic var isFavourite: Bool = false
    var genreIds = List<Int>()

    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ data: Movie) {
        self.init()
        self.id = data.id
        self.title = data.title
        self.originalTitle = data.originalTitle
        self.overview = data.overview
        self.originalLanguage = data.originalLanguage
        self.posterPath = data.posterPath
        self.backdropPath = data.backdropPath
        self.releaseDate = data.releaseDate
        self.popularity = data.popularity
        self.voteCount = data.voteCount
        self.voteAverage = data.voteAverage
        self.video = data.video
        self.adult = data.adult
        self.isFavourite = data.isFavourite
        let ids = List<Int>()
        data.genreIds.forEach { genreId in
            ids.append(genreId)
        }
        self.genreIds = ids
    }
}
