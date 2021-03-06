//
//  PlayerViewController.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 13.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

final class PlayerViewController: UIViewController {

    @IBOutlet private var teamButton: UIButton!
    @IBOutlet private var positionButton: UIButton!
    @IBOutlet private var uploadImageButton: UIButton!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var number: UITextField!
    @IBOutlet private var nationality: UITextField!
    @IBOutlet private var fullName: UITextField!
    @IBOutlet private var age: UITextField!
    @IBOutlet private var foto: UIImageView!
    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var selectLocationPlayer: UISegmentedControl!

    lazy var coreDataManager = CoreDataManager.shared
    private var isTeamSelect: Bool = true
    private var selectTeam: String?
    private var selectPosition: String?
    private var chosenImage = #imageLiteral(resourceName: "defaultImage")
    var selectPlayer: Player?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setTextFieldDelegate()
        disableSaveButton()
        displayPlayer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationAddObserver(#selector(keyboardWillShow(notification:)))
    }

    @IBAction private func uploadImage(_ sender: UIButton) {
        DispatchQueue.main.async {
                    ActivityIndicator.start()
            self.showImagePickerController()
        }

    }

    @IBAction private func pressToSelectTeam(_ sender: UIButton) {
        isTeamSelect = true
        pickerView.isHidden = false
        showPickerView()
    }

    @IBAction private func pressToSelectPosition(_ sender: UIButton) {
        isTeamSelect = false
        pickerView.isHidden = false
        showPickerView()
    }

    @IBAction private func savePlayer(_ sender: UIButton) {
        guard selectTeam != nil else {
            Alert.showAlert(self) {
                self.pressToSelectTeam(self.teamButton)
            }
            return
        }

        guard let selectPlayer = selectPlayer else {
            let team = coreDataManager.createObject(from: Club.self)
            team.name = selectTeam

            let player = coreDataManager.createObject(from: Player.self)

            setPlayer(player, of: team)

            navigationController?.popViewController(animated: false)
            return }

        setPlayer(selectPlayer)
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        number.resignFirstResponder()
        fullName.resignFirstResponder()
        nationality.resignFirstResponder()
        age.resignFirstResponder()
    }
}

//MARK: Private Methods
private extension PlayerViewController {
    func setupNavigationBar() {
        title = Title.player
        let backButton = UIBarButtonItem(image: Icon.backButton, style: .plain, target: self, action: #selector(goToMainViewController))
        backButton.tintColor = Color.gold
        navigationItem.leftBarButtonItem = .some(backButton)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func setPlayer(_ player: Player,  of team: Club? = nil) {
        player.fullName = fullName.text
        player.nationality = nationality.text
        player.age = Int16(age.text ?? "0") ?? 0
        player.number = Int16(number.text ?? "0") ?? 0
        player.image = foto.image?.pngData()
        player.position = selectPosition
        player.inPlay = selectLocation(index: selectLocationPlayer.selectedSegmentIndex)

        guard let team = team else {
            player.club?.name = selectTeam
            return }
        player.club = team
    }

    func displayPlayer() {
        enableSaveButton()
        guard let selectPlayer = selectPlayer else { return }
        fullName.text = selectPlayer.fullName
        number.text = String(describing: selectPlayer.number)
        nationality.text = selectPlayer.nationality
        age.text =  String(describing: selectPlayer.age)
        teamButton.setTitle(selectPlayer.club?.name, for: .normal)
        selectTeam = selectPlayer.club?.name
        positionButton.setTitle(selectPlayer.position, for: .normal)
        selectPosition = selectPlayer.position
        if selectPlayer.inPlay {
            selectLocationPlayer.selectedSegmentIndex = 0
        } else {
            selectLocationPlayer.selectedSegmentIndex = 1
        }

        guard
            let playerImage = selectPlayer.image,
            let image = UIImage(data: playerImage)
            else { return }
        foto.image = image
    }

    func setupUI() {
        pickerView.isHidden = true
        saveButton.layer.cornerRadius = 5
        uploadImageButton.tintColor = Color.gold
        teamButton.tintColor = Color.gold
        positionButton.tintColor = Color.gold
    }

    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .savedPhotosAlbum

        present(imagePickerController, animated: true) {
            ActivityIndicator.stop()
        }
    }

    func setTextFieldDelegate() {
        number.delegate = self
        fullName.delegate = self
        nationality.delegate = self
        age.delegate = self
    }

    func disableSaveButton() {
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
    }

    func enableSaveButton() {
        saveButton.isEnabled = true
        saveButton.alpha = 1
    }

    func selectLocation(index: Int) -> Bool {
        var isPlay: Bool = true

        switch index {
            case 0: isPlay = true
            case 1: isPlay = false
            default: break
        }
        return isPlay
    }

    @objc
    func goToMainViewController() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let size = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        shiftView(size)
    }
}

//MARK: UIImagePickerControllerDelegate
extension PlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let editingImage = info[.editedImage] as? UIImage else { return }
        chosenImage = editingImage
        foto.image = chosenImage

        dismiss(animated: true, completion: nil)
    }
}

//MARK: UIPickerViewDataSource
extension PlayerViewController: UIPickerViewDataSource {
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

//MARK: UIPickerViewDelegate
extension PlayerViewController: UIPickerViewDelegate {
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

        pickerView.isHidden = true
    }
}

// MARK: UITextFieldDelegate
extension PlayerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard
            let number = number.text, !number.isEmpty,
            let age = age.text, !age.isEmpty,
            let fullName = fullName.text, !fullName.isEmpty,
            let nationality = nationality.text, !nationality.isEmpty
            else {
                disableSaveButton()
                return }

        enableSaveButton()
    }
}
