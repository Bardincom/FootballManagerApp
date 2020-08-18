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

    let coreDataManager = CoreDataManager.shared
    private let imagePickerController = UIImagePickerController()
    private var isTeamSelect: Bool = true
    private var selectTeam: String?
    private var selectPosition: String?
    private var chosenImage = #imageLiteral(resourceName: "defaultImage")

    private enum CountItem {
        static let team = Picker.teams.count
        static let position = Picker.positions.count
    }

    lazy var rootViewController = SceneDelegate.shared.rootViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }

    @IBAction func uploadImage(_ sender: UIButton) {
        showImagePickerController()
    }

    @IBAction func pressToSelectTeam(_ sender: UIButton) {
        isTeamSelect = true
        pickerView.isHidden = false
        showPickerView()
    }

    @IBAction func pressToSelectPosition(_ sender: UIButton) {
        isTeamSelect = false
        pickerView.isHidden = false
        showPickerView()
    }

    @IBAction func savePlayer(_ sender: UIButton) {
        let context = coreDataManager.getContext()
        let image = coreDataManager.createObject(from: Image.self)
        image.image = chosenImage.pngData()

        let team = coreDataManager.createObject(from: Club.self)
        team.name = selectTeam

        let player = coreDataManager.createObject(from: Player.self)
        player.fullName = fullName.text
        player.nationality = nationality.text
        player.age = (age.text! as NSString).doubleValue
        player.number = (number.text! as NSString).doubleValue
        player.image = image
        player.club = team
        player.position = selectPosition

        //        player. = foto.image

        coreDataManager.save(context: context)
        rootViewController.switchToMainViewController()
        print("savePlayer")
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

    func setupUI() {
        pickerView.isHidden = true
        saveButton.layer.cornerRadius = 5
        uploadImageButton.tintColor = Color.gold
        teamButton.tintColor = Color.gold
        positionButton.tintColor = Color.gold
    }
}

//MARK: ImagePicker
extension PlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {

        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .savedPhotosAlbum
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let editingImage = info[.editedImage] as? UIImage else { return }
        chosenImage = editingImage
        foto.image = chosenImage


        dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController: UIPickerViewDataSource {
    func showPickerView() {
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
