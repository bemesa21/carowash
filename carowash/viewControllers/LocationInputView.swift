//
//  LocationInputView.swift
//  carowash
//
//  Created by Orlando Ortega on 18/09/21.
//

import UIKit

protocol LocationInputViewDelegate: class {
    func dismissLocationInputView()
    func executeSearch(query: String)
}

class LocationInputView: UIView {

    weak var delegate: LocationInputViewDelegate?

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()

    private lazy var locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ingresa tu dirección"
        textField.applyStyle()
        textField.setIcon(UIImage(systemName: "location.viewfinder")!)
        textField.returnKeyType = .search
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.delegate = self
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addShadow()
        backgroundColor = .white

        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44,
                          paddingLeft: 12, width: 24, height: 25)

        addSubview(locationTextField)
        locationTextField.anchor(top: backButton.bottomAnchor, left: leftAnchor,
                                 right: rightAnchor, paddingTop: 20, paddingLeft: 40,
                                 paddingRight: 40, height: 40)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleBackTapped() {
        delegate?.dismissLocationInputView()
    }
}

extension LocationInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else { return false }
        delegate?.executeSearch(query: query)
        return true
    }
}
