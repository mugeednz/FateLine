//
//  UIFont+Ext.swift
//  fateline
//
//  Created by Müge Deniz on 8.10.2025.
//

import Foundation
import UIKit

extension UIFont {
    // SF Pro Display Font Ailesi
    static func QuintessentialRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Quintessential-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
