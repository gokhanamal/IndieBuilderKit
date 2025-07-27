import SwiftUI

public struct LoadingView: View {
    @State private var isAnimating = false
    @State private var opacity: Double = 0
    
    let message: String
    let tintColor: Color?
    let showBackground: Bool
    
    public init(
        message: String = "Loading...", 
        tintColor: Color? = nil,
        showBackground: Bool = true
    ) {
        self.message = message
        self.tintColor = tintColor
        self.showBackground = showBackground
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            // Simple loading animation
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(
                    tintColor ?? .primaryColor,
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .frame(width: 32, height: 32)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 1.0).repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            // Simple message
            Text(message)
                .font(.medium(16))
                .foregroundColor(Color.textColor.opacity(0.8))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 40)
        .background(
            showBackground ? 
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundColor.opacity(0.05))
            : nil
        )
        .opacity(opacity)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                opacity = 1
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

#Preview("Default Loading") {
    LoadingView()
}

#Preview("Custom Message") {
    LoadingView(message: "Fetching data...")
}

#Preview("Custom Color") {
    LoadingView(message: "Processing...", tintColor: .purple)
}

#Preview("No Background") {
    LoadingView(
        message: "Uploading...", 
        tintColor: .green,
        showBackground: false
    )
    .background(Color.gray.opacity(0.1))
}

#Preview("Custom Theme") {
    return LoadingView(message: "Loading with custom theme...")
}

#Preview("Different Messages") {
    VStack(spacing: 40) {
        LoadingView(message: "Syncing data...", tintColor: .blue, showBackground: false)
        LoadingView(message: "Uploading photos...", tintColor: .green, showBackground: false)
        LoadingView(message: "Processing payment...", tintColor: .orange, showBackground: false)
    }
    .background(Color.gray.opacity(0.05))
}
