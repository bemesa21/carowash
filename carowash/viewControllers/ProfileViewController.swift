//
//  ProfileViewController.swift
//  carowash
//
//  Created by Berenice Medel on 19/09/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import ProgressHUD

class ProfileViewController: UITableViewController, DisplayViewControllerDelegate {
    var userFields: [UserField] = [
        UserField(field: "name", oldValue: "", newValue: "", optionLabel: "Name", uid: ""),
        UserField(field: "email", oldValue: "", newValue: "", optionLabel: "Email", uid: ""),
        UserField(field: "phone", oldValue: "", newValue: "", optionLabel: "Phone", uid: "")
    ]

    var image: UIImage?
    var currentUser: User?
    var selectedRow: IndexPath?

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        self.configureImagePicker()
        self.setupAvatarImage()
        self.title = "Update Profile"
    }

    override func viewWillAppear(_ animated: Bool) {
        setupUserProfile()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userFields.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editableCell",
                                                 for: indexPath) as? EditableOptsTableViewCell

        let field = self.userFields[indexPath.row].optionLabel
        let fieldValue = self.userFields[indexPath.row].oldValue
        cell!.fieldLabel.text = field
        cell!.valueLabel.text = fieldValue
        return cell!
    }

    func configureImagePicker() {
        profileImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profileImage.addGestureRecognizer(tapGesture)
        cameraImage.addGestureRecognizer(tapGesture)
    }

    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    func setupAvatarImage() {
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.layer.cornerRadius = 40
        self.profileImage.clipsToBounds = true
    }

    func downloadAvatar() {
        Api.User.downloadProfilePhoto(imageUrl: self.currentUser!.profileImageUrl) { (data) in
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data)
            }
        } onError: { (error) in
            print(error)
        }
    }

    func setupUserProfile() {
        let defaults = UserDefaults.standard
        let currentUserId = defaults.string(forKey: "currentUser")
        Api.User.getUser(userId: currentUserId!) { (user) in
            self.currentUser = user
            self.downloadAvatar()
            self.setupuserFields()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } onError: { (error) in
            print(error)
        }
    }

    func setupuserFields() {
        self.userFields[0].oldValue = currentUser!.name
        self.userFields[0].uid = currentUser!.uid
        self.userFields[1].oldValue = currentUser!.email
        self.userFields[1].uid = currentUser!.uid
        self.userFields[2].oldValue = currentUser!.phone
        self.userFields[2].uid = currentUser!.uid

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath
        performSegue(withIdentifier: "editSegue",
                     sender: tableView.cellForRow(at: indexPath) )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editViewController = segue.destination as? EditViewController
        editViewController!.delegate = self
        editViewController!.userField = self.userFields[self.selectedRow!.row]
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.image = imageSelected
        }

        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = imageOriginal
        }

        self.uploadPhoto()
        picker.dismiss(animated: true, completion: nil)
    }

    func uploadPhoto() {
        ProgressHUD.show()
        if self.currentUser != nil {
            guard let imageData = self.image?.jpegData(compressionQuality: 0.4) else { return}
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"

            StorageService.savePhoto(uid: self.currentUser!.uid, data: imageData, metadata: metadata) {
                self.profileImage.image = self.image
                ProgressHUD.dismiss()
            } onError: { (errorMessage) in
                ProgressHUD.showError(errorMessage)
            }

        }
    }

    func updateValue(data: String) {
        self.userFields[self.selectedRow!.row].oldValue = data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

protocol DisplayViewControllerDelegate: NSObjectProtocol {
    func updateValue(data: String)
}

struct UserField {
    let field: String
    var oldValue: String
    var newValue: String
    let optionLabel: String
    var uid: String
}
