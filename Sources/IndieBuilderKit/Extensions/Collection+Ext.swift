//
//  File.swift
//  IndieBuilderKit
//
//  Created by Erkam Kucet on 27.08.2025.
//

import Foundation

public extension Collection {
    subscript (safe index: Self.Index) -> Iterator.Element? {
        (startIndex ..< endIndex).contains(index) ? self[index] : nil
    }
}

public extension Collection {
    subscript(safeIndex index: Index) -> Element? {
        guard indices.contains(index) else {
            print("💣 Error: The index is out of the range.")
            return nil
        }
        return self[index]
    }
}
