import Foundation
import SwiftUI
import RevenueCat

// MARK: - RevenueCat Subscription Service

@Observable
public final class RevenueCatSubscriptionService: SubscriptionServiceProtocol {
    
    // MARK: - Configuration
    
    public private(set) var isConfigured = false
    
    // MARK: - Subscription Management
    
    public var subscriptionStatus: SubscriptionStatus = .unknown
    public private(set) var customerInfo: CustomerInfo?
    public private(set) var currentOfferings: Offerings?
    
    // MARK: - Paywall UI State
    
    public var availablePlans: [SubscriptionPlan] = []
    public var selectedPlan: SubscriptionPlan?
    
    public init() {}
    
    // MARK: - Configuration
    
    public func configure(apiKey: String) {
        guard !apiKey.isEmpty else {
            print(SubscriptionServiceError.purchaseFailed("RevenueCat API key cannot be empty"))
            return
        }
        
        Purchases.configure(withAPIKey: apiKey)
        isConfigured = true
    }
    
    @MainActor
    public func loadServiceData() async {
        await loadInitialData()
    }
    
    @MainActor
    public func configureAndLoadInitialData(apiKey: String) async {
        configure(apiKey: apiKey)
        await loadInitialData()
    }
    
    // MARK: - Data Loading
    
    @MainActor
    private func loadInitialData() async {
        await refreshSubscriptionStatus()
        await loadOfferings()
        updateAvailablePlans()
    }

    @MainActor
    public func refreshSubscriptionStatus() async {
        guard isConfigured else {
            return
        }
        
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            self.customerInfo = customerInfo
            self.subscriptionStatus = determineSubscriptionStatus(from: customerInfo)
        } catch {
            self.subscriptionStatus = .unknown
        }
    }
    
    @MainActor
    private func loadOfferings() async {
        guard isConfigured else { return }
        
        do {
            let offerings = try await Purchases.shared.offerings()
            self.currentOfferings = offerings
        } catch {
            // If offerings fail to load, we'll fall back to default plans in updateAvailablePlans()
            print("Failed to load RevenueCat offerings: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func updateAvailablePlans() {
        guard let currentOffering = currentOfferings?.current else {
            // No offerings available - clear plans and show error
            availablePlans = []
            selectedPlan = nil
            print("⚠️ IndieBuilderKit: No RevenueCat offerings found. Please check your RevenueCat configuration and ensure you have created an offering with products.")
            return
        }
        
        // Convert RevenueCat packages to SubscriptionPlans
        availablePlans = currentOffering.availablePackages.compactMap { package in
            convertPackageToSubscriptionPlan(package)
        }
        
        // Check if we have any plans available
        if availablePlans.isEmpty {
            selectedPlan = nil
            print("⚠️ IndieBuilderKit: No available subscription plans found. Please check your RevenueCat configuration and ensure you have configured products in your offering.")
        } else {
            // Auto-select the first plan only if we have plans
            selectedPlan = availablePlans.first
        }
    }
    
    private func convertPackageToSubscriptionPlan(_ package: Package) -> SubscriptionPlan? {
        let product = package.storeProduct
        
        // Determine period based on subscription period
        let period: SubscriptionPlan.SubscriptionPeriod
        if let subscriptionPeriod = product.subscriptionPeriod {
            switch subscriptionPeriod.unit {
            case .day:
                if subscriptionPeriod.value == 7 {
                    period = .weekly
                } else {
                    period = .weekly // Default for other day periods
                }
            case .week:
                period = .weekly
            case .month:
                period = subscriptionPeriod.value == 12 ? .yearly : .weekly
            case .year:
                period = .yearly
            @unknown default:
                period = .weekly
            }
        } else {
            period = .weekly // Default fallback
        }
        
        // Check for introductory offer (free trial)
        let hasFreeTrial = product.introductoryDiscount != nil
        let freeTrialPeriod = product.introductoryDiscount?.subscriptionPeriod.localizedDescription
        
        return SubscriptionPlan(
            id: product.productIdentifier,
            title: package.localizedPriceString,
            description: product.localizedDescription,
            price: product.localizedPriceString,
            period: period,
            hasFreeTrial: hasFreeTrial,
            freeTrialPeriod: freeTrialPeriod
        )
    }
    
    // MARK: - Subscription Status Helpers
    
    public func hasEntitlement(_ entitlementId: String) -> Bool {
        return customerInfo?.entitlements[entitlementId]?.isActive == true
    }
    
    private func determineSubscriptionStatus(from customerInfo: CustomerInfo) -> SubscriptionStatus {
        // Check for active subscriptions
        for (_, entitlement) in customerInfo.entitlements.active where entitlement.isActive {
            return .active(expirationDate: entitlement.expirationDate)
        }
        
        return .inactive
    }
    
    // MARK: - Paywall Actions
    
    @MainActor
    public func selectPlan(_ plan: SubscriptionPlan) {
        selectedPlan = plan
    }
    
    @MainActor
    public func purchaseSelectedPlan() async throws {
        guard isConfigured else {
            throw SubscriptionServiceError.notConfigured
        }
        
        guard let selectedPlan = selectedPlan else {
            throw SubscriptionServiceError.noPlanSelected
        }
        
        // Find the corresponding package
        guard let package = findPackage(for: selectedPlan) else {
            throw SubscriptionServiceError.purchaseFailed("Package not found")
        }
         
        do {
            let result = try await Purchases.shared.purchase(package: package)
            let customerInfo = result.customerInfo
            
            self.customerInfo = customerInfo
            self.subscriptionStatus = determineSubscriptionStatus(from: customerInfo)
            
            if result.userCancelled {
                throw SubscriptionServiceError.purchaseCancelled
            }
        } catch {
            if let purchasesError = error as? PublicError {
                switch ErrorCode(rawValue: purchasesError.code) {
                case .purchaseCancelledError:
                    throw SubscriptionServiceError.purchaseCancelled
                default:
                    throw SubscriptionServiceError.purchaseFailed(purchasesError.localizedDescription)
                }
            }
            throw error
        }
    }
    
    @MainActor
    public func restorePurchases() async throws {
        guard isConfigured else {
            throw SubscriptionServiceError.notConfigured
        }
        
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            self.customerInfo = customerInfo
            self.subscriptionStatus = determineSubscriptionStatus(from: customerInfo)
        } catch {
            throw SubscriptionServiceError.restoreFailed(error.localizedDescription)
        }
    }
    
    private func findPackage(for plan: SubscriptionPlan) -> Package? {
        return currentOfferings?.current?.availablePackages.first { package in
            package.storeProduct.productIdentifier == plan.id
        }
    }
    
    // MARK: - User Management
    
    public func setUserId(_ userId: String?) {
        guard isConfigured else { return }
        if let userId = userId {
            Purchases.shared.logIn(userId) { _, _, _ in }
        }
    }
    
    public func logOut() {
        guard isConfigured else { return }
        Purchases.shared.logOut { _, _ in
            self.subscriptionStatus = .inactive
            self.customerInfo = nil
        }
    }
}

// MARK: - Extensions

private extension SubscriptionPeriod {
    var localizedDescription: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        
        let valueString = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        
        switch unit {
        case .day:
            return value == 1 ? "1 day" : "\(valueString) days"
        case .week:
            return value == 1 ? "1 week" : "\(valueString) weeks"
        case .month:
            return value == 1 ? "1 month" : "\(valueString) months"
        case .year:
            return value == 1 ? "1 year" : "\(valueString) years"
        @unknown default:
            return "\(valueString) periods"
        }
    }
}
