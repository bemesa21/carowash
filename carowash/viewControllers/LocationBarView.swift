//
//  LocationBarView.swift
//  carowash
//
//  Created by Orlando Ortega on 17/09/21.
//

import UIKit

protocol LocationBarViewDelegate: class {
    func presentBarView()
}

class LocationBarView: UIView {

    weak var delegate: LocationBarViewDelegate?

    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    let searchBarLabel: UILabel = {
        let label = UILabel()
        label.text = "Select your location... "
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        configureGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        backgroundColor = .white
        addShadow()

        addSubview(indicatorView)
        indicatorView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        indicatorView.setDimensions(height: 6, width: 6)

        addSubview(searchBarLabel)
        searchBarLabel.centerY(inView: self, leftAnchor: self.indicatorView.rightAnchor, paddingLeft: 20)
    }

    func configureGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShowLocationBar))
        addGestureRecognizer(tap)
    }

    @objc func handleShowLocationBar() {
        delegate?.presentBarView()
    }
}
