import SwiftUI
import StoreKit

#if canImport(MessageUI)
import MessageUI
#endif

// MARK: - Settings Configuration

public struct AppSettingsConfiguration {
    public let appName: String
    public let appVersion: String
    public let buildNumber: String
    public let developerName: String
    public let contactEmail: String?
    public let privacyPolicyURL: URL?
    public let termsOfServiceURL: URL?
    public let websiteURL: URL?
    public let supportURL: URL?
    public let twitterHandle: String?
    public let instagramHandle: String?
    public let linkedInHandle: String?
    public let appStoreURL: URL?
    
    public init(
        appName: String,
        appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0",
        buildNumber: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1",
        developerName: String,
        contactEmail: String? = nil,
        privacyPolicyURL: URL? = nil,
        termsOfServiceURL: URL? = nil,
        websiteURL: URL? = nil,
        supportURL: URL? = nil,
        twitterHandle: String? = nil,
        instagramHandle: String? = nil,
        linkedInHandle: String? = nil,
        appStoreURL: URL? = nil
    ) {
        self.appName = appName
        self.appVersion = appVersion
        self.buildNumber = buildNumber
        self.developerName = developerName
        self.contactEmail = contactEmail
        self.privacyPolicyURL = privacyPolicyURL
        self.termsOfServiceURL = termsOfServiceURL
        self.websiteURL = websiteURL
        self.supportURL = supportURL
        self.twitterHandle = twitterHandle
        self.instagramHandle = instagramHandle
        self.linkedInHandle = linkedInHandle
        self.appStoreURL = appStoreURL
    }
}

// MARK: - Main Settings View

public struct SettingsView: View {
    private let configuration: AppSettingsConfiguration
    private let embedInNavigation: Bool

    @Environment(\.dismiss) private var dismiss
    @State private var showingMailComposer = false
    @State private var showingShareSheet = false
    #if canImport(MessageUI)
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    #endif

    /// - Parameter embedInNavigation: Set to `false` when presenting inside an existing `NavigationStack`
    ///   to avoid a double navigation bar.
    public init(configuration: AppSettingsConfiguration, embedInNavigation: Bool = true) {
        self.configuration = configuration
        self.embedInNavigation = embedInNavigation
    }

    public var body: some View {
        Group {
            if embedInNavigation {
                NavigationStack {
                    content
                }
            } else {
                content
            }
        }
    }

