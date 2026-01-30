//
//  Collection+Ext.swift
//  IndieBuilderKit
//
//  Created by Erkam Kucet on 27.08.2025.
//

import Foundation

public extension Collection {
    subscript(safeIndex index: Index) -> Element? {
        guard indices.contains(index) else {
            #if DEBUG
            print("💣 Error: The index is out of the range.")
            #endif
            return nil
        }
        return self[index]
    }
}
