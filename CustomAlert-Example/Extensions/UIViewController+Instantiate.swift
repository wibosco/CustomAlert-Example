//
//  UIViewController+Instantiate.swift
//  CustomAlert-Example
//
//  Created by William Boles on 20/05/2020.
//  Copyright © 2020 William Boles. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Instantiate
    
    static func instantiateViewController(fromStoryboard storyboard: UIStoryboard) -> Self {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self else {
           fatalError("Custom alert type does not exist")
        }
        _ = viewController.view

        return viewController
    }
}
