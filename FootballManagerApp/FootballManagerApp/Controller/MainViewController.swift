//
//  MainViewController.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 13.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet private var mainTableView: UITableView! {
        willSet {
            newValue.register(nibCell: MainTableViewCell.self)
            newValue.tableFooterView = UIView()
        }
    }
    
    lazy var coreDataManager = CoreDataManager.shared

    var players = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
}

private extension MainViewController {
    func setupUI() {
        title = Title.teamManager

        let addPlayer = UIBarButtonItem(image: Icon.addPerson,
                                        style: .plain,
                                        target: self,
                                        action: #selector(goToPlayerViewController))

        let searchPlayers = UIBarButtonItem(image: Icon.magnifyingglass,
                                        style: .plain,
                                        target: self,
                                        action: #selector(goToSearchViewController))

        addPlayer.tintColor = Color.gold
        searchPlayers.tintColor = Color.gold

        navigationItem.leftBarButtonItem = .some(searchPlayers)
        navigationItem.rightBarButtonItems = .some([addPlayer])
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func fetchData() {
        players = coreDataManager.fetchData(for: Player.self)

        if !players.isEmpty {
            mainTableView.isHidden = false
        } else {
            mainTableView.isHidden = true
        }
        mainTableView.reloadData()
    }

    @objc
    func goToSearchViewController() {
        let searchViewController = SearchViewController()
        searchViewController.modalTransitionStyle = .crossDissolve
        searchViewController.modalPresentationStyle = .overCurrentContext
        present(searchViewController, animated: true, completion: nil)
    }

    @objc
    func goToPlayerViewController() {
        let playerViewController = PlayerViewController()
        navigationController?.pushViewController(playerViewController, animated: true)
    }
}

//MARK: TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: MainTableViewCell.self, for: indexPath)
        let player = players[indexPath.row]
        cell.setupPlayer(player)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let player = players[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            self.coreDataManager.delete(object: player)
            self.fetchData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MainViewController: UITableViewDelegate {
    //TODO: didSelectRowAt indexPath

}
