//
//  AlertPresenter.swift
//  CustomAlert-Example
//
//  Created by William Boles on 26/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit
import os

class AlertPresenter {
    private var alertWindows = Set<AlertWindow>()
    
    static let shared = AlertPresenter()
    
    // MARK: - Present
    
    func presentAlert(_ viewController: UIViewController) {
        os_log(.info, "Alert being presented")
        
        let alertWindow = AlertWindow(withViewController: viewController)
        alertWindow.present()
        
        alertWindows.insert(alertWindow)
    }
    
    // MARK: - Dismiss
    
    func dismissAlert(_ viewController: UIViewController) {
        guard let alertWindow = alertWindows.first(where: { $0.viewController == viewController } )  else {
            return
        }
        
        os_log(.info, "Alert being dismissed")
        
        alertWindow.dismiss { [weak self] in
            self?.alertWindows.remove(alertWindow)
        }
    }
}
