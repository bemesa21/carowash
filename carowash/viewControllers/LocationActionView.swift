//
//  LocationActionView.swift
//  carowash
//
//  Created by Orlando Ortega on 24/09/21.
//

import UIKit

class LocationActionView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test"
        label.textAlignment = .center
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Test"
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
