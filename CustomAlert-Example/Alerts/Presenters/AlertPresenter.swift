//
//  AlertPresenter.swift
//  CustomAlert-Example
//
//  Created by William Boles on 26/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import UIKit

enum AlertType {
    case informational(alertViewModel: InformationalAlertViewModel)
    case error(alertViewModel: ErrorAlertViewModel)
}

class AlertPresenter {
    private var alertWindows = Set<AlertWindow>()
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
        
        alertWindow.present()
        
        alertWindows.insert(alertWindow)
    }
    
    // MARK: - Dismissal
    
    private func handleAlertDismissalCompletion(_ alertViewController: UIViewController) {
        guard let alertWindow = alertWindows.first(where: { $0.alertViewController == alertViewController } )  else {
            return
        }
        
        alertWindow.dismiss { [weak self] in
            self?.alertWindows.remove(alertWindow)
        }
    }
}
