import Foundation
import SwiftUI

/// Configuration for the SettingsView component
public struct SettingsConfiguration {
    
    // MARK: - App Information
    public let appStoreId: String?
    public let developerName: String?
    public let websiteURL: String?
    
    // MARK: - Contact Information
    public let supportEmail: String?
    public let contactEmail: String?
    
    // MARK: - Legal URLs
    public let privacyPolicyURL: String?
    public let termsOfServiceURL: String?
    
    // MARK: - Social Media
    public let twitterHandle: String?
    public let instagramHandle: String?
    public let linkedinHandle: String?
    public let youtubeChannel: String?
    public let tiktokHandle: String?
    
    // MARK: - Section Visibility
    public let showAppActions: Bool
    public let showSupport: Bool
    public let showLegal: Bool
    public let showAbout: Bool
    public let showSocial: Bool
    public let showDeveloper: Bool
    
    // MARK: - Custom Sections
    public let customSections: [SettingsSection]
    
    // MARK: - Feature Toggles
    public let enableNewsletterSignup: Bool
    public let enableThemeSelector: Bool
    public let enableNotificationSettings: Bool
    public let enableStorageInfo: Bool
    public let enableResetOptions: Bool
    
    // MARK: - Newsletter
    public let newsletterSignupURL: String?
    
    // MARK: - Initialization
    public init(
        appStoreId: String? = nil,
        developerName: String? = nil,
        websiteURL: String? = nil,
        supportEmail: String? = nil,
        contactEmail: String? = nil,
        privacyPolicyURL: String? = nil,
        termsOfServiceURL: String? = nil,
        twitterHandle: String? = nil,
        instagramHandle: String? = nil,
        linkedinHandle: String? = nil,
        youtubeChannel: String? = nil,
        tiktokHandle: String? = nil,
        showAppActions: Bool = true,
        showSupport: Bool = true,
        showLegal: Bool = true,
        showAbout: Bool = true,
        showSocial: Bool = true,
        showDeveloper: Bool = true,
        customSections: [SettingsSection] = [],
        enableNewsletterSignup: Bool = false,
        enableThemeSelector: Bool = false,
        enableNotificationSettings: Bool = false,
        enableStorageInfo: Bool = false,
        enableResetOptions: Bool = false,
        newsletterSignupURL: String? = nil
    ) {
        self.appStoreId = appStoreId
        self.developerName = developerName
        self.websiteURL = websiteURL
        self.supportEmail = supportEmail
        self.contactEmail = contactEmail
        self.privacyPolicyURL = privacyPolicyURL
        self.termsOfServiceURL = termsOfServiceURL
        self.twitterHandle = twitterHandle
        self.instagramHandle = instagramHandle
        self.linkedinHandle = linkedinHandle
        self.youtubeChannel = youtubeChannel
        self.tiktokHandle = tiktokHandle
        self.showAppActions = showAppActions
        self.showSupport = showSupport
        self.showLegal = showLegal
        self.showAbout = showAbout
        self.showSocial = showSocial
        self.showDeveloper = showDeveloper
        self.customSections = customSections
        self.enableNewsletterSignup = enableNewsletterSignup
        self.enableThemeSelector = enableThemeSelector
        self.enableNotificationSettings = enableNotificationSettings
        self.enableStorageInfo = enableStorageInfo
        self.enableResetOptions = enableResetOptions
        self.newsletterSignupURL = newsletterSignupURL
    }
    
    /// Default configuration with basic settings
    public static let `default` = SettingsConfiguration()
    
    /// Get social media URL for a given handle and platform
    public func socialMediaURL(for platform: SocialPlatform) -> URL? {
        let handle: String?
        let baseURL: String
        
        switch platform {
        case .twitter:
            handle = twitterHandle
            baseURL = "https://twitter.com/"
        case .instagram:
            handle = instagramHandle
            baseURL = "https://instagram.com/"
        case .linkedin:
            handle = linkedinHandle
            baseURL = "https://linkedin.com/in/"
        case .youtube:
            handle = youtubeChannel
            baseURL = "https://youtube.com/c/"
        case .tiktok:
            handle = tiktokHandle
            baseURL = "https://tiktok.com/@"
        }
        
        guard let handle = handle, !handle.isEmpty else { return nil }
        let cleanHandle = handle.hasPrefix("@") ? String(handle.dropFirst()) : handle
        return URL(string: baseURL + cleanHandle)
    }
    
    /// Check if any social media links are configured
    public var hasSocialMedia: Bool {
        [twitterHandle, instagramHandle, linkedinHandle, youtubeChannel, tiktokHandle]
            .compactMap { $0 }
            .contains { !$0.isEmpty }
    }
}

/// Custom settings section
public struct SettingsSection {
    public let title: String
    public let items: [SettingsItem]
    public let icon: String?
    
    public init(title: String, items: [SettingsItem], icon: String? = nil) {
        self.title = title
        self.items = items
        self.icon = icon
    }
}

/// Individual settings item
public struct SettingsItem {
    public let title: String
    public let subtitle: String?
    public let icon: String?
    public let action: SettingsAction
    public let accessoryType: SettingsAccessoryType
    
    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        action: SettingsAction,
        accessoryType: SettingsAccessoryType = .disclosure
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.action = action
        self.accessoryType = accessoryType
    }
}

/// Settings item actions
public enum SettingsAction {
    case url(URL)
    case email(String, subject: String?, body: String?)
    case custom(() -> Void)
    case toggle(Binding<Bool>)
}

/// Settings accessory types
public enum SettingsAccessoryType {
    case none
    case disclosure
    case toggle
    case detail
}

/// Social media platforms
public enum SocialPlatform {
    case twitter
    case instagram
    case linkedin
    case youtube
    case tiktok
    
    public var displayName: String {
        switch self {
        case .twitter: return "Twitter"
        case .instagram: return "Instagram"
        case .linkedin: return "LinkedIn"
        case .youtube: return "YouTube"
        case .tiktok: return "TikTok"
        }
    }
    
    public var iconName: String {
        switch self {
        case .twitter: return "bird.fill"
        case .instagram: return "camera.fill"
        case .linkedin: return "person.crop.rectangle.fill"
        case .youtube: return "play.rectangle.fill"
        case .tiktok: return "music.note"
        }
    }
}