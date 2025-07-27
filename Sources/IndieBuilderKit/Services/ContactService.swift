import Foundation
import SwiftUI

#if canImport(MessageUI)
import MessageUI
#endif

/// Service for handling contact-related functionality like sending emails
@Observable
public class ContactService: NSObject {
    public static let shared = ContactService()
    
    private override init() {
        super.init()
    }
    
    /// Check if the device can send emails
    public var canSendEmail: Bool {
        #if canImport(MessageUI)
        return MFMailComposeViewController.canSendMail()
        #else
        return false
        #endif
    }
    
    /// Create a mailto URL for opening the default email app
    public func createMailtoURL(
        to email: String,
        subject: String,
        body: String = ""
    ) -> URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = email
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "subject", value: subject))
        
        if !body.isEmpty {
            queryItems.append(URLQueryItem(name: "body", value: body))
        }
        
        components.queryItems = queryItems
        return components.url
    }
    
    /// Generate app info string for support emails
    public func generateAppInfoString(
        appName: String? = nil,
        appVersion: String? = nil,
        buildNumber: String? = nil
    ) -> String {
        let device = UIDevice.current
        let systemInfo = ProcessInfo.processInfo
        
        // Get app info from bundle if not provided
        let finalAppName = appName ?? Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? 
                          Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "App"
        let finalAppVersion = appVersion ?? Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let finalBuildNumber = buildNumber ?? Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        
        return """
        
        
        ---
        App Info:
        App: \(finalAppName) v\(finalAppVersion) (\(finalBuildNumber))
        Device: \(device.model)
        iOS: \(device.systemVersion)
        System: \(systemInfo.operatingSystemVersionString)
        """
    }
    
    /// Open default email app with pre-filled content
    public func openEmailApp(
        to email: String,
        subject: String,
        body: String = "",
        appName: String? = nil,
        appVersion: String? = nil,
        buildNumber: String? = nil
    ) {
        let fullBody = body + generateAppInfoString(
            appName: appName,
            appVersion: appVersion,
            buildNumber: buildNumber
        )
        
        guard let url = createMailtoURL(to: email, subject: subject, body: fullBody) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

/// Mail composer view for SwiftUI
public struct MailComposerView: UIViewControllerRepresentable {
    let recipients: [String]
    let subject: String
    let body: String
    let onResult: (Result<MFMailComposeResult, Error>) -> Void
    
    public init(
        recipients: [String],
        subject: String,
        body: String,
        onResult: @escaping (Result<MFMailComposeResult, Error>) -> Void
    ) {
        self.recipients = recipients
        self.subject = subject
        self.body = body
        self.onResult = onResult
    }
    
    public func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setToRecipients(recipients)
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)
        return composer
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(onResult: onResult)
    }
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let onResult: (Result<MFMailComposeResult, Error>) -> Void
        
        init(onResult: @escaping (Result<MFMailComposeResult, Error>) -> Void) {
            self.onResult = onResult
        }
        
        public func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            if let error = error {
                onResult(.failure(error))
            } else {
                onResult(.success(result))
            }
            controller.dismiss(animated: true)
        }
    }
}