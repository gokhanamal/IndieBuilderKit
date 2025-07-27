import SwiftUI

public struct PaywallView: View {
    @State private var subscriptionService: any SubscriptionServiceProtocol
    @State private var isLoading = false
    @State private var isShaking = false
    @State private var freeTrialEnabled = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    private let configuration: PaywallConfiguration
    
    public init(
        configuration: PaywallConfiguration = .default(),
        service: SubscriptionServiceProtocol = RevenueCatSubscriptionService()
    ) {
        self.configuration = configuration
        self.subscriptionService = service
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        headerSection
                        
                        featuresSection
                        
                        Spacer()
                            .frame(height: 8)
                            
                        subscriptionOptions
                        
                        freeTrialToggle
                        
                        // Add bottom padding to account for floating bottom section
                        Spacer()
                            .frame(height: 120)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
                // Floating bottom section
                VStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        purchaseButton
                        
                        footerSection
                    }
                    .padding(24)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Configurable Image with Optional Animation
            if let image = configuration.image {
                imageView(for: image)
                    .rotation3DEffect(
                        .degrees(configuration.showAnimation && isShaking ? 5 : -5),
                        axis: (x: 0, y: 0, z: 1)
                    )
                    .animation(
                        configuration.showAnimation ? 
                            Animation
                                .easeInOut(duration: 0.15)
                                .repeatForever(autoreverses: true) : 
                            nil,
                        value: isShaking
                    )
                    .onAppear {
                        if configuration.showAnimation {
                            isShaking = true
                        }
                    }
            }
            
            Text(configuration.title)
                .font(.bold(28))
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private func imageView(for image: PaywallImage) -> some View {
        switch image {
        case .systemIcon(let iconName):
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: configuration.iconBackgroundColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                Image(systemName: iconName)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
        case .bundleImage(let imageName):
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: configuration.iconBackgroundColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }
            
        case .customImage(let customImage):
            customImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
    
    private var featuresSection: some View {
        VStack(spacing: 12) {
            ForEach(Array(configuration.features.enumerated()), id: \.offset) { index, feature in
                FeatureRowView(icon: feature.iconName, text: feature.title)
            }
        }
        .padding(16)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
    
    private var subscriptionOptions: some View {
        VStack(spacing: 12) {
            ForEach(subscriptionService.availablePlans) { plan in
                SubscriptionOptionView(
                    plan: plan,
                    isSelected: subscriptionService.selectedPlan?.id == plan.id,
                    savingsText: configuration.strings.savingsText
                ) {
                    // Haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        subscriptionService.selectPlan(plan)
                    }
                }
            }
        }
    }
    
    private var purchaseButton: some View {
        VStack {
            PrimaryButton(
                buttonText,
                isLoading: isLoading,
                isDisabled: subscriptionService.selectedPlan == nil,
                style: .rounded
            ) {
                // Haptic feedback for button tap
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.impactOccurred()
                
                purchaseButtonOnTapped()
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button(configuration.strings.okText) {
                showAlert = false
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var footerSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Text(configuration.strings.cancelAnytimeText)
                    .font(.regular(12))
                    .foregroundColor(.secondary)
                
                LinkButton(configuration.strings.termsText, style: .small) {
                    // Handle terms link
                    if let url = URL(string: configuration.strings.termsURL) {
                        UIApplication.shared.open(url)
                    }
                }
                
                Text(configuration.strings.andText)
                    .font(.regular(12))
                    .foregroundColor(.secondary)
                
                LinkButton(configuration.strings.privacyPolicyText, style: .small) {
                    // Handle privacy policy link
                    if let url = URL(string: configuration.strings.privacyPolicyURL) {
                        UIApplication.shared.open(url)
                    }
                }
                
                Text(configuration.strings.applyText)
                    .font(.regular(12))
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.center)
        }
    }
    
    private var freeTrialToggle: some View {
        VStack(spacing: 12) {
            Toggle(isOn: $freeTrialEnabled) {
                HStack {
                    Image(systemName: "gift.fill")
                        .foregroundColor(.blue)
                    
                    Text(configuration.strings.enableFreeTrialText)
                        .font(.medium(16))
                        .foregroundColor(.primary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        }
        .padding(16)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
    
    private var buttonText: String {
        if isLoading {
            return configuration.strings.processingText
        }
        
        guard let selectedPlan = subscriptionService.selectedPlan else {
            return configuration.strings.selectPlanText
        }
        
        if freeTrialEnabled && selectedPlan.hasFreeTrial {
            return configuration.strings.startFreeTrialText
        } else {
            return configuration.strings.continueText
        }
    }
    
    private func purchaseButtonOnTapped() {
        Task {
            isLoading = true
            do {
                try await subscriptionService.purchaseSelectedPlan()
                isLoading = false
                // Success - dismiss the paywall
                dismiss()
            } catch SubscriptionServiceError.purchaseCancelled {
                isLoading = false
                alertTitle = configuration.strings.purchaseCancelledTitle
                alertMessage = configuration.strings.purchaseCancelledMessage
                showAlert = true
            } catch {
                isLoading = false
                alertTitle = configuration.strings.purchaseFailedTitle
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}

private struct SubscriptionOptionView: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let savingsText: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.title)
                            .font(.medium(16))
                            .foregroundColor(.primary)
                        
                        if plan.period == .yearly {
                            Text(savingsText)
                                .font(.bold(10))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                        
                    }
                    
                    Text(plan.description)
                        .font(.regular(14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text(plan.price)
                        .font(.bold(16))
                        .foregroundColor(.primary)
                    
                    Circle()
                        .fill(isSelected ? .accentColor : Color.clear)
                        .stroke(isSelected ? .accentColor : Color.gray, lineWidth: 2)
                        .frame(width: 20, height: 20)
                        .overlay {
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                }
            }
            .padding(16)
            .background(isSelected ? .accentColor.opacity(0.1) : Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .accentColor : Color.clear, lineWidth: 2)
            )
            .cornerRadius(12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
    }
}

private struct FeatureRowView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.accentColor)
            
            Text(text)
                .font(.regular(14))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

#if DEBUG
struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(service: RevenueCatSubscriptionService())
    }
}
#endif
