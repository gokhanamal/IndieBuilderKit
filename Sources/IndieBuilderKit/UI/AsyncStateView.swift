import SwiftUI

// MARK: - Async StateView
public struct AsyncStateView<Content: View, Data: Sendable>: View {
    @State private var state: ViewState<Data> = .idle
    let loadData: () async throws -> Data
    let content: (Data) -> Content
    let tintColor: Color
    let emptyMessage: String
    
    public init(
        tintColor: Color = .blue,
        emptyMessage: String = "No data available",
        loadData: @escaping () async throws -> Data,
        @ViewBuilder content: @escaping (Data) -> Content
    ) {
        self.loadData = loadData
        self.content = content
        self.tintColor = tintColor
        self.emptyMessage = emptyMessage
    }
    
    public var body: some View {
        StateView(
            state: state,
            tintColor: tintColor,
            onRetry: { Task { await load() } }
        ) { data in
            content(data)
        }
        .task {
            await load()
        }
    }
    
    @MainActor
    private func load() async {
        state = .loading("Loading...")
        
        do {
            let data = try await loadData()
            
            // Check if data represents empty state
            if let collection = data as? any Collection,
               collection.isEmpty {
                state = .empty(emptyMessage)
            } else {
                state = .loaded(data)
            }
        } catch {
            state = .error(error)
        }
    }
}

// MARK: - Sample Data for Previews
private struct MockItem: Identifiable, Sendable {
    let id = UUID()
    let name: String
}

private struct MockAPIClient {
    static func fetchItems() async throws -> [MockItem] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Simulate different outcomes
        let outcomes = [
            "success",
            "empty", 
            "error"
        ]
        
        let outcome = outcomes.randomElement()!
        
        switch outcome {
        case "success":
            return [
                MockItem(name: "Sample Item 1"),
                MockItem(name: "Sample Item 2"),
                MockItem(name: "Sample Item 3")
            ]
        case "empty":
            return []
        case "error":
            throw URLError(.networkConnectionLost)
        default:
            return []
        }
    }
    
    static func fetchItemsSuccess() async throws -> [MockItem] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return [
            MockItem(name: "Success Item 1"),
            MockItem(name: "Success Item 2")
        ]
    }
    
    static func fetchItemsEmpty() async throws -> [MockItem] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return []
    }
    
    static func fetchItemsError() async throws -> [MockItem] {
        try await Task.sleep(nanoseconds: 500_000_000)
        throw URLError(.badServerResponse)
    }
}

#Preview("Async Success") {
    AsyncStateView(
        tintColor: .blue,
        emptyMessage: "No items found"
    ) {
        try await MockAPIClient.fetchItemsSuccess()
    } content: { items in
        List(items) { item in
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(item.name)
            }
        }
    }
    
}

#Preview("Async Empty") {
    AsyncStateView(
        tintColor: .green,
        emptyMessage: "No data available"
    ) {
        try await MockAPIClient.fetchItemsEmpty()
    } content: { items in
        List(items) { item in
            Text(item.name)
        }
    }
    
}

#Preview("Async Error") {
    AsyncStateView(
        tintColor: .red,
        emptyMessage: "No items"
    ) {
        try await MockAPIClient.fetchItemsError()
    } content: { items in
        List(items) { item in
            Text(item.name)
        }
    }
    
}

#Preview("Async Random Outcome") {
    AsyncStateView(
        tintColor: .purple,
        emptyMessage: "Nothing to show"
    ) {
        try await MockAPIClient.fetchItems()
    } content: { items in
        NavigationView {
            List(items) { item in
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.purple)
                    Text(item.name)
                    Spacer()
                    Text("ID: \(item.id.uuidString.prefix(8))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Items")
        }
    }
    
}
