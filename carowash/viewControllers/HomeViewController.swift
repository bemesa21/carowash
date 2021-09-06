//
//  HomeViewController.swift
//  carowash
//
//  Created by Orlando Ortega on 05/09/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        view.addSubview(mapButton)
        setUpMapButton()
    }

    let mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.CarOWash.cerise
        button.setTitle("Map View", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(showNextView), for: .touchUpInside)

        return button
    }()

    func setUpMapButton() {
        mapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
    }

    @objc func showNextView() {
        let mlvc = MyLocationViewController()
        mlvc.modalPresentationStyle = .fullScreen
        present(mlvc, animated: true, completion: nil)
    }
}
