import SwiftUI
import IndieBuilderKit

@main
struct IndieBuilderKitDemoApp: App {
    @State private var demoSubscriptionService = DemoSubscriptionService()
    
    init() {
        // Register custom fonts if needed
        IndieBuilderKit.registerCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.subscriptionService, demoSubscriptionService)
        }
    }
}
