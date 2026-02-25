import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var manager: BeeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        defaultsSection
                        dataSummary
                        aboutSection
                    }.padding()
                }
            }
            .navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
    
    private var defaultsSection: some View {
        VStack(spacing: 12) {
            header(icon: "gearshape.fill", title: "Defaults")
            HStack {
                Text("Default Hive Type").foregroundColor(Theme.textSecondary); Spacer()
                Picker("", selection: $manager.settings.defaultHiveType) {
                    ForEach(HiveType.allCases) { t in Text(t.rawValue).tag(t) }
                }.pickerStyle(.menu)
            }
            HStack {
                Text("Weight Unit").foregroundColor(Theme.textSecondary); Spacer()
                Picker("", selection: $manager.settings.weightUnit) {
                    ForEach(WeightUnit.allCases, id: \.self) { u in Text(u.rawValue).tag(u) }
                }.pickerStyle(.segmented).frame(width: 120)
            }
        }.cardStyle()
    }
    
    private var dataSummary: some View {
        VStack(spacing: 12) {
            header(icon: "chart.bar.fill", title: "Apiary Summary")
            dataRow(label: "Total Hives", value: "\(manager.totalHives)")
            dataRow(label: "Total Inspections", value: "\(manager.totalInspections)")
            dataRow(label: "Total Honey", value: String(format: "%.1f kg", manager.totalHarvestKg))
            dataRow(label: "Avg Honey Rating", value: String(format: "%.1f / 5.0", manager.averageHarvestRating))
            dataRow(label: "Healthy Hives", value: String(format: "%.0f%%", manager.healthyHivePercent))
        }.cardStyle()
    }
    
    private var aboutSection: some View {
        VStack(spacing: 12) {
            header(icon: "info.circle.fill", title: "About")
            dataRow(label: "App", value: "Bee Yard Tracker")
            dataRow(label: "Version", value: "1.0")
            Text("Complete apiary management toolkit for beekeepers. All data stored locally on device.")
                .font(.caption).foregroundColor(Theme.textSecondary)
        }.cardStyle()
    }
    
    private func dataRow(label: String, value: String) -> some View {
        HStack { Text(label).foregroundColor(Theme.textSecondary); Spacer(); Text(value).font(.subheadline.bold()).foregroundColor(Theme.textPrimary) }
    }
    
    private func header(icon: String, title: String) -> some View {
        HStack { Image(systemName: icon).foregroundColor(Theme.primary); Text(title).font(.headline).foregroundColor(Theme.textPrimary); Spacer() }
    }
}
