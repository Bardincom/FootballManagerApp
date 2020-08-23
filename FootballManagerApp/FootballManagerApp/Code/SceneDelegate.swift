//
//  SceneDelegate.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 13.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        _ = CoreDataManager.shared

        assembly(windowScene)

    }
}

private extension SceneDelegate {
    func assembly(_ windowScene: UIWindowScene ) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let rootViewController = MainViewController()
        rootViewController.title = "Names.documents"
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
