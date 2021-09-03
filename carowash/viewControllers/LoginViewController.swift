//
//  ViewController.swift
//  carowash
//
//  Created by Berenice Medel on 19/08/21.
//

import UIKit
import ProgressHUD

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
        let signupPage = loginStoryBoard.instantiateViewController(withIdentifier: "SignUpViewController") as?
            SignUpViewController
        signupPage!.modalPresentationStyle = .fullScreen
        self.present(signupPage!, animated: true, completion: nil)
    }

    @IBAction func logInTapped(_ sender: Any) {
        if !self.validateFields() { return }
        self.logIn {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as?
                HomeViewController
            homePage!.modalPresentationStyle = .fullScreen
            self.present(homePage!, animated: true, completion: nil)
        } onError: { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }

    func logIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        ProgressHUD.show()
        Api.User.logIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!,
                        onSuccess: {
                            ProgressHUD.dismiss()
                            onSuccess()

                        },
                        onError: {(errorMessage) in  onError(errorMessage)})
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

    func validateFields() -> Bool {
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showError("Please enter a valid email")
            return false
        }

        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showError("Please enter you new password")
            return false
        }

        return true
    }
}
