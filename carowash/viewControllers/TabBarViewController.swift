//
//  HomeViewController.swift
//  carowash
//
//  Created by Berenice Medel on 21/08/21.
//

import Foundation

import UIKit

protocol TabBarDelegate: class {
    func displayAddressLabel(dir: String)
}

class TabBarViewController: UITabBarController {

    // MARK: - Properties
    weak var delegateLbl: TabBarDelegate?
    let hvc = HomeViewController()
    let cvc = CarViewController()
    let pvc = ProfileViewController()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

                
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController = mainStoryBoard.instantiateViewController(withIdentifier: "SettingsNavigationViewController") as! UINavigationController
        settingsController.title = "Account"
        /*settingsController.navigationBar.barTintColor = UIColor.CarOWash.blueNeon
        
        settingsController.navigationBar.backgroundColor = UIColor.CarOWash.blueNeon*/
        
	hvc.title = "Home"
        cvc.title = "Cars"

        self.setViewControllers([hvc, cvc, settingsController], animated: false)

        guard let items = self.tabBar.items else { return }
        let images = ["house.fill", "car.2.fill", "person.crop.circle.fill"]
        for item in 0...2 {
            items[item].image = UIImage(systemName: images[item])
        }
    }
}

extension TabBarViewController: MyLocationViewControllerDelegate {
    func passLabel(label: String) {
        self.hvc.displayAddressLabel(dir: label)
    }
}
