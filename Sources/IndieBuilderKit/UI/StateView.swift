import SwiftUI

public struct StateView<Content: View, Data>: View {
    let state: ViewState<Data>
    let content: (Data) -> Content
    let tintColor: Color
    let onRetry: (() -> Void)?
    
    public init(
        state: ViewState<Data>,
        tintColor: Color = .blue,
        onRetry: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Data) -> Content
    ) {
        self.state = state
        self.content = content
        self.tintColor = tintColor
        self.onRetry = onRetry
    }
    
    public var body: some View {
        ZStack {
            switch state {
            case .idle:
                Color.clear
                    .transition(.opacity)
                
            case .loading(let message):
                LoadingView(message: message, tintColor: tintColor)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .scale(scale: 1.1).combined(with: .opacity)
                    ))
                
            case .loaded(let data):
                content(data)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .scale(scale: 0.95).combined(with: .opacity)
                    ))
                
            case .error(let error):
                ErrorView(
                    message: error.localizedDescription,
                    tintColor: tintColor,
                    onRetry: onRetry ?? {}
                )
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.9).combined(with: .move(edge: .top)),
                    removal: .scale(scale: 0.8).combined(with: .opacity)
                ))
                
            case .empty(let message):
                EmptyStateView(
                    title: message,
                    tintColor: tintColor
                )
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .scale(scale: 0.9).combined(with: .opacity)
                ))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: state.id)
    }
}

// MARK: - Sample Data for Previews
private struct SampleItem: Identifiable, Sendable {
    let id = UUID()
    let name: String
}

private struct SampleError: Error, LocalizedError {
    let description: String
    
    var errorDescription: String? { description }
}

#Preview("Loading State") {
    StateView(
        state: ViewState<[SampleItem]>.loading("Fetching items..."),
        tintColor: .blue
    ) { items in
        List(items) { item in
            Text(item.name)
        }
    }
    
}

#Preview("Loaded State") {
    let items = [
        SampleItem(name: "Item 1"),
        SampleItem(name: "Item 2"),
        SampleItem(name: "Item 3")
    ]
    
    return StateView(
        state: ViewState.loaded(items),
        tintColor: .green
    ) { items in
        List(items) { item in
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text(item.name)
            }
        }
    }
    
}

#Preview("Error State") {
    StateView(
        state: ViewState<[SampleItem]>.error(SampleError(description: "Network connection failed")),
        tintColor: .red,
        onRetry: { print("Retry tapped") }
    ) { items in
        List(items) { item in
            Text(item.name)
        }
    }
    
}

#Preview("Empty State") {
    StateView(
        state: ViewState<[SampleItem]>.empty("No items found"),
        tintColor: .orange
    ) { items in
        List(items) { item in
            Text(item.name)
        }
    }
    
}

#Preview("Idle State") {
    StateView(
        state: ViewState<[SampleItem]>.idle,
        tintColor: .purple
    ) { items in
        List(items) { item in
            Text(item.name)
        }
    }
    
}
