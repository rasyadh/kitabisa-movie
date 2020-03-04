//
//  Apify.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

/**
 RequestCode Identifier for each api endpoint.
 */
enum RequestCode {
    case getPopularMovies,
    getUpcomingMovies,
    getTopRatedMovies,
    getNowPlayingMovies,
    getMovieDetail,
    getMovieReviews
}

/**
 Networking class to handle api networking request.
 */
class Apify: NSObject {
    static let shared = Apify()
    var prevOperationData: [String: Any]?
    
    fileprivate let API_BASE_URL = "https://api.themoviedb.org/3/"
    fileprivate let API_KEY = "48cf77b80286d711e5ac8dfc4bce2cef"
    
    let API_MOVIE = "/movie"
    
    // MARK: - Basic Networking Functions
    
    /**
     Create headers for http request.
     - Parameters:
        - withAuthorization: Bool indicate usage of Authorization in headers
        - withXApiKey: Bool indicate usage of X-Api-Key in headers
        - accept: String indicate defined Accept in headers, default set to application/json
     - Returns: Map of headers value
     */
    fileprivate func getHeaders(accept: String? = nil) -> [String: String] {
        var headers = [String: String]()
        
        // Assign accept properties
        if accept == nil { headers["Accept"] = "application/json" }
        else { headers["Accept"] = accept }
        
        return headers
    }
    
    /**
     Asynchronous networking http request.
     - Parameters:
        - url: String url endpoint API
        - method: HTTPMethod used for request
        - parameters: Body used for the request
        - headers: Headers used for the request
        - code: RequestCode identifier
     */
    private func request(_ url: String, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?, code: RequestCode) {
        // Perform request
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("[ Success ] Request Code: \(code)")
                    print("[ Success ] Status Code: \(response.response!.statusCode)")
                    
                    // URL parsing or pre-delivery functions goes here
                    let responseJSON = try! JSON(data: response.data!)
                    var addData: [String: Any]? = response.data == nil ? nil : ["json": responseJSON["results"]]
                    if !responseJSON["page"].isEmpty && !responseJSON["total_pages"].isEmpty && !responseJSON["total_results"].isEmpty {
                        let meta = [
                            "page": responseJSON["page"],
                            "total_pages": responseJSON["total_pages"],
                            "total_results": responseJSON["total_results"],
                        ]
                        addData!["meta"] = JSON(meta)
                    }
                    self.consolidation(code, success: true, additionalData: addData)
                case .failure:
                    // Request error parsing
                    print("[ Failed ] Request Code : \(code)")
                    print("[ Error ] : Error when executing API operation : \(code) ! Details :\n" + (response.result.error?.localizedDescription)!)
                    print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                    print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                    print("[ ERROR ] : Result : %@", response.result.value as Any)
                    
                    let statusCode = response.response?.statusCode
                    print("[ Failed ] Status Code: \(String(describing: statusCode))")
                    
                    if let json = JSON(rawValue: response.data as Any) {
                        print("[ ERROR ] Error JSON : \(json)")
                        self.consolidation(code, success: false, additionalData: ["json": json])
                        return
                    } else {
                        self.consolidation(code, success: false)
                        return
                    }
                }
        }
    }
    
    /**
     Handle parsing response JSON to standard format.
     - Parameters:
        - requestCode: RequestCode identifier
        - success: Bool indicating request status
        - additionalData: JSON Data
     */
    private func consolidation(_ requestCode: RequestCode, success: Bool, additionalData: [String: Any]? = nil) {
        var dict = [String: Any]()
        dict["success"] = success
        
        if additionalData != nil {
            for (key, value) in additionalData! {
                dict[key] = value
            }
            
            if !success && dict["json"] != nil {
                if let json = dict["json"] as? JSON {
                    if let error = json["error"].string {
                        dict["error"] = error
                    }
                    
                    if let message = json["message"].string {
                        dict["message"] = message
                    }
                    
                    if let message = json["status_message"].string {
                        dict["status_message"] = message
                    }
                }
            }
        }
        
        switch requestCode {
        case .getPopularMovies:
            if success { Storify.shared.storePopularMovies(dict["json"] as! JSON, dict["meta"] as! JSON) }
            else { Notify.post(name: NotifName.getPopularMovies, sender: self, userInfo: dict) }
        case .getUpcomingMovies:
            if success { Storify.shared.storeUpcomingMovies(dict["json"] as! JSON, dict["meta"] as! JSON) }
            else { Notify.post(name: NotifName.getUpcomingMovies, sender: self, userInfo: dict) }
        case .getTopRatedMovies:
            if success { Storify.shared.storeTopRatedMovies(dict["json"] as! JSON, dict["meta"] as! JSON) }
            else { Notify.post(name: NotifName.getTopRatedMovies, sender: self, userInfo: dict) }
        case .getNowPlayingMovies:
            if success { Storify.shared.storeNowPlayingMovies(dict["json"] as! JSON, dict["meta"] as! JSON) }
            else { Notify.post(name: NotifName.getNowPlayingMovies, sender: self, userInfo: dict) }
        case .getMovieDetail:
            if success { Storify.shared.storeMovieDetail(dict["json"] as! JSON) }
            else { Notify.post(name: NotifName.getMovieDetail, sender: self, userInfo: dict) }
        case .getMovieReviews:
            if success { Storify.shared.storeMovieReviews(dict["json"] as! JSON, dict["meta"] as! JSON) }
            else { Notify.post(name: NotifName.getMovieReviews, sender: self, userInfo: dict) }
        }
    }
    
    func getPopularMovies(page: Int = 1) {
        let URL = API_BASE_URL + API_MOVIE + "/popular?api_key=\(API_KEY)&language=en-US&page=\(page)"
        
        request(
            URL,
            method: .get,
            parameters: nil,
            headers: getHeaders(),
            code: .getPopularMovies)
    }
    
    func getUpcomingMoviews(page: Int = 1) {
        let URL = API_BASE_URL + API_MOVIE + "/upcoming?api_key=\(API_KEY)&language=en-US&page=\(page)"
        
        request(
            URL,
            method: .get,
            parameters: nil,
            headers: getHeaders(),
            code: .getUpcomingMovies)
    }
    
    func getTopRatedMovies(page: Int = 1) {
        let URL = API_BASE_URL + API_MOVIE + "/top_rated?api_key=\(API_KEY)&language=en-US&page=\(page)"
        
        request(
            URL,
            method: .get,
            parameters: nil,
            headers: getHeaders(),
            code: .getTopRatedMovies)
    }
    
    func getNowPlayingMovies(page: Int = 1) {
        let URL = API_BASE_URL + API_MOVIE + "/now_playing?api_key=\(API_KEY)&language=en-US&page=\(page)"
        
        request(
            URL,
            method: .get,
            parameters: nil,
            headers: getHeaders(),
            code: .getNowPlayingMovies)
    }
    
    func getMovieDetail(id: Int) {
        let URL = API_BASE_URL + API_MOVIE + "/\(id)"
        
        request(
            URL,
            method: .get,
            parameters: nil,
            headers: getHeaders(),
            code: .getMovieDetail)
    }
    
    func getMovieReviews(id: Int) {
        let URL = API_BASE_URL + API_MOVIE + "/\(id)/reviews"
        
        request(
            URL,
            method: .get,
            parameters: nil,
            headers: getHeaders(),
            code: .getMovieReviews)
    }
}
