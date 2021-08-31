//
//  SignUpViewController.swift
//  carowash
//
//  Created by Berenice Medel on 30/08/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayer()
        setupTextFields()
        setupLabels()
        setupButtons()
    }

    @IBAction func logIn(_ sender: Any) {
        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginPage = loginStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginPage.modalPresentationStyle = .fullScreen
        self.present(loginPage, animated: true, completion: nil)
    }

    @IBAction func signUp(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {
                (authDataResult, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let authData = authDataResult {
                    let dict: [String: Any] = [
                        "uid": authData.user.uid,
                        "email": authData.user.email,
                        "name": name,
                        "profileImageUrl": "",
                        "status": "enabled"
                    ]
                    Database.database().reference().child("users")
                        .child(authData.user.uid).updateChildValues(dict, withCompletionBlock: {
                            (error, _) in
                            if error == nil {
                                print("Done")
                            }
                        })
                }
            }
          } else {
            print("empty text fields")
            return
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

    func setupTextFields() {
        emailTextField.applyStyle()
        passwordTextField.applyStyle()
        nameTextField.applyStyle()
    }

    func setupLabels() {
        nameLabel.setTextColor()
        passwordLabel.setTextColor()
        emailLabel.setTextColor()
        tittleLabel.setTextColor()
    }

    func setupButtons() {
        signUpButton.colorful()
        loginButton.simple()
    }

}
