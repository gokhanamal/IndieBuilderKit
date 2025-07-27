import SwiftUI
import IndieBuilderKit

struct ContentView: View {
    @State private var showPaywall = false
    @State private var showCustomPaywall = false
    @State private var showMinimalPaywall = false
    @State private var showSettings = false
    @State private var showOnboarding = false
    @State private var showUIComponents = false
    @State private var showPermissions = false
    @State private var showNotificationReview = false
    @State private var showRatingReview = false
    @State private var showNetworkDemo = false
    @Environment(\.subscriptionService) private var subscriptionService
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    featuresGrid
                    
                    demoActions
                    
                    Spacer(minLength: 40)
                }
                .padding(24)
            }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            if let service = subscriptionService {
                PaywallView(
                    configuration: .default(),
                    service: service
                )
            } else {
                PaywallView(configuration: .default())
            }
        }
        .fullScreenCover(isPresented: $showCustomPaywall) {
            if let service = subscriptionService {
                PaywallView(
                    configuration: .custom(
                        title: "IndieBuilderKit Premium",
                        subtitle: "Unlock powerful tools and features to accelerate your indie development journey",
                        image: .systemIcon("hammer.fill"),
                        iconBackgroundColors: [.blue, .purple, .pink],
                        showAnimation: true,
                        features: [
                            PaywallFeature(iconName: "hammer.circle.fill", title: "Advanced development tools"),
                            PaywallFeature(iconName: "swift", title: "Swift code generation"),
                            PaywallFeature(iconName: "doc.text.fill", title: "Documentation templates"),
                            PaywallFeature(iconName: "chart.line.uptrend.xyaxis", title: "Analytics dashboard")
                        ]
                    ),
                    service: service
                )
            } else {
                PaywallView(configuration: .custom(
                    title: "IndieBuilderKit Premium",
                    subtitle: "Unlock powerful tools and features to accelerate your indie development journey",
                    image: .systemIcon("hammer.fill"),
                    iconBackgroundColors: [.blue, .purple, .pink],
                    showAnimation: true
                ))
            }
        }
        .fullScreenCover(isPresented: $showMinimalPaywall) {
            if let service = subscriptionService {
                PaywallView(
                    configuration: .custom(
                        title: "Go Premium",
                        subtitle: "Experience the full potential of our app with premium features",
                        image: nil,
                        iconBackgroundColors: [.green, .mint],
                        showAnimation: false,
                        features: [
                            PaywallFeature(iconName: "star.fill", title: "Premium features"),
                            PaywallFeature(iconName: "cloud.fill", title: "Cloud storage")
                        ]
                    ),
                    service: service
                )
            } else {
                PaywallView(configuration: .custom(
                    title: "Go Premium",
                    subtitle: "Experience the full potential of our app with premium features",
                    image: nil,
                    iconBackgroundColors: [.green, .mint],
                    showAnimation: false
                ))
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(configuration: AppSettingsConfiguration(
                appName: "IndieBuilderKit Demo",
                appVersion: "1.0.0",
                buildNumber: "1",
                developerName: "IndieBuilderKit Team",
                contactEmail: "support@example.com",
                privacyPolicyURL: URL(string: "https://example.com/privacy"),
                termsOfServiceURL: URL(string: "https://example.com/terms"),
                websiteURL: URL(string: "https://example.com"),
                supportURL: URL(string: "https://example.com/support"),
                twitterHandle: "indiebuilderkit",
                instagramHandle: "indiebuilderkit",
                appStoreURL: URL(string: "https://apps.apple.com/app/indiebuilderkit/id123456789")
            ))
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView(
                configuration: OnboardingConfiguration(
                    pages: [
                        OnboardingPage(
                            content: {
                                VStack(spacing: 32) {
                                    Spacer()
                                    
                                    // App Icon
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 22)
                                            .fill(
                                                LinearGradient(
                                                    colors: [.blue, .purple],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 100, height: 100)
                                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                        
                                        Image(systemName: "hammer.fill")
                                            .font(.system(size: 50, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    VStack(spacing: 16) {
                                        Text("Welcome to IndieBuilderKit")
                                            .font(.bold(32))
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.center)
                                        
                                        Text("The ultimate iOS SDK for indie developers. Build amazing apps faster with our pre-built components and services.")
                                            .font(.regular(18))
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    
                                    Spacer()
                                }
                            },
                            backgroundColor: .blue.opacity(0.05),
                            primaryButtonTitle: "Continue"
                        ),
                        OnboardingPage(
                            content: {
                                VStack(spacing: 32) {
                                    Spacer()
                                    
                                    // Feature Grid
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                                        FeatureItem(icon: "crown.fill", title: "Paywall System", color: .yellow)
                                        FeatureItem(icon: "chart.bar.fill", title: "Analytics", color: .green)
                                        FeatureItem(icon: "textformat", title: "Design System", color: .blue)
                                        FeatureItem(icon: "gearshape.fill", title: "Settings", color: .gray)
                                    }
                                    .padding(.horizontal)
                                    
                                    VStack(spacing: 16) {
                                        Text("Everything You Need")
                                            .font(.bold(28))
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.center)
                                        
                                        Text("Subscription management, analytics, custom UI components, and complete settings screens - all integrated and ready to use.")
                                            .font(.regular(16))
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    
                                    Spacer()
                                }
                            },
                            backgroundColor: .green.opacity(0.05),
                            primaryButtonTitle: "Next"
                        ),
                        OnboardingPage(
                            content: {
                                VStack(spacing: 32) {
                                    Spacer()
                                    
                                    Image(systemName: "rocket.fill")
                                        .font(.system(size: 80, weight: .light))
                                        .foregroundColor(.purple)
                                    
                                    VStack(spacing: 16) {
                                        Text("Ready to Build")
                                            .font(.bold(28))
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.center)
                                        
                                        Text("Start exploring the demo features and see how IndieBuilderKit can accelerate your app development journey.")
                                            .font(.regular(18))
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    
                                    Spacer()
                                }
                            },
                            backgroundColor: .purple.opacity(0.05)
                        )
                    ],
                    showSkipButton: false,
                    showProgressBar: false,
                    finalButtonTitle: "Start Exploring",
                    onCompleted: {
                        showOnboarding = false
                    }
                )
            )
        }
        .sheet(isPresented: $showUIComponents) {
            UIComponentsDemo()
        }
        .sheet(isPresented: $showPermissions) {
            NavigationView {
                PermissionDemo()
                    .navigationTitle("Permission Manager")
                    .navigationBarTitleDisplayMode(.large)
            }
        }
        .sheet(isPresented: $showNotificationReview) {
            NotificationPermissionView()
        }
        .sheet(isPresented: $showRatingReview) {
            RatingView()
        }
        .sheet(isPresented: $showNetworkDemo) {
            NetworkDemo()
        }
    }
    
    private var headerSection: some View {
        HStack(spacing: 16) {
            // App Logo
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                
                Image(systemName: "hammer.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("IndieBuilderKit")
                    .font(.bold(24))
                    .foregroundColor(.primary)
                
                Text("iOS SDK for Indie Developers")
                    .font(.regular(14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    private var featuresGrid: some View {
        HStack(spacing: 12) {
            CompactFeatureCard(
                icon: "crown.fill",
                title: "Paywall",
                color: .yellow
            )
            
            CompactFeatureCard(
                icon: "chart.bar.fill",
                title: "Analytics",
                color: .green
            )
            
            CompactFeatureCard(
                icon: "textformat",
                title: "Design",
                color: .blue
            )
            
            CompactFeatureCard(
                icon: "bell.fill",
                title: "Notifications",
                color: .indigo
            )
        }
    }
    
    private var demoActions: some View {
        VStack(spacing: 16) {
            Text("Try Demo Features")
                .font(.bold(20))
                .padding(.top)
            
            VStack(spacing: 12) {
                DemoButton(
                    title: "Default Paywall",
                    description: "Standard premium subscription screen",
                    icon: "creditcard.fill",
                    color: .blue
                ) {
                    showPaywall = true
                }
                
                DemoButton(
                    title: "Custom Paywall",
                    description: "IndieBuilderKit branded paywall",
                    icon: "hammer.fill",
                    color: .purple
                ) {
                    showCustomPaywall = true
                }
                
                DemoButton(
                    title: "Minimal Paywall",
                    description: "Clean design without icon",
                    icon: "rectangle.fill",
                    color: .green
                ) {
                    showMinimalPaywall = true
                }
                
                DemoButton(
                    title: "Open Settings",
                    description: "Full-featured settings with contact, social links, and app info",
                    icon: "gearshape.fill",
                    color: .gray
                ) {
                    showSettings = true
                }
                
                DemoButton(
                    title: "View Onboarding",
                    description: "Interactive welcome flow with progress tracking",
                    icon: "hand.wave.fill",
                    color: .orange
                ) {
                    showOnboarding = true
                }
                
                DemoButton(
                    title: "UI Components",
                    description: "States, buttons, fonts, and design system",
                    icon: "rectangle.3.group.fill",
                    color: .mint
                ) {
                    showUIComponents = true
                }
                
                DemoButton(
                    title: "Permission Manager",
                    description: "View and manage notification permissions",
                    icon: "bell.badge.fill",
                    color: .indigo
                ) {
                    showPermissions = true
                }
                
                DemoButton(
                    title: "Notification Review",
                    description: "Request notification permission with benefits explanation",
                    icon: "bell.fill",
                    color: .blue
                ) {
                    showNotificationReview = true
                }
                
                DemoButton(
                    title: "Rating Review",
                    description: "Ask for App Store review using same UI pattern",
                    icon: "star.fill",
                    color: .yellow
                ) {
                    showRatingReview = true
                }
                
                DemoButton(
                    title: "Network Service",
                    description: "HTTP requests with JSONPlaceholder API demo",
                    icon: "network",
                    color: .cyan
                ) {
                    showNetworkDemo = true
                }
                

            }
        }
    }
}

private struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.medium(14))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.regular(12))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

private struct CompactFeatureCard: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.1))
                .cornerRadius(10)
            
            Text(title)
                .font(.medium(13))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
}

