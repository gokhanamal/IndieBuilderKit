import Foundation
import struct SwiftUI.Color

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        guard let rgbValue = UInt32(hex, radix: 16) else {
            self.init(.clear)
            return
        }
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Design System Colors

public extension Color {
    /// Primary brand color - used for main actions and branding
    static let primaryColor: Color = .blue
    
    /// Secondary color - used for supporting elements
    static let secondaryColor: Color = .gray
    
    /// Brand accent color - used for highlights and calls-to-action
    static let brandAccent: Color = .orange
    
    /// Background color - used for view backgrounds
    static let backgroundColor: Color = .clear
    
    /// Primary text color - used for main text content
    static let textColor: Color = .primary
    
    /// Secondary text color - used for supporting text
    static let secondaryTextColor: Color = .secondary
    
    /// Success color - used for positive states
    static let successColor: Color = .green
    
    /// Warning color - used for warning states
    static let warningColor: Color = .yellow
    
    /// Error color - used for error states
    static let errorColor: Color = .red
}
