//
//  ManagerViewController.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

public class ManagerViewController: UIViewController {
    
    // MARK: - Variables
    // Storyboards variable
    private var homeStoryboard: UIStoryboard?
    
    private var cachedViewController = [String: UIViewController]()
    private var activeViewControllerId = ""
    
    private let CHILD_KEY = 1000000
    private let CHILD_HOME_KEY = "HomeViewController"
    
    // Change status bar style to light
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .lightContent
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        showHomeScreen()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Remove all cached view controller and
        // set it to current active view controller
        let activeViewController = cachedViewController[activeViewControllerId]
        cachedViewController.removeAll()
        cachedViewController[activeViewControllerId] = activeViewController
    }
    
    public func showHomeScreen() {
        displayContentViewController(CHILD_HOME_KEY)
    }
    
    public func screenInitialization(identifier: String) -> UIViewController? {
        var viewController: UIViewController?
        if let cachedViewController = cachedViewController[identifier] {
            viewController = cachedViewController
        } else if identifier == CHILD_HOME_KEY {
            if homeStoryboard == nil {
                homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
            }
            viewController = homeStoryboard?.instantiateInitialViewController()
        } else if let vendorTabViewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            cachedViewController[identifier] = vendorTabViewController
            viewController = vendorTabViewController
        }
        
        return viewController
    }
    
    public func displayContentViewController(_ identifier: String, secondaryIdentifier: String? = nil) {
        if activeViewControllerId != identifier {
            // Screen Initialization
            let viewController = screenInitialization(identifier: identifier)
            
            // Screen Implementation
            activeViewControllerId = identifier
            addChild(viewController!)
            
            let existingView = view.viewWithTag(CHILD_KEY)
            if existingView != nil {
                viewController?.view.alpha = 0
            }
            
            viewController!.view.frame = view.bounds
            view.addSubview(viewController!.view)
            
            if existingView != nil {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                    existingView?.alpha = 0
                }, completion: { finished in
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        viewController?.view.alpha = 1
                    }, completion: { finished in
                        if finished {
                            existingView?.removeFromSuperview()
                            let firstViewController = self.children.first
                            firstViewController?.removeFromParent()
                            firstViewController?.didMove(toParent: nil)
                        }
                    })
                })
            }
            
            viewController!.view.tag = CHILD_KEY
            viewController!.view.setNeedsLayout()
            viewController!.view.layoutIfNeeded()
            
            viewController!.didMove(toParent: self)
        }
    }
    
    public func getActiveViewControllerId() -> String {
        return activeViewControllerId
    }
    
    public func getCachedViewController() -> [String: UIViewController] {
        return cachedViewController
    }
}

public extension UIViewController {
    var managerViewController: ManagerViewController? {
        return managerViewControllerForViewController(self)
    }
    
    private func managerViewControllerForViewController(_ controller: UIViewController) -> ManagerViewController? {
        if let managerController = controller as? ManagerViewController {
            return managerController
        }
        
        if let parent = controller.parent {
            return managerViewControllerForViewController(parent)
        } else if let parent = controller.presentingViewController {
            return managerViewControllerForViewController(parent)
        } else {
            return nil
        }
    }
}
