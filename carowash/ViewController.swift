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
            emailTextField.tintColor = rgbColor(red: 0, green: 175, blue: 255)
            emailTextField.setIcon(UIImage(named: "icon-email")!)
        }
     }

    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.tintColor = rgbColor(red: 0, green: 175, blue: 255)
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
        cgColorForRed(red: 33, green: 118, blue: 174),
       cgColorForRed(red: 113, green: 238, blue: 200)
      ]

       gradientLayer.startPoint = CGPoint(x: 0, y: 0)
       gradientLayer.endPoint = CGPoint(x: 0, y: 1)

        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat) -> AnyObject {
       return rgbColor(red: red, green: green, blue: blue).cgColor as AnyObject
    }

    func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }

    func setupTextFields() {
        let backgroundColor = rgbColor(red: 254, green: 233, blue: 225)

        emailTextField.layer.cornerRadius = 10
        emailTextField.clipsToBounds = true
        emailTextField.backgroundColor = backgroundColor

        passwordTextField.layer.cornerRadius = 10
        passwordTextField.clipsToBounds = true
        passwordTextField.backgroundColor = backgroundColor

    }

    func setupLabels() {
        let fontColor = rgbColor(red: 254, green: 233, blue: 225)
        emailLabel.textColor = fontColor
        passwordLabel.textColor = fontColor
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
