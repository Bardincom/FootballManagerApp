//
//  SearchViewController.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 24.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func viewController(_ viewController: SearchViewController, didPassedData predicate: [NSPredicate])
}

final class SearchViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var age: UITextField!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var viewWithPickerView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var labelWintPickerVie: UILabel!
    @IBOutlet var teamButton: UIButton!
    @IBOutlet var positionButton: UIButton!

    private var isTeamSelect: Bool = true
    private var selectTeam: String?
    private var selectPosition: String?

    weak var delegate: SearchViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func pressReset(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.viewController(self, didPassedData: [NSPredicate]())
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressSearch(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        let name = self.name.text ?? ""
        let age = self.age.text ?? ""
        let team = selectTeam ?? ""
        let position = selectPosition ?? ""

        let predecate = makePredicate(fullName: name, age: age, team: team, position: position)
        delegate.viewController(self, didPassedData: predecate)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func selectTeam(_ sender: UIButton) {
        isTeamSelect = true
        viewWithPickerView.isHidden = false
        showPickerView()
    }

    @IBAction func selectPosition(_ sender: UIButton) {
        isTeamSelect = false
        viewWithPickerView.isHidden = false
        showPickerView()
    }

    func setupUI() {
        resetButton.layer.cornerRadius = 5
        searchButton.layer.cornerRadius = 5
    }
}

//MARK: UIPickerViewDelegate
extension SearchViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return isTeamSelect ? Picker.teams[row] : Picker.positions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if isTeamSelect {
            teamButton.setTitle(Picker.teams[row], for: .normal)
            selectTeam = Picker.teams[row]
        } else {
            positionButton.setTitle(Picker.positions[row], for: .normal)
            selectPosition = Picker.positions[row]
        }

        viewWithPickerView.isHidden = true
    }
}

//MARK: UIPickerViewDataSource
extension SearchViewController: UIPickerViewDataSource {
    func showPickerView() {
        pickerView.setDefaultValue()
        pickerView.backgroundColor = Color.lightGray
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isTeamSelect ? CountItem.team : CountItem.position
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel

        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }

        label.textColor = Color.gold
        label.textAlignment = .center
        label.backgroundColor = .black

        isTeamSelect ? (label.text = Picker.teams[row]) : (label.text = Picker.positions[row])

        return label
    }
}

private extension SearchViewController {

    func makePredicate(fullName: String,
                               age: String,
                               team: String,
                               position: String) -> [NSPredicate] {

        var  predicate = [NSPredicate]()

        if !fullName.isEmpty {
            let fullNamePredicate = NSPredicate(format: "\(Predicate.fullName) CONTAINS[cd] '\(fullName)'")
            predicate.append(fullNamePredicate)
        }

        if !age.isEmpty {
            let selectedSegmentControl = ageSearchConditin(index: segmentControl.selectedSegmentIndex)
            let agePredicate = NSPredicate(format: "\(Predicate.age) \(selectedSegmentControl) '\(age)'")
            predicate.append(agePredicate)
        }

        if !team.isEmpty {
            let teamPredicate = NSPredicate(format: "\(Predicate.clubName) CONTAINS[cd] '\(team)'")
            predicate.append(teamPredicate)
        }

        if !position.isEmpty {
            let positionPredicate = NSPredicate(format: "\(Predicate.position) CONTAINS[cd] '\(position)'")
            predicate.append(positionPredicate)
        }

        return predicate
    }

    func ageSearchConditin(index: Int) -> String {
        var condition = ">="

        switch index {
            case 0: condition = ">="
            case 1: condition = "="
            case 2: condition = "<="
            default: break
        }

        return condition
    }
}
