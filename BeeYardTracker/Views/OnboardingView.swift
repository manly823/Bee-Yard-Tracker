import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var manager: BeeManager
    @State private var page = 0
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()
            VStack(spacing: 0) {
                TabView(selection: $page) {
                    onboardingPage(icon: "ladybug.fill", title: "Bee Yard Tracker", subtitle: "Your apiary companion",
                                   desc: "Manage hives, log inspections, track harvests, calculate feed, and follow seasonal guides — all in one app.", color: Theme.primary).tag(0)
                    onboardingPage(icon: "square.stack.3d.up.fill", title: "Hive Management", subtitle: "Track every colony",
                                   desc: "Add unlimited hives with queen status, marker color, age tracking, and detailed notes. Monitor health across your entire apiary.", color: Theme.hive).tag(1)
                    onboardingPage(icon: "doc.text.magnifyingglass", title: "Inspections & Harvests", subtitle: "Detailed records",
                                   desc: "Log inspections with brood pattern, stores, mood, mite count. Track honey harvests with triple ratings for taste, clarity, and aroma.", color: Theme.success).tag(2)
                    onboardingPage(icon: "calendar", title: "Seasonal Calendar", subtitle: "Know what to do when",
                                   desc: "Month-by-month task guide for spring, summer, fall, and winter. Feeding calculator with syrup ratios for every situation.", color: Theme.honey).tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                if page == 3 {
                    Button(action: { withAnimation { manager.settings.hasCompletedOnboarding = true } }) {
                        Text("Start Beekeeping")
                            .font(.headline).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding()
                            .background(Theme.primaryGradient).cornerRadius(16)
                    }
                    .padding(.horizontal, 40).padding(.bottom, 40)
                }
            }
        }
    }
    
    private func onboardingPage(icon: String, title: String, subtitle: String, desc: String, color: Color) -> some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 150, height: 150)
                Circle().fill(color.opacity(0.08)).frame(width: 200, height: 200)
                Image(systemName: icon).font(.system(size: 60)).foregroundColor(color)
            }
            Text(title).font(.largeTitle.bold()).foregroundColor(Theme.textPrimary)
            Text(subtitle).font(.title3).foregroundColor(color)
            Text(desc).font(.body).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center).padding(.horizontal, 40)
            Spacer(); Spacer()
        }
    }
}
