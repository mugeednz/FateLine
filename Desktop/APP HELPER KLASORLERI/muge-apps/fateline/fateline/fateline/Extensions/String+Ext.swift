//
//  String+Ext.swift
//  fateline
//
//  Created by Müge Deniz on 8.10.2025.
//

import Foundation
import UIKit
import Localize_Swift

extension String {
    
    func translate() -> String {
        return self.localized(using: "Localizable")
    }
    func translate(with arguments: CVarArg...) -> String {
        let localizedString = self.localized(using: "Localizable")
        return String(format: localizedString, arguments: arguments)
    }
}
