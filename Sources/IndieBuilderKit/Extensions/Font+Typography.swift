//
//  Font+Typography.swift
//  IndieBuilderKit
//
//  Custom font registration and typography system
//

import Foundation
import SwiftUI
import UIKit

// MARK: - Typography Extensions

public extension Font {
    /// Roboto Medium font with specified size, falls back to system medium
    static func medium(_ size: CGFloat) -> Font {
        if FontUtility.isFontAvailable("Roboto-Medium") {
            return Font.custom("Roboto-Medium", size: size)
        } else {
            return Font.system(size: size, weight: .medium)
        }
    }
    
    /// Roboto Regular font with specified size, falls back to system regular
    static func regular(_ size: CGFloat) -> Font {
        if FontUtility.isFontAvailable("Roboto-Regular") {
            return Font.custom("Roboto-Regular", size: size)
        } else {
            return Font.system(size: size, weight: .regular)
        }
    }
    
    /// Roboto Light font with specified size, falls back to system light
    static func light(_ size: CGFloat) -> Font {
        if FontUtility.isFontAvailable("Roboto-Light") {
            return Font.custom("Roboto-Light", size: size)
        } else {
            return Font.system(size: size, weight: .light)
        }
    }
    
    /// Roboto Bold font with specified size, falls back to system bold
    static func bold(_ size: CGFloat) -> Font {
        if FontUtility.isFontAvailable("Roboto-Bold") {
            return Font.custom("Roboto-Bold", size: size)
        } else {
            return Font.system(size: size, weight: .bold)
        }
    }
    
    /// Roboto Italic font with specified size, falls back to system with italic design
    static func italic(_ size: CGFloat) -> Font {
        if FontUtility.isFontAvailable("Roboto-Italic") {
            return Font.custom("Roboto-Italic", size: size)
        } else {
            return Font.system(size: size).italic()
        }
    }
}

// MARK: - Font Utility

struct FontUtility {
    /// Check if a custom font is available in the system
    static func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 12) != nil
    }
}

// MARK: - Font Registration

extension Font {
    /// Registers custom Roboto fonts from the bundle with error handling
    static func registerFonts() {
        let customFonts = [
            "Roboto-Bold",
            "Roboto-Italic", 
            "Roboto-Light",
            "Roboto-Medium",
            "Roboto-Regular"
        ]
        
        var registeredFonts = 0
        
        customFonts.forEach { fontName in
            if let fontURL = Bundle.module.url(forResource: fontName, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
                
                if success {
                    registeredFonts += 1
                } else {
                    print("⚠️ IndieBuilderKit: Failed to register font \(fontName)")
                    if let error = error?.takeRetainedValue() {
                        print("   Error: \(CFErrorCopyDescription(error))")
                    }
                }
            } else {
                print("⚠️ IndieBuilderKit: Font file not found: \(fontName).ttf")
            }
        }
        
        if registeredFonts == customFonts.count {
            print("✅ IndieBuilderKit: All custom fonts registered successfully (\(registeredFonts)/\(customFonts.count))")
        } else if registeredFonts > 0 {
            print("⚠️ IndieBuilderKit: Partial font registration (\(registeredFonts)/\(customFonts.count)) - fallback to system fonts enabled")
        } else {
            print("❌ IndieBuilderKit: No custom fonts registered - using system fonts only")
        }
    }
}