//
//  Localify.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

/**
 Localisation Language Identifier.
 */
enum LanguageName: String {
    case english = "en"
}

/**
 Class used to handle Localisation.
 */
class Localify: NSObject {
    static let shared = Localify()
    private var languageBundle: Bundle!
    var languageIdentifier = ""
    
    /**
    Set enabled language localisation.
    - Parameters:
       - name: LanguageName identifier
    */
    func setLanguage(_ name: LanguageName) {
        let path = Bundle.main.path(forResource: name.rawValue, ofType: ".lproj")!
        let bundle = Bundle(path: path)!
        languageBundle = bundle
        
        switch name {
        case .english:
            languageIdentifier = "en"
        }
    }
    
    /**
    Get string of localisation.
    - Parameters:
       - key: String localisation identifier
    */
    static func get(_ key: String) -> String {
        return NSLocalizedString(key, bundle: Localify.shared.languageBundle, comment: "")
    }
}
