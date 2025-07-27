import Foundation
import UserNotifications

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Permission Types

public enum PermissionType: CaseIterable {
    case notifications
    
    public var title: String {
        switch self {
        case .notifications:
            return "Notifications"
        }
    }
    
    public var description: String {
        switch self {
        case .notifications:
            return "Send you important updates and reminders"
        }
    }
}

// MARK: - Permission Status

public enum PermissionStatus {
    case notDetermined
    case denied
    case authorized
    case restricted
    
    public var isGranted: Bool {
        return self == .authorized
    }
}

// MARK: - Permission Manager

@Observable
public class PermissionManager {
    public static let shared = PermissionManager()
    
    // MARK: - Properties
    
    // Observable properties for SwiftUI
    public var notificationStatus: PermissionStatus = .notDetermined
    
    // MARK: - Initialization
    
    private init() {
        updatePermissionStatuses()
    }
    
    // MARK: - Public Methods
    
    /// Get current status for a specific permission type
    public func status(for permission: PermissionType) -> PermissionStatus {
        switch permission {
        case .notifications:
            return notificationStatus
        }
    }
    
    /// Request permission for a specific type
    public func requestPermission(for permission: PermissionType) async -> PermissionStatus {
        switch permission {
        case .notifications:
            return await requestNotificationPermission()
        }
    }
    
    /// Request multiple permissions
    public func requestPermissions(for permissions: [PermissionType]) async -> [PermissionType: PermissionStatus] {
        var results: [PermissionType: PermissionStatus] = [:]
        
        for permission in permissions {
            results[permission] = await requestPermission(for: permission)
        }
        
        return results
    }
    
    /// Check if all specified permissions are granted
    public func arePermissionsGranted(_ permissions: [PermissionType]) -> Bool {
        return permissions.allSatisfy { status(for: $0).isGranted }
    }
    
    /// Update all permission statuses
    public func updatePermissionStatuses() {
        Task {
            await updateNotificationStatus()
        }
    }
    
    /// Open app settings for permission management
    public func openAppSettings() {
        #if canImport(UIKit)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        Task { @MainActor in
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        #endif
    }
    
    
    // MARK: - Notification Permission
    
    private func requestNotificationPermission() async -> PermissionStatus {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            
            let status: PermissionStatus = granted ? .authorized : .denied
            
            await MainActor.run {
                self.notificationStatus = status
            }
            
            return status
        } catch {
            await MainActor.run {
                self.notificationStatus = .denied
            }
            return .denied
        }
    }
    
    private func updateNotificationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        
        let status: PermissionStatus
        switch settings.authorizationStatus {
        case .notDetermined:
            status = .notDetermined
        case .denied:
            status = .denied
        case .authorized, .provisional:
            status = .authorized
        case .ephemeral:
            status = .authorized
        @unknown default:
            status = .notDetermined
        }
        
        await MainActor.run {
            self.notificationStatus = status
        }
    }
}


// MARK: - Permission Request UI Helper

public extension PermissionManager {
    /// Creates a permission request explanation for UI
    func permissionExplanation(for permission: PermissionType) -> (title: String, description: String, buttonTitle: String) {
        let title = "Allow \(permission.title)?"
        let description = permission.description
        let buttonTitle = status(for: permission) == .denied ? "Open Settings" : "Allow \(permission.title)"
        
        return (title, description, buttonTitle)
    }
    
    /// Handle permission request with automatic settings redirect for denied permissions
    func handlePermissionRequest(for permission: PermissionType) async -> PermissionStatus {
        let currentStatus = status(for: permission)
        
        if currentStatus == .denied {
            // Permission was previously denied, open settings
            openAppSettings()
            return currentStatus
        } else {
            // Request permission normally
            return await requestPermission(for: permission)
        }
    }
    
}
