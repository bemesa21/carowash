//
//  OrderViewController.swift
//  carowash
//
//  Created by Orlando Ortega on 25/09/21.
//

import UIKit
import FSCalendar

class OrderViewController: UIViewController {

    // MARK: - Properties
    var formatter = DateFormatter()
    private var arrString = [String]()
    var calendar: FSCalendar = {
        var cal = FSCalendar()
        cal.backgroundColor = UIColor.CarOWash.unbleachedSilk
        return cal
    }()

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

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()

    private let hourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
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
        view.backgroundColor = UIColor.CarOWash.mistyRose

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
        configureCalendar()
        view.addSubview(calendar)

        view.addSubview(dateLabel)
        dateLabel.centerX(inView: view)
        dateLabel.anchor(top: calendar.bottomAnchor, paddingTop: 10, paddingLeft: 12)

        view.addSubview(hourLabel)
        hourLabel.centerX(inView: view)
        hourLabel.anchor(top: dateLabel.bottomAnchor, paddingTop: 10)
    }

    func configureCalendar() {
        calendar = FSCalendar(frame: CGRect(x: 0, y: 180,
                                            width: view.frame.size.width, height: 300))
        calendar.scrollDirection = .horizontal
        calendar.delegate = self
        calendar.dataSource = self
    }

    func showConfirmationServiceAccepted() {
        let alert = UIAlertController(title: "Your CarOWash has been accepted!",
                                      message: "Your washer will be with you at any moment",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Selectors
    @objc func confirmOrderButtonPressed() {
        let dict: [String: String] = [
                            "service": arrString[0],
                            "date": arrString[4],
                            "cost": arrString[2],
                            "status": "pending",
                            "userId": "1",
                            "address": arrString[3],
                            "time": arrString[5],
                            "type": arrString[1]
                        ]
        Api.Order.create(dict: dict, onSuccess: {
            self.showConfirmationServiceAccepted()
        }, onError: { (error) in
            print(error)
        })
    }

    @objc func handleBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - HomeViewControllerDelegate
extension OrderViewController: HomeViewControllerDelegate {
    func sendDataToOrderView(title: String, desc: String, price: String, address: String) {
        arrString.append(title)
        arrString.append(desc)
        arrString.append(price)
        arrString.append(address)
        titleLabel.text = title
        descriptionLabel.text = desc
        priceLabel.text = "MXN \(price)"
    }
}
// MARK: - FSCalendarDelegate
extension OrderViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MM-yyyy"
        let fecha = formatter.string(from: date)
        arrString.append(fecha)
        dateLabel.text = formatter.string(from: date)
        getHour()
    }

    private func getHour() {
        let hourDate = Date()
        let cal = Calendar.current
        let hour = cal.component(.hour, from: hourDate)
        let minute = cal.component(.minute, from: hourDate)
        let second = cal.component(.second, from: hourDate)
        let time = "\(hour):\(minute):\(second)"
        arrString.append(time)
        hourLabel.text = "\(hour):\(minute):\(second)"
    }
}
// MARK: - FSCalendarDataSource
extension OrderViewController: FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
