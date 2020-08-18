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


struct Picker {
    static let positions = ["Forward", "Winger", "Midfiel", "Back", "Keeper"]
    
    static let teams = ["Free agent", "Real Madrid CF", "FC Bayern München", "FC Barcelona", "Club Atlético de Madrid", "Juventus", "Manchester City FC", "Paris Saint-Germain", "Sevilla FC", "Manchester United FC", "Liverpool FC", "Arsenal FC", "Borussia Dortmund", "Tottenham Hotspur", "FC Shakhtar Donetsk", "Chelsea FC", "Olympique Lyonnais"]
}
