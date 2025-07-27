import SwiftUI

public enum ViewState<T>: Sendable where T: Sendable {
    case idle
    case loading(String = "Loading...")
    case loaded(T)
    case error(Error)
    case empty(String = "No data available")
    
    // Helper property for animations
    var id: String {
        switch self {
        case .idle:
            return "idle"
        case .loading:
            return "loading"
        case .loaded:
            return "loaded"
        case .error:
            return "error"
        case .empty:
            return "empty"
        }
    }
}