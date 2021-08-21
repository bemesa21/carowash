//
//  ViewController.swift
//  carowash
//
//  Created by Berenice Medel on 19/08/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!

    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.tintColor = UIColor.CarOWash.blueNeon
            emailTextField.setIcon(UIImage(named: "icon-email")!)
        }
     }

    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.tintColor = UIColor.CarOWash.blueNeon
            passwordTextField.setIcon(UIImage(named: "icon-password")!)
        }
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayer()
        setupTextFields()
        setupLabels()
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

    func setupTextFields() {
        emailTextField.layer.cornerRadius = 10
        emailTextField.clipsToBounds = true
        emailTextField.backgroundColor = UIColor.CarOWash.mistyRose

        passwordTextField.layer.cornerRadius = 10
        passwordTextField.clipsToBounds = true
        passwordTextField.backgroundColor = UIColor.CarOWash.mistyRose

    }

    func setupLabels() {
        emailLabel.textColor = UIColor.CarOWash.mistyRose
        passwordLabel.textColor = UIColor.CarOWash.mistyRose
    }
}
extension UITextField {
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
}
