//
//  RatingConfiguration.swift
//  IndieBuilderKit
//
//  Configuration for customizing rating request flow
//

import SwiftUI

// MARK: - Rating Configuration

public struct RatingConfiguration {
    public let title: String
    public let subtitle: String
    public let iconName: String
    public let iconColors: [Color]
    public let benefits: [RatingBenefit]
    public let primaryButtonTitle: String
    public let secondaryButtonTitle: String
    
    public init(
        title: String = "Enjoying the App?",
        subtitle: String = "Your feedback means the world to us! Help other users discover this app by leaving a review on the App Store.",
        iconName: String = "star.fill",
        iconColors: [Color] = [.yellow, .orange],
        benefits: [RatingBenefit] = RatingBenefit.defaultBenefits,
        primaryButtonTitle: String = "Rate on App Store",
        secondaryButtonTitle: String = "Maybe Later"
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.iconColors = iconColors
        self.benefits = benefits
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}

// MARK: - Rating Benefit

public struct RatingBenefit {
    public let icon: String
    public let title: String
    public let description: String
    
    public init(icon: String, title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }
}

// MARK: - Default Benefits

public extension RatingBenefit {
    static let defaultBenefits: [RatingBenefit] = [
        RatingBenefit(
            icon: "heart.fill",
            title: "Show Your Support",
            description: "Help other users discover this app with your honest review"
        ),
        RatingBenefit(
            icon: "sparkles",
            title: "Share Your Experience",
            description: "Let the developer know what you love about the app"
        ),
        RatingBenefit(
            icon: "megaphone.fill",
            title: "Help Us Improve",
            description: "Your feedback helps us make the app even better"
        )
    ]
}

// MARK: - Predefined Configurations

public extension RatingConfiguration {
    /// Default rating configuration
    static func `default`() -> RatingConfiguration {
        return RatingConfiguration()
    }
    
    /// Minimal configuration with fewer benefits
    static func minimal() -> RatingConfiguration {
        return RatingConfiguration(
            title: "Rate This App",
            subtitle: "Help us improve by sharing your feedback.",
            benefits: [
                RatingBenefit(
                    icon: "star.fill",
                    title: "Quick Review",
                    description: "Share your experience in just a few taps"
                )
            ]
        )
    }
    
    /// Custom configuration
    static func custom(
        title: String,
        subtitle: String,
        iconName: String = "star.fill",
        iconColors: [Color] = [.yellow, .orange],
        benefits: [RatingBenefit],
        primaryButtonTitle: String = "Rate on App Store",
        secondaryButtonTitle: String = "Maybe Later"
    ) -> RatingConfiguration {
        return RatingConfiguration(
            title: title,
            subtitle: subtitle,
            iconName: iconName,
            iconColors: iconColors,
            benefits: benefits,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle
        )
    }
}