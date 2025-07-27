import SwiftUI

// MARK: - Onboarding Data Models

public struct OnboardingPage: Identifiable, Hashable {
    public let id = UUID()
    public let content: AnyView
    public let backgroundColor: Color?
    public let primaryButtonTitle: String?
    public let secondaryButtonTitle: String?
    
    public init<Content: View>(
        @ViewBuilder content: () -> Content,
        backgroundColor: Color? = nil,
        primaryButtonTitle: String? = nil,
        secondaryButtonTitle: String? = nil
    ) {
        self.content = AnyView(content())
        self.backgroundColor = backgroundColor
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
    
    public static func == (lhs: OnboardingPage, rhs: OnboardingPage) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct OnboardingConfiguration {
    public let pages: [OnboardingPage]
    public let showSkipButton: Bool
    public let showProgressBar: Bool
    public let skipButtonTitle: String
    public let finalButtonTitle: String
    public let onCompleted: () -> Void
    public let onSkipped: (() -> Void)?
    
    public init(
        pages: [OnboardingPage],
        showSkipButton: Bool = true,
        showProgressBar: Bool = true,
        skipButtonTitle: String = "Skip",
        finalButtonTitle: String = "Get Started",
        onCompleted: @escaping () -> Void,
        onSkipped: (() -> Void)? = nil
    ) {
        self.pages = pages
        self.showSkipButton = showSkipButton
        self.showProgressBar = showProgressBar
        self.skipButtonTitle = skipButtonTitle
        self.finalButtonTitle = finalButtonTitle
        self.onCompleted = onCompleted
        self.onSkipped = onSkipped
    }
}

// MARK: - Main Onboarding View

public struct OnboardingView: View {
    private let configuration: OnboardingConfiguration
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentPageIndex = 0
    
    public init(configuration: OnboardingConfiguration) {
        self.configuration = configuration
    }
    
    public var body: some View {
        NavigationView {
            Group {
                if !configuration.pages.isEmpty {
                    OnboardingPageView(
                        page: configuration.pages[currentPageIndex],
                        pageIndex: currentPageIndex,
                        totalPages: configuration.pages.count,
                        configuration: configuration,
                        onNavigateNext: navigateToNext,
                        onNavigatePrevious: navigateToPrevious
                    )
                } else {
                    EmptyStateView(
                        title: "No onboarding pages configured",
                        tintColor: .primaryColor
                    )
                }
            }
            .animation(.easeInOut(duration: 0.3), value: currentPageIndex)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip") {
                        dismiss()
                    }
                    .font(.medium(16))
                    .contentShape(Rectangle())
                    .opacity(currentPageIndex < configuration.pages.count - 1 ? 1 : 0)
                }
            }
        }
    }
    
    private func navigateToNext() {
        guard currentPageIndex < configuration.pages.count - 1 else { return }
        currentPageIndex += 1
    }
    
    private func navigateToPrevious() {
        guard currentPageIndex > 0 else { return }
        currentPageIndex -= 1
    }
}

// MARK: - Individual Page View

private struct OnboardingPageView: View {
    let page: OnboardingPage
    let pageIndex: Int
    let totalPages: Int
    let configuration: OnboardingConfiguration
    let onNavigateNext: () -> Void
    let onNavigatePrevious: () -> Void
    
    private var isLastPage: Bool {
        pageIndex == totalPages - 1
    }
    
    var body: some View {
        ZStack {
            // Background
            (page.backgroundColor ?? Color.backgroundColor)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                if configuration.showProgressBar {
                    ProgressBarView(
                        currentStep: pageIndex + 1,
                        totalSteps: totalPages
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            
                // Custom Content Area - takes available space between progress bar and buttons
                page.content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 24)
                
                // Navigation buttons
                navigationButtons
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    handleSwipeGesture(gesture)
                }
        )
    }
    
    
    private var navigationButtons: some View {
        VStack(spacing: 16) {
            // Primary button
            PrimaryButton(
                isLastPage ? configuration.finalButtonTitle : (page.primaryButtonTitle ?? "Continue")
            ) {
                handlePrimaryAction()
            }
            
            // Secondary button (if available and not last page)
            if let secondaryTitle = page.secondaryButtonTitle, !isLastPage {
                LinkButton(secondaryTitle) {
                    handleSecondaryAction()
                }
            }
        }
    }
    
    private func handlePrimaryAction() {
        if isLastPage {
            configuration.onCompleted()
        } else {
            onNavigateNext()
        }
    }
    
    private func handleSecondaryAction() {
        // Custom secondary action can be implemented based on needs
        // For now, skip to next page
        onNavigateNext()
    }
    
    private func handleSkip() {
        configuration.onSkipped?()
        configuration.onCompleted()
    }
    
    private func handleSwipeGesture(_ gesture: DragGesture.Value) {
        let threshold: CGFloat = 50
        let horizontalDistance = gesture.translation.width
        
        if horizontalDistance > threshold && pageIndex > 0 {
            // Swipe right - go to previous page
            onNavigatePrevious()
        } else if horizontalDistance < -threshold && pageIndex < totalPages - 1 {
            // Swipe left - go to next page
            onNavigateNext()
        }
    }
}

// MARK: - Default Configurations

