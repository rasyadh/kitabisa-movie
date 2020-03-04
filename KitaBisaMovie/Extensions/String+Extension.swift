//
//  String+Extension.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

extension String {
    func toDate(format: String = "") -> Date? {
        _ = TimeZone.current.secondsFromGMT(for: Date.init(timeIntervalSinceNow: 3600*24*60)) / 3600
        
        var stringDate = ""
        let dateFormatter = DateFormatter()
        
        if format == "" {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            stringDate = self
        } else if format == "yyyy-MM-dd HH:mm" {
            dateFormatter.dateFormat = format
            let index = self.index(self.startIndex, offsetBy: format.count)
            stringDate = String(self[..<index])
        } else if format == "yyyy-MM-dd'T'HH:mm:ss.SSSZ" {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            stringDate = self
        } else if format == "yyyy-MM-dd" {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            stringDate = self
        } else {
            dateFormatter.dateFormat = format
            stringDate = self
        }
        
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        if let date = dateFormatter.date(from: stringDate) {
            return date
        } else {
            return nil
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegexString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegexString)
        return emailTest.evaluate(with: self)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func UTCToLocal(fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func convertStringToDictionary() -> [String: AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: AnyObject]
            }
            catch let error as NSError {
                print("error: \(error)")
            }
        }
        return nil
    }
    
    func setInitialName() -> String {
        let arrName = self.components(separatedBy: " ")
        var initial = ""
        if arrName.count >= 2 {
            initial = String(arrName[0].prefix(1) + arrName[1].prefix(1))
        } else {
            initial = String(arrName[0].prefix(1))
        }
        return initial.uppercased()
    }
    
    // Handle emoji
    var decodeEmoji: String {
        let data = self.data(using: String.Encoding.utf8)
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr {
            return str as String
        }
        return self
    }
    
    var encodeEmoji: String {
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue) {
            return encodeStr as String
        }
        return self
    }
    
    var isSingleEmoji: Bool {
        return self.count == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var isMaxEmoji: Bool {
        return self.count <= 3
    }
    
    var containsOnlyEmoji: Bool {
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji && !$0.isZeroWidthJoiner
            })
    }
    
    var containsSpecialCharacter: Bool {
        let characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")
        if self.rangeOfCharacter(from: characterSet.inverted) != nil {
            return true
        } else {
            return false
        }
    }
}

extension NSAttributedString {
    convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}

extension UnicodeScalar {
    /// Note: This method is part of Swift 5, so you can omit this.
    /// See: https://developer.apple.com/documentation/swift/unicode/scalar
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF, // Misc symbols
        0x2700...0x27BF, // Dingbats
        0xE0020...0xE007F, // Tags
        0xFE00...0xFE0F, // Variation Selectors
        0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
        0x1F018...0x1F270, // Various asian characters
        0x238C...0x2454, // Misc items
        0x20D0...0x20FF: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}
