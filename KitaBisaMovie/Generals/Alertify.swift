//
//  Alertify.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

import UIKit

/**
 Helper alert for UIAlertController.
 */
class Alertify: NSObject {
    
    /**
    Display simple alert.
    - Parameters:
       - title: String title alert
       - message: String message alert
       - sender: which UIViewController showing it
    */
    static func displayAlert(title: String, message: String, sender: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localify.get("alertify.ok"), style: .default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
    /**
    Display custom confirmation alert.
    - Parameters:
       - title: String title alert
       - message: String message alert
       - confirmTitle: String confirmation button title
       - cancelTitle: String cancel button title
       - sender: which UIViewController showing it
       - isDestructive: Bool indicating confirmation button is destructive
       - confirmCallbak: Callback confirm button
       - cancelCallbak: Callback cancel button
    */
    static func customConfirmation(title: String, message: String, confirmTitle: String, cancelTitle: String, sender: UIViewController, isDestructive: Bool = false, confirmCallback: (() -> Void)? = nil, cancelCallback: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message
            , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { action in
            if cancelCallback != nil {
                cancelCallback!()
            }
        }))
        if isDestructive {
            alert.addAction(UIAlertAction(title: confirmTitle, style: .destructive, handler: { action in
                if confirmCallback != nil {
                    confirmCallback!()
                }
            }))
        } else {
            alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: { action in
                if confirmCallback != nil {
                    confirmCallback!()
                }
            }))
        }
        sender.present(alert, animated: true, completion: nil)
    }
    
    /**
    Display error message alert.
    - Parameters:
       - sender: which UIViewController showing it
       - manager: root view controller
       - notification: NotificationCenter data payload
    */
    static func showErrorMessage(sender: UIViewController, manager: ManagerViewController?, notification: Notification) {
        let message = notification.userInfo!["message"] != nil ?
            notification.userInfo!["message"] as! String :
            Localify.get("messages.failed.default.message")
        Alertify.displayAlert(
            title: Localify.get("messages.failed.default.title"),
            message: message,
            sender: sender)
    }
}
