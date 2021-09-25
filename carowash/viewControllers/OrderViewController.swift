//
//  OrderViewController.swift
//  carowash
//
//  Created by Orlando Ortega on 25/09/21.
//

import UIKit

class OrderViewController: UIViewController {

    // MARK: - Properties
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()

    private let confirmOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(confirmOrderButtonPressed),
                         for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Configurations
    func configureUI() {
        view.backgroundColor = UIColor.CarOWash.babyBlue

        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 44,
                          paddingLeft: 12, width: 24, height: 25)

//        view.addSubview(titleLabel)
//        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 44,
//                           paddingLeft: 12, width: 24, height: 25)
    }

    // MARK: - Selectors
    @objc func confirmOrderButtonPressed() {

    }

    @objc func handleBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