    private var content: some View {
        List {
                // App Actions Section
                Section {
                    SettingsRow(
                        icon: "star.fill",
                        title: "Rate \(configuration.appName)",
                        iconColor: .yellow
                    ) {
                        handleRateApp()
                    }
                    
                    if let appStoreURL = configuration.appStoreURL {
                        SettingsRow(
                            icon: "square.and.pencil",
                            title: "Write a Review",
                            iconColor: .primaryColor
                        ) {
                            handleWriteReview(url: appStoreURL)
                        }
                    }
                    
                    SettingsRow(
                        icon: "square.and.arrow.up",
                        title: "Share App",
                        iconColor: .blue
                    ) {
                        showingShareSheet = true
                    }
                } header: {
                    Text("App")
                        .foregroundColor(.secondaryColor)
                }
                
                // Support Section
                if hasSupportSection {
                    Section {
                        if configuration.contactEmail != nil {
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                iconColor: .green
                            ) {
                                handleContactUs()
                            }
                        }
                        
                        if let supportURL = configuration.supportURL {
                            SettingsRow(
                                icon: "questionmark.circle.fill",
                                title: "Help & Support",
                                iconColor: .orange,
                                showChevron: true
                            ) {
                                handleOpenURL(supportURL)
                            }
                        }
                        
                        if configuration.contactEmail != nil {
                            SettingsRow(
                                icon: "exclamationmark.triangle.fill",
                                title: "Report a Bug",
                                iconColor: .red
                            ) {
                                handleReportBug()
                            }
                        }
                    } header: {
                        Text("Support")
                            .foregroundColor(.secondaryColor)
                    }
                }
                
                // Legal Section
                if hasLegalSection {
                    Section {
                        if let privacyURL = configuration.privacyPolicyURL {
                            SettingsRow(
                                icon: "hand.raised.fill",
                                title: "Privacy Policy",
                                iconColor: .purple,
                                showChevron: true
                            ) {
                                handleOpenURL(privacyURL)
                            }
                        }
                        
                        if let termsURL = configuration.termsOfServiceURL {
                            SettingsRow(
                                icon: "doc.text.fill",
                                title: "Terms of Service",
                                iconColor: .gray,
                                showChevron: true
                            ) {
                                handleOpenURL(termsURL)
                            }
                        }
                    } header: {
                        Text("Legal")
                            .foregroundColor(.secondaryColor)
                    }
                }
                
                // Social Section
                if hasSocialLinks {
                    Section {
                        if let websiteURL = configuration.websiteURL {
                            SettingsRow(
                                icon: "globe",
                                title: "Website",
                                iconColor: .blue,
                                showChevron: true
                            ) {
                                handleOpenURL(websiteURL)
                            }
                        }
                        
                        if let twitterHandle = configuration.twitterHandle {
                            SettingsRow(
                                icon: "at",
                                title: "Follow on X (Twitter)",
                                iconColor: .black,
                                showChevron: true
                            ) {
                                handleOpenSocialMedia(platform: "twitter", handle: twitterHandle)
                            }
                        }
                        
                        if let instagramHandle = configuration.instagramHandle {
                            SettingsRow(
                                icon: "camera.fill",
                                title: "Follow on Instagram",
                                iconColor: .pink,
                                showChevron: true
                            ) {
                                handleOpenSocialMedia(platform: "instagram", handle: instagramHandle)
                            }
                        }
                        
                        if let linkedInHandle = configuration.linkedInHandle {
                            SettingsRow(
                                icon: "person.crop.square.fill",
                                title: "Connect on LinkedIn",
                                iconColor: .blue,
                                showChevron: true
                            ) {
                                handleOpenSocialMedia(platform: "linkedin", handle: linkedInHandle)
                            }
                        }
                    } header: {
                        Text("Connect")
                            .foregroundColor(.secondaryColor)
                    }
                }
                
                // About Section
                if hasAboutSection {
                    Section {
                        SettingsInfoRow(title: "Version", value: configuration.appVersion)
                        SettingsInfoRow(title: "Build", value: configuration.buildNumber)
                        SettingsInfoRow(title: "Developer", value: configuration.developerName)
                    } header: {
                        Text("About")
                            .foregroundColor(.secondaryColor)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    LinkButton("Done", style: .small) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingMailComposer) {
                #if canImport(MessageUI)
                if let contactEmail = configuration.contactEmail {
                    MailComposeView(
                        subject: "Feedback for \(configuration.appName)",
                        recipients: [contactEmail],
                        messageBody: generateFeedbackTemplate(),
                        result: $mailResult
                    )
                }
                #endif
            }
            .sheet(isPresented: $showingShareSheet) {
                if let appStoreURL = configuration.appStoreURL {
                    ShareSheet(items: [
                        "Check out \(configuration.appName)!",
                        appStoreURL
                    ])
                }
            }
    }
    
    private var hasSupportSection: Bool {
        configuration.contactEmail != nil || configuration.supportURL != nil
    }
    
    private var hasLegalSection: Bool {
        configuration.privacyPolicyURL != nil || configuration.termsOfServiceURL != nil
    }
    
    private var hasSocialLinks: Bool {
        configuration.websiteURL != nil ||
        configuration.twitterHandle != nil ||
        configuration.instagramHandle != nil ||
        configuration.linkedInHandle != nil
    }
    
    private var hasAboutSection: Bool {
        true // Always show about section as it contains app info
    }
    
    // MARK: - Action Handlers
    
    private func handleRateApp() {
        RatingService.shared.requestRating()
    }
    
    private func handleWriteReview(url: URL) {
        RatingService.shared.openAppStoreReview(appStoreURL: url)
    }
    
    private func handleContactUs() {
        #if canImport(MessageUI)
        if MFMailComposeViewController.canSendMail() {
            showingMailComposer = true
        } else {
            // Fallback to opening mail app
            if let emailURL = URL(string: "mailto:\(configuration.contactEmail ?? "")") {
                UIApplication.shared.open(emailURL)
            }
        }
        #else
        // Fallback to opening mail app
        if let emailURL = URL(string: "mailto:\(configuration.contactEmail ?? "")") {
            UIApplication.shared.open(emailURL)
        }
        #endif
    }
    
    private func handleReportBug() {
        #if canImport(MessageUI)
        if MFMailComposeViewController.canSendMail() {
            showingMailComposer = true
        } else {
            if let emailURL = URL(string: "mailto:\(configuration.contactEmail ?? "")?subject=Bug Report for \(configuration.appName)") {
                UIApplication.shared.open(emailURL)
            }
        }
        #else
        if let emailURL = URL(string: "mailto:\(configuration.contactEmail ?? "")?subject=Bug Report for \(configuration.appName)") {
            UIApplication.shared.open(emailURL)
        }
        #endif
    }
    
    private func handleOpenURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
    
    private func handleOpenSocialMedia(platform: String, handle: String) {
        var url: URL?
        
        switch platform {
        case "twitter":
            url = URL(string: "https://twitter.com/\(handle)")
        case "instagram":
            url = URL(string: "https://instagram.com/\(handle)")
        case "linkedin":
            url = URL(string: "https://linkedin.com/in/\(handle)")
        default:
            return
        }
        
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
    
    private func generateFeedbackTemplate() -> String {
        """
        Hi there!
        
        I'm reaching out regarding \(configuration.appName).
        
        App Version: \(configuration.appVersion)
        Build: \(configuration.buildNumber)
        Device: \(UIDevice.current.model)
        iOS Version: \(UIDevice.current.systemVersion)
        
        ---
        Please describe your feedback or issue below:
        
        
        """
    }
}

// MARK: - Settings Row Components

private struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let showChevron: Bool
    let action: () -> Void
    
    init(
        icon: String,
        title: String,
        iconColor: Color,
        showChevron: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.iconColor = iconColor
        self.showChevron = showChevron
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 28, height: 28)
                    .background(iconColor)
                    .cornerRadius(6)
                
                Text(title)
                    .foregroundColor(.textColor)
                    .font(.medium(16))
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondaryColor)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .padding(.vertical, 2)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct SettingsInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.textColor)
                .font(.medium(16))
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondaryColor)
                .font(.regular(16))
        }
        .padding(.vertical, 2)
    }
}

