import Foundation

// MARK: - Analytics Provider Protocol

public protocol AnalyticsProvider {
    var name: String { get }
    func track(event: String, parameters: [String: Any]?)
    func setUserProperty(_ value: String?, forName name: String)
    func setUserId(_ userId: String?)
}

// MARK: - Analytics Event Types

public enum AnalyticsEvent {
    case screenView(name: String, className: String? = nil)
    case purchase(transactionId: String, value: Double, currency: String = "USD")
    case custom(name: String, parameters: [String: Any]? = nil)
    
    var eventName: String {
        switch self {
        case .screenView: return "screen_view"
        case .purchase: return "purchase"
        case .custom(let name, _): return name
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .screenView(let name, let className):
            var params: [String: Any] = ["screen_name": name]
            if let className = className {
                params["screen_class"] = className
            }
            return params
        case .purchase(let transactionId, let value, let currency):
            return [
                "transaction_id": transactionId,
                "value": value,
                "currency": currency
            ]
        case .custom(_, let parameters):
            return parameters
        }
    }
}

// MARK: - Mock Analytics Provider

public final class MockAnalyticsProvider: AnalyticsProvider {
    public let name = "Mock"
    private let isEnabled: Bool
    
    public init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
    
    public func track(event: String, parameters: [String: Any]?) {
        guard isEnabled else { return }
        
        var message = "📊 Mock Analytics: \(event)"
        if let parameters = parameters, !parameters.isEmpty {
            message += " | Parameters: \(parameters)"
        }
        print(message)
    }
    
    public func setUserProperty(_ value: String?, forName name: String) {
        guard isEnabled else { return }
        print("👤 Mock Analytics: User property '\(name)' = \(value ?? "nil")")
    }
    
    public func setUserId(_ userId: String?) {
        guard isEnabled else { return }
        print("🆔 Mock Analytics: User ID = \(userId ?? "nil")")
    }
}

// MARK: - Analytics Wrapper (Main Interface)

public final class AnalyticsWrapper {
    private let providers: [AnalyticsProvider]
    
    public init(providers: [AnalyticsProvider] = [MockAnalyticsProvider()]) {
        self.providers = providers
    }
    
    /// Track an analytics event
    public func track(_ event: AnalyticsEvent) {
        track(event: event.eventName, parameters: event.parameters)
    }
    
    /// Track a custom event with name and parameters
    public func track(event: String, parameters: [String: Any]? = nil) {
        for provider in providers {
            provider.track(event: event, parameters: parameters)
        }
    }
    
    /// Set a user property across all providers
    public func setUserProperty(_ value: String?, forName name: String) {
        for provider in providers {
            provider.setUserProperty(value, forName: name)
        }
    }
    
    /// Set user ID across all providers
    public func setUserId(_ userId: String?) {
        for provider in providers {
            provider.setUserId(userId)
        }
    }
    
    /// Get list of configured provider names
    public var providerNames: [String] {
        providers.map { $0.name }
    }
}