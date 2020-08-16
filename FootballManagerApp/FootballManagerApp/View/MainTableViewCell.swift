//
//  MainTableViewCell.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 14.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet private var team: UILabel!
    @IBOutlet private var number: UILabel!
    @IBOutlet private var nationality: UILabel!
    @IBOutlet private var fullName: UILabel!
    @IBOutlet private var age: UILabel!
    @IBOutlet private var foto: UIImageView!

    func setupPlayer(_ player: Player) {
        team.text = player.club?.name
        number.text = "\(player.number)"
        nationality.text = player.nationality
        fullName.text = player.fullName
        age.text = "\(player.age)"
        foto.image = player.image as? UIImage
    }
}