private struct FeatureItem: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(color.opacity(0.1))
                .cornerRadius(12)
            
            Text(title)
                .font(.medium(14))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
    }
}

private struct DemoButton: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.medium(16))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.regular(14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct UIComponentsDemo: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showLoadingView = false
    @State private var showEmptyStateView = false
    @State private var showErrorView = false
    @State private var showStateView = false
    @State private var showAsyncStateView = false
    @State private var showDataLoader = false
    @State private var showFontsDemo = false
    @State private var showButtonsDemo = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Basic State Views") {
                    DemoRow(
                        title: "Loading View",
                        description: "Animated loading indicator with custom messages",
                        icon: "arrow.triangle.2.circlepath",
                        color: .blue
                    ) {
                        showLoadingView = true
                    }
                    
                    DemoRow(
                        title: "Empty State",
                        description: "Beautiful empty state with action buttons",
                        icon: "tray",
                        color: .gray
                    ) {
                        showEmptyStateView = true
                    }
                    
                    DemoRow(
                        title: "Error View",
                        description: "User-friendly error handling with retry actions",
                        icon: "exclamationmark.triangle",
                        color: .red
                    ) {
                        showErrorView = true
                    }
                }
                
                Section("Advanced Components") {
                    DemoRow(
                        title: "State View",
                        description: "Unified view that handles all states with transitions",
                        icon: "square.stack.3d.up",
                        color: .purple
                    ) {
                        showStateView = true
                    }
                    
                    DemoRow(
                        title: "Async State View",
                        description: "Automatic state management for async operations",
                        icon: "network",
                        color: .mint
                    ) {
                        showAsyncStateView = true
                    }
                    
                    DemoRow(
                        title: "Data Loader",
                        description: "Observable data loader with automatic state handling",
                        icon: "arrow.down.circle",
                        color: .orange
                    ) {
                        showDataLoader = true
                    }
                }
                
                Section("Design System") {
                    DemoRow(
                        title: "Font Showcase",
                        description: "Custom typography with fallback system",
                        icon: "textformat",
                        color: .primary
                    ) {
                        showFontsDemo = true
                    }
                    
                    DemoRow(
                        title: "Button Components",
                        description: "Beautiful, reusable button library",
                        icon: "rectangle.fill",
                        color: .teal
                    ) {
                        showButtonsDemo = true
                    }
                }
            }
            .navigationTitle("UI Components")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showLoadingView) {
            NavigationView {
                VStack(spacing: 40) {
                    LoadingView(message: "Loading your data...")
                    LoadingView(message: "Syncing with cloud...", tintColor: .green)
                    LoadingView(message: "Processing payment...", tintColor: .orange, showBackground: false)
                }
                .navigationTitle("Loading Views")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") {
                            showLoadingView = false
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showEmptyStateView) {
            NavigationView {
                VStack(spacing: 30) {
                    EmptyStateView(
                        title: "No Messages",
                        subtitle: "Start a conversation to see messages here",
                        systemImage: "message",
                        actionTitle: "New Message",
                        tintColor: .blue
                    ) {
                        print("New message tapped")
                    }
                    .frame(height: 300)
                    
                    EmptyStateView(
                        title: "No Photos",
                        subtitle: "Add photos to your gallery",
                        systemImage: "photo",
                        actionTitle: "Add Photos",
                        tintColor: .green,
                        showBackground: false
                    ) {
                        print("Add photos tapped")
                    }
                    .frame(height: 250)
                }
                .navigationTitle("Empty States")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") {
                            showEmptyStateView = false
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showErrorView) {
            NavigationView {
                VStack(spacing: 30) {
                    ErrorView(
                        title: "Network Error",
                        message: "Unable to connect to server. Please check your internet connection."
                    ) {
                        print("Retry network request")
                    }
                    .frame(height: 300)
                    
                    ErrorView(
                        title: "Payment Failed",
                        message: "Your payment could not be processed",
                        retryTitle: "Try Again",
                        tintColor: .red,
                        showBackground: false
                    ) {
                        print("Retry payment")
                    }
                    .frame(height: 250)
                }
                .navigationTitle("Error Views")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") {
                            showErrorView = false
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showStateView) {
            StateViewDemo()
        }
        .sheet(isPresented: $showAsyncStateView) {
            AsyncStateViewDemo()
        }
        .sheet(isPresented: $showDataLoader) {
            DataLoaderDemo()
        }
        .sheet(isPresented: $showFontsDemo) {
            FontsDemo()
        }
        .sheet(isPresented: $showButtonsDemo) {
            ButtonsDemo()
        }
    }
}

// MARK: - Advanced Component Demos

struct StateViewDemo: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentState: ViewState<[MockItem]> = .idle
    
    var body: some View {
        NavigationView {
            VStack {
                StateView(
                    state: currentState,
                    tintColor: .purple,
                    onRetry: { loadData() }
                ) { items in
                    List(items) { item in
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(item.name)
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    Button("Loading") {
                        currentState = .loading("Fetching data...")
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Success") {
                        currentState = .loaded([
                            MockItem(name: "Item 1"),
                            MockItem(name: "Item 2"),
                            MockItem(name: "Item 3")
                        ])
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Empty") {
                        currentState = .empty("No items found")
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Error") {
                        currentState = .error(URLError(.networkConnectionLost))
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle("State View")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private func loadData() {
        currentState = .loading("Retrying...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            currentState = .loaded([
                MockItem(name: "Retry Item 1"),
                MockItem(name: "Retry Item 2")
            ])
        }
    }
}

struct AsyncStateViewDemo: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                AsyncStateView(
                    tintColor: .mint,
                    emptyMessage: "No data available"
                ) {
                    try await mockAPICall()
                } content: { items in
                    List(items) { item in
                        HStack {
                            Circle()
                                .fill(.mint)
                                .frame(width: 8, height: 8)
                            Text(item.name)
                        }
                    }
                }
                .frame(height: 300)
                
                Text("This view automatically handles loading, success, empty, and error states")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Async State View")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private func mockAPICall() async throws -> [MockItem] {
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        let outcomes = ["success", "empty", "error"]
        let outcome = outcomes.randomElement()!
        
        switch outcome {
        case "success":
            return [
                MockItem(name: "Async Item 1"),
                MockItem(name: "Async Item 2"),
                MockItem(name: "Async Item 3")
            ]
        case "empty":
            return []
        case "error":
            throw URLError(.badServerResponse)
        default:
            return []
        }
    }
}

struct DataLoaderDemo: View {
    @Environment(\.dismiss) private var dismiss
    @State private var loader = AsyncDataLoader<[MockItem]>()
    
    var body: some View {
        NavigationView {
            VStack {
                StateView(
                    state: loader.state,
                    tintColor: .orange,
                    onRetry: { Task { await loadData() } }
                ) { items in
                    List(items) { item in
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.orange)
                            Text(item.name)
                            Spacer()
                            Text("Loaded")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                HStack(spacing: 16) {
                    Button("Load Data") {
                        Task { await loadData() }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Reset") {
                        loader.reset()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle("Data Loader")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private func loadData() async {
        await loader.load(
            loadingMessage: "Fetching items...",
            emptyMessage: "No items found"
        ) {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            let success = Bool.random()
            guard success else {
                throw URLError(.networkConnectionLost)
            }
            
            let count = Int.random(in: 0...4)
            return (1...count).map { MockItem(name: "Data Item \($0)") }
        }
    }
}

struct MockItem: Identifiable, Sendable {
    let id = UUID()
    let name: String
}

// MARK: - Fonts Demo

struct FontsDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Group {
                    fontSection(title: "Regular Fonts") {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Regular 24").font(.regular(24))
                                Text("Regular 18").font(.regular(18))
                                Text("Regular 16").font(.regular(16))
                                Text("Regular 14").font(.regular(14))
                                Text("Regular 12").font(.regular(12))
                            }
                        }
                        
                        fontSection(title: "Medium Fonts") {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Medium 24").font(.medium(24))
                                Text("Medium 18").font(.medium(18))
                                Text("Medium 16").font(.medium(16))
                                Text("Medium 14").font(.medium(14))
                                Text("Medium 12").font(.medium(12))
                            }
                        }
                        
                        fontSection(title: "Bold Fonts") {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Bold 32").font(.bold(32))
                                Text("Bold 28").font(.bold(28))
                                Text("Bold 24").font(.bold(24))
                                Text("Bold 20").font(.bold(20))
                                Text("Bold 16").font(.bold(16))
                            }
                        }
                    }
                    
                    fontSection(title: "Typography Examples") {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Heading")
                                    .font(.bold(28))
                                    .foregroundColor(.primary)
                                Text("This is a heading using bold 28pt font")
                                    .font(.regular(16))
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Subheading")
                                    .font(.medium(20))
                                    .foregroundColor(.primary)
                                Text("This is a subheading using medium 20pt font")
                                    .font(.regular(14))
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Body Text")
                                    .font(.medium(16))
                                    .foregroundColor(.primary)
                                Text("This is body text using regular 16pt font. It's perfect for longer paragraphs and readable content throughout your app.")
                                    .font(.regular(16))
                                    .foregroundColor(.primary)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Caption")
                                    .font(.medium(14))
                                    .foregroundColor(.primary)
                                Text("This is caption text using regular 12pt font")
                                    .font(.regular(12))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    fontSection(title: "Font Fallback System") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("✅ Custom Fonts")
                                .font(.medium(16))
                                .foregroundColor(.green)
                            Text("When Roboto fonts are available, they're used for a custom look")
                                .font(.regular(14))
                                .foregroundColor(.secondary)
                            
                            Text("🔄 System Fallback")
                                .font(.medium(16))
                                .foregroundColor(.blue)
                            Text("When Roboto fonts fail to load, system fonts are automatically used")
                                .font(.regular(14))
                                .foregroundColor(.secondary)
                            
                            Text("🎨 Consistent Design")
                                .font(.medium(16))
                                .foregroundColor(.purple)
                            Text("Your app looks great regardless of font loading status")
                                .font(.regular(14))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("Font Showcase")
            .navigationBarTitleDisplayMode(.large)
    }
    
    @ViewBuilder
    private func fontSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.bold(20))
                .foregroundColor(.primary)
            
            content()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}

// MARK: - Buttons Demo

struct ButtonsDemo: View {
    @State private var isLoading = false
    @State private var selectedChips = Set<String>()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Group {
                    buttonSection(title: "Primary Buttons") {
                        VStack(spacing: 12) {
                                PrimaryButton("Default Primary") {
                                    print("Default primary tapped")
                                }
                                
                                PrimaryButton("Loading State", isLoading: isLoading) {
                                    toggleLoading()
                                }
                                
                                PrimaryButton("Disabled", isDisabled: true) {
                                    print("This won't fire")
                                }
                                
                                PrimaryButton("Rounded Style", style: .rounded) {
                                    print("Rounded primary tapped")
                                }
                                
                                PrimaryButton("Destructive Action", style: .destructive) {
                                    print("Destructive action")
                                }
                                
                                PrimaryButton("Success Action", style: .success) {
                                    print("Success action")
                                }
                            }
                        }
                        
                        buttonSection(title: "Secondary Buttons") {
                            VStack(spacing: 12) {
                                SecondaryButton("Default Secondary") {
                                    print("Secondary tapped")
                                }
                                
                                SecondaryButton("Filled Style", style: .filled) {
                                    print("Filled secondary tapped")
                                }
                                
                                SecondaryButton("Disabled", isDisabled: true) {
                                    print("This won't fire")
                                }
                                
                                SecondaryButton("Rounded Style", style: .rounded) {
                                    print("Rounded secondary tapped")
                                }
                            }
                        }
                        
                        buttonSection(title: "Icon Buttons") {
                            VStack(spacing: 16) {
                                HStack(spacing: 12) {
                                    IconButton(icon: "heart.fill") {
                                        print("Heart tapped")
                                    }
                                    
                                    IconButton(icon: "star.fill", title: "Favorite") {
                                        print("Favorite tapped")
                                    }
                                    
                                    IconButton(icon: "share", style: .prominent) {
                                        print("Share tapped")
                                    }
                                    
                                    Spacer()
                                }
                                
                                HStack(spacing: 12) {
                                    IconButton(icon: "bookmark.fill") {
                                        print("Bookmark tapped")
                                    }
                                    
                                    IconButton(icon: "arrow.up.forward.square", title: "Export") {
                                        print("Export tapped")
                                    }
                                    
                                    IconButton(icon: "gear", title: "Settings") {
                                        print("Settings tapped")
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                        buttonSection(title: "Floating Action Buttons") {
                            HStack(spacing: 16) {
                                FloatingActionButton(icon: "plus") {
                                    print("Add tapped")
                                }
                                
                                FloatingActionButton(icon: "message", style: .compact) {
                                    print("Message tapped")
                                }
                                
                                FloatingActionButton(icon: "camera.fill", style: .large) {
                                    print("Camera tapped")
                                }
                                
                                Spacer()
                            }
                        }
                        
                        buttonSection(title: "Chip Buttons") {
                            VStack(spacing: 12) {
                                HStack(spacing: 8) {
                                    ForEach(["All", "Favorites", "Recent"], id: \.self) { chip in
                                        ChipButton(chip, isSelected: selectedChips.contains(chip)) {
                                            toggleChip(chip)
                                        }
                                    }
                                    Spacer()
                                }
                                
                                HStack(spacing: 8) {
                                    ForEach(["Design", "Development", "Marketing"], id: \.self) { chip in
                                        ChipButton(chip, isSelected: selectedChips.contains(chip)) {
                                            toggleChip(chip)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        
                        buttonSection(title: "Link Buttons") {
                            VStack(spacing: 12) {
                                HStack(spacing: 16) {
                                    LinkButton("Learn More") {
                                        print("Learn more tapped")
                                    }
                                    
                                    LinkButton("Terms of Service", style: .underlined) {
                                        print("Terms tapped")
                                    }
                                    
                                    LinkButton("Small Link", style: .small) {
                                        print("Small link tapped")
                                    }
                                    
                                    Spacer()
                                }
                                
                                Text("Link buttons are perfect for subtle actions and navigation")
                                    .font(.regular(12))
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("Button Components")
            .navigationBarTitleDisplayMode(.large)
    }
    
    @ViewBuilder
    private func buttonSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.bold(18))
                .foregroundColor(.primary)
            
            content()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
    
    private func toggleLoading() {
        isLoading.toggle()
        if isLoading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = false
            }
        }
    }
    
    private func toggleChip(_ chip: String) {
        if selectedChips.contains(chip) {
            selectedChips.remove(chip)
        } else {
            selectedChips.insert(chip)
        }
    }
}

private struct DemoRow: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.medium(16))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.regular(13))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Permission Demo

private struct PermissionDemo: View {
    @Environment(\.permissions) private var permissions
    @State private var showingNotificationReview = false
    
    var body: some View {
        List {
            Section("Current Permission Status") {
                PermissionStatusRow(
                    permission: .notifications,
                    status: permissions.notificationStatus
                )
            }
            
            Section("Permission Actions") {
                Button("Request Notification Permission") {
                    Task {
                        showingNotificationReview = true
                    }
                }
                
                Button("Open App Settings") {
                    permissions.openAppSettings()
                }
                
                Button("Refresh Status") {
                    permissions.updatePermissionStatuses()
                }
            }
            
            Section("Programmatic Testing") {
                Button("Test Notification Request") {
                    testNotificationRequest()
                }
                
                Button("Check Permission Status") {
                    checkPermissionStatus()
                }
            }
            
            Section("Permission Information") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notification Permission")
                        .font(.headline)
                    Text("Used to send important updates, reminders, and app notifications. The review flow provides context before requesting permission.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .onAppear {
            permissions.updatePermissionStatuses()
        }
        .sheet(isPresented: $showingNotificationReview) {
            NotificationPermissionView()
        }
    }
    
    private func testNotificationRequest() {
        Task {
            let result = await permissions.requestPermission(for: .notifications)
            print("Programmatic notification request result: \(result)")
        }
    }
    
    private func checkPermissionStatus() {
        let isGranted = permissions.arePermissionsGranted([.notifications])
        print("Notification permission granted: \(isGranted)")
        print("Notification status: \(permissions.status(for: .notifications))")
    }
}

private struct PermissionStatusRow: View {
    let permission: PermissionType
    let status: PermissionStatus
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(permission.title)
                    .font(.medium(16))
                
                Text(permission.description)
                    .font(.regular(12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            statusBadge
        }
        .padding(.vertical, 4)
    }
    
    private var iconName: String {
        switch permission {
        case .notifications:
            return "bell.fill"
        }
    }
    
    private var iconColor: Color {
        switch status {
        case .authorized:
            return .successColor
        case .denied:
            return .errorColor
        case .notDetermined:
            return .secondaryColor
        case .restricted:
            return .warningColor
        }
    }
    
    private var statusText: String {
        switch status {
        case .authorized:
            return "Granted"
        case .denied:
            return "Denied"
        case .notDetermined:
            return "Not requested"
        case .restricted:
            return "Restricted"
        }
    }
    
    private var statusBadge: some View {
        Text(statusText)
            .font(.regular(12))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(iconColor.opacity(0.2))
            )
            .foregroundColor(iconColor)
    }
}

#Preview {
    ContentView()
}
