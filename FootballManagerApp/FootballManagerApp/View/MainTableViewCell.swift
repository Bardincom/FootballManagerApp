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
    @IBOutlet private var position: UILabel!
    @IBOutlet private var foto: UIImageView!

    func setupPlayer(_ player: Player) {
        team.text = player.club?.name
        number.text = String(player.number)
        nationality.text = player.nationality
        fullName.text = player.fullName
        position.text = player.position
        age.text = String(player.age)
        guard
            let playerImage = player.image,
            let image = UIImage(data: playerImage)
            else { return }
        foto.image = image
    }
}
