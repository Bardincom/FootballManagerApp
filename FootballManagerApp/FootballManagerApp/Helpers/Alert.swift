//
//  Alert.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 23.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

final class Alert {
    class func showAlert(_ viewController: UIViewController,
                         hendler: @escaping () -> Void) {

        let alert = UIAlertController(title: "No team selected",
                                      message: nil, preferredStyle: .alert)

        alert.addAction(.init(title: Button.cancel, style: .cancel, handler: nil))
        alert.addAction(.init(title: Button.selectTeam, style: .default, handler: { action in
            hendler()
        }))

        viewController.present(alert, animated: true)
    }
}
