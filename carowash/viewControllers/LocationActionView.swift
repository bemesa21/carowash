//
//  LocationActionView.swift
//  carowash
//
//  Created by Orlando Ortega on 24/09/21.
//

import UIKit
import MapKit

protocol LocationActionViewDelegate: class {
    func confirmLocation(_ view: LocationActionView)
}

class LocationActionView: UIView {

    // MARK: - Properties

    var placemark: MKPlacemark? {
        didSet {
            titleLabel.text = placemark?.name
            addressLabel.text = placemark?.address
        }
    }

    weak var delegate: LocationActionViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black

        let image = UIImage(systemName: "mappin")
        let imageView = UIImageView(image: image)

        view.addSubview(imageView)
        imageView.centerX(inView: view)
        imageView.centerY(inView: view)

        return view
    }()

    private let pickupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Confirm Location"
        label.textAlignment = .center
        return label
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(confirmButtonPressed),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - SetUp

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        addShadow()

        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually

        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, paddingTop: 12)

        addSubview(infoView)
        infoView.centerX(inView: self)
        infoView.anchor(top: stack.bottomAnchor, paddingTop: 16)
        infoView.setDimensions(height: 60, width: 60)
        infoView.layer.cornerRadius = 60 / 2

        addSubview(pickupLabel)
        pickupLabel.anchor(top: infoView.bottomAnchor, paddingTop: 8)
        pickupLabel.centerX(inView: self)

        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: pickupLabel.bottomAnchor, left: leftAnchor,
                             right: rightAnchor, paddingTop: 4, height: 0.75)

        addSubview(confirmButton)
        confirmButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor,
                             right: rightAnchor, paddingLeft: 12,
                             paddingBottom: 24, paddingRight: 12, height: 50)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors
    @objc func confirmButtonPressed() {
        delegate?.confirmLocation(self)
    }
}
