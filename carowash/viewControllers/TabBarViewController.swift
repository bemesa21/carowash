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

        hvc.title = "Home"
        cvc.title = "Cars"
        pvc.title = "Profile"

        self.setViewControllers([hvc, cvc, pvc], animated: false)

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