#if canImport(MessageUI)
// MARK: - Mail Composer

private struct MailComposeView: UIViewControllerRepresentable {
    let subject: String
    let recipients: [String]
    let messageBody: String
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        controller.setSubject(subject)
        controller.setToRecipients(recipients)
        controller.setMessageBody(messageBody, isHTML: false)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                parent.result = .failure(error)
            } else {
                parent.result = .success(result)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
#endif

// MARK: - Share Sheet

private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Default Configuration

public extension AppSettingsConfiguration {
    static func defaultConfiguration() -> AppSettingsConfiguration {
        return AppSettingsConfiguration(
            appName: Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? 
                     Bundle.main.infoDictionary?["CFBundleName"] as? String ?? 
                     "App",
            developerName: "Indie Developer"
        )
    }
}

// MARK: - Preview

#Preview("Settings Screen") {
    SettingsView(
        configuration: AppSettingsConfiguration(
            appName: "MyApp",
            appVersion: "1.2.0",
            buildNumber: "42",
            developerName: "Indie Developer",
            contactEmail: "support@myapp.com",
            privacyPolicyURL: URL(string: "https://myapp.com/privacy"),
            termsOfServiceURL: URL(string: "https://myapp.com/terms"),
            websiteURL: URL(string: "https://myapp.com"),
            supportURL: URL(string: "https://myapp.com/support"),
            twitterHandle: "myapp",
            instagramHandle: "myapp",
            appStoreURL: URL(string: "https://apps.apple.com/app/myapp/id123456789")
        )
    )
    
}

#Preview("Minimal Settings") {
    SettingsView(
        configuration: AppSettingsConfiguration(
            appName: "Simple App",
            developerName: "Simple Dev"
            // Sections will automatically hide since no URLs/emails provided
        )
    )
    
}
