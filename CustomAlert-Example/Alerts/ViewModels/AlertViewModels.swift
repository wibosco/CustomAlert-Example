//
//  AlertViewModels.swift
//  CustomAlert-Example
//
//  Created by William Boles on 15/05/2020.
//  Copyright © 2020 William Boles. All rights reserved.
//

import UIKit

struct AlertTextButtonViewModel {
    let title: String
    let action: (() -> ())?
}

struct InformationalAlertViewModel {
    let title: String
    let button: AlertTextButtonViewModel
}

struct ErrorAlertViewModel {
    let title: String
    let message: String
    let button: AlertTextButtonViewModel
}
