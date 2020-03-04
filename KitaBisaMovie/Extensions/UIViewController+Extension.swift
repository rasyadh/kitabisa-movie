//
//  UIViewController+Extension.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: - Navigation Bar
    func configureTransparentNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func showNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func hideNavigationBarShadow() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func showNavigationBarShadow() {
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    func omitNavBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func hideNavBackButton() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setBarImageView(imageName: String) -> UIBarButtonItem {
        let logo = UIImage(named: imageName)
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = logo
        logoImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return UIBarButtonItem(customView: logoImageView)
    }
    
    // MARK: - Dismiss Keyboard
    func hideKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
