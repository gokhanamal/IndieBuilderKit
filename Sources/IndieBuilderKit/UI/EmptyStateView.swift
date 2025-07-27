import SwiftUI

public struct EmptyStateView: View {
    @State private var opacity: Double = 0
    @State private var scale: Double = 0.8
    @State private var iconBounce = false
    
    let title: String
    let subtitle: String?
    let systemImage: String
    let actionTitle: String?
    let action: (() -> Void)?
    let tintColor: Color?
    let showBackground: Bool
    
    public init(
        title: String,
        subtitle: String? = nil,
        systemImage: String = "tray",
        actionTitle: String? = nil,
        tintColor: Color? = nil,
        showBackground: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.actionTitle = actionTitle
        self.action = action
        self.tintColor = tintColor
        self.showBackground = showBackground
    }
    
    public var body: some View {
        VStack(spacing: 32) {
            // Clean minimal icon
            ZStack {
                // Simple background circle
                Circle()
                    .fill((tintColor ?? .primaryColor).opacity(0.1))
                    .frame(width: 100, height: 100)
                
                // Clean icon
                Image(systemName: systemImage)
                    .font(.system(size: 36, weight: .regular))
                    .foregroundColor(tintColor ?? .primaryColor)
                    .scaleEffect(iconBounce ? 1.05 : 1.0)
                    .animation(
                        .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: iconBounce
                    )
            }
            
            // Improved text layout
            VStack(spacing: 16) {
                Text(title)
                    .font(.bold(24))
                    .foregroundColor(.textColor)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.regular(16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 8)
                }
            }
            
            // Enhanced action button
            if let actionTitle = actionTitle, let action = action {
                IconButton(
                    icon: "plus.circle.fill",
                    title: actionTitle,
                    style: IconButtonStyle(
                        backgroundColor: tintColor ?? .primaryColor,
                        foregroundColor: .white
                    )
                ) {
                    // Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    
                    action()
                }
                .scaleEffect(scale)
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 60)
        .background(
            showBackground ?
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.backgroundColor.opacity(0.05))
            : nil
        )
        .opacity(opacity)
        .scaleEffect(scale)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.1)) {
                opacity = 1
                scale = 1.0
            }
            
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                iconBounce = true
            }
        }
    }
}

// Custom button style for better interaction
private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview("Basic Empty State") {
    EmptyStateView(title: "No Items Found")
            
}

#Preview("With Subtitle") {
    EmptyStateView(
        title: "No Messages",
        subtitle: "Start a conversation with someone to see messages here"
    )
    
}

#Preview("With Action Button") {
    EmptyStateView(
        title: "No Photos",
        subtitle: "Add some photos to get started",
        systemImage: "photo",
        actionTitle: "Add Photos"
    ) {
        print("Add photos tapped")
    }
    
}

#Preview("Custom Theme & Color") {
    EmptyStateView(
        title: "No Favorites",
        subtitle: "Items you favorite will appear here",
        systemImage: "heart",
        actionTitle: "Browse Items",
        tintColor: .pink
    ) {
        print("Browse tapped")
    }
    
}

#Preview("Different Icons") {
    VStack(spacing: 40) {
        EmptyStateView(
            title: "No Downloads",
            systemImage: "arrow.down.circle",
            tintColor: .green
        )
        
        EmptyStateView(
            title: "No Bookmarks",
            systemImage: "bookmark",
            tintColor: .orange
        )
        
        EmptyStateView(
            title: "No Notifications",
            systemImage: "bell.slash",
            tintColor: .red
        )
    }
    
}
