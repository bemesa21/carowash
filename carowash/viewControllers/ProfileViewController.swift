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

class ProfileViewController: UITableViewController {
    var image: UIImage? = nil
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImagePicker()
        setupAvatar()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }

    func configureImagePicker(){
        profileImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profileImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    
    func setupAvatar(){
        self.profileImage.layer.cornerRadius = 40
        self.profileImage.clipsToBounds = true
        
        Api.User.downloadProfilePhoto { (data) in
            self.profileImage.image = UIImage(data: data)
        } onError: { (error) in
            print(error)
        }
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.image = imageSelected
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.image = imageOriginal
        }
        
        self.uploadPhoto()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadPhoto() {
        ProgressHUD.show()

        let defaults = UserDefaults.standard
        if let currentUser = defaults.dictionary(forKey: "currentUser"){
            guard let imageData = self.image?.jpegData(compressionQuality: 0.4) else{ return}
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            let currentUserUid = currentUser["uid"] as! String

            StorageService.savePhoto(uid: currentUserUid , data: imageData, metadata: metadata) {
                self.profileImage.image = self.image
                ProgressHUD.dismiss()
            } onError: { (errorMessage) in
                ProgressHUD.showError(errorMessage)
            }

        }
    }
}
