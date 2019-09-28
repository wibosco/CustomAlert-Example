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
    
    static let shared = AlertPresenter()
    
    // MARK: - Present
    
    func presentAlert<T>(withAlertViewModel alertViewModel: T) {
        let viewController = alertViewController(from: alertViewModel)

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
    
    // MARK: - WindowPresentationViewModel
    
    private func alertViewController<T>(from alertViewModel: T) -> UIViewController {
        let viewController: UIViewController
        if let alertViewModel = alertViewModel as? TextAlertViewModel {
            viewController = createAlertViewController(from: alertViewModel)
        } else if let alertViewModel = alertViewModel as? IconAlertViewModel {
            viewController = createAlertViewController(from: alertViewModel)
        } else {
            fatalError("Unknown Alert type: \(alertViewModel.self)")
        }
        
        return viewController
    }
    
    // MARK: - ViewControllers
    
    private func createAlertViewController(from alertViewModel: TextAlertViewModel) -> TextAlertViewController {
        let storyboard = UIStoryboard(name: "Alerts", bundle: nil)
        guard let alertController = storyboard.instantiateViewController(withIdentifier: "InformationalAlertViewController") as? TextAlertViewController else {
            fatalError("Custom alert type does not exist")
        }
        let _ = alertController.view
        
        let dismissingButton = TextAlertButton(title: alertViewModel.button.title) {
            alertViewModel.button.action?()
            self.dismissAlert(onAlertViewController: alertController)
        }
        let dismissingAlertViewModel = TextAlertViewModel(title: alertViewModel.title, button: dismissingButton)
        
        alertController.configure(withViewModel: dismissingAlertViewModel)
        
        return alertController
    }
    
    private func createAlertViewController(from alertViewModel: IconAlertViewModel) -> IconAlertViewController {
        let storyboard = UIStoryboard(name: "Alerts", bundle: nil)
        guard let alertController = storyboard.instantiateViewController(withIdentifier: "ErrorAlertViewController") as? IconAlertViewController else {
            fatalError("Custom alert type does not exist")
        }
        let _ = alertController.view
        
        let dismissingButton = IconAlertButton(title: alertViewModel.button.title) {
            alertViewModel.button.action?()
            self.dismissAlert(onAlertViewController: alertController)
        }
        let dismissingAlertViewModel = IconAlertViewModel(title: alertViewModel.title, message: alertViewModel.message, icon: alertViewModel.icon, button: dismissingButton)
        
        alertController.configure(withViewModel: dismissingAlertViewModel)
        
        return alertController
    }
    
    // MARK: - Dismissal
    
    private func dismissAlert(onAlertViewController alertViewController: UIViewController) {
        guard let index = alertWindows.firstIndex(where: { $0.alertViewController == alertViewController } )  else {
            return
        }
        let alertWindow = alertWindows[index]
        alertWindow.dismiss()
        
        alertWindows.remove(at: index)
    }
}
