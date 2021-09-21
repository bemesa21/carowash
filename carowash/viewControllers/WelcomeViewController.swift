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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        if defaults.dictionary(forKey: "currentUser") != nil
        {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController")
                as? TabBarViewController
            homePage!.modalPresentationStyle = .fullScreen
            self.present(homePage!, animated: true, completion: nil)
        }

    }

}
