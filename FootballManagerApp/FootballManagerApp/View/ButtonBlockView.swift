//
//  PickerBlockView.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 24.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

final class ButtonBlockView: UIView {
    let backgroundView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.turnOffAutoresizingMask()
        return view
    }()

    let teamLabel: UILabel = {
        let label = UILabel()
        label.text = PickerLabel.team
        label.turnOffAutoresizingMask()
        return label
    }()

    let positionLabel: UILabel = {
        let label = UILabel()
        label.text = PickerLabel.position
        label.turnOffAutoresizingMask()
        return label
    }()

    let teamButton: UIButton = {
        let button = UIButton()
        button.setTitle(Button.pressToSelect, for: .normal)
        button.setTitleColor(Color.gold, for: .normal)
        button.turnOffAutoresizingMask()
        return button
    }()

    let positionButton: UIButton = {
        let button = UIButton()
        button.setTitle(Button.pressToSelect, for: .normal)
        button.setTitleColor(Color.gold, for: .normal)
        button.turnOffAutoresizingMask()
        return button
    }()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.sizeToFit()
        stackView.turnOffAutoresizingMask()
        return stackView
    }()

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.turnOffAutoresizingMask()
        return stackView
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.turnOffAutoresizingMask()
        return stackView
    }()

    override func awakeFromNib() {
           super.awakeFromNib()
           setupLayout()
       }
}

private extension ButtonBlockView {
    func setupLayout() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(mainStackView)

        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.addArrangedSubview(buttonStackView)

        labelStackView.addArrangedSubview(teamLabel)
        labelStackView.addArrangedSubview(positionLabel)
        buttonStackView.addArrangedSubview(teamButton)
        buttonStackView.addArrangedSubview(positionButton)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            mainStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),

            teamButton.heightAnchor.constraint(equalToConstant: 25),
            positionButton.heightAnchor.constraint(equalToConstant: 25),
            teamLabel.heightAnchor.constraint(equalToConstant: 25),
            positionLabel.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
}
