import Foundation
import RevenueCat

public struct SubscriptionPlan: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let description: String
    public let price: String
    public let period: SubscriptionPeriod
    public let hasFreeTrial: Bool
    public let freeTrialPeriod: String?
    
    public enum SubscriptionPeriod: String, CaseIterable {
        case weekly = "weekly"
        case yearly = "yearly"
        
        public var displayName: String {
            switch self {
            case .weekly:
                return "Weekly"
            case .yearly:
                return "Yearly"
            }
        }
    }
    
    public init(
        id: String,
        title: String,
        description: String,
        price: String,
        period: SubscriptionPeriod,
        hasFreeTrial: Bool = false,
        freeTrialPeriod: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.period = period
        self.hasFreeTrial = hasFreeTrial
        self.freeTrialPeriod = freeTrialPeriod
    }
}

public extension SubscriptionPlan {
    static let weeklyPlan = SubscriptionPlan(
        id: "weekly_premium",
        title: "Weekly Premium",
        description: "Full access to all features",
        price: "$4.99/week",
        period: .weekly,
        hasFreeTrial: true,
        freeTrialPeriod: "3 days free"
    )
    
    static let yearlyPlan = SubscriptionPlan(
        id: "yearly_premium",
        title: "Yearly Premium",
        description: "Full access to all features + Save 60%",
        price: "$99.99/year",
        period: .yearly,
        hasFreeTrial: false
    )
    
    static let weeklyPlanWithoutTrial = SubscriptionPlan(
        id: "weekly_premium",
        title: "Weekly Premium",
        description: "Full access to all features",
        price: "$4.99/week",
        period: .weekly,
        hasFreeTrial: false
    )
}