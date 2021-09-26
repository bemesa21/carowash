//
//  WelcomeViewController.swift
//  carowash
//
//  Created by Berenice Medel on 30/08/21.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayer()
        self.startButton.simple()
        self.logoImage.tintColor =  UIColor.CarOWash.mistyRose
        self.nameLabel.setTextColor()
    }

    @IBAction func welcomeBack(_ sender: Any) {
        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginPage = loginStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as?
            LoginViewController
        loginPage!.modalPresentationStyle = .fullScreen
        self.present(loginPage!, animated: true, completion: nil)

    }

    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard

        if defaults.string(forKey: "currentUser") != nil {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController")
                as? TabBarViewController
            homePage!.modalPresentationStyle = .fullScreen
            self.present(homePage!, animated: true, completion: nil)
        }

    }

    func setUpLayer() {

       let gradientLayer = CAGradientLayer()
       gradientLayer.frame = view.bounds

       gradientLayer.colors = [
        UIColor.CarOWash.starComandBlue.cgColor,
        UIColor.CarOWash.aquamarine.cgColor
      ]

       gradientLayer.startPoint = CGPoint(x: 0, y: 0)
       gradientLayer.endPoint = CGPoint(x: 0, y: 1)

        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
