//
//  fields.swift
//  carowash
//
//  Created by Berenice Medel on 21/08/21.
//

import UIKit

extension UITextField {
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
    
    func applyStyle() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = UIColor.CarOWash.mistyRose
    }
}
