//
//  SettingsTableViewController.swift
//  carowash
//
//  Created by Berenice Medel on 06/09/21.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    let settingOptions: [SettingsOption] = [
        SettingsOption(name: "My Profile", segueName: "EditProfile", iconName: "icon-user"),
        SettingsOption(name: "LogOut", segueName: "logoutTapped", iconName: "icon-user")
    ]

    @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.viewWithTag(10)?.backgroundColor = UIColor.CarOWash.blueNeon
        tableView.rowHeight = 80
        setupAvatar()
    }

    // MARK: - Table view data source

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
        if self.settingOptions[indexPath.row].name == "LogOut"{
            let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginPage = loginStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as?
                LoginViewController
            loginPage!.modalPresentationStyle = .fullScreen
            self.present(loginPage!, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: self.settingOptions[indexPath.row].segueName,
                         sender: tableView.cellForRow(at: indexPath) )
        }
    }

    func setupAvatar() {
        self.profileImage.layer.cornerRadius = 40
        self.profileImage.clipsToBounds = true

        Api.User.downloadProfilePhoto { (data) in
            self.profileImage.image = UIImage(data: data)
        } onError: { (error) in
            print(error)
        }
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
