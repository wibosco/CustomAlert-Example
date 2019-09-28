//
//  TextAlertViewModel.swift
//  CustomAlert-Example
//
//  Created by William Boles on 26/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation

struct TextAlertViewModel {
    let title: String
    let button: TextAlertButton
}

struct TextAlertButton {
    let title: String
    let action: (() -> ())?
}
