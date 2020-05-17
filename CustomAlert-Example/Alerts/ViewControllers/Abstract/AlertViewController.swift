//
//  AlertViewController.swift
//  CustomAlert-Example
//
//  Created by William Boles on 15/05/2020.
//  Copyright © 2020 William Boles. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    // MARK: - Factory
    
    static func createAlertViewController() -> Self {
        let storyboard = UIStoryboard(name: "Alerts", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self else {
            fatalError("Custom alert type does not exist")
        }
        _ = alertViewController.view
        
        return alertViewController
    }
}
