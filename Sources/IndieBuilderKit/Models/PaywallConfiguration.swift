import SwiftUI

public enum PaywallImage {
    case systemIcon(String)
    case bundleImage(String)
    case customImage(Image)
    
    /// Default diamond icon
    public static var `default`: PaywallImage {
        .systemIcon("diamond.fill")
    }
    
    /// Common system icons for paywalls
    public static var crown: PaywallImage { .systemIcon("crown.fill") }
    public static var star: PaywallImage { .systemIcon("star.fill") }
    public static var diamond: PaywallImage { .systemIcon("diamond.fill") }
    public static var sparkles: PaywallImage { .systemIcon("sparkles") }
    public static var gift: PaywallImage { .systemIcon("gift.fill") }
    public static var bolt: PaywallImage { .systemIcon("bolt.fill") }
    public static var heart: PaywallImage { .systemIcon("heart.fill") }
    public static var shield: PaywallImage { .systemIcon("shield.checkered") }
}

public struct PaywallFeature {
    public let iconName: String
    public let title: String
    
    public init(iconName: String, title: String) {
        self.iconName = iconName
        self.title = title
    }
}

public struct PaywallStrings {
    // Button texts
    public let processingText: String
    public let selectPlanText: String
    public let startFreeTrialText: String
    public let continueText: String
    public let okText: String
    
    // Alert texts
    public let purchaseCancelledTitle: String
    public let purchaseCancelledMessage: String
    public let purchaseFailedTitle: String
    
    // Footer texts
    public let cancelAnytimeText: String
    public let termsText: String
    public let andText: String
    public let privacyPolicyText: String
    public let applyText: String
    
    // Free trial texts
    public let enableFreeTrialText: String
    
    // Savings badge
    public let savingsText: String
    
    // URLs
    public let termsURL: String
    public let privacyPolicyURL: String
    
    public init(
        processingText: String = "Processing...",
        selectPlanText: String = "Select a Plan",
        startFreeTrialText: String = "Start Free Trial",
        continueText: String = "Continue",
        okText: String = "OK",
        purchaseCancelledTitle: String = "Purchase Cancelled",
        purchaseCancelledMessage: String = "You can start your subscription anytime.",
        purchaseFailedTitle: String = "Purchase Failed",
        cancelAnytimeText: String = "Cancel anytime.",
        termsText: String = "Terms",
        andText: String = "and",
        privacyPolicyText: String = "Privacy Policy",
        applyText: String = "apply.",
        enableFreeTrialText: String = "Enable Free Trial",
        savingsText: String = "SAVE 60%",
        termsURL: String = "https://yourapp.com/terms",
        privacyPolicyURL: String = "https://yourapp.com/privacy"
    ) {
        self.processingText = processingText
        self.selectPlanText = selectPlanText
        self.startFreeTrialText = startFreeTrialText
        self.continueText = continueText
        self.okText = okText
        self.purchaseCancelledTitle = purchaseCancelledTitle
        self.purchaseCancelledMessage = purchaseCancelledMessage
        self.purchaseFailedTitle = purchaseFailedTitle
        self.cancelAnytimeText = cancelAnytimeText
        self.termsText = termsText
        self.andText = andText
        self.privacyPolicyText = privacyPolicyText
        self.applyText = applyText
        self.enableFreeTrialText = enableFreeTrialText
        self.savingsText = savingsText
        self.termsURL = termsURL
        self.privacyPolicyURL = privacyPolicyURL
    }
    
    public static func `default`() -> PaywallStrings {
        PaywallStrings()
    }
    
