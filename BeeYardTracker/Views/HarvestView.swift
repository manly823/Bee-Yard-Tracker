import SwiftUI

struct HarvestView: View {
    @EnvironmentObject var manager: BeeManager
    @Environment(\.dismiss) var dismiss
    @State private var showAdd = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 14) {
                        summaryBar
                        ForEach(manager.harvests) { entry in harvestCard(entry) }
                        if manager.harvests.isEmpty { emptyLabel }
                    }.padding()
                }
            }
            .navigationTitle("Honey Harvests").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Done") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAdd = true }) { Image(systemName: "plus.circle.fill").foregroundColor(Theme.primary) }
                }
            }
            .sheet(isPresented: $showAdd) { AddHarvestView().environmentObject(manager) }
        }
    }
    
    private var summaryBar: some View {
        HStack(spacing: 12) {
            sumItem(value: String(format: "%.1f kg", manager.totalHarvestKg), label: "Total")
            sumItem(value: "\(manager.harvests.count)", label: "Harvests")
            sumItem(value: String(format: "%.1f", manager.averageHarvestRating), label: "Avg Rating")
        }
    }
    
    private func sumItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.headline.bold()).foregroundColor(Theme.primary)
            Text(label).font(.caption2).foregroundColor(Theme.textSecondary)
        }.frame(maxWidth: .infinity).cardStyle(opacity: 0.5)
    }
    
    private func harvestCard(_ entry: HarvestEntry) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle().fill(entry.honeyType.color).frame(width: 14, height: 14)
                Text(entry.honeyType.rawValue).font(.headline).foregroundColor(Theme.textPrimary)
                Spacer()
                Text(entry.date, style: .date).font(.caption).foregroundColor(Theme.textSecondary)
            }
            
            HStack {
                Text(manager.hiveName(for: entry.hiveId)).font(.caption).foregroundColor(Theme.hive)
                Spacer()
                Text(String(format: "%.1f kg", entry.weightKg)).font(.title3.bold()).foregroundColor(Theme.honey)
            }
            
            HStack(spacing: 16) {
                ratingRow(label: "Taste", value: entry.tasteRating)
                ratingRow(label: "Clarity", value: entry.clarityRating)
                ratingRow(label: "Aroma", value: entry.aromaRating)
            }
            
            if !entry.notes.isEmpty {
                Text(entry.notes).font(.caption).foregroundColor(Theme.textSecondary).lineLimit(2)
            }
        }
        .cardStyle()
        .contextMenu { Button(role: .destructive) { manager.deleteHarvest(entry) } label: { Label("Delete", systemImage: "trash") } }
    }
    
    private func ratingRow(label: String, value: Int) -> some View {
        HStack(spacing: 3) {
            Text(label).font(.caption2).foregroundColor(Theme.textSecondary)
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= value ? "star.fill" : "star").font(.system(size: 8))
                    .foregroundColor(i <= value ? Theme.primary : Theme.textSecondary.opacity(0.3))
            }
        }
    }
    
    private var emptyLabel: some View {
        VStack(spacing: 12) {
            Image(systemName: "drop").font(.system(size: 40)).foregroundColor(Theme.textSecondary.opacity(0.5))
            Text("No harvests yet").foregroundColor(Theme.textSecondary)
        }.padding(.top, 60)
    }
}