public extension OnboardingConfiguration {
    static func defaultConfiguration(onCompleted: @escaping () -> Void) -> OnboardingConfiguration {
        let pages = [
            OnboardingPage(
                content: {
                    VStack(spacing: 32) {
                        Spacer()
                        
                        Image(systemName: "hand.wave.fill")
                            .font(.system(size: 80, weight: .light))
                            .foregroundColor(.blue)
                        
                        VStack(spacing: 16) {
                            Text("Welcome")
                                .font(.bold(28))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text("Discover amazing features designed just for you")
                                .font(.regular(18))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                },
                backgroundColor: .blue.opacity(0.1)
            ),
            OnboardingPage(
                content: {
                    VStack(spacing: 32) {
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80, weight: .light))
                            .foregroundColor(.green)
                        
                        VStack(spacing: 16) {
                            Text("Stay Organized")
                                .font(.bold(28))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text("Keep track of everything that matters to you")
                                .font(.regular(18))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                },
                backgroundColor: .green.opacity(0.1)
            ),
            OnboardingPage(
                content: {
                    VStack(spacing: 32) {
                        Spacer()
                        
                        Image(systemName: "rocket.fill")
                            .font(.system(size: 80, weight: .light))
                            .foregroundColor(.purple)
                        
                        VStack(spacing: 16) {
                            Text("Get Started")
                                .font(.bold(28))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text("You're all set! Let's begin your journey")
                                .font(.regular(18))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                },
                backgroundColor: .purple.opacity(0.1)
            )
        ]
        
        return OnboardingConfiguration(
            pages: pages,
            onCompleted: onCompleted
        )
    }
}

// MARK: - Progress Bar View

private struct ProgressBarView: View {
    let currentStep: Int
    let totalSteps: Int
    
    private var progress: Double {
        Double(currentStep) / Double(totalSteps)
    }
    
    private var progressPercentage: String {
        String(format: "%.0f%%", progress * 100)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Progress percentage text
            HStack {
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(.caption)
                    .foregroundStyle(Color.secondaryColor)
                
                Spacer()
                
                Text(progressPercentage)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Color.primaryColor)
                    .contentTransition(.numericText())
            }
            
            // Modern progress view for iOS 17+
            ProgressView(value: progress) {
                EmptyView()
            }
            .progressViewStyle(LinearProgressViewStyle())
            .tint(.primaryColor)
            .scaleEffect(y: 2.0, anchor: .center)
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
}

// MARK: - Preview

#Preview("Default Onboarding") {
    OnboardingView(
        configuration: .defaultConfiguration {
            print("Onboarding completed!")
        }
    )
    
}

#Preview("Custom Onboarding") {
    let customPages = [
        OnboardingPage(
            content: {
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(.orange)
                    
                    VStack(spacing: 16) {
                        Text("Custom Welcome")
                            .font(.bold(28))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("This is a custom onboarding flow")
                            .font(.regular(18))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
            },
            backgroundColor: .orange.opacity(0.1),
            primaryButtonTitle: "Next Step"
        ),
        OnboardingPage(
            content: {
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(.mint)
                    
                    VStack(spacing: 16) {
                        Text("Final Step")
                            .font(.bold(28))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("Ready to get started?")
                            .font(.regular(18))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
            },
            backgroundColor: .mint.opacity(0.1)
        )
    ]
    
    return OnboardingView(
        configuration: OnboardingConfiguration(
            pages: customPages,
            showSkipButton: false,
            showProgressBar: true,
            finalButtonTitle: "Let's Go!",
            onCompleted: {
                print("Custom onboarding completed!")
            }
        )
    )
    
}

#Preview("Without Progress Bar") {
    OnboardingView(
        configuration: OnboardingConfiguration(
            pages: [
                OnboardingPage(
                    content: {
                        VStack(spacing: 24) {
                            Spacer()
                            
                            Image(systemName: "eye.slash.fill")
                                .font(.system(size: 80, weight: .light))
                                .foregroundColor(.gray)
                            
                            VStack(spacing: 16) {
                                Text("Clean Interface")
                                    .font(.bold(28))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                
                                Text("No progress bar shown")
                                    .font(.regular(18))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Spacer()
                        }
                    },
                    backgroundColor: .gray.opacity(0.1)
                )
            ],
            showSkipButton: true,
            showProgressBar: false,
            onCompleted: {
                print("Onboarding without progress bar completed!")
            }
        )
    )
    
}

#Preview("Advanced Custom Content") {
    let advancedPages = [
        OnboardingPage(
            content: {
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Custom video player placeholder
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.1))
                        .frame(height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                                Text("Watch Demo")
                                    .font(.medium(16))
                                    .foregroundColor(.blue)
                            }
                        )
                    
                    VStack(spacing: 12) {
                        Text("See It In Action")
                            .font(.bold(24))
                            .foregroundColor(.primary)
                        
                        Text("Watch how our app can transform your workflow")
                            .font(.regular(16))
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
                VStack(spacing: 16) {
                    Spacer()
                    
                    // Feature grid layout
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        ForEach(["chart.bar.fill", "lock.shield.fill", "cloud.fill", "star.fill"], id: \.self) { icon in
                            VStack(spacing: 8) {
                                Image(systemName: icon)
                                    .font(.system(size: 30))
                                    .foregroundColor(.purple)
                                    .frame(width: 60, height: 60)
                                    .background(Color.purple.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                Text("Feature")
                                    .font(.medium(12))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        Text("Powerful Features")
                            .font(.bold(24))
                            .foregroundColor(.primary)
                        
                        Text("Everything you need to stay productive")
                            .font(.regular(16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    Spacer()
                }
            },
            backgroundColor: .purple.opacity(0.05)
        )
    ]
    
    return OnboardingView(
        configuration: OnboardingConfiguration(
            pages: advancedPages,
            showSkipButton: true,
            showProgressBar: true,
            finalButtonTitle: "Start Using App",
            onCompleted: {
                print("Advanced onboarding completed!")
            }
        )
    )
}
