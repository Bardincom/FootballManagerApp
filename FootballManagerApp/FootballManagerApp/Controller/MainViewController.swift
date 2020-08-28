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
    @IBOutlet private var playerLocationSegmentControl: UISegmentedControl!
    
    lazy var coreDataManager = CoreDataManager.shared
    private var selectedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [])

    var players = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    @IBAction func displaySelectedPlayerLocation(_ sender: UISegmentedControl) {
        players.removeAll()
        fetchData(predicate: selectedPredicate)
        mainTableView.reloadData()
    }
}

private extension MainViewController {
    func setupNavigationBar() {
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

    func fetchData(predicate: NSCompoundPredicate? = nil) {

        let fetchedPlayers = coreDataManager.fetchData(for: Player.self, predicate: predicate)

        switch playerLocationSegmentControl.selectedSegmentIndex {
            case 0:
                players = fetchedPlayers
            case 1:
                players = fetchedPlayers.filter({$0.inPlay})
            case 2:
                players = fetchedPlayers.filter({!$0.inPlay})
            default:
                break
        }

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
        searchViewController.delegate = self
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

extension MainViewController: SearchViewControllerDelegate {
    func viewController(_ viewController: SearchViewController, didPassedData predicate: NSCompoundPredicate) {
        fetchData(predicate: predicate)
        selectedPredicate = predicate
        mainTableView.reloadData()
    }
}
