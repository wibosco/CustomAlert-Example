//
//  TextAlertViewController.swift
//  CustomAlert-Example
//
//  Created by William Boles on 26/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class TextAlertViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private var viewModel: TextAlertViewModel?
    
    // MARK: - Configure
    
    func configure(withViewModel viewModel: TextAlertViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        button.setTitle(viewModel.button.title, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let viewModel = viewModel else {
            fatalError("Alert needs a view model")
        }
        
        viewModel.button.action?()
    }
}
