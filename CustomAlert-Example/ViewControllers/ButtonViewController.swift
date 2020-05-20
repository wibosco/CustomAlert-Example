//
//  SliderViewController.swift
//  CustomAlert-Example
//
//  Created by William Boles on 26/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit
import os

class ButtonViewController: UIViewController {
    @IBOutlet weak var showAlertsButton: UIButton!
    
    private var showInformationalAlert: Bool = true
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAlertsButton.layer.borderWidth = 1
        showAlertsButton.layer.borderColor = showAlertsButton.tintColor.cgColor
        showAlertsButton.layer.cornerRadius = 10
    }
    
    // MARK: - Button
    
    @IBAction func showButtonPressed(_ sender: Any) {
        if showInformationalAlert {
            let alertViewController = createInformationalViewController()
            AlertPresenter.shared.presentAlert(alertViewController)
        } else {
            let alertViewController = createErrorViewController()
            AlertPresenter.shared.presentAlert(alertViewController)
        }
        
        showInformationalAlert.toggle()
    }
    
    // MARK: - Alerts
    
    private func createInformationalViewController() -> InformationalAlertViewController  {
        let alertStoryboard = UIStoryboard.alertStoryboard()
        let alertViewController = InformationalAlertViewController.instantiateViewController(fromStoryboard: alertStoryboard)
        
        let dismissButton = AlertTextButtonViewModel(title: "Dismiss") {
            AlertPresenter.shared.dismissAlert(alertViewController)
        }
        let alertViewModel = InformationalAlertViewModel(title: "Text alert title", button: dismissButton)
        
        alertViewController.configure(withViewModel: alertViewModel)
        
        return alertViewController
    }
    
    private func createErrorViewController() -> ErrorAlertViewController  {
        let alertStoryboard = UIStoryboard.alertStoryboard()
        let alertViewController = ErrorAlertViewController.instantiateViewController(fromStoryboard: alertStoryboard)
        
        let okButton = AlertTextButtonViewModel(title: "OK") {
            AlertPresenter.shared.dismissAlert(alertViewController)
        }
        let alertViewModel = ErrorAlertViewModel(title: "Error alert title", message: "Message for error alert", button: okButton)
        
        alertViewController.configure(withViewModel: alertViewModel)
        
        return alertViewController
    }
}
