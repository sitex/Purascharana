import SwiftUI

@main
struct PurascharanaApp: App {
    @StateObject private var counterState = CounterState.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(counterState)
        }
    }
}
