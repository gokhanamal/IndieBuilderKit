import Foundation
import StoreKit
import SwiftUI

/// Service for handling app rating requests using StoreKit's native rating dialog
public class RatingService {
    public static let shared = RatingService()

    // These are placeholders for future “smart prompting” rules.
    // Kept for now to avoid a breaking change to any planned roadmap.
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

    /// Open App Store review page directly.
    ///
    /// - Parameter appId: The numeric App Store ID (e.g. "123456789").
    public func openAppStoreReview(appId: String) {
        let trimmed = appId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard let url = URL(string: "https://apps.apple.com/app/id\(trimmed)?action=write-review") else { return }

        UIApplication.shared.open(url)
    }

    /// Open App Store review page using an App Store URL (extracts the app id from the URL).
    ///
    /// If parsing fails, falls back to opening the provided URL.
    public func openAppStoreReview(appStoreURL: URL) {
        let s = appStoreURL.absoluteString

        // Typical formats include:
        // - https://apps.apple.com/us/app/some-app/id123456789
        // - https://apps.apple.com/app/id123456789
        if let match = s.range(of: #"id(\d+)"#, options: .regularExpression) {
            let idPart = String(s[match]) // e.g. "id123456789"
            let appId = idPart.replacingOccurrences(of: "id", with: "")
            openAppStoreReview(appId: appId)
            return
        }

        UIApplication.shared.open(appStoreURL)
    }
}
