//
//  RoudedCornerView.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 24.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

class RoudedCornerView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    private func setUpView () {

        clipsToBounds = true
        backgroundColor = .white
        layer.masksToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
    }

}
