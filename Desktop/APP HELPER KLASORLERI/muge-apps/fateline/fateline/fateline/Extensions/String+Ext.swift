//
//  String+Ext.swift
//  fateline
//
//  Created by Müge Deniz on 17.10.2025.
//

import Foundation

extension String {
    var translate: String {
        return NSLocalizedString(self, comment: "")
    }
}
