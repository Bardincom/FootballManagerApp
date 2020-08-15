//
//  Constants.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 13.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

let withConfiguration = UIImage.SymbolConfiguration(weight: .medium)

enum Icon {
    static let addPerson = UIImage(systemName: "person.badge.plus", withConfiguration: withConfiguration)
    static let backButton = UIImage(systemName: "chevron.left", withConfiguration: withConfiguration)
}

enum Title {
    static let teamManager = "Team Manager"
    static let player = "Player"
}

enum Model {
    static let name = "Team"
}

enum Color {
    static let gold = UIColor(named: "gold")
    static let lightGray = UIColor(named: "lightGray")
}
