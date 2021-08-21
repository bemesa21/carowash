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
    @IBOutlet weak var tittleLabel: UILabel!

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

    @IBOutlet weak var signInButton: UIButton!

    @IBOutlet weak var forgotPasswordButton: UIButton!

    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayer()
        setupTextFields()
        setupLabels()
        setupButtons()
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
        tittleLabel.textColor = UIColor.CarOWash.mistyRose
    }

    func setupButtons() {
        signInButton.backgroundColor = UIColor.CarOWash.unbleachedSilk
        signInButton.layer.cornerRadius = 10
        signInButton.clipsToBounds = true
        signInButton.setTitleColor(UIColor.CarOWash.starComandBlue, for: .normal)

        forgotPasswordButton.backgroundColor = nil
        forgotPasswordButton.setTitleColor(UIColor.CarOWash.mistyRose, for: .normal)

        signupButton.backgroundColor = nil
        signupButton.setTitleColor(UIColor.CarOWash.mistyRose, for: .normal)

    }
}

