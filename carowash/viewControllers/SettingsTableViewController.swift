//
//  SettingsTableViewController.swift
//  carowash
//
//  Created by Berenice Medel on 06/09/21.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    let settingOptions: [SettingsOption] = [
        SettingsOption(name: "My Profile", segueName: "EditProfile", iconName: "icon-profile"),
        SettingsOption(name: "Payment", segueName: "", iconName: "credit-card-icon"),
        SettingsOption(name: "Help", segueName: "", iconName: "help-icon"),
        SettingsOption(name: "Log out", segueName: "logoutTapped", iconName: "icon-logout")
    ]

    var currentUser: User?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.viewWithTag(10)?.backgroundColor = UIColor.CarOWash.blueNeon
        tableView.rowHeight = 80
        self.setupAvatarImage()
        self.setupLabels()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setupCurrentUser()
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.settingOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell", for: indexPath) as? IconTableViewCell

        let labelText = self.settingOptions[indexPath.row].name
        let imageIcon = self.settingOptions[indexPath.row].iconName
        cell!.optionLabel.text = labelText

        cell?.iconImage.image = UIImage(named: imageIcon)!

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.settingOptions[indexPath.row].name == "Log out"{
            let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginPage = loginStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as?
                LoginViewController
            loginPage!.modalPresentationStyle = .fullScreen
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "currentUser")
            self.present(loginPage!, animated: true, completion: nil)
        } else if self.settingOptions[indexPath.row].segueName != ""{
            performSegue(withIdentifier: self.settingOptions[indexPath.row].segueName,
                         sender: tableView.cellForRow(at: indexPath) )
        } else {
            print("in development")
        }
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

    func setupCurrentUser() {
        let defaults = UserDefaults.standard
        let currentUserId = defaults.string(forKey: "currentUser")
        Api.User.getUser(userId: currentUserId!) { (user) in
            self.currentUser = user
            DispatchQueue.main.async {
                self.nameLabel.text = user.name
            }
            self.downloadAvatar()
        } onError: { (error) in
            print(error)
        }
    }

    func setupLabels() {
        self.nameLabel.setTextColor()
    }

    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }

}

struct SettingsOption {
    let name: String
    let segueName: String
    let iconName: String
}
