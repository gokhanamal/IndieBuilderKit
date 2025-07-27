//
//  NotificationPermissionView.swift
//  IndieBuilderKit
//
//  Dedicated view for requesting notification permissions
//

import SwiftUI

// MARK: - Notification Permission View

public struct NotificationPermissionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.permissions) private var permissions
    
    private let configuration: NotificationPermissionConfiguration
    private let onCompletion: ((PermissionStatus) -> Void)?
    
    public init(
        configuration: NotificationPermissionConfiguration = .default(),
        onCompletion: ((PermissionStatus) -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onCompletion = onCompletion
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                
                // Header Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [configuration.accentColor.opacity(0.2), configuration.accentColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "bell.fill")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(configuration.accentColor)
                }
                
                // Title and Description
                VStack(spacing: 16) {
                    Text(configuration.title)
                        .font(.bold(28))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(configuration.description)
                        .font(.regular(16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 20)
                }
                
                // Features List
                if !configuration.features.isEmpty {
                    VStack(spacing: 16) {
                        ForEach(configuration.features, id: \.title) { feature in
                            PermissionFeatureRow(
                                icon: feature.icon,
                                title: feature.title,
                                description: feature.description,
                                accentColor: configuration.accentColor
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    PrimaryButton(
                        configuration.allowButtonTitle,
                        style: PrimaryButtonStyle(
                            cornerRadius: 12,
                            backgroundColors: [configuration.accentColor],
                            foregroundColor: .white
                        )
                    ) {
                        Task {
                            let status = await permissions.requestPermission(for: .notifications)
                            onCompletion?(status)
                            dismiss()
                        }
                    }
                    
                    LinkButton(
                        configuration.denyButtonTitle,
                        style: .small
                    ) {
                        onCompletion?(.denied)
                        dismiss()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Permission Feature Row

private struct PermissionFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(accentColor)
                .frame(width: 32, height: 32)
                .background(accentColor.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.medium(16))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.regular(14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
}

// MARK: - Configuration

public struct NotificationPermissionConfiguration {
    public let title: String
    public let description: String
    public let features: [PermissionFeature]
    public let allowButtonTitle: String
    public let denyButtonTitle: String
    public let accentColor: Color
    
    public init(
        title: String = "Stay Updated",
        description: String = "Get notified about important updates and new features",
        features: [PermissionFeature] = [],
        allowButtonTitle: String = "Allow Notifications",
        denyButtonTitle: String = "Not Now",
        accentColor: Color = .blue
    ) {
        self.title = title
        self.description = description
        self.features = features
        self.allowButtonTitle = allowButtonTitle
        self.denyButtonTitle = denyButtonTitle
        self.accentColor = accentColor
    }
    
    public static func `default`() -> NotificationPermissionConfiguration {
        return NotificationPermissionConfiguration(
            features: [
                PermissionFeature(
                    icon: "bell.badge.fill",
                    title: "Important Updates",
                    description: "Get notified when new features are available"
                ),
                PermissionFeature(
                    icon: "clock.fill",
                    title: "Timely Reminders",
                    description: "Never miss important deadlines or events"
                ),
                PermissionFeature(
                    icon: "shield.checkered",
                    title: "Privacy First",
                    description: "You can change this anytime in Settings"
                )
            ]
        )
    }
}

public struct PermissionFeature {
    public let icon: String
    public let title: String
    public let description: String
    
    public init(icon: String, title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }
}

// MARK: - Convenience Initializers

public extension NotificationPermissionView {
    /// Simple notification permission request
    static func simple(
        title: String = "Enable Notifications",
        description: String = "Stay updated with the latest from our app",
        onCompletion: ((PermissionStatus) -> Void)? = nil
    ) -> NotificationPermissionView {
        let config = NotificationPermissionConfiguration(
            title: title,
            description: description,
            features: []
        )
        return NotificationPermissionView(configuration: config, onCompletion: onCompletion)
    }
    
    /// Detailed notification permission request with features
    static func detailed(onCompletion: ((PermissionStatus) -> Void)? = nil) -> NotificationPermissionView {
        return NotificationPermissionView(configuration: .default(), onCompletion: onCompletion)
    }
}

#if DEBUG
struct NotificationPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPermissionView()
    }
}
#endif
