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
            let alertViewModel = createTextAlertViewModel()
            AlertPresenter.shared.presentAlert(.informational(alertViewModel: alertViewModel))
        } else {
            let alertViewModel = createIconAlertViewModel()
            AlertPresenter.shared.presentAlert(.error(alertViewModel: alertViewModel))
        }
        
        showInformationalAlert.toggle()
    }
    
    // MARK: - Alerts
    
    private func createTextAlertViewModel() -> InformationalAlertViewModel  {
        let dismissButton = AlertTextButtonViewModel(title: "Dismiss") {
            os_log(.info, "Dismiss button was pressed")
        }
        let alertViewModel = InformationalAlertViewModel(title: "Text alert title", button: dismissButton)
        
        return alertViewModel
    }
    
    private func createIconAlertViewModel() -> ErrorAlertViewModel  {
        let okButton = AlertTextButtonViewModel(title: "OK") {
            os_log(.info, "OK button was pressed")
        }
        let alertViewModel = ErrorAlertViewModel(title: "Error alert title", message: "Message for error alert", button: okButton)
        
        return alertViewModel
    }
}
