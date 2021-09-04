//
//  buttons.swift
//  carowash
//
//  Created by Berenice Medel on 30/08/21.
//

import UIKit

extension UIButton {
    func colorful() {
        self.backgroundColor = UIColor.CarOWash.unbleachedSilk
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.setTitleColor(UIColor.CarOWash.starComandBlue, for: .normal)
    }

    func simple() {
        self.backgroundColor = nil
        self.setTitleColor(UIColor.CarOWash.mistyRose, for: .normal)
    }

}
