import SwiftUI

public struct ErrorView: View {
    @State private var opacity: Double = 0
    
    let title: String
    let message: String?
    let retryTitle: String
    let onRetry: () -> Void
    let tintColor: Color?
    let showBackground: Bool
    
    public init(
        title: String = "Something went wrong",
        message: String? = nil,
        retryTitle: String = "Try Again",
        tintColor: Color? = nil,
        showBackground: Bool = true,
        onRetry: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.onRetry = onRetry
        self.tintColor = tintColor
        self.showBackground = showBackground
    }
    
    public var body: some View {
        VStack(spacing: 32) {
            // Clean minimal error icon
            ZStack {
                // Simple background circle
                Circle()
                    .fill((tintColor ?? .red).opacity(0.1))
                    .frame(width: 100, height: 100)
                
                // Clean error icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 36, weight: .regular))
                    .foregroundColor(tintColor ?? .red)
            }
            
            // Improved content layout
            VStack(spacing: 20) {
                // Title and message
                VStack(spacing: 12) {
                    Text(title)
                        .font(.bold(22))
                        .foregroundColor(.textColor)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let message = message {
                        Text(message)
                            .font(.regular(16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 8)
                    }
                }
                
            }
            
            // Enhanced retry button
            IconButton(
                icon: "arrow.clockwise",
                title: retryTitle,
                style: IconButtonStyle(
                    backgroundColor: tintColor ?? .primaryColor,
                    foregroundColor: .white
                )
            ) {
                // Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                
                onRetry()
            }
            .buttonStyle(BounceButtonStyle())
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                opacity = 1
            }
            
            
        }
    }
}

// Custom button style for bounce effect
private struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview("Basic Error") {
    ErrorView {
        print("Retry tapped")
    }
    
}

#Preview("With Custom Message") {
    ErrorView(
        title: "Failed to Load Data",
        message: "We couldn't fetch the latest information. Please check your connection and try again."
    ) {
        print("Retry tapped")
    }
}

#Preview("Network Error") {
 ErrorView(
        title: "Connection Failed",
        message: "Unable to connect to our servers"
    ) {
        print("Retry tapped")
    }
}

#Preview("Custom Theme & Button") {
    ErrorView(
        title: "Upload Failed",
        message: "Your file couldn't be uploaded",
        retryTitle: "Try Upload Again",
        tintColor: .purple
    ) {
        print("Upload retry tapped")
    }
    
}

#Preview("Different Error Types") {
    VStack(spacing: 40) {
        ErrorView(
            title: "Payment Failed",
            message: "Your payment could not be processed",
            retryTitle: "Retry Payment",
            tintColor: .red
        ) {
            print("Payment retry")
        }
        
        ErrorView(
            title: "Sync Error",
            message: "Unable to sync your data",
            retryTitle: "Sync Again",
            tintColor: .blue
        ) {
            print("Sync retry")
        }
    }
    
}
