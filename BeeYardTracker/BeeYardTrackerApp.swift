import SwiftUI

@main
struct BeeYardTrackerApp: App {
    @StateObject private var manager = BeeManager()
    
    var body: some Scene {
        WindowGroup {
            if manager.settings.hasCompletedOnboarding {
                MainView()
                    .environmentObject(manager)
            } else {
                OnboardingView()
                    .environmentObject(manager)
            }
        }
    }
}
