//
//  UIView+Extension.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 24.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

extension UIView {

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }

    func turnOffAutoresizingMask() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
