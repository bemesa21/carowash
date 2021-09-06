//
//  HomeViewController.swift
//  carowash
//
//  Created by Berenice Medel on 21/08/21.
//

import Foundation

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set-Up instances of vc & assign them.
        let hvc = HomeViewController()
        let cvc = CarViewController()
        let pvc = ProfileViewController()

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
