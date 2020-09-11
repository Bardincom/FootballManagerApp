//
//  MainViewController.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 13.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit
import CoreData

final class MainViewController: UIViewController {

    @IBOutlet private var mainTableView: UITableView! {
        willSet {
            newValue.register(nibCell: MainTableViewCell.self)
            newValue.tableFooterView = UIView()
        }
    }
    @IBOutlet private var playerLocationSegmentControl: UISegmentedControl!
    
    lazy var coreDataManager = CoreDataManager.shared
    private var fetchedResultController: NSFetchedResultsController<Player>?
    private var searchPredicate = [NSPredicate]()
    private var locationPredicate = [NSPredicate]()
    private var selectedCompoundPredicate: NSCompoundPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: searchPredicate + locationPredicate)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coreDataManager.save()
    }

    @IBAction private func displaySelectedPlayerLocation(_ sender: UISegmentedControl) {

        guard let location = locationConditin(index: playerLocationSegmentControl.selectedSegmentIndex) else {
            fetchData()
            return }

        locationPredicate.append(makePredicate(location: location))

        fetchData()
        locationPredicate.removeAll()
    }
}

private extension MainViewController {
    func setupNavigationBar() {
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

            guard fetchedResultController == nil else {
                fetchedResultController?.fetchRequest.predicate = selectedCompoundPredicate
                try? self.fetchedResultController?.performFetch()
                fetchedObjectsCheck()
                return
            }

            let fetchedResult = coreDataManager.fetchData(for: Player.self,
                                                          selectionNameKeyPath: SortDescriptorKey.position,
                                                          predicate: selectedCompoundPredicate)

            // Фильтрация по локации игрока
            switch playerLocationSegmentControl.selectedSegmentIndex {
                case 0:
                    fetchedResultController = fetchedResult
                case 1:
                    fetchedResultController = fetchedResult
                case 2:
                    fetchedResultController = fetchedResult
                default:
                    break
            }
            fetchedResultController?.delegate = self
            fetchedObjectsCheck()
        }

    func makePredicate(location: Bool) -> NSPredicate {
        guard let location = locationConditin(index: playerLocationSegmentControl.selectedSegmentIndex) else {
            return NSPredicate() }

        return NSPredicate(format: "inPlay == %@", NSNumber(value: location))
    }

    func locationConditin(index: Int) -> Bool? {
        var condition: Bool?

        switch index {
            case 0: condition = nil
            case 1: condition = true
            case 2: condition = false
            default: break
        }

        return condition
    }

    func fetchedObjectsCheck() {
        guard let players = fetchedResultController?.fetchedObjects else { return }

        if !players.isEmpty {
            mainTableView.isHidden = false
        } else {
            mainTableView.isHidden = true
        }
        mainTableView.reloadData()
    }

    func showPlayerLocation(_ player: Player) -> String? {
        return player.inPlay ? Location.inPlay.rawValue : Location.Bench.rawValue
    }

    @objc
    func goToSearchViewController() {
        playerLocationSegmentControl.selectedSegmentIndex = 0
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
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultController?.sections else { return 0 }
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultController?.sections else { return nil }
        return sections[section].name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusable: MainTableViewCell.self, for: indexPath)

        guard let player = fetchedResultController?.object(at: indexPath) else {return cell}
        cell.setupPlayer(player)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let player = self.fetchedResultController?.object(at: indexPath) else { return nil}

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in

            self.coreDataManager.delete(object: player)
        }

        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            let playerViewController = PlayerViewController()
            playerViewController.selectPlayer = player
            self.navigationController?.pushViewController(playerViewController, animated: true)
        }

        let locationPlayer = UIContextualAction(style: .normal, title: showPlayerLocation(player)) { (_, _, _) in

            player.inPlay ? (player.inPlay = false) : (player.inPlay = true)
        }

        editAction.backgroundColor = .orange
        locationPlayer.backgroundColor = .purple

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, locationPlayer])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

//MARK: TableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: FetchedResultsControllerDelegate
extension MainViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                mainTableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            case .delete:
                mainTableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                if let indexPath = newIndexPath {
                    mainTableView.insertRows(at: [indexPath], with: .fade)
                    fetchedObjectsCheck()
            }

            case .delete:
                if let indexPath = indexPath {
                    mainTableView.deleteRows(at: [indexPath], with: .fade)
                    fetchedObjectsCheck()
            }

            case .update:
                if let indexPath = indexPath {
                    let cell = mainTableView.cellForRow(at: indexPath) as! MainTableViewCell
                    guard let player = fetchedResultController?.object(at: indexPath as IndexPath) else { return }
                    cell.setupPlayer(player)
            }

            case .move:
                if let indexPath = indexPath {
                    self.mainTableView.deleteRows(at: [indexPath], with: .fade)
                }
                
                if let indexPath = newIndexPath {
                    self.mainTableView.insertRows(at: [indexPath], with: .fade)
            }
            @unknown default:
                fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainTableView.endUpdates()
    }
}

//MARK: SearchViewControllerDelegate
extension MainViewController: SearchViewControllerDelegate {
    func viewController(_ viewController: SearchViewController, didPassedData predicate: [NSPredicate]) {
        searchPredicate = predicate
        fetchData()
        mainTableView.reloadData()
    }
}
