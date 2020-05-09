//
//  AlertPresenter.swift
//  CustomAlert-Example
//
//  Created by William Boles on 26/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import UIKit

class AlertPresenter: AlertWindowDelegate {
    private var alertWindows = [AlertWindow]()
    private let viewControllerFactory: AlertViewControllerFactory
    
    static let shared = AlertPresenter()
    
    // MARK - Init
    
    init(viewControllerFactory: AlertViewControllerFactory = AlertViewControllerFactory()) {
        self.viewControllerFactory = viewControllerFactory
    }
    
    // MARK: - Present
    
    func presentAlert(_ alertType: AlertType) {
        let viewController = viewControllerFactory.alertViewController(for: alertType, with: handleAlertDismissalCompletion)

        let alertWindow = AlertWindow(withAlertViewController: viewController)
        alertWindow.delegate = self
        
        alertWindow.present()
        
        alertWindows.append(alertWindow)
    }
    
    // MARK: - AlertWindowDelegate
    
    func alertWindow(_ alertWindow: AlertWindow, didDismissAlert viewController: UIViewController) {
        guard let index = alertWindows.firstIndex(of: alertWindow) else {
            return
        }
        
        alertWindows.remove(at: index)
    }
    
    // MARK: - Dismissal
    
    private func handleAlertDismissalCompletion(_ alertViewController: UIViewController) {
        guard let index = alertWindows.firstIndex(where: { $0.alertViewController == alertViewController } )  else {
            return
        }
        let alertWindow = alertWindows[index]
        alertWindow.dismiss()
        
        alertWindows.remove(at: index)
    }
}
