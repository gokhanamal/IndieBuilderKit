import SwiftUI

// MARK: - Environment Keys

public struct AnalyticsWrapperKey: EnvironmentKey {
    public static let defaultValue = AnalyticsWrapper()
}

public struct PermissionManagerKey: EnvironmentKey {
    public static let defaultValue: PermissionManager = PermissionManager.shared
}

public struct SubscriptionServiceKey: EnvironmentKey {
    public static let defaultValue: (any SubscriptionServiceProtocol)? = nil
}

// MARK: - Environment Values Extension

public extension EnvironmentValues {
    var analytics: AnalyticsWrapper {
        get { self[AnalyticsWrapperKey.self] }
        set { self[AnalyticsWrapperKey.self] = newValue }
    }
    
    var permissions: PermissionManager {
        get { self[PermissionManagerKey.self] }
        set { self[PermissionManagerKey.self] = newValue }
    }
    
    var subscriptionService: (any SubscriptionServiceProtocol)? {
        get { self[SubscriptionServiceKey.self] }
        set { self[SubscriptionServiceKey.self] = newValue }
    }
}
