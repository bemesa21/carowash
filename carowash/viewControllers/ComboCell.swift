//
//  ComboCell.swift
//  carowash
//
//  Created by Orlando Ortega on 24/09/21.
//

import UIKit

class ComboCell: UITableViewCell {

    // MARK: - Properties    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.setTextColor()
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.CarOWash.cerise
        return label
    }()

    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.CarOWash.starComandBlue
        return label
    }()

    let imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()

    var stack = UIStackView()

    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configureUI() {
        stack = UIStackView(arrangedSubviews: [titleLabel, descLabel, costLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        let header = UIView(frame: CGRect(x: 0, y: 0,
                                          width: contentView.frame.width + 200,
                                          height: 80))
        header.backgroundColor = UIColor.CarOWash.blueNeon
        contentView.addSubview(header)
        contentView.addSubview(stack)
        contentView.addSubview(imgView)
    }

    func configureCell(titleText: String, descText: String, cost: String,
                       imageName: String) {
        titleLabel.text = titleText
        descLabel.text = descText
        costLabel.text = cost
        imgView.image = UIImage(named: imageName)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        descLabel.text = nil
        costLabel.text = nil
        imgView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let imageSize = contentView.frame.size.width / 3

        stack.frame = CGRect(x: 10, y: 5, width: contentView.frame.size.width - imageSize,
                             height: contentView.frame.size.height)

        imgView.frame = CGRect(x: contentView.frame.width - imageSize,
                               y: 70, width: imageSize, height: imageSize)
    }
}
