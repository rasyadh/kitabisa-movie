//
//  RealmHelper.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Handle Realm DAO Operation.
 */
class RealmHelper {
    static let shared = RealmHelper()
    let realm = try? Realm()
    
    // delete table
    func deleteDatabase() {
        try! realm?.write({
            realm?.deleteAll()
        })
    }
    
    // delete particular object
    func deleteObject(objs : Object) {
        try? realm!.write ({
            realm?.delete(objs)
        })
    }
    
    func deleteObjectType(type: Object.Type) {
        try? realm!.write {
            realm?.delete(realm!.objects(type))
        }
    }
    
    // save array of objects to database
    func saveObjects(objs: Object) {
        try? realm!.write ({
            // adds the object
            realm?.add(objs, update: .all)
        })
    }
    
    // editing the object
    func editObjects(objs: Object) {
        try? realm!.write ({
            // objects that are already in the Realm will be
            // updated instead of added a new.
            realm?.add(objs, update: .modified)
        })
    }
    
    // returns an array as Results<object>?
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm!.objects(type)
    }
    
    func getObjectsById(type: Object.Type, id: Int) -> Results<Object>? {
        return realm?.objects(type).filter("conversation_id == %@", id)
    }
    
    // return the Result
    func getObjectById(type: Object.Type, id: Int) -> Object? {
        return realm!.objects(type).filter("id == %@", id).first
    }
    
    // custom operation
    func checkIsFavourite(type: Object.Type, id: Int) -> Bool {
        if let _ = realm?.objects(type).filter("id == %@", id).first {
            return true
        }
        return false
    }
    
    func addToFavourite(type: Object.Type, movie: Movie) -> Bool {
        if let result = realm?.objects(type).filter("id == %@", movie.id).first {
            deleteObject(objs: result)
            return false
        } else {
            movie.isFavourite = true
            editObjects(objs: MovieRealm(movie))
            return true
        }
    }
    
    func getFavouriteMovies(type: Object.Type, id: Int) -> Results<Object>? {
        return getObjects(type: type)
    }
}
