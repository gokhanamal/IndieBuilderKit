import Foundation
import SwiftUI
import IndieBuilderKit

// MARK: - Demo Subscription Service

/// A mock subscription service specifically for the demo app
/// This shows how to implement a custom subscription service with realistic behavior
@Observable
public final class DemoSubscriptionService: SubscriptionServiceProtocol {
    
    // MARK: - Configuration
    
    public var isConfigured = true // Demo is always "configured"
    
    // MARK: - Subscription Management
    
    public var subscriptionStatus: SubscriptionStatus = .inactive
    
    // MARK: - Paywall UI State
    
    public var availablePlans: [SubscriptionPlan] = []
    public var selectedPlan: SubscriptionPlan?
    
    // MARK: - Demo State
    
    private var simulatePurchaseFailure = false
    private var purchaseCount = 0
    
    public init() {
        setupDemoPlans()
        selectedPlan = availablePlans.first
    }
    
    private func setupDemoPlans() {
        availablePlans = [
            SubscriptionPlan(
                id: "demo_weekly",
                title: "Weekly Premium",
                description: "Perfect for trying out premium features",
                price: "$4.99/week",
                period: .weekly,
                hasFreeTrial: true,
                freeTrialPeriod: "3 days free"
            ),
            SubscriptionPlan(
                id: "demo_yearly",
                title: "Yearly Premium",
                description: "Best value - Save 70%",
                price: "$49.99/year",
                period: .yearly,
                hasFreeTrial: false
            )
        ]
    }
    
    // MARK: - Configuration
    
    public func configure(apiKey: String) {
        // Demo is always configured
        print("🎭 Demo: Configured with API key: \(apiKey.prefix(8))...")
    }
    
    public func loadServiceData() async {
        print("🔄 Demo: Loading service data...")
        await refreshSubscriptionStatus()
        // Demo plans are already set up in init
    }
    
    public func configureAndLoadInitialData(apiKey: String) async {
        configure(apiKey: apiKey)
        await loadServiceData()
    }
    
    // MARK: - Subscription Management
    
    public func refreshSubscriptionStatus() async {
        print("🔄 Demo: Refreshing subscription status...")
        
        // Simulate network delay
        try? await Task.sleep(for: .seconds(0.5))
        
        // Keep current status - don't override user's demo state
        print("📊 Demo: Current status: \(subscriptionStatus)")
    }
    
    public func hasEntitlement(_ entitlementId: String) -> Bool {
        let hasAccess = subscriptionStatus.isActive
        print("🔐 Demo: Checking entitlement '\(entitlementId)': \(hasAccess)")
        return hasAccess
    }
    
    // MARK: - Paywall Actions
    
    public func selectPlan(_ plan: SubscriptionPlan) {
        selectedPlan = plan
        print("🎯 Demo: Selected plan: \(plan.title)")
    }
    
    public func purchaseSelectedPlan() async throws {
        guard let selectedPlan = selectedPlan else {
            throw SubscriptionServiceError.noPlanSelected
        }
        
        print("💳 Demo: Starting purchase for: \(selectedPlan.title)")
        
        // Simulate realistic purchase flow timing
        try? await Task.sleep(for: .seconds(2))
        
        purchaseCount += 1
        
        // Simulate occasional failure for demo purposes
        if purchaseCount % 5 == 0 {
            print("❌ Demo: Simulated purchase failure")
            throw SubscriptionServiceError.purchaseFailed("Network timeout")
        }
        
        // Simulate success
        subscriptionStatus = .active(expirationDate: Date().addingTimeInterval(365 * 24 * 60 * 60))
        
        print("🎉 Demo: Purchase successful! Status: \(subscriptionStatus)")
    }
    
    public func restorePurchases() async throws {
        print("🔄 Demo: Restoring purchases...")
        
        // Simulate restore process
        try? await Task.sleep(for: .seconds(1.5))
        
        // For demo, always restore to active subscription
        subscriptionStatus = .active(expirationDate: Date().addingTimeInterval(365 * 24 * 60 * 60))
        
        print("✅ Demo: Purchases restored successfully")
    }
    
    // MARK: - User Management
    
    public func setUserId(_ userId: String?) {
        print("👤 Demo: Set user ID to \(userId ?? "nil")")
    }
    
    public func logOut() {
        subscriptionStatus = .inactive
        print("👋 Demo: User logged out - subscription status reset")
    }
    
    // MARK: - Demo-specific methods
    
    /// Reset the demo state (useful for demo presentations)
    public func resetDemoState() {
        subscriptionStatus = .inactive
        selectedPlan = availablePlans.first
        purchaseCount = 0
        print("🔄 Demo: State reset to initial values")
    }
    
    public func simulateActiveState() {
        subscriptionStatus = .active(expirationDate: Date().addingTimeInterval(300 * 24 * 60 * 60))
        print("✅ Demo: Simulated active subscription (300 days remaining)")
    }
    
    public func simulateInactiveState() {
        subscriptionStatus = .inactive
        print("❌ Demo: Simulated inactive state")
    }
}

// MARK: - Demo Extensions

extension DemoSubscriptionService {
    /// Get a user-friendly description of the current subscription status
    var statusDescription: String {
        switch subscriptionStatus {
        case .active(let expirationDate):
            if let date = expirationDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return "Active until \(formatter.string(from: date))"
            } else {
                return "Active (lifetime)"
            }
        case .inactive:
            return "No active subscription"
        case .unknown:
            return "Status unknown"
        }
    }
    
    /// Get the next renewal date as a formatted string
    var renewalDateString: String? {
        switch subscriptionStatus {
        case .active(let date):
            guard let date = date else { return nil }
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        case .inactive, .unknown:
            return nil
        }
    }
}
