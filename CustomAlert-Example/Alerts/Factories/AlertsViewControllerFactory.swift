//
//  AlertsViewControllerFactory.swift
//  CustomAlert-Example
//
//  Created by William Boles on 09/05/2020.
//  Copyright © 2020 William Boles. All rights reserved.
//

import UIKit

enum AlertType {
    case informational(alertViewModel: InformationalAlertViewModel)
    case error(alertViewModel: ErrorAlertViewModel)
}

typealias AlertDismissalCompletion = ((_ alertViewController: UIViewController) -> ())

class AlertViewControllerFactory {
    
    // MARK: - WindowPresentationViewModel
    
    func alertViewController(for type: AlertType, with dismissalCompletion: @escaping AlertDismissalCompletion) -> UIViewController {
        let viewController: UIViewController
        switch type {
        case .informational(let alertViewModel):
            viewController = createAlertViewController(from: alertViewModel, with: dismissalCompletion)
        case .error(let alertViewModel):
            viewController = createAlertViewController(from: alertViewModel, with: dismissalCompletion)
        }
        
        return viewController
    }
    
    // MARK: - ViewControllers
    
    private func createAlertViewController(from alertViewModel: InformationalAlertViewModel, with dismissalCompletion: @escaping AlertDismissalCompletion) -> InformationalAlertViewController {
        let storyboard = UIStoryboard(name: "Alerts", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "InformationalAlertViewController") as? InformationalAlertViewController else {
            fatalError("Custom alert type does not exist")
        }
        let _ = alertViewController.view
        
        let dismissingButton = AlertTextButtonViewModel(title: alertViewModel.button.title) {
            alertViewModel.button.action?()
            dismissalCompletion(alertViewController)
        }
        let dismissingAlertViewModel = InformationalAlertViewModel(title: alertViewModel.title, button: dismissingButton)
        
        alertViewController.configure(withViewModel: dismissingAlertViewModel)
        
        return alertViewController
    }
    
    private func createAlertViewController(from alertViewModel: ErrorAlertViewModel, with dismissalCompletion: @escaping AlertDismissalCompletion) -> ErrorAlertViewController {
        let storyboard = UIStoryboard(name: "Alerts", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "ErrorAlertViewController") as? ErrorAlertViewController else {
            fatalError("Custom alert type does not exist")
        }
        let _ = alertViewController.view
        
        let dismissingButton = AlertTextButtonViewModel(title: alertViewModel.button.title) {
            alertViewModel.button.action?()
            dismissalCompletion(alertViewController)
        }
        let dismissingAlertViewModel = ErrorAlertViewModel(title: alertViewModel.title, message: alertViewModel.message, button: dismissingButton)
        
        alertViewController.configure(withViewModel: dismissingAlertViewModel)
        
        return alertViewController
    }
}
