//
//  SearchViewController.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 24.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func pressReset(_ sender: UIButton) {
        print("pressReset")
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressSearch(_ sender: UIButton) {
        print("pressSearch")
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
