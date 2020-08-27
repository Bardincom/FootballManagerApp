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
    static let magnifyingglass = UIImage(systemName: "magnifyingglass", withConfiguration: withConfiguration)
}

enum Title {
    static let teamManager = "Team Manager"
    static let player = "Player"
}

enum Model {
    static let name = "Team"
}

enum PickerLabel {
    static let team = "Team:"
    static let position = "Position:"
}

enum Color {
    static let gold = UIColor(named: "gold")
    static let lightGray = UIColor(named: "lightGray")
    static let oliveСolor = UIColor(named: "oliveСolor")
}

enum Button {
    static let cancel = "Cancel"
    static let selectTeam = "Select Team"
    static let pressToSelect = "Press to select"
}

struct Picker {
    static let positions = ["Forward", "Winger", "Midfiel", "Back", "Keeper"]
    
    static let teams = ["Free agent", "Real Madrid CF", "FC Bayern München", "FC Barcelona", "Club Atlético de Madrid", "Juventus", "Manchester City FC", "Paris Saint-Germain", "Sevilla FC", "Manchester United FC", "Liverpool FC", "Arsenal FC", "Borussia Dortmund", "Tottenham Hotspur", "FC Shakhtar Donetsk", "Chelsea FC", "Olympique Lyonnais"]
}

enum CountItem {
    static let team = Picker.teams.count
    static let position = Picker.positions.count
}

enum Location: String {
    case inPlay = "In play"
    case Bench

    var inPlay: Bool {
        return self == .inPlay
    }

    var Bench: Bool {
        return self == .Bench
    }
}
