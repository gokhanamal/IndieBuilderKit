//
//  EmptyValueRepresentable.swift
//  IndieBuilderKit
//
//  Created by Erkam Kucet on 27.08.2025.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol EmptyValueRepresentable {

    static var emptyValue: Self { get }
}

extension String: EmptyValueRepresentable {

    public static var emptyValue: String { return "" }
}

extension Array: EmptyValueRepresentable {

    public static var emptyValue: [Element] { return [] }
}

extension Set: EmptyValueRepresentable {

    public static var emptyValue: Set<Element> { return Set() }
}

extension Dictionary: EmptyValueRepresentable {

    public static var emptyValue: [Key: Value] { return [:] }
}

#if canImport(UIKit)
extension UIEdgeInsets: EmptyValueRepresentable {
    public static var emptyValue: UIEdgeInsets { return .zero }
}
#elseif canImport(AppKit)
extension NSEdgeInsets: EmptyValueRepresentable {
    public static var emptyValue: NSEdgeInsets { return NSEdgeInsetsZero }
}
#endif
