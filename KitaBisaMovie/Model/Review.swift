//
//  Review.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import Foundation
import SwiftyJSON

class Review {
    var id: String = ""
    var author: String = ""
    var content: String = ""
    var url: String = ""
    
    convenience init(_ data: JSON) {
        self.init()
        self.id = data["id"].stringValue
        self.author = data["author"].stringValue
        self.content = data["content"].stringValue
        self.url = data["url"].stringValue
    }
}
