//
//  MainViewController.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 13.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    lazy var rootViewController = SceneDelegate.shared.rootViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
}

private extension MainViewController {
    func setupNavigationBar() {
        title = Title.teamManager

        let button = UIBarButtonItem(image: Icon.addPerson,
                                     style: .plain,
                                     target: self,
                                     action: #selector(goToPlaerViewController))

        button.tintColor = UIColor.red

        navigationItem.rightBarButtonItems = .some([button])
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    @objc
    func goToPlaerViewController() {
        rootViewController.switchToPlayerViewController()
    }
}
