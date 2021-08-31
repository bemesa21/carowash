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

    @IBAction func signUp(_ sender: Any) {
        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let signupPage = loginStoryBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        signupPage.modalPresentationStyle = .fullScreen
        self.present(signupPage, animated: true, completion: nil)
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
        emailTextField.applyStyle()
        passwordTextField.applyStyle()
    }

    func setupLabels() {
        emailLabel.setTextColor()
        passwordLabel.setTextColor()
        tittleLabel.setTextColor()
    }

    func setupButtons() {
        signInButton.colorful()
        forgotPasswordButton.simple()
        signupButton.simple()

    }
}
