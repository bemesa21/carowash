//
//  HomeViewController.swift
//  carowash
//
//  Created by Orlando Ortega on 05/09/21.
//

import UIKit
import MapKit

private let reuseIdentifier = "ComboCell"

class HomeViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView()

    var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()

    let mapButton: UIButton = {
        let mapImage = UIImage(systemName: "mappin.circle.fill")
        mapImage?.withTintColor(UIColor.black)

        let button = UIButton(type: .system)
        button.setImage(mapImage, for: .normal)
        button.colorful()
        button.addTarget(self, action: #selector(showNextView), for: .touchUpInside)

        return button
    }()

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        view.backgroundColor = UIColor.CarOWash.babyBlue
        setUpMapButton()
    }

    func setUpMapButton() {
        view.addSubview(mapButton)
        mapButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         paddingTop: 16, paddingLeft: 20, width: 50, height: 30)

        view.addSubview(addressLabel)
        addressLabel.centerY(inView: mapButton)
        addressLabel.centerX(inView: view)
        addressLabel.anchor(left: mapButton.rightAnchor, paddingLeft: 10)
    }

    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(ComboCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()

//        let height = view.frame.height - locationInputViewHeight
//        tableView.frame = CGRect(x: 0, y: view.frame.height,
//                                 width: view.frame.width, height: height)

        view.addSubview(tableView)
    }

    // MARK: - Selectors

    @objc func showNextView() {
        let mlvc = MyLocationViewController()
        mlvc.modalPresentationStyle = .fullScreen
        present(mlvc, animated: true, completion: nil)
    }
}

// MARK: - TableView[Delegate/DataSource]

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ComboCell
        return cell!
    }
}

// MARK: - TabBarDelegate

extension HomeViewController: TabBarDelegate {
    func displayAddressLabel(dir: String) {
        addressLabel.text = dir
    }
}
