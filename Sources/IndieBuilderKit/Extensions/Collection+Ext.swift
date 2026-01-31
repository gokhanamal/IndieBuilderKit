//
//  Collection+Ext.swift
//  IndieBuilderKit
//
//  Created by Erkam Kucet on 27.08.2025.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else {
            assertionFailure("Index out of range in safe subscript")
            return nil
        }
        return self[index]
    }
}
