import SwiftUI

struct MainView: View {
    @EnvironmentObject var manager: BeeManager
    @State private var activeSheet: Destination?
    @State private var showMenu = false
    @State private var beeOffset: CGFloat = 0
    
    enum Destination: String, Identifiable {
        case hives, inspections, harvests, feeding, calendar, settings
        var id: String { rawValue }
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()
            VStack(spacing: 16) {
                headerBar
                Spacer()
                honeycombMenu
                Spacer()
                statsBar
            }
            .padding()
        }
        .onAppear {
            withAnimation { showMenu = true }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) { beeOffset = 12 }
        }
        .sheet(item: $activeSheet) { dest in sheetContent(for: dest) }
    }
    
    private var headerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Bee Yard Tracker")
                    .font(.title2.bold()).foregroundColor(Theme.textPrimary)
                Text("\(manager.totalHives) hives in your apiary")
                    .font(.subheadline).foregroundColor(Theme.textSecondary)
            }
            Spacer()
            Button(action: { activeSheet = .settings }) {
                Image(systemName: "gearshape.fill").font(.title3).foregroundColor(Theme.primary)
            }
        }
    }
    
    // MARK: - Honeycomb Menu
    
    private var honeycombMenu: some View {
        ZStack {
            centralBee
            ForEach(0..<menuItems.count, id: \.self) { i in
                hexBubble(at: i)
            }
        }
        .frame(height: 360)
    }
    
    private var centralBee: some View {
        ZStack {
            hexagonShape.fill(Theme.honeyGradient).frame(width: 80, height: 80)
                .shadow(color: Theme.primary.opacity(0.3), radius: 8)
            Text("🐝").font(.system(size: 36)).offset(y: beeOffset)
        }
    }
    
    private var hexagonShape: some Shape {
        RoundedRectangle(cornerRadius: 20)
    }
    
    private func hexBubble(at index: Int) -> some View {
        let item = menuItems[index]
        let angle = Double(index) * (360.0 / Double(menuItems.count)) - 90
        let radian = angle * Double.pi / 180
        let radius: CGFloat = 135
        let xOff = cos(radian) * radius
        let yOff = sin(radian) * radius
        
        return Button(action: { activeSheet = item.dest }) {
            VStack(spacing: 5) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16).fill(item.color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    Image(systemName: item.icon).font(.system(size: 24)).foregroundColor(item.color)
                }
                Text(item.title).font(.caption2.bold()).foregroundColor(Theme.textPrimary).lineLimit(1)
            }
        }
        .offset(x: showMenu ? xOff : 0, y: showMenu ? yOff : 0)
        .opacity(showMenu ? 1 : 0).scaleEffect(showMenu ? 1 : 0.3)
        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.07), value: showMenu)
    }
    
    private var menuItems: [MenuItem] {
        [
            MenuItem(icon: "square.stack.3d.up.fill", title: "Hives", color: Theme.hive, dest: .hives),
            MenuItem(icon: "doc.text.magnifyingglass", title: "Inspect", color: Theme.success, dest: .inspections),
            MenuItem(icon: "drop.fill", title: "Harvest", color: Theme.honey, dest: .harvests),
            MenuItem(icon: "cup.and.saucer.fill", title: "Feeding", color: .orange, dest: .feeding),
            MenuItem(icon: "calendar", title: "Calendar", color: Theme.primary, dest: .calendar),
            MenuItem(icon: "book.fill", title: "Settings", color: Theme.hive, dest: .settings),
        ]
    }
    
    // MARK: - Stats
    
    private var statsBar: some View {
        HStack(spacing: 12) {
            statCard(value: "\(manager.totalHives)", label: "Hives", icon: "square.stack.3d.up.fill")
            statCard(value: String(format: "%.1f", manager.totalHarvestKg), label: "kg Honey", icon: "drop.fill")
            statCard(value: "\(manager.totalInspections)", label: "Inspections", icon: "doc.text")
        }
    }
    
    private func statCard(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.caption).foregroundColor(Theme.primary)
            Text(value).font(.headline.bold()).foregroundColor(Theme.textPrimary)
            Text(label).font(.caption2).foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity).cardStyle(opacity: 0.5)
    }
    
    @ViewBuilder
    private func sheetContent(for dest: Destination) -> some View {
        switch dest {
        case .hives: HivesView().environmentObject(manager)
        case .inspections: InspectionLogView().environmentObject(manager)
        case .harvests: HarvestView().environmentObject(manager)
        case .feeding: FeedingCalculatorView()
        case .calendar: CalendarView()
        case .settings: SettingsView().environmentObject(manager)
        }
    }
}

private struct MenuItem {
    let icon: String; let title: String; let color: Color; let dest: MainView.Destination
}
