//
//  HomeViewController.swift
//  carowash
//
//  Created by Orlando Ortega on 05/09/21.
//

import UIKit
import MapKit

private let reuseIdentifier = "ComboCell"

protocol HomeViewControllerDelegate: class {
    func sendDataToOrderView(title: String, desc: String,
                             price: String, address: String)
}

class HomeViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView()
    private let val = CombosWash()
    private let iconArr = ["carIcon", "vanIcon", "bikeIcon"]
    private var valuesArray = [String]()
    private var priceArray = [String]()
    weak var delegate: HomeViewControllerDelegate?

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

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Configurations
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(ComboCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60

        let height = view.frame.height - 200
        tableView.frame = CGRect(x: 0, y: view.frame.height - 810,
                                 width: view.frame.width, height: height)

        view.addSubview(tableView)
    }

    func configureUI() {
        view.backgroundColor = UIColor.CarOWash.mistyRose
        setUpMapButton()
        setUpTableView()
        populateArrays()
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

    func populateArrays() {
        valuesArray = [val.comboAuto, val.comboVan, val.comboBike]
        priceArray = [val.priceComboAuto, val.priceComboVan, val.priceComboBike]
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
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ComboCell
        cell?.configureCell(titleText: valuesArray[indexPath.row],
                            descText: val.desc,
                            cost: priceArray[indexPath.row],
                            imageName: iconArr[indexPath.row])
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addressLabel.text != nil {
            let orderView = OrderViewController()
            orderView.modalPresentationStyle = .fullScreen
            orderView.sendDataToOrderView(title: valuesArray[indexPath.row],
                                          desc: val.desc, price: priceArray[indexPath.row],
                                          address: addressLabel.text!)
            self.present(orderView, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Did you selected your location?",
                                          message: "Please select your location before selecting a combo",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - TabBarDelegate
extension HomeViewController: TabBarDelegate {
    func displayAddressLabel(dir: String) {
        addressLabel.text = dir
    }
}
