import Foundation
import SwiftUI

// MARK: - Subscription Status

public enum SubscriptionStatus {
    case active(expirationDate: Date?)
    case inactive
    case unknown
    
    public var isActive: Bool {
        switch self {
        case .active:
            return true
        case .inactive, .unknown:
            return false
        }
    }
}

// MARK: - Unified Subscription Service Protocol

public protocol SubscriptionServiceProtocol: AnyObject {
    
    // MARK: - Configuration
    
    /// Whether the service is properly configured
    var isConfigured: Bool { get }
    
    /// Configure the service (e.g., with API keys)
    func configure(apiKey: String)
    
    /// Load initial service data (offerings, subscription status, etc.)
    func loadServiceData() async
    
    func configureAndLoadInitialData(apiKey: String) async
    
    // MARK: - Subscription Management
    
    /// Current subscription status
    var subscriptionStatus: SubscriptionStatus { get }
    
    /// Refresh subscription status from server
    func refreshSubscriptionStatus() async
    
    /// Check if user has a specific entitlement
    func hasEntitlement(_ entitlementId: String) -> Bool
    
    // MARK: - Paywall UI State
    
    /// Available subscription plans for paywall
    var availablePlans: [SubscriptionPlan] { get }
    
    /// Currently selected plan in paywall
    var selectedPlan: SubscriptionPlan? { get set }
    
    // MARK: - Purchase Actions
    
    /// Select a plan in the paywall
    func selectPlan(_ plan: SubscriptionPlan)
    
    /// Purchase the currently selected plan
    /// - Throws: SubscriptionServiceError for various failure cases
    func purchaseSelectedPlan() async throws
    
    /// Restore previous purchases
    /// - Throws: SubscriptionServiceError for various failure cases
    func restorePurchases() async throws
    
    // MARK: - User Management
    
    /// Set user ID for analytics/tracking
    func setUserId(_ userId: String?)
    
    /// Log out current user
    func logOut()
}

// MARK: - Errors

public enum SubscriptionServiceError: LocalizedError {
    case notConfigured
    case noPlanSelected
    case purchaseCancelled
    case purchaseFailed(String)
    case restoreFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Subscription service not configured"
        case .noPlanSelected:
            return "No subscription plan selected"
        case .purchaseCancelled:
            return "Purchase was cancelled"
        case .purchaseFailed(let message):
            return "Purchase failed: \(message)"
        case .restoreFailed(let message):
            return "Restore failed: \(message)"
        }
    }
}
