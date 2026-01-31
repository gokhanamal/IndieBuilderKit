//
//  ZeroValueRepresentable.swift
//  IndieBuilderKit
//
//  Created by Erkam Kucet on 27.08.2025.
//

import UIKit

public protocol ZeroValueRepresentable {

    static var zeroValue: Self { get }
}

extension Int: ZeroValueRepresentable {

    public static var zeroValue: Int { return 0 }
}

extension Decimal: ZeroValueRepresentable {

    public static var zeroValue: Decimal { return 0 }
}

extension UInt: ZeroValueRepresentable {

    public static var zeroValue: UInt { return 0 }
}

extension Double: ZeroValueRepresentable {

    public static var zeroValue: Double { return 0.0 }
}

extension Float: ZeroValueRepresentable {

    public static var zeroValue: Float { return 0.0 }
}

extension CGFloat: ZeroValueRepresentable {

    public static var zeroValue: CGFloat { return 0.0 }
}

extension CGRect: ZeroValueRepresentable {
    public static var zeroValue: CGRect { return .zero }
}

extension UIEdgeInsets: ZeroValueRepresentable {
    public static var zeroValue: UIEdgeInsets { return .zero }
}

extension String: ZeroValueRepresentable {
    public static var zeroValue: String { return "0" }
}

