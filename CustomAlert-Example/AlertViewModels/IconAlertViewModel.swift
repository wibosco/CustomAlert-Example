//
//  IconAlertViewModel.swift
//  CustomAlert-Example
//
//  Created by William Boles on 26/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import UIKit

struct IconAlertViewModel {
    let title: String
    let message: String
    let icon: UIImage
    let button: IconAlertButton
}

struct IconAlertButton {
    let title: String
    let action: (() -> ())?
}