    /// Create localized strings for common languages
    public static func localized(
        processingText: String = NSLocalizedString("paywall.processing", value: "Processing...", comment: "Loading text for purchase button"),
        selectPlanText: String = NSLocalizedString("paywall.selectPlan", value: "Select a Plan", comment: "Text when no plan is selected"),
        startFreeTrialText: String = NSLocalizedString("paywall.startFreeTrial", value: "Start Free Trial", comment: "Text for free trial button"),
        continueText: String = NSLocalizedString("paywall.continue", value: "Continue", comment: "Text for purchase button"),
        okText: String = NSLocalizedString("paywall.ok", value: "OK", comment: "OK button text"),
        purchaseCancelledTitle: String = NSLocalizedString("paywall.purchaseCancelled.title", value: "Purchase Cancelled", comment: "Title when purchase is cancelled"),
        purchaseCancelledMessage: String = NSLocalizedString("paywall.purchaseCancelled.message", value: "You can start your subscription anytime.", comment: "Message when purchase is cancelled"),
        purchaseFailedTitle: String = NSLocalizedString("paywall.purchaseFailed.title", value: "Purchase Failed", comment: "Title when purchase fails"),
        cancelAnytimeText: String = NSLocalizedString("paywall.cancelAnytime", value: "Cancel anytime.", comment: "Cancel anytime text"),
        termsText: String = NSLocalizedString("paywall.terms", value: "Terms", comment: "Terms link text"),
        andText: String = NSLocalizedString("paywall.and", value: "and", comment: "And text between links"),
        privacyPolicyText: String = NSLocalizedString("paywall.privacyPolicy", value: "Privacy Policy", comment: "Privacy policy link text"),
        applyText: String = NSLocalizedString("paywall.apply", value: "apply.", comment: "Apply text after links"),
        enableFreeTrialText: String = NSLocalizedString("paywall.enableFreeTrial", value: "Enable Free Trial", comment: "Free trial toggle text"),
        savingsText: String = NSLocalizedString("paywall.savings", value: "SAVE 60%", comment: "Savings badge text"),
        termsURL: String = "https://yourapp.com/terms",
        privacyPolicyURL: String = "https://yourapp.com/privacy"
    ) -> PaywallStrings {
        PaywallStrings(
            processingText: processingText,
            selectPlanText: selectPlanText,
            startFreeTrialText: startFreeTrialText,
            continueText: continueText,
            okText: okText,
            purchaseCancelledTitle: purchaseCancelledTitle,
            purchaseCancelledMessage: purchaseCancelledMessage,
            purchaseFailedTitle: purchaseFailedTitle,
            cancelAnytimeText: cancelAnytimeText,
            termsText: termsText,
            andText: andText,
            privacyPolicyText: privacyPolicyText,
            applyText: applyText,
            enableFreeTrialText: enableFreeTrialText,
            savingsText: savingsText,
            termsURL: termsURL,
            privacyPolicyURL: privacyPolicyURL
        )
    }
}

public struct PaywallConfiguration {
    public let title: String
    public let subtitle: String
    public let image: PaywallImage?
    public let iconBackgroundColors: [Color]
    public let showAnimation: Bool
    public let features: [PaywallFeature]
    public let strings: PaywallStrings
    
    public init(
        title: String = "Unlock Premium Features",
        subtitle: String = "Get unlimited access to all features with our premium subscription",
        image: PaywallImage? = .default,
        iconBackgroundColors: [Color] = [.blue, .purple],
        showAnimation: Bool = true,
        features: [PaywallFeature] = PaywallConfiguration.defaultFeatures,
        strings: PaywallStrings = .default()
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.iconBackgroundColors = iconBackgroundColors
        self.showAnimation = showAnimation
        self.features = features
        self.strings = strings
    }
    
    // Backward compatibility - deprecated, use image parameter instead
    @available(*, deprecated, message: "Use init with image: PaywallImage parameter instead")
    public init(
        title: String,
        subtitle: String,
        iconName: String? = nil,
        iconBackgroundColors: [Color] = [.blue, .purple],
        showAnimation: Bool = true,
        features: [PaywallFeature] = PaywallConfiguration.defaultFeatures,
        strings: PaywallStrings = .default()
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = iconName.map { .systemIcon($0) } ?? .default
        self.iconBackgroundColors = iconBackgroundColors
        self.showAnimation = showAnimation
        self.features = features
        self.strings = strings
    }
    
    public static var defaultFeatures: [PaywallFeature] {
        [
            PaywallFeature(iconName: "checkmark.circle.fill", title: "Unlimited access to all features"),
            PaywallFeature(iconName: "bolt.circle.fill", title: "Priority customer support"),
            PaywallFeature(iconName: "star.circle.fill", title: "Advanced analytics & insights"),
            PaywallFeature(iconName: "eye.slash.circle.fill", title: "Ad-free experience")
        ]
    }
    
    public static func `default`() -> PaywallConfiguration {
        PaywallConfiguration()
    }
    
    public static func custom(
        title: String,
        subtitle: String,
        image: PaywallImage? = .default,
        iconBackgroundColors: [Color] = [.blue, .purple],
        showAnimation: Bool = true,
        features: [PaywallFeature] = PaywallConfiguration.defaultFeatures,
        strings: PaywallStrings = .default()
    ) -> PaywallConfiguration {
        PaywallConfiguration(
            title: title,
            subtitle: subtitle,
            image: image,
            iconBackgroundColors: iconBackgroundColors,
            showAnimation: showAnimation,
            features: features,
            strings: strings
        )
    }
    
    /// Create a localized paywall configuration
    public static func localized(
        title: String = NSLocalizedString("paywall.title", value: "Unlock Premium Features", comment: "Paywall title"),
        subtitle: String = NSLocalizedString("paywall.subtitle", value: "Get unlimited access to all features with our premium subscription", comment: "Paywall subtitle"),
        image: PaywallImage? = .default,
        iconBackgroundColors: [Color] = [.blue, .purple],
        showAnimation: Bool = true,
        features: [PaywallFeature] = PaywallConfiguration.defaultFeatures,
        strings: PaywallStrings = .localized()
    ) -> PaywallConfiguration {
        PaywallConfiguration(
            title: title,
            subtitle: subtitle,
            image: image,
            iconBackgroundColors: iconBackgroundColors,
            showAnimation: showAnimation,
            features: features,
            strings: strings
        )
    }
}
