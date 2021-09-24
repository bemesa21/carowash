//
//  ComboCell.swift
//  carowash
//
//  Created by Orlando Ortega on 24/09/21.
//

import UIKit

class ComboCell: UITableViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
}
