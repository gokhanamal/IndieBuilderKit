import Foundation
import StoreKit
import SwiftUI

/// Service for handling app rating requests using StoreKit's native rating dialog
public class RatingService {
    public static let shared = RatingService()
    
    private let minimumLaunchCountForRating = 3
    private let minimumDaysSinceInstall = 7
    private let minimumDaysBetweenRatingRequests = 30
    
    private init() {}
    
    /// Force request rating (useful for manual "Rate App" buttons)
    @MainActor
    public func requestRating() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return
        }
        
        SKStoreReviewController.requestReview(in: windowScene)
    }
    
    /// Open App Store review page directly
    public func openAppStoreReview(appId: String) {
        let urlString = "https://apps.apple.com/app/id\(appId)?action=write-review"
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
