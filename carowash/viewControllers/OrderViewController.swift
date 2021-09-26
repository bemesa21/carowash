//
//  OrderViewController.swift
//  carowash
//
//  Created by Orlando Ortega on 25/09/21.
//

import UIKit

class OrderViewController: UIViewController {

    // MARK: - Properties
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()

    private let confirmOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Confirm Order", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(confirmOrderButtonPressed),
                         for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
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

        view.addSubview(titleLabel)
        titleLabel.anchor(top: backButton.bottomAnchor, left: view.leftAnchor,
                          paddingTop: 8, paddingLeft: 14)

        let stack = UIStackView(arrangedSubviews: [descriptionLabel, priceLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(top: titleLabel.bottomAnchor, paddingTop: 12)

        view.addSubview(confirmOrderButton)
        confirmOrderButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  right: view.rightAnchor, paddingLeft: 12,
                                  paddingBottom: 24, paddingRight: 12, height: 50)
    }

    func createCalendar() {

    }

    // MARK: - Selectors
    @objc func confirmOrderButtonPressed() {
        print("presed")
        print("presed")
        let dict: [String: String] = [
                            "service": "servicio1",
                            "date": "10/10/2021",
                            "cost": "",
                            "status": "pending",
                            "userId": "1",
                            "address": "here en mi casa"
                        ]
        Api.Order.create(dict: dict, onSuccess: {
            print("yei")
        }, onError: { (error) in
            print(error)
        })

    }

    @objc func handleBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OrderViewController: HomeViewControllerDelegate {
    func sendDataToOrderView(title: String, desc: String, price: String) {
        print("DATA: \(title), \(desc), \(price)")
        titleLabel.text = title
        descriptionLabel.text = desc
        priceLabel.text = "MX$\(price)"
    }
}
