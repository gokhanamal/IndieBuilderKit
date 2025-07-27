import SwiftUI
import Observation

// MARK: - Data Loading Helper
@Observable
public class AsyncDataLoader<T: Sendable> {
    public private(set) var state: ViewState<T> = .idle
    
    public init() {}
    
    @MainActor
    public func load(
        loadingMessage: String = "Loading...",
        emptyMessage: String = "No data available",
        operation: @escaping () async throws -> T
    ) async {
        state = .loading(loadingMessage)
        
        do {
            let data = try await operation()
            
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
    
    @MainActor
    public func reset() {
        state = .idle
    }
}

// MARK: - Sample Usage View for Preview
private struct AsyncDataLoaderExampleView: View {
    @State private var loader = AsyncDataLoader<[String]>()
    
    var body: some View {
        NavigationView {
            StateView(
                state: loader.state,
                tintColor: .blue,
                onRetry: { Task { await loadData() } }
            ) { items in
                List(items, id: \.self) { item in
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                        Text(item)
                    }
                }
            }
            .navigationTitle("Data Loader")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Load") {
                        Task { await loadData() }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        loader.reset()
                    }
                }
            }
        }
    }
    
    private func loadData() async {
        await loader.load(
            loadingMessage: "Fetching data...",
            emptyMessage: "No items available"
        ) {
            // Simulate API call with random outcomes
            try await Task.sleep(nanoseconds: 1_500_000_000)
            
            let outcomes = ["success", "empty", "error"]
            let outcome = outcomes.randomElement()!
            
            switch outcome {
            case "success":
                return ["Item 1", "Item 2", "Item 3", "Item 4"]
            case "empty":
                return []
            case "error":
                throw URLError(.networkConnectionLost)
            default:
                return []
            }
        }
    }
}

#Preview("AsyncDataLoader Example") {
    AsyncDataLoaderExampleView()
        
}

#Preview("Multiple Loaders") {
    VStack(spacing: 20) {
        AsyncDataLoaderSection(title: "Users", color: .blue)
        AsyncDataLoaderSection(title: "Products", color: .green)
        AsyncDataLoaderSection(title: "Orders", color: .orange)
    }
    
}

private struct AsyncDataLoaderSection: View {
    let title: String
    let color: Color
    @State private var loader = AsyncDataLoader<[String]>()
    
    var body: some View {
        GroupBox(title) {
            StateView(
                state: loader.state,
                tintColor: color,
                onRetry: { Task { await loadData() } }
            ) { items in
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Circle()
                                .fill(color)
                                .frame(width: 6, height: 6)
                            Text(item)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task { await loadData() }
        }
    }
    
    private func loadData() async {
        await loader.load(
            loadingMessage: "Loading \(title.lowercased())...",
            emptyMessage: "No \(title.lowercased()) found"
        ) {
            try await Task.sleep(nanoseconds: UInt64.random(in: 500_000_000...2_000_000_000))
            
            let items = (1...Int.random(in: 0...5)).map { "\(title) \($0)" }
            
            if Bool.random() && items.isEmpty {
                throw URLError(.badServerResponse)
            }
            
            return items
        }
    }
}
