import SwiftUI
import struct SwiftUI.Font

public struct IndieBuilderKit {
    private init() {}
    
    /// Register custom fonts bundled with IndieBuilderKit
    /// Fonts will automatically fallback to system fonts if registration fails
    public static func registerCustomFonts() {
        Font.registerFonts()
    }
}
