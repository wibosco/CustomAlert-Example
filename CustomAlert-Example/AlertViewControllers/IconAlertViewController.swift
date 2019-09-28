//
//  IconAlertViewController.swift
//  CustomAlert-Example
//
//  Created by William Boles on 26/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class IconAlertViewController: UIViewController {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private var viewModel: IconAlertViewModel?
    
    // MARK: - Configure
    
    func configure(withViewModel viewModel: IconAlertViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        headerImageView.image = viewModel.icon
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
