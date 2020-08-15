//
//  PlayerViewController.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 13.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

final class PlayerViewController: UIViewController {

    lazy var rootViewController = SceneDelegate.shared.rootViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
}

private extension PlayerViewController {
    @objc
    func goToMainViewController() {
        rootViewController.switchToMainViewController()
    }

    func setupNavigationBar() {
        title = Title.player
        let backButton = UIBarButtonItem(image: Icon.backButton, style: .plain, target: self, action: #selector(goToMainViewController))
        backButton.tintColor = Color.gold
        navigationItem.leftBarButtonItem = .some(backButton)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
