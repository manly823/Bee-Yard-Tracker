import SwiftUI

struct InspectionLogView: View {
    @EnvironmentObject var manager: BeeManager
    @Environment(\.dismiss) var dismiss
    @State private var showAdd = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(manager.inspections) { entry in inspectionCard(entry) }
                        if manager.inspections.isEmpty { emptyLabel }
                    }.padding()
                }
            }
            .navigationTitle("Inspections").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Done") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAdd = true }) { Image(systemName: "plus.circle.fill").foregroundColor(Theme.primary) }
                }
            }
            .sheet(isPresented: $showAdd) { AddInspectionView().environmentObject(manager) }
        }
    }
    
    private func inspectionCard(_ entry: InspectionEntry) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(manager.hiveName(for: entry.hiveId)).font(.headline).foregroundColor(Theme.textPrimary)
                Spacer()
                Text(entry.date, style: .date).font(.caption).foregroundColor(Theme.textSecondary)
            }
            
            HStack(spacing: 10) {
                healthBadge(entry.health)
                broodBadge(entry.broodPattern)
                moodBadge(entry.mood)
            }
            
            HStack(spacing: 16) {
                checkItem(label: "Queen", checked: entry.queenSeen)
                checkItem(label: "Eggs", checked: entry.eggsPresent)
                checkItem(label: "Larvae", checked: entry.larvaePresent)
                checkItem(label: "Q-Cells", checked: entry.queenCellsSeen)
            }
            
            HStack(spacing: 20) {
                storesBar(label: "Honey", value: entry.honeyStores, color: Theme.honey)
                storesBar(label: "Pollen", value: entry.pollenStores, color: .orange)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "ladybug.fill").font(.caption)
                    Text("Mites: \(entry.miteCount)").font(.caption)
                }.foregroundColor(entry.miteCount > 3 ? Theme.danger : Theme.textSecondary)
            }
            
            if !entry.notes.isEmpty {
                Text(entry.notes).font(.caption).foregroundColor(Theme.textSecondary).lineLimit(2)
            }
        }
        .cardStyle()
        .contextMenu { Button(role: .destructive) { manager.deleteInspection(entry) } label: { Label("Delete", systemImage: "trash") } }
    }
    
    private func healthBadge(_ h: HiveHealth) -> some View {
        Text(h.rawValue).font(.caption2.bold()).foregroundColor(.white)
            .padding(.horizontal, 8).padding(.vertical, 3).background(h.color).cornerRadius(8)
    }
    
    private func broodBadge(_ b: BroodPattern) -> some View {
        HStack(spacing: 3) {
            Image(systemName: b.icon).font(.caption2)
            Text(b.rawValue).font(.caption2)
        }.foregroundColor(b.color)
    }
    
    private func moodBadge(_ m: BeeMood) -> some View {
        HStack(spacing: 3) {
            Image(systemName: m.icon).font(.caption2)
            Text(m.rawValue).font(.caption2)
        }.foregroundColor(m.color)
    }
    
    private func checkItem(label: String, checked: Bool) -> some View {
        HStack(spacing: 2) {
            Image(systemName: checked ? "checkmark.circle.fill" : "circle").font(.caption2)
                .foregroundColor(checked ? Theme.success : Theme.textSecondary.opacity(0.4))
            Text(label).font(.caption2).foregroundColor(Theme.textSecondary)
        }
    }
    
    private func storesBar(label: String, value: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption2).foregroundColor(Theme.textSecondary)
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2).fill(i <= value ? color : color.opacity(0.2))
                        .frame(width: 14, height: 8)
                }
            }
        }
    }
    
    private var emptyLabel: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text").font(.system(size: 40)).foregroundColor(Theme.textSecondary.opacity(0.5))
            Text("No inspections yet").foregroundColor(Theme.textSecondary)
        }.padding(.top, 60)
    }
}
