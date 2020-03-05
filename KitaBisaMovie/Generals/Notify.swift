//
//  Notify.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

/**
 Notification Center Identifiers.
 */
struct NotifName {
    static let getMovies = Notification.Name("getMovies")
    static let getMovieDetail = Notification.Name("getMovieDetail")
    static let getMovieReviews = Notification.Name("getMovieReviews")
}

/**
 Class used to handle NotificationCenter.
 */
class Notify: NSObject {
    static let shared = Notify()
    fileprivate var listener = [NSObject]()
    
    /**
    Emit to selected listener.
    - Parameters:
       - name: Notification Name identifier
       - sender: NSObject listener
       - userInfo: payload data
    */
    static func post(name: Notification.Name, sender: NSObject? = nil, userInfo: [String: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: (sender == nil ? self : sender), userInfo: userInfo)
    }
    
    /**
    Create listener of Notification Center.
    - Parameters:
       - sender: NSObject listener
       - selector: Callback selector function
       - name: Notification Name identifier
    */
    func listen(_ sender: NSObject, selector: Selector, name: Notification.Name? = nil, object: Any? = nil) {
        NotificationCenter.default.addObserver(sender, selector: selector, name: name, object: object)
        listener.append(sender)
    }
    
    /**
    Removing Notification Center listener.
    - Parameters:
       - listener: NSObject listener
       - name: Notification Name identifier
       - object: Any payload
    */
    func removeListener(_ listener: NSObject, name: Notification.Name? = nil, object: Any? = nil) {
        if let index = self.listener.firstIndex(where: {$0 == listener}) {
            self.listener.remove(at: index)
            NotificationCenter.default.removeObserver(listener, name: name, object: object)
        }
    }
    
    /**
    Removing all Notification Center listener.
    */
    func removeAllListener() {
        let nCenter = NotificationCenter.default
        for anObject in listener {
            nCenter.removeObserver(anObject)
        }
        listener.removeAll()
    }
}
