//
//  PickerViewBlock.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 25.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

class PickerViewBlock: UIView {

    let backgroundView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.turnOffAutoresizingMask()
        return view
    }()

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Make a choice"
        label.turnOffAutoresizingMask()
        return label
    }()

    let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.sizeToFit()
        pickerView.turnOffAutoresizingMask()
        return pickerView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
}

extension PickerViewBlock {
    func setupLayout() {
        addSubview(backgroundView)
        backgroundView.addSubviews(label, pickerView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            label.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: 8),

            pickerView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
        ])

    }
}
