//
//  UIPickerView+Extansion.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 25.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

extension UIPickerView {
    func setDefaultValue(){
       self.selectRow(0, inComponent: 0, animated: true)
    }
}
