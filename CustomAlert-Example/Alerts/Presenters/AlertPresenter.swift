//
//  AlertPresenter.swift
//  CustomAlert-Example
//
//  Created by William Boles on 26/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import os

class AlertPresenter {
    private var alertWindows = Set<AlertWindow>()
    
    static let shared = AlertPresenter()
    
    // MARK: - Present
    
    func presentAlert(_ alertViewController: AlertViewController) {
        os_log(.info, "Alert being presented")
        
        let alertWindow = AlertWindow(withAlertViewController: alertViewController)
        alertWindow.present()
        
        alertWindows.insert(alertWindow)
    }
    
    // MARK: - Dismiss
    
    func dismissAlert(_ alertViewController: AlertViewController) {
        guard let alertWindow = alertWindows.first(where: { $0.alertViewController == alertViewController } )  else {
            return
        }
        
        os_log(.info, "Alert being dismissed")
        
        alertWindow.dismiss { [weak self] in
            self?.alertWindows.remove(alertWindow)
        }
    }
}
